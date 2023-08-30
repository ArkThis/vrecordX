# vrecordX

**This is a friendly-fork of vrecord 😊️!**


## vrecord Summary 

The original AMIA "vrecord" is open-source software for capturing a video
signal and turning it into a digital file. Its purpose is to make videotape
digitization or transfer easier.

Vrecord can capture analog and digital signals through a variety of inputs and
can create digital video files in a variety of formats and codecs. Vrecord has
been designed with needs of audiovisual archivists in mind. 


## The main differences are:

  * Intended for a consistent, stable and reproducible capture environment, rather than rolling-release with "brew".
  * Tested on GNU/Linux - mainly Debian-based (eg Ubuntu) distros, rather than MacOS.
  * Makes use of the system's packages, libraries and build-environment.
  * Defaults to PAL (rather than NTSC)


## Reasons for this fork:

The main reason we created this fork is, that we had a stable vrecord setup in
2021 - and when we wanted to just "have the same thing again" on another machine
(with the exact same Linux distro and version), it just didn't work.

vrecord would have worked just fine, but the whole brew package environment was
pulling in different versions, which at that time just happened to simply fail to  
build without errors.
And even if we found out how to fix it: This could happen again at any later time.

So: **vrecordX is for a stable and consistent setup.**  
In the spirit of Debian-Stable.

(How boring, huh? 😜️)
