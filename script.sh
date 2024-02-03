#!/bin/bash

#
# Collection of scripts combined using:
# https://github.com/hmerritt/combine-script
#
# Metadata:
#   | Compiled Timestamp | 1706979761       |
#   | Compiled Date      | 2024-02-03 17:02 |
#   | Combine.sh Version | 1.4.7            |
#
# Scripts Bundled:
#  (7)  env.sh install.sh install_dev.sh install_gui.sh install_my.sh main.sh utils.sh
#



#
# Combine.sh Interface Framework
#

__ARGS="${@}"


SCRIPT_DIR="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
SCRIPT_DIR_PARENT="$( cd -- "${SCRIPT_DIR}/../" ; pwd -P )"


LOG="no"
LOGPATH="./script.log"
ERROR=""


# Color codes
NOCOLOR="\033[0m"

# Text
BLACK="\e[30m"
RED="\e[31m"
GREEN="\e[32m"
ORANGE="\e[33m"
BLUE="\e[34m"
PURPLE="\e[35m"
CYAN="\e[36m"
LIGHTGRAY="\e[37m"
DARKGRAY="\e[90m"
LIGHTRED="\e[91m"
LIGHTGREEN="\e[92m"
YELLOW="\e[93m"
LIGHTBLUE="\e[94m"
LIGHTPURPLE="\e[95m"
LIGHTCYAN="\e[96m"
WHITE="\e[97m"

# Background
BG_RED="\e[41m${WHITE}"
BG_GREEN="\e[42m${WHITE}"
BG_YELLOW="\e[43m${WHITE}"
BG_BLUE="\e[44m${WHITE}"
BG_PURPLE="\e[45m${WHITE}"
BG_CYAN="\e[46m${WHITE}"
BG_LIGHTRED="\e[101m${WHITE}"
BG_LIGHTGREEN="\e[102m${WHITE}"
BG_WHITE="\e[107m${BLACK}"


# Print colored text to the terminal
# - $1: color
# - $2: text
function cprint
{
	echo -e "$1$2${NOCOLOR}"
}


# Print colored text
# - $1: text
# -> output colored text with no background
function white
{
	cprint $WHITE "${1}"
}

function green
{
	cprint $GREEN "${1}"
}

function red
{
	cprint $RED "${1}"
}

function orange
{
	cprint $ORANGE "${1}"
}


# Print message by named state
# - $1: text
function success
{
	cprint $BG_GREEN "${1}"
}

function failure
{
	cprint $BG_RED "${1}"
}

function error
{
	red "${1}"
}

function warning
{
	orange "${1}"
}


# Use a fallback value if initial value does not exist
# - Usage: value=$(fallback $1 "fallback")
# - $1: initial value
# - $2: fallback value
function fallback
{
	local value="${1}"

	# Check for NULL/empty value
	if [ ! -n "${value}" ]; then
		local value="${2}"
	fi

	echo "${value}"
}


# Log script
# date -- script name -- ok/error
function exitlog
{
	NAMEOFFUNCTION=$(fallback "${__ARGS}" "~~")
	if [ -n "${ERROR}" ]; then code="ERROR"; else code="OK"; fi

	if [ "${code}" == "OK" ]; then
		echo "$(date '+%Y-%m-%d %H:%M %a')  --   OK    --  ${NAMEOFFUNCTION}" >> "${LOGPATH}"
	else
		echo "$(date '+%Y-%m-%d %H:%M %a')  --  ERROR  --  ${NAMEOFFUNCTION}" >> "${LOGPATH}"
	fi
}

# Capture if process fails
function onfail
{
	if [ "${?}" != "0" ]; then
		# Error
		ERROR="ERROR"
	fi
}






#
# Script: env.sh
#



