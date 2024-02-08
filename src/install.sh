#!/bin/bash

function install
{
	setenv
	version

	printsection "Performing System Updates"
	sudo apt update -y
	sudo apt upgrade -y
	sudo apt -y --fix-broken install
	sudo apt install -y \
		bison \
		cmake \
		curl \
		dialog \
		fontconfig \
		g++ \
		gawk \
		gcc \
		gcc \
		git \
		gnome-shell-extensions \
		gpg \
		htop \
		imagemagick \
		inkscape \
		libglib2.0-dev-bin \
		lsb-release \
		make \
		make \
		net-tools \
		optipng \
		pkg-config \
		rsync \
		sassc \
		software-properties-common \
		tar \
		unzip \
		wget \
		zip

	sudo apt -y --fix-broken install

	# Flatpak
	sudo apt install flatpak
	sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

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
