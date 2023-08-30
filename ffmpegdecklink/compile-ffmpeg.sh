#!/bin/bash
# @history:
#   30.08.2023  peter_b     - Added Decklink SDK support.
#   30.10.2020  peter_b     - Added HTTPs support.
#   22.04.2020  peter_b     - Added option to use aptitude for installing prereqs.
#   10.04.2020  peter_b     - Removed libopenjpeg (is "libopenjp2-7" now)
#   01.04.2019  peter_b     - Added DVA Fidelity.
#   03.07.2018  peter_b     - Added H.265
#   07.03.2018  peter_b     - Removed libdirac.
#   30.11.2015  peter_b     - Added libsox as build dependency

# ==============================================
# Compile options:
# ==============================================
LICENSES="--enable-gpl --enable-nonfree --enable-version3"

# TARGET specific flags:
FFMPEG_SPECIFIC="--enable-postproc --enable-ffplay"

# Default compile flags:
COMPILE_FLAGS1="--prefix=/usr/local $LICENSES $FFMPEG_SPECIFIC --enable-swscale --enable-avfilter --enable-pthreads --enable-bzlib --enable-zlib"

# additional A/V formats and codecs:
COMPILE_FLAGS2="--enable-decoder=png --enable-encoder=png"

# additional features:
COMPILE_FLAGS3="--enable-libsoxr"                       # NOTE: libsoxr is only available in very recent distro versions!
# These are necessary to support the https protocol:
#COMPILE_FLAGS_HTTPS="--enable-openssl --enable-gnutls --enable-mbedtls --enable-libtls"
COMPILE_FLAGS_HTTPS="--enable-openssl"


# Additional, but optional compilation flags
OPTIONAL="--enable-libfreetype"
#SHARED="--enable-shared"                                # Build libraries (libavutil, libavcodec, libavformat) as dynamic link libraries.

# Enable muxer for DVA Fidelity analysis
# (requires Georg Lippitsch's patch from 2013)
FIDELITY="--enable-muxer=dvafidelity"

# For FATE tests lines-of-code coverage:
FATE_SUITE="../fate-suite"
COMPILE_FLAGS_FATE="$COMPILE_FLAGS1 $COMPILE_FLAGS2 --toolchain=gcov --samples=$FATE_SUITE"

# Regular build:
COMPILE_FLAGS="$COMPILE_FLAGS1 $COMPILE_FLAGS2 $COMPILE_FLAGS_HTTPS --samples=$FATE_SUITE"
PARALLEL_BUILD="-k -j16"                                 # Settings for running compile/build in parallel

# ==============================================

# Optional codecs:
# --- VIDEO:
#SCHROEDINGER="--enable-libschroedinger"
XVID="--enable-libxvid"
JPEG2000="--enable-libopenjpeg --disable-decoder=jpeg2000"  # Disabling the built-in J2K decoder, because it's buggy/broken for lossless.
# --- AUDIO:
MP3="--enable-libmp3lame"
VORBIS="--enable-libvorbis"
# --- STANDARDS:
MP4_SP="$XVID $MP3"
#MP4_AVC="--enable-libx264 --enable-libfaac"
MP4_AVC="--enable-libx264"
HEVC="--enable-libx265"
WEBM="--enable-libvpx $VORBIS"

# Optional features:
# Decklink device support (requires Decklink SDK in a folder)
# Unzip the Blackmagic Decklink SDK ZIP file, then copy the "Linux/include" subfolder to:
DIR_DECKLINK_SDK="/opt/blackmagic/decklink_sdk"
DECKLINK_SDK="--pkg-config-flags=--static --extra-cflags='-I${DIR_DECKLINK_SDK}' --extra-ldflags='-I${DIR_DECKLINK_SDK}' --extra-libs='-lpthread -lm'"
DECKLINK="$DECKLINK_SDK --enable-decklink"

# Name of application to compile:
TARGET="ffmpeg"

