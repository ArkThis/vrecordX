# Put this makefile into the folder where the Debian packages are located in
# the unpacked Blackmagic tools-and-driver downloads.
#
# The default path from Blackmagic is:
# `/Blackmagic_Desktop_Video_Linux_XX.x/deb/x86_64/`
#
# Then run `make install`:
# This will install Blackmagic's drivers and tools to enable Decklink support.

# @author: Peter B. (peter@ArkThis.com)


.PHONY = install

install:
	apt update && \
	apt install \
	./desktopvideo_*_amd64.deb \
	./desktopvideo-gui_*_amd64.deb \
	./mediaexpress_*_amd64.deb

