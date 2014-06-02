#!/bin/bash -ex

if [[ ! -f libusb-compat-0.1.4.tar.bz2 ]] ;
then
	wget http://downloads.sourceforge.net/project/libusb/libusb-compat-0.1/libusb-compat-0.1.4/libusb-compat-0.1.4.tar.bz2
fi

tar xfv libusb-compat-0.1.4.tar.bz2

mkdir -p objdir
cd objdir
PREFIX=`pwd`
cd -

mkdir -p libusb-compat-build
cd libusb-compat-build

../libusb-compat-0.1.4/configure \
	--prefix=$PREFIX

#	--disable-shared \

if [ -z "$MAKE_JOBS" ]; then
	MAKE_JOBS="4"
fi

nice -n 10 make -j $MAKE_JOBS

make install

