#!/usr/bin/env zsh
# vi: set ft=zsh tw=80 ts=2

function getZSHLibArchive() {
	local fileUrl=${ZSHLIB_URL:-https://github.com/astzweig/zshlib/archive/refs/heads/main.zip}
	local zipPath=./zshlib.zip
	curl --output ${zipPath} -fsSL "${fileUrl}" || return 10
	[[ -f ${zipPath} ]] && unzip ${zipPath} &> /dev/null && rm ${zipPath}
}

function changeToZSHLibFolder() {
	[[ -d ./zshlib-main ]] || { printError 'Could not download zshlib. Aborting.'; return 10 }
	pushd -q ./zshlib-main
}

function getSystemOrUserLibPath() {
	if [[ $(id -un) == 'root' ]]; then
		libDir='/usr/local/share/zsh/site-functions'
		ensureDirectory /usr/local/share root:admin 775
		ensureDirectory /usr/local/share/zsh root:admin 755
		ensureDirectory $libDir root:admin 755
	else
		[[ -z $HOME ]] && return 10
		libDir="$HOME/.zshfn"
		ensureDirectory $libDir $(id -un):staff u=rwx,g=rx
	fi
}

function ensureDirectory() {
	local dirPath=$1
	[[ ! -d $dirPath ]] && mkdir $dirPath && ensureOwnerAndPermission "$@"
	return 0
}

function ensureOwnerAndPermission() {
	local dirPath=$1 owner=$2 permission=$3
	chown $owner $dirPath
	chmod $permission $dirPath
}

function compileZSHLib() {
	local zshlibPath=$libDir/astzweig_zshlib.zwc
	if [[ -f $zshlibPath ]]; then
		print 'Updating zshlib'
		rm $zshlibPath
	else
		print 'Installing zshlib'
	fi
	zcompile -z -U ${zshlibPath} $(find . -type f -perm +u=x -maxdepth 1)
	chmod ugo=r ${zshlibPath}
	print 'done'
}

function installZSHLib() {
	local libDir
	getZSHLibArchive || return $((10 * $?))
	changeToZSHLibFolder || return $((20 * $?))
	getSystemOrUserLibPath || return $((30 * $?))
	compileZSHLib
}

function isDebug() {
	test "${DEBUG}" = true -o "${DEBUG}" = 1
}

function printSuccess() {
	print "${colors[green]}${*}${colors[reset]}"
}

function printError() {
	print "${errColors[red]}${*}${errColors[reset]}" >&2
}

function printFailedWithError() {
	print "${colors[red]}failed.${colors[reset]}"
	print "$*" >&2
}

function defineColors() {
	local -A colorCodes=(red "`tput setaf 9`" green "`tput setaf 10`" reset "`tput sgr0`")
	[ -t 1 ] && colors=(${(kv)colorCodes})
	[ -t 2 ] && errColors=(${(kv)colorCodes})
}

function changeToTemporaryFolder() {
	tmpdir="`mktemp -d -t 'zshlib'`"
	isDebug || traps+=("rm -fr -- '${tmpdir}'")
	pushd -q "${tmpdir}"
	print -l "Working directory is: ${tmpdir}"
}

function configureTerminal() {
	defineColors
	if [ -t 0 ]; then
		traps+=("stty $(stty -g)")
		stty -echo
	fi

	if [ -t 1 ]; then
		traps+=('tput cnorm')
		tput civis
		export TERMINAL_CURSOR_HIDDEN=true
	fi
}

function main() {
	local traps=() tmpdir=
	local -A colors=() errColors=()

	configureTerminal
	changeToTemporaryFolder
	trap ${(j.;.)traps} INT TERM EXIT

	whence curl &> /dev/null || { printError 'This script needs curl. Aborting.'; return 10 }
	installZSHLib

	[ -t 1 ] && tput cnorm
	popd -q
}

if [[ "${ZSH_EVAL_CONTEXT}" == toplevel || "${ZSH_EVAL_CONTEXT}" == cmdarg ]]; then
	_DIR="${0:A:h}"
	main "$@"
fi
