#!/bin/bash

#
# Script environment
#
function setenv
{
	export version="0.7.80"

    export dir_local_bin="/usr/local/bin"
}

function refreshenv
{
    setenv

    # Reload bash profile (if it exists)
    if [ -e "$HOME/.bashrc" ]; then
        source $HOME/.bashrc
    fi
}
