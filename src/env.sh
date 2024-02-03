#!/bin/bash

#
# Script environment
#
function setenv
{
	export version="0.1.1"
}

function refreshenv
{
    setenv

    # Reload bash profile (if it exists)
    if [ -e "$HOME/.bashrc" ]; then
        source $HOME/.bashrc
    fi
}
