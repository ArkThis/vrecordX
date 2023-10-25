# Installation instructions for vrecordX

# Xubuntu 20.04.6

## Install prerequisites

`$ sudo apt install vlc mpv mediainfo-gui git build-essential`


## Download (clone) git repository

`$ git clone https://github.com/ArkThis/vrecordX.git`


## Build non-distro packages

In the folder where you have the copy of vrecordX, run the following to build
and install all required non-packaged dependencies (like FFmpeg, GTKdialog):

```
$ make prep
$ make all
$ make install
```

## Run vrecordX

./vrecord
