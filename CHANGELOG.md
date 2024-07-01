# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]
Nothing here yet.

## [v2.0.1] - 2024-07-01
### Added
- Add bootstrap script. Now you can automatically install the library using a
  single command.

## [v2.0.0] - 2022-04-28
### Added
- askUser asks for password confirmation now, to prevent typo errors.

### Changed
- indicateActivity now accepts arguments as arguments instead of a
  comma separated list.

## [v1.0.1] - 2022-04-26
### Added
- Validators of askUser can now habe a comma separated list of arguments given
  to them additionally to the user reply.

### Fixed
- Changed parsing semantics of isTerminalBackgroundDark to handle special chars
  in Terminal answer to xterm control sequence. Those were causing parsing errors
  previously.
- Add trap for killing the background job while showing spinner dots in showSpinner
  as before they'd keep spinning even after forcefully quitting the script.
- Run functions of indicateActivity (or showSpinner) in the current shell context
  instead of a subshell.
- Fixed wrong date in CHANGELOG.md regarding release v1.0.0.

## [v1.0.0] - 2022-04-21
First major release.
### Added
- Useful functions for logging, output and activity indication. Take a look at
  [what's included].
- A compiled version of the library. Head over to [Releases].

[Unreleased]: https://github.com/astzweig/zshlib/compare/v1.0.0...HEAD
[v1.0.0]: https://github.com/astzweig/zshlib/releases/tag/v1.0.0
[v1.0.1]: https://github.com/astzweig/zshlib/releases/tag/v1.0.1
[v2.0.0]: https://github.com/astzweig/zshlib/releases/tag/v2.0.0
[Releases]: https://github.com/astzweig/zshlib/releases
[README.md]: https://github.com/astzweig/zshlib
[what's included]: https://github.com/astzweig/zshlib#whats-included
