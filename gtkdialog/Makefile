GTKD_VERSION := 0.8.5c
GTKD_RELEASE := https://github.com/puppylinux-woof-CE/gtkdialog/archive/refs/tags/$(GTKD_VERSION).tar.gz
GTKD_ZIP := gtkdialog-$(GTKD_VERSION).tar.gz
GTKD_DIR := build
GTKD_OPT := /usr/local/bin

PKG_DEFAULT := \
	build-essential \
	autoconf automake \
	libgtk2.0-dev \
	libgtk-3-dev \
	libvte-dev \
	libvte-2.91-dev \
	libgtk-layer-shell-dev \
	bison \
	flex \
	texinfo

PACKAGES := $(PKG_DEFAULT)


.PHONY: all clean install prep download unpack gtkdialog

# Install prerequisites:
prep:
	sudo apt-get install -y --no-install-recommends $(PACKAGES)

$(GTKD_DIR):
	mkdir -p $(GTKD_DIR)

download:
	# wget from upstream release
	@wget -nc -O $(GTKD_ZIP) $(GTKD_RELEASE) || true

unpack: $(GTKD_DIR)
	# Unpack if not already unpacked:
	[ -e $(GTKD_DIR)/autogen.sh ] || tar --strip-components=1 -xvzf $(GTKD_ZIP) -C $(GTKD_DIR)

$(GTKD_ZIP): download

gtkdialog: unpack
	cd $(GTKD_DIR) && \
	./autogen.sh && \
	make && echo "Success!"

install: $(GTKD_OPT)/gtkdialog
	mkdir -p $(GTKD_OPT)
	cp -avi $(GTKD_DIR)/src/gtkdialog $(GTKD_OPT)/
	chmod +x $(GTKD_OPT)/gtkdialog
	@echo "Installed."


clean:
	@echo "Cleaning up temp files..."
	rm -rf $(GTKD_DIR)

all: prep gtkdialog
