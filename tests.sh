#!/usr/bin/env sh

set -u

output="stdout"
total=0
failed=0

SUDO=
[ "$(id -u)" -ne 0 ] && SUDO=sudo

spec() {
  local fn="$1"

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

test_backward_compatibility_nochecksum_install() {
  cat ./install | REPO=shikaan/shmux sh -
  [ -f "$HOME/.local/bin/shmux" ]
}

test_backward_compatibility_nochecksum_warning() {
  cat ./install | REPO=shikaan/shmux sh - > $output
  [ $(grep -c "WARNING" $output) -eq "1" ]
}

test_backward_compatibility_nochecksum_uninstall() {
  cat ./uninstall | REPO=shikaan/shmux sh -
  [ ! -f "$HOME/.local/bin/shmux" ]
}

test_backward_compatibility_withsudo_install() {
  $SUDO sh -c "cat ./install | REPO=shikaan/shmux sh -"
  [ -f "$HOME/.local/bin/shmux" ]
}

test_backward_compatibility_withsudo_uninstall() {
  # simulate package present in old location
  $SUDO cp "$HOME/.local/bin/shmux" "/usr/local/bin/shmux" 
  $SUDO sh -c "cat ./uninstall | REPO=shikaan/shmux sh -"
  [ ! -f "$HOME/.local/bin/shmux" ]
  [ ! -f "/usr/local/bin/shmux" ]
}

test_withchecksum_nomanpage() {
  cat ./install | REPO=shikaan/keydex sh -
  [ -f "$HOME/.local/bin/keydex" ]
}

test_withchecksum_nomanpage_nowarning() {
  cat ./install | REPO=shikaan/keydex sh -
  cat ./install | REPO=shikaan/keydex sh - > $output
  [ $(grep -c "WARNING" $output) -eq "0" ]
}

test_withchecksum_nomanpage_uninstall() {
  cat ./uninstall | REPO=shikaan/keydex sh -
  [ ! -f "$HOME/.local/bin/shmux" ]
}

test_withchecksum_manpage() {
  cat ./install | REPO=shikaan/lifp sh -
  [ -f "$HOME/.local/bin/lifp" ] && [ -f "$HOME/.local/share/man/man1/lifp.1" ]
}

test_withchecksum_manpage_uninstall() {
  cat ./uninstall | REPO=shikaan/lifp sh -
  [ ! -f "$HOME/.local/bin/shmux" ] && [ ! -f "$HOME/.local/share/man/man1/lifp.1" ]
}

specs=$(sed -n 's/^[[:space:]]*\(test_[A-Za-z0-9_]*\)[[:space:]]*()[[:space:]]*{[[:space:]]*$/\1/p' "$0")
for s in $specs; do
  spec "$s"
done

rm -f $output
printf 'Total: %s, Failed: %s\n' "$total" "$failed"
exit $failed
