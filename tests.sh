#!/usr/bin/env sh

set -e

output="stdout"
total=0
failed=0

SUDO=
[ "$(id -u)" -ne 0 ] && SUDO="sudo -E"

spec() {
  fn="$1"

  printf '%s\n' "$fn..."
  total=$((total + 1))
  printf "\x1b[2m"
  if "$fn"; then
    printf "\x1b[22m"
    printf '%s\n' "$fn... OK"
  else
    printf "\x1b[22m"
    printf '%s\n' "$fn... FAIL"
    failed=$((failed + 1))
  fi
}

config_init() {
  file="$HOME/$1"
  rm -f "$file"
  touch "$file"
}

has_valid_config() {
  file="$HOME/$1"
  manpage="${2:-}"

  grep -Fq "$HOME/.local/bin" "$file" || return 1

  if [ -n "$manpage" ]; then
    grep -Fq "$HOME/.local/share/man" "$file" || return 1
  fi
}

test_backward_compatibility_nochecksum_install() {
  config_init ".bashrc"
  REPO=shikaan/shmux sh - < ./install
  [ -f "$HOME/.local/bin/shmux" ] && has_valid_config ".bashrc"
}

test_backward_compatibility_nochecksum_warning() {
  REPO=shikaan/shmux sh - < ./install > $output
  [ "$(grep -c "WARNING" $output)" -eq "1" ]
}

test_backward_compatibility_nochecksum_uninstall() {
  REPO=shikaan/shmux sh - < ./uninstall
  [ ! -f "$HOME/.local/bin/shmux" ]
}

test_backward_compatibility_withsudo_install() {
  config_init ".bashrc"
  $SUDO sh -c "REPO=shikaan/shmux sh - < ./install"
  [ -f "$HOME/.local/bin/shmux" ] && has_valid_config ".bashrc"
}

test_backward_compatibility_withsudo_uninstall() {
  # simulate package present in old location
  $SUDO cp "$HOME/.local/bin/shmux" "/usr/local/bin/shmux"
  $SUDO sh -c "REPO=shikaan/shmux sh - < ./uninstall"
  [ ! -f "$HOME/.local/bin/shmux" ] && [ ! -f "/usr/local/bin/shmux" ]
}

test_withchecksum_nomanpage() {
  config_init ".bashrc"
  REPO=shikaan/keydex sh - < ./install
  [ -f "$HOME/.local/bin/keydex" ]  && has_valid_config ".bashrc"
}

test_withchecksum_nomanpage_nowarning() {
  REPO=shikaan/keydex sh - < ./install > $output
  [ "$(grep -c "WARNING" $output)" -eq "0" ]
}

test_withchecksum_nomanpage_uninstall() {
  REPO=shikaan/keydex sh - < ./uninstall
  [ ! -f "$HOME/.local/bin/keydex" ]
}

test_withchecksum_manpage() {
  config_init ".bashrc"
  REPO=shikaan/lifp sh - < ./install
  [ -f "$HOME/.local/bin/lifp" ] && \
    [ -f "$HOME/.local/share/man/man1/lifp.1" ] && \
    has_valid_config ".bashrc" "1"
}

test_withchecksum_manpage_uninstall() {
  REPO=shikaan/lifp sh - < ./uninstall
  [ ! -f "$HOME/.local/bin/lifp" ] && [ ! -f "$HOME/.local/share/man/man1/lifp.1" ]
}

specs=$(sed -n 's/^[[:space:]]*\(test_[A-Za-z0-9_]*\)[[:space:]]*()[[:space:]]*{[[:space:]]*$/\1/p' "$0")
for s in $specs; do
  spec "$s"
done

rm -f $output
printf 'Total: %s, Failed: %s\n' "$total" "$failed"
exit $failed
