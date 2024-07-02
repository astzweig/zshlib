#!/usr/bin/env zsh
FPATH="`pwd`/functions:${FPATH}"
local funcNames=("${(@f)$(find `pwd`/functions -type f -perm +u=x -maxdepth 1 | awk -F/ '{ print $NF }')}")
autoload -Uz "${funcNames[@]}"
