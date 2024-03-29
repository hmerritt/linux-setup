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
	symlink_localbin "yt-dlp" "youtube-dl"
	symlink_localbin "yt-dlp" "yt"
	sudo apt install -y aria2 cloc composer ffmpeg git mediainfo flac

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

	# @note this doesn't work
	# fetch_install_deb "KeeWeb-1.18.7.linux.x64.deb" "https://github.com/keeweb/keeweb/releases/download/v1.18.7/KeeWeb-1.18.7.linux.x64.deb"

	# rio
	fetch_install_binary "rio" "rio" "https://raw.githubusercontent.com/hmerritt/linux-bucket/master/bucket/rio/rio" # terminal
	curl "https://raw.githubusercontent.com/hmerritt/linux-bucket/master/bucket/rio/config.toml" -o config.toml
	mv -f config.toml ~/.config/rio/config.toml

	install_gui_macos_theme
}

function install_gui_macos_theme
{
	setenv

	# MacOS Big Sur like theme https://github.com/vinceliuice/WhiteSur-gtk-theme
	cd ~
	git clone https://github.com/vinceliuice/WhiteSur-gtk-theme.git --depth=1 && cd WhiteSur-gtk-theme
	./install.sh -l
	sudo ./tweaks.sh -F
	sudo ./tweaks.sh -f
	sudo ./tweaks.sh -g
	cd ../
	# Wallpaper
	git clone https://github.com/vinceliuice/WhiteSur-wallpapers && cd WhiteSur-wallpapers
	sudo ./install-gnome-backgrounds.sh
	cd ../
	# Icons
	git clone https://github.com/vinceliuice/WhiteSur-icon-theme && cd WhiteSur-icon-theme
	sudo ./install.sh
	cd ../
	# Cleanup
	# rm -rf WhiteSur-gtk-theme WhiteSur-wallpapers WhiteSur-icon-theme
	# Misc
	sudo flatpak override --filesystem=xdg-config/gtk-4.0
	# GNOME Shell extensions
	xdg-open https://extensions.gnome.org/extension/19/user-themes/     # user-themes
	xdg-open https://extensions.gnome.org/extension/307/dash-to-dock/   # dash-to-dock
	xdg-open https://extensions.gnome.org/extension/3193/blur-my-shell/ # blur-my-shell
}
