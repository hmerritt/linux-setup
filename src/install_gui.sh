#!/bin/bash

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
