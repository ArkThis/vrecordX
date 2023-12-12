.PHONY: add-mediaarea prep all install ffmpeg gtkdialog

MA_REPO_DEB = repo-mediaarea_1.0-24_all.deb 

# Install prerequisites
$(MA_REPO_DEB):
	# It makes sense to add the [MediaArea repository (Release versions)](https://mediaarea.net/en/Repos) to your system:
	echo "Adding MediaArea repository package source..."
	wget https://mediaarea.net/repo/deb/$(MA_REPO_DEB) && sudo dpkg -i $(MA_REPO_DEB) && sudo apt-get update

prep: $(MA_REPO_DEB)
	# Regular distribution repositories:
	sudo apt install cowsay vlc mpv mediainfo-gui git build-essential
	# Requires MediaArea repositories enabled:
	# (For instructions see INSTALL.md - or the [MediaArea Website](https://mediaarea.net/en/Repos))
	sudo apt install qctools qcli


# Optional packages for full vrecord use:
# NOTE: for these to pull the right packages, please add the MediaArea repository first!
# (see "prep:")
prep-optional: prep
	sudo apt install \
	curl \
	gnuplot \
	xmlstarlet \
	mkvtoolnix \
	mediaconch


# Build FFmpeg
ffmpeg:
	echo "Building ffmpeg with Decklink SDI support (no DV)..."
	make prep
	cd ffmpegdecklink && make prep && make ffmpeg


ffmpeg-dv: prep
	echo "Building ffmpeg with Decklink SDI and DV support..."
	cd ffmpegdecklink && make prep-dv && make ffmpeg-dv


# Build GTKdialog
gtkdialog:
	make prep
	cd gtkdialog && make prep && make gtkdialog


# Build everything
all:
	make ffmpeg-dv
	make gtkdialog


# Install everything
install:
	cd ffmpegdecklink && sudo make install
	cd gtkdialog && sudo make install
