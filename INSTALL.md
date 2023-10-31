# Installation instructions for vrecordX

# Xubuntu 20.04.6

## Install prerequisites

It makes sense to add the [MediaArea repository (Release versions)](https://mediaarea.net/en/Repos) to your system:

`$ wget https://mediaarea.net/repo/deb/repo-mediaarea_1.0-24_all.deb && sudo dpkg -i repo-mediaarea_1.0-24_all.deb && sudo apt-get update`


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
