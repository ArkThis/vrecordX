# Which ffmpeg release/version to use:
#FFMPEG_VERSION := 6.1
#FFMPEG_RELEASE := https://ffmpeg.org//releases/ffmpeg-6.1.tar.bz2
FFMPEG_VERSION := 5.1.3
#DECKLINK_SDK_VERSION := 12.4.2
DECKLINK_SDK_VERSION := 12.9
FFMPEG_RELEASE := https://ffmpeg.org/releases/ffmpeg-$(FFMPEG_VERSION).tar.bz2
FFMPEG_ZIP := ffmpeg-$(FFMPEG_VERSION).tar.bz2

# Folder where to build ffmpeg:
FFMPEG_DIR := build

# Comment this line out to disable Decklink SDK support (and dependencies):
WITH_DECKLINK = true
# Folder where the Blackmagic SDK library source code is located.
DECKLINK_SDK := ../../DecklinkSDK/Linux/v$(DECKLINK_SDK_VERSION)/include

# Comment this line out to disable DV support (and dependencies):
WITH_DV = true

# Comment this line out to disable NVIDIA CUDA support (and dependencies):
#WITH_CUDA = true
CUDA_SDK := /usr/local/cuda/include
CUDA_SDK_LD := /usr/local/cuda/lib64

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

FF_COMPILE_FLAGS_CUDA := \
	--enable-nonfree \
	--enable-ffnvcodec \
	--enable-libnpp \
	--extra-cflags='-I$(CUDA_SDK)' \
	--extra-ldflags='-L$(CUDA_SDK_LD)' \
	--enable-cuda-nvcc \
#	--nvccflags="-gencode arch=compute_52,code=sm_52 -O2"
#	--enable-cuda-llvm
#	--disable-static --enable-shared

FF_DECKLINK := \
	--enable-nonfree \
	--pkg-config-flags=--static \
	--extra-libs='-lpthread -lm' \
	--enable-nonfree \
	--extra-cflags='-I$(DECKLINK_SDK)' \
	--extra-ldflags='-I$(DECKLINK_SDK)' \
	--enable-decklink


FF_COMPILE_FLAGS := $(FF_COMPILE_FLAGS1) $(FF_COMPILE_FLAGS2) $(FF_COMPILE_FLAGS3)

PKG_DEFAULT = \
	wget \
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

# Packages for DV support:
PKG_DV = \
	libiec61883-dev \
	libraw1394-dev \
	libavc1394-dev \
	libavc1394-tools

# Packages for NVIDIA CUDA support:
PKG_CUDA = \
	cuda \
	nvidia-driver-545 \
	cuda-toolkit-12 \
	cmake libtool \
	libc6 libc6-dev \
	libnuma1 libnuma-dev

# Assume default set of packages, then add additional requirements on "ifdef" conditions:

PACKAGES := $(PKG_DEFAULT)


# Compile with Decklink support:
ifdef WITH_DECKLINK
	FF_COMPILE_FLAGS := $(FF_COMPILE_FLAGS) $(FF_DECKLINK)
	#PACKAGES := $(PACKAGES) $(PKG_DECKLINK)
endif


# Compile with DV support:
ifdef WITH_DV
	FF_COMPILE_FLAGS := $(FF_COMPILE_FLAGS) $(FF_COMPILE_FLAGS_DV)
	PACKAGES := $(PACKAGES) $(PKG_DV)
endif


# Compile with NVIDIA CUDA support:
ifdef WITH_CUDA
	FF_COMPILE_FLAGS := $(FF_COMPILE_FLAGS) $(FF_COMPILE_FLAGS_CUDA)
	PACKAGES := $(PACKAGES) $(PKG_CUDA)
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
	wget -cO $(FFMPEG_ZIP) $(FFMPEG_RELEASE)


$(FFMPEG_DIR):
	mkdir $(FFMPEG_DIR)


# The tarball is either already included in the git repository, or can be
# downloaded from upstream:
$(FFMPEG_ZIP): ffmpeg-download


.PHONY: ffmpeg-unpack
ffmpeg-unpack: $(FFMPEG_ZIP) $(FFMPEG_DIR)
	tar --strip-components=1 --skip-old-files -xjf $(FFMPEG_ZIP) -C $(FFMPEG_DIR)

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