# Build dependencies (Debian/Ubuntu packages):
BUILD_DEPS_WEBM="libvpx-dev libvorbis-dev"              # Dependencies for handling WebM
BUILD_DEPS_MP4_SP="libxvidcore-dev libmp3lame-dev"      # Dependencies for handling MPEG-4 (SP) video (DivX, XviD)
BUILD_DEPS_MP4_AVC="libx264-dev libfaac-dev libfaad-dev" # Dependencies for handling MPEG-4 (AVC) video (H.264)
BUILD_DEPS_HEVC="libx265-dev" # Dependencies for handling MPEG-4 (AVC) video (H.264)
#BUILD_DEPS_COVERAGE="gcov lcov"                         # Lines-of-code coverage (for FATE tests)
BUILD_DEPS_COVERAGE="lcov"                              # Lines-of-code coverage (for FATE tests)
BUILD_DEPS_FFPLAY="libsdl2-dev libva-dev libvdpau-dev libxcb1-dev libxcb-shm0-dev libxcb-xfixes0-dev" # Necessary for ffplay to build

# Orphaned / Unavailable (since Ubuntu 18.04?)
BUILD_DEPS_DIRAC="libschroedinger-dev"     # Dependencies for handling Dirac
#BUILD_DEPS_JPEG2000="libopenjpeg-dev"   # Up to Ubuntu 16.04
BUILD_DEPS_JPEG2000="libopenjp2-7-dev"   # Dependencies for handling JPEG2000

BUILD_DEPS="build-essential yasm libbz2-dev libfreetype6-dev $BUILD_DEPS_JPEG2000 $BUILD_DEPS_WEBM $BUILD_DEPS_MP4_SP $BUILD_DEPS_MP4_AVC $BUILD_DEPS_HEVC $BUILD_DEPS_FFPLAY $BUILD_DEPS_COVERAGE"


function install_prerequisites
{
    APTITUDE="$1"
    if [ -z "$APTITUDE" ]; then
        sudo apt install $BUILD_DEPS
    else
        sudo aptitude install $BUILD_DEPS
    fi
}


function install_package
{
    local VERSION="$1"
    local MAINTAINER="$2"

    local DIR_TARGET="$TARGET-$VERSION"
    local VERSION_NUMBER="$(cd $DIR_TARGET; ./version.sh)"

    echo "Packaging and installing '$TARGET' ($VERSION_NUMBER)..."

    # Taken from "https://gist.github.com/faleev/3435377":
    (cd $DIR_TARGET; checkinstall --pkgname=ffmpeg --pkgversion="6:$($DIR_TARGET/version.sh)dva1-0" --backup=no --deldoc=yes --fstrans=no --default --maintainer=$MAINTAINER)
}


function compile
{
    local VERSION="$1"
    local COMPILE_FLAGS="$2"

    local DIR_TARGET="$TARGET-$VERSION"

    echo "Compiling $TARGET version '$VERSION'..."

    if [ ! -d "$DIR_TARGET" ]; then
        echo "ERROR: compile target folder '$DIR_TARGET' does not exist!"
        return 1
    fi

    # Show TARGET version:
    cd "$DIR_TARGET"
    cat RELEASE

    cmd="./configure $COMPILE_FLAGS && make clean && make $PARALLEL_BUILD"
    #cmd="./configure $COMPILE_FLAGS" # DEBUG: configure only.
    echo ""
    echo $cmd
    sleep 5

    eval "$cmd"   
}


##
# Lists all Makefile targets of FATE tests.
#
function list_fate
{
    local VERSION="$1"

    local DIR_TARGET="$TARGET-$VERSION"
    cd "$DIR_TARGET"
    ./version.sh

    local CMD="make fate-list"
    echo "$CMD"
    sleep 2
    eval "$CMD"
}


