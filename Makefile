# Install prerequisites
prep:
	sudo apt install cowsay

all:
	cd ffmpegdecklink && make ffmpeg
	cd gtkdialog && make gtkdialog

install:
	cd ffmpegdecklink && sudo make install
	cd gtkdialog && sudo make install
