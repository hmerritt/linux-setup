#!/bin/bash

function install_gui
{
	setenv
    printsection "Installing GUI apps"

	# essential
	sudo apt install p7zip
	sudo snap install p7zip-desktop
	sudo snap install brave
	sudo snap install mpv
	sudo snap install notepad-plus-plus

	# media
	sudo snap install foobar2000
	sudo snap install vlc
	sudo snap install plex-desktop

	# programming
	sudo snap install android-studio --classic
	sudo snap install beekeeper-studio # SQL editor
	sudo snap install code --classic
	sudo snap install gitkraken --classic

	#  cli
	sudo snap install yt-dlp
	# fetch_install_binary "yt-dlp" "yt-dlp_linux" "https://github.com/yt-dlp/yt-dlp/releases/download/2023.12.30/yt-dlp_linux"
	sudo apt install -y \
		aria2 \
		cloc \ 
		composer \ 
		ffmpeg \
		git \ 
		mediainfo \
		flac

	# misc
	sudo snap install todoist
	sudo snap install steam
	sudo snap install audacity
	sudo snap install blender --classic
	fetch_install_deb "KeeWeb-1.18.7.linux.x64.deb" "https://github.com/keeweb/keeweb/releases/download/v1.18.7/KeeWeb-1.18.7.linux.x64.deb"
}
