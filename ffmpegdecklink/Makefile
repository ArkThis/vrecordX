# Which ffmpeg release/version to build:
#FFMPEG_RELEASE := http://ffmpeg.org/releases/ffmpeg-6.0.tar.bz2
FFMPEG_RELEASE := https://ffmpeg.org/releases/ffmpeg-5.1.3.tar.bz2
# Filename to save the source code to:
FFMPEG_ZIP := ffmpeg-stable.tar.bz2
# Folder where to build ffmpeg:
FFMPEG_DIR := build

# Folder where the Blackmagic SDK library source code is located.
DECKLINK_SDK := ../../DecklinkSDK/Linux/include

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
FF_COMPILE_FLAGS_DV := $(FF_COMPILE_FLAGS) $(FF_COMPILE_FLAGS_DV)

.PHONY: clean install prep prep-dv ffmpeg ffmpeg-download

prep:
	sudo apt update
	sudo apt install \
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


# Dependencies for DV capture:
prep-dv:
	sudo apt install \
	libiec61883-dev \
	libraw1394-dev \
	libavc1394-dev \
	libavc1394-tools



# ---------------------------

$(FFMPEG_DIR):
	mkdir $(FFMPEG_DIR)

ffmpeg-download: $(FFMPEG_DIR)
	wget -cO $(FFMPEG_ZIP) $(FFMPEG_RELEASE)
	tar --strip-components=1 --skip-old-files -xjf $(FFMPEG_ZIP) -C $(FFMPEG_DIR)

ffmpeg: ffmpeg-download
	cd $(FFMPEG_DIR) && ./configure --prefix=$(FF_PREFIX) $(FF_COMPILE_FLAGS) && make $(PARALLEL_MAKE)

ffmpeg-dv: ffmpeg-download
	cd $(FFMPEG_DIR) && ./configure --prefix=$(FF_PREFIX) $(FF_COMPILE_FLAGS_DV) && make $(PARALLEL_MAKE)


# ---------------------------

# Folder where vrecord is looking for ffmpeg-decklink binaries:
$(BREW_FFDECKLINK):
	    mkdir -vp $(BREW_FFDECKLINK)

# There probably is a more elegant way to copy these 2 files in one make-rule, but it works.
$(BREW_FFDECKLINK)/ffmpeg-dl: $(BREW_FFDECKLINK) $(FFMPEG_DIR)/ffmpeg
	cp -avi $(FFMPEG_DIR)/ffmpeg $(BREW_FFDECKLINK)/ffmpeg-dl

$(BREW_FFDECKLINK)/ffplay-dl: $(BREW_FFDECKLINK) $(FFMPEG_DIR)/ffplay
	cp -avi $(FFMPEG_DIR)/ffplay $(BREW_FFDECKLINK)/ffplay-dl

# Call this one (as sudo) to put the binaries in place:
install: $(BREW_FFDECKLINK)/ffmpeg-dl $(BREW_FFDECKLINK)/ffplay-dl


clean:
	@echo "Cleaning up temp files..."
	rm -r $(FFMPEG_DIR)
	rm $(FFMPEG_ZIP)