function make_lcov
{
    local VERSION="$1"

    local DIR_TARGET="$TARGET-$VERSION"
    cd "$DIR_TARGET"
    ./version.sh

    local CMD="make lcov-reset"
    echo "$CMD"
    sleep 2
    eval "$CMD"

    local CMD="make fate $PARALLEL_BUILD"
    echo "$CMD"
    sleep 2
    eval "$CMD"

    local CMD="make lcov"
    echo "$CMD"
    sleep 2
    eval "$CMD"
}



case $1 in
    prepare)
        # This prepares the build-environment:
        install_prerequisites "$2"
    ;;

    checkout)
        # Checks out the current $VERSION version of $TARGET:
        VERSION="git";
        git clone git://source.$TARGET.org/$TARGET.git $TARGET-git
    ;;

    git-revert)
        # Reverts locally modified files to lastest git head:
        # TODO.
    ;;

    fate-list)
        list_fate "git-fate"
    ;;

    fate-lcov)
        make_lcov "git-fate"
    ;;

    # -----------------------------------
    git)
        VERSION="git";
        COMPILE_FLAGS="$COMPILE_FLAGS $OPTIONAL $JPEG2000 $WEBM $MP4_AVC $HEVC"
        compile "$VERSION" "$COMPILE_FLAGS"
    ;;

    decklink)
        VERSION="decklink";
        COMPILE_FLAGS="$COMPILE_FLAGS $OPTIONAL $JPEG2000 $WEBM $MP4_AVC $HEVC $DECKLINK"
        compile "$VERSION" "$COMPILE_FLAGS"
    ;;


    # Used for adding new FATE tests:
    git-fate)
        VERSION="git-fate";
        COMPILE_FLAGS="$COMPILE_FLAGS_FATE $OPTIONAL $SCHROEDINGER $JPEG2000 $WEBM $MP4_AVC $HEVC"
        compile "$VERSION" "$COMPILE_FLAGS"
    ;;

    # Used for testing patches:
    git-patched)
        VERSION="git-patched";
        COMPILE_FLAGS="$COMPILE_FLAGS $OPTIONAL $JPEG2000 $WEBM $MP4_AVC $HEVC"
        compile "$VERSION" "$COMPILE_FLAGS"
    ;;

    fidelity)
        VERSION="fidelity";
        COMPILE_FLAGS="$COMPILE_FLAGS $OPTIONAL $FIDELITY"
        compile "$VERSION" "$COMPILE_FLAGS"
    ;;

    stable)
        VERSION="stable";
        COMPILE_FLAGS="$COMPILE_FLAGS $OPTIONAL $WEBM $MP4_AVC $JPEG2000 $HEVC"
        compile "$VERSION" "$COMPILE_FLAGS"
    ;;

    # -----------------------------------
    stable-install)
        VERSION="stable";
        MAINTAINER="pb@das-werkstatt.com"
        install_package "$VERSION" "$MAINTAINER"
    ;;

    # -----------------------------------

    *)
        echo ""
        echo "SYNTAX: $0 ACTION"
        echo ""
        echo "Available ACTIONs:"
        echo " -- Preparation:"
        echo "  prepare:        Installs Debian/Ubuntu packages for building $TARGET"
        echo "  checkout:       Checks out the current git version of $TARGET"
        echo ""
        echo " -- Configure and make builds:"
        echo "  git:            Current git version"
        echo "  git-fate:       Version used to ate FATE tests"
        echo "  git-patched:    Version used to to test/extract patches"
        echo "  fidelity:       Version used for DVA-Fidelity tests"
        echo "  stable:         Current stable version"
        echo "  decklink:       Compile against DecklinkSDK for SDI support"
        echo ""
        echo " -- FATE tests:"
        echo "  fate-list:      List FATE targets"
        echo "  fate-lcov:      Run FATE tests and generate LCOV HTML output"
        echo ""
        echo " -- Installation:"
        echo "  stable-install: Install version in folder 'stable' using 'checkinstall'."
        echo ""
        exit 0
    ;;
esac


