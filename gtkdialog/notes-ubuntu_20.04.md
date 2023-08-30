# Notes on building gtkdialog on Xubuntu 20.04.6

## Upstream source

  * Website: https://github.com/puppylinux-woof-CE/gtkdialog
  * GIT: https://github.com/puppylinux-woof-CE/gtkdialog.git

### Releases list

https://github.com/puppylinux-woof-CE/gtkdialog/releases



## Package Dependencies (Debian / Ubuntu):

Dependency information taken from:

  * https://github.com/puppylinux-woof-CE/gtkdialog/blob/c3164a8505b053e4f3973ec81ca1d75b0ef0b144/.github/workflows/build.yml#L12
  * https://github.com/puppylinux-woof-CE/gtkdialog/issues/152
  * https://github.com/amiaopensource/homebrew-amiaos/blob/master/gtkdialog.rb


### Successful build after installing these:

sudo apt-get install -y --no-install-recommends \
build-essential \
libgtk2.0-dev \
libgtk-3-dev \
libvte-dev \
libvte-2.91-dev \
libgtk-layer-shell-dev \
bison \
flex \
texinfo

### Maybe some of these were already installed though:

libc6 \
libgtk-3-0 \
libglade2-0 \
procps \
libgdk-pixbuf2.0-0 \
libglib2.0-0 \
libatk1.0-0 \
libpango-1.0-0 \
libcairo2 \
libfreetype6 \
libfontconfig1 \
libxml2 \
x11-utils \
gettext-base \
libgtk2.0-dev \
libgtk-3-dev \
libvte-dev \
libvte-2.91-dev \
libgtk-layer-shell-dev \

### List from vrecord brew recipe:

Caution: These are *not* Debian package names, but project/brew names:

atk
autoconf
automake
cairo
fontconfig
freetype
fribidi
gdk-pixbuf
gettext
glib
graphite2
harfbuzz
libepoxy
libffi
libpng
libpthread-stubs
libtiff
libx11
libxau
libxcb
libxdmcp
libxext
libxrender
pango
pixman
pkg-config
xorgproto


