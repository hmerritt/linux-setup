#!/bin/bash

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