#
# Script environment
#
function setenv
{
	export version="0.5.40"

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



#
# Script: install.sh
#



function install
{
	setenv
	version

	printsection "Performing System Updates"
	sudo apt update -y
	sudo apt upgrade -y
	sudo apt install \
		bison \
		curl \
		gawk \
		gcc \
		git \
		gpg \
		htop \
		libncurses5 \
		lsb-release \
		make \
		net-tools \
		rsync \
		software-properties-common \
		tar \
		unzip \
		wget \
		zip \
		-y

	sudo apt -y --fix-broken install

	# Flatpak
	sudo apt install flatpak

	# Snap
	sudo rm -f /etc/apt/preferences.d/nosnap.pref
	sudo apt install snapd

	# Personal
	install_fspop
	install_backup
	install_combine
	install_esync

	backup install
	esync setup

	# Development
	install_jq
	install_nodejs
	install_golang
	install_rust
	install_starship
	install_docker # Docker is last because it takes ages to install

	# GUI
	install_gui

	# SSH
	# $ ssh-keygen
	# $ cd ~/.ssh && ls -al
	# $ vi ~/.ssh/authorized_keys
}



#
# Script: install_dev.sh
#



function install_docker
{
	setenv
    printsection "Installing Docker"
    apt install -y apt-transport-https ca-certificates

	if command_exists docker; then
        command_exists_warning docker
    else
        curl -sSL https://get.docker.com | sudo sh
	fi

    sudo chmod 666 /var/run/docker.sock
    sudo systemctl enable docker
    sudo systemctl stop docker
    sudo service docker stop
}

function install_golang
{
	setenv
    printsection "Installing Go-lang"

	if command_exists go; then
        command_exists_warning go
    else
        curl -OL https://golang.org/dl/go1.21.6.linux-amd64.tar.gz
		tar -C /usr/local -xvf go1.21.6.linux-amd64.tar.gz
		export GOROOT=/usr/local/go
		export GOPATH=$HOME/go
		mkdir -p $GOPATH/bin
		echo "export GOROOT=/usr/local/go" >> ~/.bashrc
		echo "export GOPATH=\$HOME/go" >> ~/.bashrc
		echo "export PATH=\$PATH:/usr/local/go/bin:\$HOME/go/bin" >> ~/.bashrc
		source ~/.bashrc
	fi

	refreshenv

	if command_exists tinygo; then
        command_exists_warning tinygo
    else
		wget https://github.com/tinygo-org/tinygo/releases/download/v0.30.0/tinygo_0.30.0_amd64.deb
		sudo dpkg -i tinygo_0.30.0_amd64.deb
	fi

	go get github.com/jesseduffield/lazydocker
	go install github.com/jesseduffield/lazydocker@latest
}

function install_jq
{
	setenv

	if command_exists jq; then
        command_exists_warning jq
    else 
        echo "Installing jq"
        curl --silent -Lo /bin/jq https://github.com/stedolan/jq/releases/download/jq-1.7.1/jq-linux64
        chmod +x /bin/jq
	fi
}

function install_nodejs
{
	setenv
    printsection "Installing NodeJS"

	if command_exists node; then
        command_exists_warning node
    else
        curl -fsSL https://raw.githubusercontent.com/tj/n/master/bin/n | bash -s lts
		npm install -g n
		npm install -g npm@latest
		# n install 20.9.0
		# n use 20.9.0

		# yarn
		corepack enable
		corepack prepare yarn@stable --activate
		yarn set version stable

		# globals
		npm -g i tsc nx pm2
	fi
}

function install_rust
{
	setenv
    printsection "Installing Rust"

	curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
}

function install_starship
{
	setenv
    printsection "Installing Starship.rs"

	curl -sS https://starship.rs/install.sh | sh
	echo "eval \"\$(starship init bash)\"" >> ~/.bashrc
}



#
# Script: install_gui.sh
#



#
# https://flathub.org
#

function install_gui
{
	setenv
    printsection "Installing GUI apps"

	# essential
	sudo apt install p7zip
	flatpakget chrome com.google.Chrome
	flatpakget mpv io.mpv.Mpv
	flatpakget texteditor org.gnome.TextEditor

	# media
	sudo snap install foobar2000
	flatpakget vlc org.videolan.VLC
	flatpakget plexdesktop tv.plex.PlexDesktop

	# programming
	flatpakget androidstudio com.google.AndroidStudio
	flatpakget beekeeperstudio io.beekeeperstudio.Studio # SQL editor
	flatpakget gitkraken com.axosoft.GitKraken
	flatpakget vscode com.visualstudio.code

	#  cli
	fetch_install_binary "yt-dlp" "yt-dlp_linux" "https://github.com/yt-dlp/yt-dlp/releases/download/2023.12.30/yt-dlp_linux"
	sudo apt install -y \
		aria2 \
		cloc \ 
		composer \ 
		ffmpeg \
		git \ 
		mediainfo \
		flac

	# misc
	flatpakget audacity org.audacityteam.Audacity
	flatpakget blender org.blender.Blender
	flatpakget missioncenter io.missioncenter.MissionCenter
	flatpakget obsidian md.obsidian.Obsidian
	flatpakget pupgui2 net.davidotek.pupgui2 # Install and manage Wine/Proton
	flatpakget slack com.slack.Slack
	flatpakget steam com.valvesoftware.Steam
	flatpakget todoist com.todoist.Todoist 
	flatpakget xnconvert com.xnview.XnConvert

	fetch_install_deb "KeeWeb-1.18.7.linux.x64.deb" "https://github.com/keeweb/keeweb/releases/download/v1.18.7/KeeWeb-1.18.7.linux.x64.deb"
}



#
# Script: install_my.sh
#



function install_fspop
{
	setenv
	printsection "fspop"

	apt -qq install wget unzip

	version="v1.3.6"
	release_url="https://releases.mrrtt.me/fspop"

	arch="amd64"

	echo
	echo "Downloading fspop from ${release_url}"
	curl -L "${release_url}/${version}/fspop-${version}-linux_${arch}.zip" -o fspop.zip
	onfail
	echo

	# Extract fspop release zip
	unzip fspop.zip
	onfail

	rm fspop.zip

	chmod +x fspop
	mv -f fspop "${dir_local_bin}/fspop"

	success "Success. fspop is good to go!"
}

function install_backup
{
	setenv
	printsection "backup script"
	curl -L https://github.com/hmerritt/backup-script/releases/download/v0.2.7/backup.sh -o backup.sh
	onfail

	chmod +x backup.sh
	onfail
	mv -f backup.sh "${dir_local_bin}/backup"
	onfail

	success "Success. backup script is good to go!"
}

function install_combine
{
	setenv
	printsection "> combine script"
	curl -L https://raw.githubusercontent.com/hmerritt/combine-script/master/src/combine.sh -o combine.sh
	onfail

	chmod +x combine.sh
	onfail
	mv -f combine.sh "${dir_local_bin}/combine"
	onfail

	success "Success. combine script is good to go!"
}

function install_esync
{
	setenv
	printsection "> esync script"
	curl -L https://github.com/hmerritt/esync-script/releases/download/v0.1.8/esync.sh -o esync.sh
	onfail

	chmod +x esync.sh
	onfail
	mv -f esync.sh "${dir_local_bin}/esync"
	onfail

	success "Success. esync script is good to go!"
}



#
# Script: main.sh
#



function main
{
	refreshenv
	install
}



#
# Script: utils.sh
#



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

    flatpak install -y --noninteractive flathub "${appuri}"
}


