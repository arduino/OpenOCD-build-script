#!/bin/bash -ex
# Copyright (c) 2016 Arduino LLC
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
ARCH=`gcc -v 2>&1 | awk '/Target/ { print $2 }'`

mkdir -p distrib/$ARCH
cd  distrib/$ARCH
PREFIX=`pwd`
cd -

#disable pkg-config
export PKG_CONFIG_PATH=`pwd`

cd eudev-3.1.5
export UDEV_DIR=`pwd`
./autogen.sh
./configure --enable-static --disable-shared --disable-blkid --disable-kmod
make clean
make -j4
cd ..

cd libusb-1.0.20
export LIBUSB_DIR=`pwd`
./configure --enable-static --disable-shared
make clean
make
cd ..

#cd kmod-22
#export KMOD_DIR=`pwd`
#./configure --host=arm-linux-gnueabihf
#make clean
#make -j4
#cd ..

#export KMOD_CFLAGS="-I$KMOD_DIR/libkmod/"
#export KMOD_LIBS="-L$KMOD_DIR/libkmod/.libs/ -lkmod"

cd libusb-compat-0.1.5
export LIBUSB0_DIR=`pwd`
./configure --enable-static --disable-shared
make clean
make
cd ..

export libusb_CFLAGS="-I$LIBUSB_DIR/libusb/"
export libusb_LIBS="-L$LIBUSB_DIR/libusb/.libs/ -lusb-1.0 -lpthread"
export libudev_CFLAGS="-I$UDEV_DIR/src/libudev/"
export libudev_LIBS="-L$UDEV_DIR/src/libudev/.libs/ -ludev"

cd hidapi
./bootstrap
export HIDAPI_DIR=`pwd`
./configure --enable-static --disable-shared
make clean
make -j4
cd ..

cd OpenOCD
./bootstrap
export LIBUSB0_CFLAGS="-I$LIBUSB0_DIR/libusb/" 
export LIBUSB0_LIBS="-L$LIBUSB0_DIR/libusb/.libs/ -lusb -lpthread" 
export LIBUSB1_CFLAGS="-I$LIBUSB_DIR/libusb/" 
export LIBUSB1_LIBS="-L$LIBUSB_DIR/libusb/.libs/ -lusb-1.0 -lpthread" 
export HIDAPI_CFLAGS="-I$HIDAPI_DIR/hidapi/"
export HIDAPI_LIBS="-L$HIDAPI_DIR/linux/.libs/ -L$HIDAPI_DIR/libusb/.libs/ -lhidapi-hidraw -lhidapi-libusb" 
export CFLAGS="-DHAVE_LIBUSB_ERROR_NAME"
PKG_CONFIG_PATH=`pwd` ./configure --prefix=$PREFIX
make clean
CFLAGS=-static make
make install
