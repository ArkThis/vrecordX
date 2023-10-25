.PHONY: prep all install ffmpeg gtkdialog

# Install prerequisites
prep:
	sudo apt install cowsay


# Build FFmpeg
ffmpeg:
	make prep
	cd ffmpegdecklink && make prep && make ffmpeg


# Build GTKdialog
gtkdialog:
	make prep
	cd gtkdialog && make prep && make gtkdialog


# Build everything
all:
	make ffmpeg
	make gtkdialog


# Install everything
install:
	cd ffmpegdecklink && sudo make install
	cd gtkdialog && sudo make install
