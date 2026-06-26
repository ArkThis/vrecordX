# Put this makefile into the folder where the Debian packages are located in
# the unpacked Blackmagic tools-and-driver downloads.
#
# The default path from Blackmagic is:
# `/Blackmagic_Desktop_Video_Linux_XX.x/deb/x86_64/`
#
# Then run `make install`:
# This will install Blackmagic's drivers and tools to enable Decklink support.

# @author: Peter B. (peter@ArkThis.com)


# Install packages without asking for confirmation?
APT_YES := -y

.PHONY = install deb-pkgs sdk all

#DECKLINK_SDK_VERSION := 16.0
DECKLINK_SDK_VERSION := 12.9
#DECKLINK_SDK_VERSION := 12.4.1

BM_TAR := bm-deb-$(DECKLINK_SDK_VERSION).tar
BM_LINK := http://download.arkthis.com/bm/$(BM_TAR)
SDK_ZIP:= SDK_$(DECKLINK_SDK_VERSION)-include.zip

# Retrieving slim Debian-only BM package from $BM_LINK:
$(BM_TAR):
	$(info "Downloading Blackmagic packages...")
	wget -cO $(BM_TAR) $(BM_LINK)

# Unpack only the APT .deb files from Blackmagic package:
deb-pkgs: $(BM_TAR)
	tar -xvf $(BM_TAR) --wildcards "*.deb"

# Unpack and extract the SDK headers in 'Linux/vXX/include' subfolder:
sdk: $(BM_TAR)
	tar -xvf $(BM_TAR) --strip-components=1 --wildcards "SDK/SDK_*-include.zip"
	unzip -d Linux/v$(DECKLINK_SDK_VERSION)/ SDK_$(DECKLINK_SDK_VERSION)-include.zip

all: sdk deb-pkgs

install: deb-pkgs
	$(info "Installing Blackmagic drivers and tools...")

	apt update && \
	apt install $(APT_YES) \
	./desktopvideo_$(DECKLINK_SDK_VERSION)_amd64.deb \
	./desktopvideo-gui_$(DECKLINK_SDK_VERSION)_amd64.deb \
	./mediaexpress_*_amd64.deb
