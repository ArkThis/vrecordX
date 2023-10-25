#!/bin/bash
# @author: Peter B. (pb at ArkThis dot com)
# @date: 2023-10-18

FFMPEG="/usr/local/opt/ffmpegdecklink/bin/ffmpeg-dl"
FFPLAY="/usr/local/opt/ffmpegdecklink/bin/ffplay-dl"

# Get this name by "copy/pasting" the string shown in '[]' by 
# `$ ffmpeg -sources decklink`.
DL_CARD="DeckLink SDI 4K"
#DL_CARD="ArkThis Decklink SDI B"

CONTAINER="-f matroska"
DIR_OUT="/home/pb/storage/Filmzeug/Captures/vrecord"
FRAMEMD5="$VIDEO_OUT.framemd5"

TITLE="mode:record - video:'sdi' audio:'embedded' - to end recording press q, esc, or close video window"

COLOR_TV="-color_primaries bt470bg -color_trc bt709 -colorspace bt470bg -color_range tv"
COLOR_FULL="-color_primaries bt470bg -color_trc bt709 -colorspace bt470bg -color_range pc"
COLOR=$COLOR_TV

# Decklink raw input format:
# (This is *not* pix_fmt syntax-compatible)
RAW_FORMAT="auto"           # This is the default which means 8-bit YUV 422 or 8-bit ARGB if format autodetection is used, 8-bit YUV 422 otherwise. 
RAW_FORMAT="yuv422p10"      # 10bpc YUV 422
RAW_FORMAT="uyvy422"        # 8bpc YUV 422

#LIMIT="-t 10"


# Experimental (not tested yet) options.

# MAX_DELAY="-max_delay 200"      # Integer
# RTBUFSIZE="-rtbufsize 128M"


# ------------------------------

ACTION="$1"
VIDEO_NAME="$2"
VIDEO_OUT="$DIR_OUT/$VIDEO_NAME.mkv"

LIMIT="-t 12000" # 200 minutes (in seconds)


REC="$FFMPEG -y \
    -nostdin -nostats $LIMIT -timecode_format none \
    $RTBUFSIZE \
    $MAXDELAY \
    -loglevel info \
    -f decklink -draw_bars 0 \
    -audio_input embedded -video_input sdi -format_code pal \
    -channels 8 -audio_depth 32 \
    -raw_format $RAW_FORMAT \
    -i '$DL_CARD' \
    -map_metadata 0:s:v:0 \
    $COLOR \
    -metadata creation_time=now \
    -c:v ffv1 -level 3 -g 1 -slices 24 -slicecrc 1 \
    -c:a pcm_s24le -metadata:s:v:0 encoder='FFV1 version 3' \
    -filter_complex '[0:v:0]setdar=4/3; [0:a:0]pan=stereo| c0=c0 | c1=c1[stereo1]' -map [stereo1] \
    $CONTAINER $VIDEO_OUT \
    -an -f framemd5 $FRAMEMD5 \
    -c copy -c:a pcm_s24le \
    -map 0 \
    -f matroska -write_crc32 0 -live true -"

PLAY="$FFPLAY \
    -v info -hide_banner -stats -autoexit \
    -probesize 32 -sync video \
    -window_title '$TITLE' \
    -i - -af channelmap='0|1:stereo'"

PASS="$FFMPEG \
    -nostdin -nostats $LIMIT -timecode_format none \
    -loglevel info \
    -f decklink -draw_bars 0 \
    -audio_input embedded -video_input sdi -format_code pal \
    -channels 8 -audio_depth 32 \
    -raw_format $RAW_FORMAT \
    -i '$DL_CARD' \
    -map_metadata 0:s:v:0 \
    $COLOR \
    -metadata creation_time=now \
    -c copy -c:a pcm_s24le \
    -map 0 \
    -f matroska -write_crc32 0 -live true -"

case $ACTION in
    list)
        echo "Listing available decklink devices..."
        $FFMPEG -hide_banner -sources decklink
        ;;

    rec)
        # Here, a video name (to write to) is mandatory:
        if [ -z "$VIDEO_NAME" ]; then
            echo "ERROR: No video name given."
            exit 1
        fi
        sleep 1

        echo "Writing to video: '$VIDEO_OUT'..."
        CMD="$REC | $PLAY"
        ;;
    pass)
        CMD="$PASS | $PLAY"
        ;;
    *)
        echo "Syntax: {rec,play} video_out"
        exit 0
        ;;
esac


echo "$CMD"

sleep 2
eval "$CMD"
