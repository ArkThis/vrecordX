.PHONY: prep all install clean ffmpeg gtkdialog

# Enable/disable =(un)comment these lines:
WITH_DV = true
#WITH_QCTOOLS = true
#WITH_OPTIONAL = true

# MediaArea repository information package (Debian-based):
MA_REPO_DEB = repo-mediaarea_1.0-24_all.deb 

# List of required packages:
PKG_DEFAULT = vlc mpv cowsay mediainfo-gui git build-essential
PKG_OPTIONAL = curl gnuplot xmlstarlet mkvtoolnix mediaconch
PKG_QCTOOLS = qctools qcli
PKG_DV = dvrescue dvrescue-gui dvgrab

PACKAGES = $(PKG_DEFAULT)

ifdef WITH_DV
	PACKAGES := $(PACKAGES) $(PKG_DV) 
endif
ifdef WITH_QCTOOLS
	PACKAGES := $(PACKAGES) $(PKG_QCTOOLS)
endif
ifdef WITH_OPTIONAL
	PACKAGES := $(PACKAGES) $(PKG_OPTIONAL)
endif

# -------------------------


# Install prerequisites
$(MA_REPO_DEB):
	# It makes sense to add the [MediaArea repository (Release versions)](https://mediaarea.net/en/Repos) to your system:
	# (For more information or additional options see the [MediaArea Website](https://mediaarea.net/en/Repos))
	$(info "Adding MediaArea repository package source...")
	wget https://mediaarea.net/repo/deb/$(MA_REPO_DEB) && sudo dpkg -i $(MA_REPO_DEB)
	# In order to update the package lists, you should usually run `apt update` after adding new repos.
	# Since `apt update`will be called here in the Makefile before installing
	# packages anyways, so we save time here by not doing it ;)


APT_UPDATED := apt-updated
apt-updated:
	$(info "Updating package source lists...")
	sudo apt update && touch $(APT_UPDATED)


prep: $(MA_REPO_DEB) apt-updated
	$(info "Installing required packages...")
	sudo apt install $(PACKAGES)


# Build FFmpeg (SDI-only support):
ffmpeg: prep
	cd ffmpegdecklink && make prep && make ffmpeg


# Build GTKdialog
gtkdialog: prep
	cd gtkdialog && make prep && make gtkdialog


# Build everything
all: ffmpeg gtkdialog


# Install everything
install:
	cd ffmpegdecklink && sudo make install
	cd gtkdialog && sudo make install


clean:
	rm $(MA_REPO_DEB)
	rm $(APT_UPDATED)
