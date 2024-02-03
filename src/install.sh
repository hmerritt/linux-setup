#!/bin/bash

function install
{
	setenv
	version

	printsection "Performing System Updates"
	apt update -y
	apt upgrade -y
	apt install \
		bison \
		curl \
		gawk \
		git \
		gpg \
		htop \
		libncurses5 \
		lsb-release \
		net-tools \
		rsync \
		snapd \
		software-properties-common \
		tar \
		unzip \
		wget \
		zip \
		-y

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
	install_golang_programs
	install_docker # Docker is last because it takes ages to install

	# SSH
	# $ ssh-keygen
	# $ cd ~/.ssh && ls -al
	# $ vi ~/.ssh/authorized_keys
}
