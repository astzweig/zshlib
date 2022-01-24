# Zsh Lib
Awesome functions that make writing Z shell CLI applications easier.

## Install
To use this library in you own project add it as a [`git-submodule`][git-submodule]
to your repository.

```zsh
# Run inside your project directory
git submodule add https://github.com/astzweig/zshlib
```
Afterwards just add that new directory to the beginning of your `PATH` variable
in your script and you are ready to go

> **Caveat**: Remember that `sudo` does not inherit all environment variables.
> To pass your modified `PATH` variable run `sudo --preserve-env=PATH`.

## What's included

| name | description | dependencies | supported platforms |
| ---- | ----------- | ------------ | ------------------- |
| hio  | Highlighted output to command line. | [`docopts`][docopts][^docopts] | all |
| getPrefDir | Get system specific preferences directory. | - | macOS, Linux, Windows Subsystem for Linux |

[^docopts]: `docopts` with `-f, --function` option needed. See the
  [Astzweig fork][astzweig-docopts] for example.

[git-submodule]: https://git-scm.com/docs/git-submodule
[docopts]: https://github.com/docopt/docopts
[astzweig-docopts]: https://github.com/astzweig/docopts
