
<p align="center">
  <img width="96" height="96" src="./docs/96x96.png" alt="logo">
</p>

<h1 align="center">sup</h1>

<p align="center">
Installation scripts for any binary.
</p>

## ⚡️ Quick start

`sup` is a set of simple and useful shell scripts that can be used to make your development workflow more efficient. These scripts provide one-liners that can be used to install or perform other common tasks on your binaries, and can easily be incorporated into your project's README.

`sup` works under the following assumptions binaries should be published as assets of a GitHub release and follow the naming convention "${BIN}-${OS}-${ARCH}" (e.g., "keydex-linux-amd64").

### Install

Executing the following command will install latest version of `mybin`

```sh
sudo sh -c "curl -s https://shikaan.github.io/sup/install | REPO=myuser/mybin sh -"
```

The name of the binary is inferred from the `REPO` variable. You can override it with `BIN`

```sh
sudo sh -c "curl -s https://shikaan.github.io/sup/install | REPO=myuser/myrepo BIN=mybin sh -"
```

### Uninstall

Same as above, but it will uninstall `mybin`

```sh
sudo sh -c "curl -s https://shikaan.github.io/sup/uninstall | REPO=myuser/mybin sh -"
```

Or, again, with the `BIN` override

```sh
sudo sh -c "curl -s https://shikaan.github.io/sup/uninstall | REPO=myuser/myrepo BIN=mybin sh -"
```

## 📝 Example

Repositories using `sup` in their README (open a Pull Request and add yours):

 * [keydex](http://github.com/shikaan/keydex)
 * [shmux](http://github.com/shikaan/shmux)

## 🤓 Contributing

Have a look through existing [Issues](https://github.com/shikaan/sup/issues) and [Pull Requests](https://github.com/shikaan/sup/pulls) that you could help with. If you'd like to request a feature or report a bug, please create a [GitHub Issue](https://github.com/shikaan/sup/issues).

## License

[MIT](./LICENSE)
