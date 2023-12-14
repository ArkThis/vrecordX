# vrecordX

**This is a friendly-fork of vrecord 😊️!**

Sponsored by the [Austrian Mediathek](https://www.mediathek.at/), as part of
their archival video digitization system.


## vrecord Summary 

The [original AMIA "vrecord"](https://github.com/amiaopensource/vrecord)
is open-source software for capturing a video signal and turning it into a
digital file. Its purpose is to make videotape digitization or transfer easier.

Vrecord can capture analog and digital signals through a variety of inputs and
can create digital video files in a variety of formats and codecs. Vrecord has
been designed with needs of audiovisual archivists in mind. 


## The main differences are:

  * Intended for a consistent, stable and reproducible capture environment,
    rather than rolling-release with "brew".
  * Tested on GNU/Linux instead of MacOS (mainly Debian-based (eg Xubuntu) distros)
  * Makes use of the system's packages, libraries and build-environment.
  * Defaults to PAL (rather than NTSC).
  * Uses own copy of Blackmagic's SDK libraries.
  * Uses a fixed set of library/tool versions that have been tested with each
    other.


## Reasons for this fork:

The main reason we created this fork is, that we had a stable vrecord setup in
2021 - and when we wanted to just "have the same thing again" on another machine
(with the exact same Linux distro and version), it just didn't work.

vrecord would have worked just fine, but the whole *brew* package environment was
pulling in different versions, which at some time just happened to simply fail to  
build fine - and another time: fail with errors.

The original vrecord is simply designed for and tested on MacOS environments.
vrecordX does not require brew, and uses the more GNU-native "Makefiles" for setup.

So: **vrecordX is for a stable and consistent setup on GNU/Linux systems.**  
(In the spirit of [Debian-stable](https://www.debian.org/releases/))


We try to keep this fork as in-sync as possible with upstream vrecord, and of
course provide improvements or fixes back upstream. 😇️🌟️🌈️
