# Zsh Lib
Awesome functions that make writing Z shell CLI applications easier.

## Install
To use this library in you own project add it as a [`git-submodule`][git-submodule]
to your repository.

```zsh
# Run inside your project directory
git submodule add https://github.com/astzweig/zshlib
```

### Using on the command line
Just add the zshlib directory to the beginning of your `PATH` variable and you
can call the commands from the command line. Alternatively you can enter the
whole path e.g. `/path/to/repo/hio --help`.

> **Caveat**: Remember that `sudo` does not inherit all environment variables.
> To pass your modified `PATH` variable run `sudo --preserve-env=PATH`.

### Using as a library
Just source the specific commands that you want inside your script. Alternatively
you can enable Zsh autoload:

```zsh
  # This will register all commands to autoload
  FPATH="/path/to/zshlib:${FPATH}"
  local funcNames=("${(@f)$(find ./zshlib -type f -perm +u=x | awk -F/ '{ print $NF }')}")
  autoload -Uz "${funcNames[@]}"
```
Or if you want to autoload only specific commands:

```zsh
  # This will register only hio and getPrefDir to autoload
  FPATH="/path/to/zshlib:${FPATH}"
  autoload -Uz hio getPrefDir
```

## What's included

| name | description | dependencies | supported platforms |
| ---- | ----------- | ------------ | ------------------- |
| hio  | Highlighted output to command line. | [`docopts`][docopts][^docopts] | all |
| lop | Log messages to syslog, file or print to command line with highlight. | `hio`[^zshlib], [`docopts`][docopts][^docopts] | all |
| trim  | Remove leading and trailing whitespace from string. | [`docopts`][docopts][^docopts] | all |
| askUser | Ask user for input. Supports questions, password, selections or confirmations. | `hio`[^zshlib], [`docopts`][docopts][^docopts] | all |
| getPrefDir | Get system specific preferences directory. | [`docopts`][docopts][^docopts] | macOS, Linux, Windows Subsystem for Linux |
| config | Config file writer and reader. | `getPrefDir`[^zshlib], `PlistBuddy`[^plistbuddy], [`docopts`][docopts][^docopts] | macOS, Linux, Windows Subsystem for Linux |
| abbreviatePaths | Truncate the passed paths so that they are minimal in length and pairwise distinct. Useful to save the user long path specifications. | `hio`[^zshlib], [`docopts`][docopts][^docopts] | all |

[^zshlib]: A command of Zsh Lib (this library).
[^docopts]: `docopts` with `-f, --function` option needed. See the
  [Astzweig fork][astzweig-docopts] for example.
[^plistbuddy]: `/usr/libexec/PlistBuddy` is a utility found on macOS systems.
  Apple does not provide any documentation besides the man page and the programs
  `--help` output.

## Usage
Run any command with the `--help` option to read about its usage. e.g.
`/path/to/zshlib/hio --help`.

[git-submodule]: https://git-scm.com/docs/git-submodule
[docopts]: https://github.com/docopt/docopts
[astzweig-docopts]: https://github.com/astzweig/docopts
