#!/usr/bin/env zsh
# vi: set ft=zsh tw=80 ts=2

# =================
# Utility Functions
# =================

function isDebug() {
	[[ ${DEBUG} == true || ${DEBUG} == 1 ]]
}

function printSuccess() {
	printOrLog "${colors[green]}${*}${colors[reset]}"
}

function printError() {
	printOrLog "${errColors[red]}${*}${errColors[reset]}" >&2
}

function printOrLog() {
	if [[ -t 1 ]]; then
		print "$@"
	else
		logger -t zshlib_bootstrap_sh "$@"
	fi
}

# =================
# ZSH Lib Downloads
# =================

function getZSHLibArchive() {
	local fileUrl=${ZSHLIB_ZIP_URL:-https://github.com/astzweig/zshlib/archive/refs/heads/main.zip}
	local zipPath=./zshlib.zip
	printOrLog 'Downloading zshlib from astzweig/zshlib on GitHub.'
	curl --output ${zipPath} -fsSL "${fileUrl}" || return 10
	[[ -f ${zipPath} ]] && unzip ${zipPath} &> /dev/null && rm ${zipPath}
	printOrLog 'Done.'
}

function compileZSHLib() {
	printOrLog 'Compile zshlib to zsh word code.'
	zcompile -z -U ${zshlibTempPath} $(find ./zshlib-main -type f -perm +u=x -maxdepth 1)
	printOrLog 'Done.'
}

function buildZSHLibWordCodeFromSource() {
	getZSHLibArchive
	compileZSHLib
}

function downloadZSHLibWordCodeFromGithub() {
	local apiURL=${ZSHLIB_RELEASE_API_URL:-https://api.github.com/repos/astzweig/zshlib/releases/latest}
	local zwcURL=`curl -s $apiURL |  python3 -c 'import json,sys;print(json.load(sys.stdin)["assets"][0]["browser_download_url"])' 2> /dev/null`
	printOrLog 'Downloading latest zshlib word code from astzweig/zshlib on GitHub: '"$zwcURL"
	curl --output ${zshlibTempPath} -fsSL "${zwcURL}" || return 10
	printOrLog 'Done.'
}

# ==================
# ZSH Lib Installers
# ==================

function moveDownloadToLibDir() {
	mv ${zshlibTempPath} ${libDir}
	zshlibPath=${libDir}/${zshlibTempPath:t}
	chown $user ${zshlibPath}
	chmod 'ugo=rx' ${zshlibPath}
}

function installZSHLibWordCodeForRoot() {
	libDir='/usr/local/share/zsh/site-functions'
	local user=root
	ensureDirectory /usr/local/share root 775
	ensureDirectory /usr/local/share/zsh root 755
	ensureDirectory $libDir root 755
	moveDownloadToLibDir
}

function checkHomeFolderExists() {
	[[ -d $HOME ]] || return 10
}

function installZSHLibWordCodeForUser() {
	checkHomeFolderExists || { printError 'Home variable not set. Aborting.'; return 10 }
	libDir="$HOME/.zshfn"
	local user=$(id -un)
	ensureDirectory $libDir $user u=rwx
	moveDownloadToLibDir
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

# =====================
# ZSH Lib Env Installer
# =====================

function createEnvFileIfNotExists() {
	local envFile=$1 owner=$2 permission=$3
	[[ -f $envFile ]] && return
	touch $envFile
	ensureOwnerAndPermission $envFile $owner $permission
}

function extendPathInEnvFile() {
	createEnvFileIfNotExists $envFile $owner $permission
	cat $envFile 2> /dev/null | grep $libDir >&! /dev/null && return
	print -- "fpath+=($zshlibPath)" >> $envFile
}

function modifyFpathForRoot() {
	local envFile=/etc/zshenv owner=root permission='ugo=r'
	extendPathInEnvFile
}

function modifyFpathForUser() {
	local envFile=$HOME/.zshenv owner=$((id -un)):staff permission='u=r'
	extendPathInEnvFile
}

# ====
# Main
# ====

function defineColors() {
	local -A colorCodes=(red "`tput setaf 9`" green "`tput setaf 10`" reset "`tput sgr0`")
	[ -t 1 ] && colors=(${(kv)colorCodes})
	[ -t 2 ] && errColors=(${(kv)colorCodes})
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
	fi
}

function parseArgs() {
	zmodload zsh/zutil
	zparseopts -D -- {h,-help}=help_option -from-source=from_source_option
}

function printUsage() {
	[[ ! -t 1 ]] && return
	cat <<- USAGE
	Usage: $_CMD_NAME [options]

	Install Astzweig Zsh Lib on current system.

	Options:
		-h, --help      Show this message.
		--from-source   Compile library from source. Default is to use the latest
										release version.
	----
	$_CMD_NAME 0.1.0
	Copyright (C) 2022 Thomas Bernstein, Astzweig GmbH & Co. KG
	License EUPL-1.2. There is NO WARRANTY, to the extent permitted by law.
	USAGE
}

function showHelpIfRequested() {
	[[ -z ${help_option} ]] && return
	printUsage "$@"
	exit 0
}

function checkForCurl() {
	whence curl &> /dev/null || { printError 'This script needs curl. Aborting.'; return 11 }
}

function changeToTemporaryFolder() {
	tmpdir="`mktemp -d -t 'zshlib'`"
	isDebug || traps+=("rm -fr -- '${tmpdir}'")
	pushd -q "${tmpdir}"
	print -l "Working directory is: ${tmpdir}"
}

function switchInstallationVariantByUser() {
	local username=$(id -un)
	[[ $username != root ]] && installVariant=User
}

function installZSHLib() {
	local libDir zshlibPath= zshlibTempPath=${tmpdir}/zshlib.zwc
	if [[ -z $from_source_option ]]; then
		downloadZSHLibWordCodeFromGithub
	else
		buildZSHLibWordCodeFromSource
	fi
	installZSHLibWordCodeFor$installVariant
	modifyFpathFor$installVariant
}

function main() {
	local traps=('[ -t 1 ] && tput cnorm') tmpdir=
	local help_option=() from_source_option=()
	local installVariant=Root
	local -A colors=() errColors=()
	configureTerminal

	parseArgs "$@"
	showHelpIfRequested
	checkForCurl || return $?
	changeToTemporaryFolder
	trap ${(j.;.)traps} INT TERM EXIT

	switchInstallationVariantByUser
	installZSHLib || return $?
	printSuccess 'All Done.'
}

if [[ "${ZSH_EVAL_CONTEXT}" == toplevel || "${ZSH_EVAL_CONTEXT}" == cmdarg ]]; then
	_DIR="${0:A:h}"
	_CMD_NAME=${0:t}
	main "$@"
fi
