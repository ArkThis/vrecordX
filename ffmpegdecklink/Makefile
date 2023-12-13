# Which ffmpeg release/version to use:
#FFMPEG_RELEASE := http://ffmpeg.org/releases/ffmpeg-6.0.tar.bz2
FFMPEG_RELEASE_URL := https://ffmpeg.org/releases
FFMPEG_SOURCE_TAR := ffmpeg-5.1.3.tar.bz2
FFMPEG_RELEASE := $(FFMPEG_RELEASE_URL)/$(FFMPEG_SOURCE_TAR)

# Folder where to build ffmpeg:
FFMPEG_DIR := build

# Folder where the Blackmagic SDK library source code is located.
DECKLINK_SDK := ../../DecklinkSDK/Linux/include

# Comment this out to disable DV support (and dependencies):
WITH_DV = true

# Folder where vrecord expects ffmpeg-decklink binaries to be.
#
# (Note: The /usr/local/opt is non-POSIX, but merely linuxbrew-specific (AFAIK)).
# Maybe it'd be good to add preference for /opt/ffmpeg/decklink to support
# proper Linux paths.
#
# See: [Linux Filesystem Hierarchy (TLDP)](https://tldp.org/LDP/Linux-Filesystem-Hierarchy/html/opt.html)
#
# Splitting "ffmpegdecklink" into "ffmpeg/decklink" as subfolder would also
# allow having multiple versions of FFmpeg in parallel subfolders of /opt/ffmpeg.
# Which, btw is the case I do have on several machines/setups productively.
#
# My suggestion:
#BREW_FFDECKLINK := /opt/ffmpeg/decklink/bin
BREW_FFDECKLINK := /usr/local/opt/ffmpegdecklink/bin

# FFmpeg configure parameters:
FF_PREFIX := /opt/ffmpegdecklink
FF_LICENSES := --enable-gpl --enable-version3
FFPLAY_SPECIFIC := --enable-postproc --enable-ffplay
PARALLEL_MAKE := -k -j16

## Default compile flags:
FF_COMPILE_FLAGS1 := --disable-shared $(FF_LICENSES) $(FFPLAY_SPECIFIC)
FF_COMPILE_FLAGS2 := \
	--enable-libfreetype \
	--enable-libmp3lame \
	--enable-libopenjpeg \
	--enable-libopus \
	--enable-libsnappy \
	--enable-libtheora \
	--enable-libvorbis \
	--enable-libvpx \
	--enable-libx264 \
	--enable-libxvid \
	--enable-libfontconfig \
	--disable-libjack \
	--disable-indev=jack
FF_COMPILE_FLAGS3 := \
	--enable-swscale \
	--enable-avfilter \
	--enable-pthreads \
	--enable-bzlib \
	--enable-zlib
FF_COMPILE_FLAGS_DV := \
	--enable-libiec61883

FF_DECKLINK := \
	--pkg-config-flags=--static \
	--extra-libs='-lpthread -lm' \
	--enable-nonfree \
	--extra-cflags='-I$(DECKLINK_SDK)' \
	--extra-ldflags='-I$(DECKLINK_SDK)' \
	--enable-decklink

FF_COMPILE_FLAGS := $(FF_COMPILE_FLAGS1) $(FF_COMPILE_FLAGS2) $(FF_COMPILE_FLAGS3) $(FF_DECKLINK)

PKG_DEFAULT = \
	build-essential \
	yasm \
	libbz2-dev \
	libfreetype6-dev \
	libopenjp2-7-dev \
	libvpx-dev \
	libvorbis-dev \
	libxvidcore-dev \
	libmp3lame-dev \
	libx264-dev \
	libfaac-dev \
	libfaad-dev \
	libx265-dev \
	libsdl2-dev \
	libva-dev \
	libvdpau-dev \
	libxcb1-dev \
	libxcb-shm0-dev \
	libxcb-xfixes0-dev \
	libopus-dev \
	libsnappy-dev \
	libtheora-dev \
	libfontconfig1-dev

PKG_DV = \
	libiec61883-dev \
	libraw1394-dev \
	libavc1394-dev \
	libavc1394-tools

PACKAGES := $(PKG_DEFAULT)

# Compile with DV support:
ifdef WITH_DV
	FF_COMPILE_FLAGS := $(FF_COMPILE_FLAGS) $(FF_COMPILE_FLAGS_DV)
	PACKAGES := $(PACKAGES) $(PKG_DV)
endif


# ---------------------------

APT_UPDATED := apt-updated
apt-updated:
	$(info "Updating package source lists...")
	sudo apt update && touch $(APT_UPDATED)


.PHONY: prep
prep: apt-updated
	$(info "Installing required packages...")
	sudo apt install $(PACKAGES)


# ---------------------------

.PHONY: ffmpeg-download
ffmpeg-download: $(FFMPEG_DIR)
	$(info "Downloading FFmpeg source from upstream...")
	wget -cO $(FFMPEG_SOURCE_TAR) $(FFMPEG_RELEASE)


$(FFMPEG_DIR):
	mkdir $(FFMPEG_DIR)


# The tarball is either already included in the git repository, or can be
# downloaded from upstream:
$(FFMPEG_SOURCE_TAR): ffmpeg-download


.PHONY: ffmpeg-unpack
ffmpeg-unpack: $(FFMPEG_SOURCE_TAR) $(FFMPEG_DIR)
	tar --strip-components=1 --skip-old-files -xjf $(FFMPEG_SOURCE_TAR) -C $(FFMPEG_DIR)

.PHONY: ffmpeg
ffmpeg: ffmpeg-unpack
	$(info "Building FFmpeg...")
	cd $(FFMPEG_DIR) && ./configure --prefix=$(FF_PREFIX) $(FF_COMPILE_FLAGS) && make $(PARALLEL_MAKE)


# ---------------------------

# Folder where vrecord is looking for ffmpeg-decklink binaries:
$(BREW_FFDECKLINK):
	mkdir -vp $(BREW_FFDECKLINK)

# There probably is a more elegant way to copy these 2 files in one make-rule, but it works.
$(BREW_FFDECKLINK)/ffmpeg-dl: $(BREW_FFDECKLINK) $(FFMPEG_DIR)/ffmpeg
	cp -avi $(FFMPEG_DIR)/ffmpeg $(BREW_FFDECKLINK)/ffmpeg-dl

$(BREW_FFDECKLINK)/ffplay-dl: $(BREW_FFDECKLINK) $(FFMPEG_DIR)/ffplay
	cp -avi $(FFMPEG_DIR)/ffplay $(BREW_FFDECKLINK)/ffplay-dl


# ---------------------------

# Call this one (as sudo) to put the binaries in place:
.PHONY: install
install: $(BREW_FFDECKLINK)/ffmpeg-dl $(BREW_FFDECKLINK)/ffplay-dl


.PHONY: all
all: prep ffmpeg


.PHONY: clean
clean:
	$(info "Cleaning up temp files...")
	rm -rf $(FFMPEG_DIR)
	rm -f $(APT_UPDATED)

