# Installation instructions for vrecordX

# Xubuntu 20.04.6

## Install "make":

Most of the setup and installation is done using **Makefiles**
in the good old "[GNU Make](https://www.gnu.org/software/make/)" syntax.

GNU `make` is a tool well-known and widely supported among program developers.
You'll also need the `git` tool to checkout vrecordX's code:

Simply install `make` and `git` like this:
`$ sudo apt install make git`



## Download (clone) git repository

`$ sudo mkdir /opt/vrecordX && chown $USER /opt/vrecordX`
`$ git clone https://github.com/ArkThis/vrecordX.git /opt/vrecordX`


## Install prerequisites:

Each folder of vrecordX contains a "Makefile" that holds all the instructions
necessary to perform the setup.

Download and install all required packages:

`$ cd /opt/vrecordX`
`$ make prep`



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
