#!/bin/bash

function version
{
    setenv
    echo "Linux Setup [Version v${version}]"
    echo
}

function printsection
{
    green "-------------------------------------------"
    green "     ${1}"
    green "-------------------------------------------"
}

# Check if a command exists
# - Usage: command_exists <command>
function command_exists
{
	  command -v "$@" > /dev/null 2>&1
}

function command_exists_warning
{
    warning "Warning: the '$@' command appears to already exist on this system."
    warning "Warning: $@ is assumed to already be installed."
    warning "Warning: Skipping '$@' installation."
}

function user_exists
{
    local -r username="$1"
    id "$username" >/dev/null 2>&1
}

function create_user
{
    local -r username="$1"

    if user_exists "$username"; then
        warning "User $username already exists. Will not create again."
    else
        echo "Creating user named $username"
        sudo useradd -m "$username"
    fi
}

function create_group
{
    local -r groupname="$1"

    echo "Creating group named $groupname"
    sudo groupadd "$groupname"
}

function change_owner
{
    local -r usergroup="${1}"
    local -r directory_path="${2}"

    chown --recursive $usergroup:$usergroup "${directory_path}"
    chmod 770 "${directory_path}"
}

function ask_user
{
    input="junk"
    read -p "" input
    echo "${input}"
}

function confirm_continue
{
    read -p "Are you sure? " -n 1 -r
    echo    # (optional) move to a new line
    if [[ ! $REPLY =~ ^[Yy]$ ]]
    then
        [[ "$0" = "$BASH_SOURCE" ]] && exit 1 || return 1 # handle exits from shell or function but don't exit interactive shell
    fi
}

function wait_for_response
{
    local -r name="${1}"
    local -r requestURL="${2}"
    local -r requestResponse="${3}"

    # Wait for response to be ready
    while true; do
        echo "Waiting for ${name} to be ready..."
        curl -sL ${requestURL} | grep -q "${requestResponse}" && break
        sleep 1
    done
}

function fetch_install_deb
{
    local -r filename="${1}"
    local -r requestURL="${2}"

    wget "${requestURL}"
    sudo dpkg -i "${filename}"
}

function fetch_install_binary
{
    setenv
    local -r binname="${1}"
    local -r filename="${2}"
    local -r requestURL="${3}"

    wget "${requestURL}"
    sudo chmod +x "${filename}"
    sudo mv -f "${filename}" "${dir_local_bin}/${binname}"
}

function flatpakget
{
    setenv
    local -r appname="${1}"
    local -r appuri="${2}"

    flatpak install flathub "${appuri}"
}
