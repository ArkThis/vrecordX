GTKD_RELEASE := https://github.com/puppylinux-woof-CE/gtkdialog/archive/refs/tags/0.8.5c.tar.gz
GTKD_ZIP := gtkdialog-stable.tar.gz
GTKD_DIR := build

# Install prerequisites:
prep:
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

$(GTKD_DIR):
	mkdir -p $(GTKD_DIR)

download: $(GTKD_DIR)
	# wget from upstream release
	wget -cO $(GTKD_ZIP) $(GTKD_RELEASE)
	tar --strip-components=1 -xvzf $(GTKD_ZIP) -C $(GTKD_DIR)

gtkdialog: download
	cd $(GTKD_DIR) && \
	./autogen.sh && \
	make
	cp -av $(GTKD_DIR)/src/gtkdialog .
	@echo "Success!"
