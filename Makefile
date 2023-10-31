.PHONY: prep all install ffmpeg gtkdialog

# Install prerequisites
prep:
	# Regular distribution repositories:
	sudo apt install cowsay vlc mpv mediainfo-gui git build-essential
	# Requires MediaArea repositories enabled:
	# (For instructions see INSTALL.md - or the [MediaArea Website](https://mediaarea.net/en/Repos))
	sudo apt install qctools qcli


# Build FFmpeg
ffmpeg:
	make prep
	cd ffmpegdecklink && make prep && make ffmpeg


# Build GTKdialog
gtkdialog:
	make prep
	cd gtkdialog && make prep && make gtkdialog


# Build everything
all:
	make ffmpeg
	make gtkdialog


# Install everything
install:
	cd ffmpegdecklink && sudo make install
	cd gtkdialog && sudo make install
