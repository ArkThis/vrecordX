FFMPEG_RELEASE := http://ffmpeg.org/releases/ffmpeg-6.0.tar.bz2
FFMPEG_ZIP := ffmpeg-stable.tar.bz2
FFMPEG_DIR := ffmpeg-src
DECKLINK_SDK := ../../DecklinkSDK/Linux/include
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

FF_DECKLINK := \
	--pkg-config-flags=--static \
	--extra-libs='-lpthread -lm' \
	--enable-nonfree \
	--extra-cflags='-I$(DECKLINK_SDK)' \
	--extra-ldflags='-I$(DECKLINK_SDK)' \
	--enable-decklink

FF_COMPILE_FLAGS := $(FF_COMPILE_FLAGS1) $(FF_COMPILE_FLAGS2) $(FF_COMPILE_FLAGS3) $(FF_DECKLINK)


prep:
	sudo apt update
	sudo apt install build-essential yasm libbz2-dev libfreetype6-dev libopenjp2-7-dev libvpx-dev libvorbis-dev libxvidcore-dev libmp3lame-dev libx264-dev libfaac-dev libfaad-dev libx265-dev libsdl2-dev libva-dev libvdpau-dev libxcb1-dev libxcb-shm0-dev libxcb-xfixes0-dev libopus-dev libsnappy-dev libtheora-dev



# ---------------------------

$(FFMPEG_DIR):
	mkdir $(FFMPEG_DIR)

ffmpeg-download: $(FFMPEG_DIR)
	wget -cO $(FFMPEG_ZIP) $(FFMPEG_RELEASE)
	tar --strip-components=1 --skip-old-files -xjf $(FFMPEG_ZIP) -C $(FFMPEG_DIR)

ffmpeg: ffmpeg-download
	cd $(FFMPEG_DIR) && ./configure --prefix=$(FF_PREFIX) $(FF_COMPILE_FLAGS) && make $(PARALLEL_MAKE)


# ---------------------------

clean:
	cd $(FFMPEG_DIR) && make clean

$(BREW_FFDECKLINK)/ffmpeg-dl: $(FFMPEG_DIR)/ffmpeg
	cp -avi $(FFMPEG_DIR)/ffmpeg $(BREW_FFDECKLINK)/ffmpeg-dl

$(BREW_FFDECKLINK)/ffplay-dl: $(FFMPEG_DIR)/ffplay
	cp -avi $(FFMPEG_DIR)/ffplay $(BREW_FFDECKLINK)/ffplay-dl

install: $(BREW_FFDECKLINK)/ffmpeg-dl $(BREW_FFDECKLINK)/ffplay-dl
