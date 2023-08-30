# FFmpeg with Decklink support

I'd love to use linuxbrew recipes here, but not in its own dependency-bubble,
but rather just compiling against localy system libs. And I don't know if
that's possible or how to do that.

Therefore, anything in this folder is to facilitate an easy build of FFmpeg
with Blackmagic/Decklink support.


## Requirements

  1. Blackmagic Developer SDK
     Use the ones from here, or download them from:
     https://www.blackmagicdesign.com/

     For example: *Support > Decklink SDI 4k > "Desktop Video 12.5.1 SDK"*

  2. FFmpeg (preferred stable release) version source code

       * Origin: http://ffmpeg.org/download.html#releases
       * For example: [FFmpeg 6.0 "Von Neumann"](http://ffmpeg.org/releases/ffmpeg-6.0.tar.bz2)

  3. Install additional distro packages required by specific formats or
     functions of this FFmpeg to compile.