#
# Combine.sh Helper Functions
#

# Print a list of script commands
function __combinescript__print_commands
{
    echo "Commands"
    echo "  * run <fn>  |  run a function"
	echo "  * cat <fn>  |  prints function code"
    echo "  * help      |  print script help"
    echo "  * repl      |  shell to run multiple commands (not for programmatic use)"
}


# Print a list of all functions
# within the current script
function __combinescript__print_functions
{
	echo "Functions"
    # grep "^function" $0
    grep "^function" $0 | while read -r line ; do
		# Exclude native combine functions
		if [ "$line" != "function cprint" ] && [ "$line" != "function white" ] && [ "$line" != "function green" ] && [ "$line" != "function red" ] && [ "$line" != "function orange" ] && [ "$line" != "function success" ] && [ "$line" != "function failure" ] && [ "$line" != "function error" ] && [ "$line" != "function warning" ] && [ "$line" != "function fallback" ] && [ "$line" != "function exitlog" ] && [ "$line" != "function onfail" ] && [ "$line" != "function __combinescript__print_functions" ] && [ "$line" != "function __combinescript__print_commands" ] && [ "$line" != "function __combinescript__print_help" ]; then
		    fname=$(echo "${line}" | sed -n 's/function //p')
			echo "  * ${fname}"
		fi
	done
    grep -e "^\w*\s()" -e "^\w*()" $0 | while read -r line ; do
		fname=$(echo "${line}" | grep -o "^\w*\b")
		echo "  * ${fname}"
	done
}


# Print combine-script help
function __combinescript__print_help
{
    echo "Help:"
    echo
    __combinescript__print_commands
    echo
    __combinescript__print_functions
}


# Print combine-script help message
# if no arguments have been passed
if [ "${1}" = "" ] || [ "${1}" = "help" ] || [ "${1}" = "h" ]; then
  __combinescript__print_help
  exit 0
fi


# Command,  cat
# > Print function code
if [ "${1}" = "cat" ]; then
    if [ "${2}" = "" ]; then
        echo -e "\e[31mNo function passed\033[0m"
        echo "cat <function>"
        echo
        exit 0
    else
		declare -f "${@: 2}"
    fi
fi


# Command,  run
# > Run function via CLI
if [ "${1}" = "run" ]; then
    if [ "${2}" = "" ]; then
        echo -e "\e[31mNo function passed\033[0m"
        echo "run <function>"
        echo
        exit 0
    else
        "${@: 2}"

		onfail

		# Log what just ran
		if [ "${LOG}" == "yes" ]; then
			exitlog
		fi

		# If ERROR, force exit code
		if [ -n "${ERROR}" ]; then
			exit 1
		fi
    fi
fi


# Command,  repl
# > Interactive REPL
if [ "${1}" = "repl" ]; then
  __combinescript__print_help

  # Init repl
  while true ; do
    while IFS="" read -r -e -d $'\n' -p ':$ ' options; do
  	  if [ "$options" = "quit" ]; then
	    exit 0
	  else
	    ${options}
	    echo
	  fi
	done
  done
fi

