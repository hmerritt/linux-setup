#!/bin/bash

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
}

function install_golang_programs
{
	setenv
	refreshenv
    printsection "Installing Go-lang programs"

	go get github.com/jesseduffield/lazydocker
	go install github.com/jesseduffield/lazydocker@latest
}