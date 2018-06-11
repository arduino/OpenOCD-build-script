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

if [ x$CROSS_COMPILER == x ]; then
CROSS_COMPILER=${CROSS_COMPILE}-gcc
fi

ARCH=`$CROSS_COMPILER -v 2>&1 | awk '/Target/ { print $2 }'`

mkdir -p distrib/$ARCH
cd  distrib/$ARCH
PREFIX=`pwd`
cd -

#disable pkg-config
export PKG_CONFIG_PATH=`pwd`

if [[ ${ARCH} == *mingw* ]]; then
export CFLAGS="-mno-ms-bitfields"
fi

if [[ ${ARCH} == *linux* ]]; then

cd eudev-3.1.5
export UDEV_DIR=`pwd`
./autogen.sh
./configure --enable-static --disable-shared --disable-blkid --disable-kmod  --disable-manpages --host=${CROSS_COMPILE}
make clean
make -j4
cd ..

export CFLAGS="-I$UDEV_DIR/src/libudev/"
export LDFLAGS="-L$UDEV_DIR/src/libudev/.libs/"
export LIBS="-ludev"

fi

cd libusb-1.0.20
export LIBUSB_DIR=`pwd`
./configure --enable-static --disable-shared --host=${CROSS_COMPILE}
make clean
make
cd ..

export LIBUSB1_CFLAGS="-I$LIBUSB_DIR/libusb/"
export LIBUSB1_LIBS="-L$LIBUSB_DIR/libusb/.libs/ -lusb-1.0 -lpthread"

export LIBUSB_1_0_CFLAGS="-I$LIBUSB_DIR/libusb/"
export LIBUSB_1_0_LIBS="-L$LIBUSB_DIR/libusb/.libs/ -lusb-1.0 -lpthread"

cd libusb-compat-0.1.5
export LIBUSB0_DIR=`pwd`
./bootstrap.sh
./configure --enable-static --disable-shared --host=${CROSS_COMPILE}
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
./configure --enable-static --disable-shared --host=${CROSS_COMPILE}
make clean
make -j4
cd ..

cd libftdi1-1.4
export LIBFTDI1_DIR=`pwd`
if [ -d build ]; then
rm -rf build
fi
mkdir build && cd build

if [[ ${ARCH} == *mingw* ]]; then
LIBFTDI1_EXTRAFLAGS="-DBUILD_SHARED_LIBS=OFF -DCMAKE_C_COMPILER_WORKS=1 -DCMAKE_CROSSCOMPILING=1 -DCMAKE_C_FLAGS=-fpermissive"
fi

cmake -DCMAKE_C_COMPILER=${CROSS_COMPILER} -DBUILD_TESTS=no -DDOCUMENTATION=no -DEXAMPLES=no -DFTDIPP=no -DFTDI_EEPROM=no -DLINK_PYTHON_LIBRARY=no -DPYTHON_BINDINGS=no -DCMAKE_INSTALL_PREFIX=$LIBFTDI1_DIR $LIBFTDI1_EXTRAFLAGS ..
make clean
make ftdi1-static
cd ..
cd ..

cd OpenOCD
./bootstrap
export LIBUSB0_CFLAGS="-I$LIBUSB0_DIR/libusb/" 
export LIBUSB0_LIBS="-L$LIBUSB0_DIR/libusb/.libs/ -lusb -lpthread" 
export LIBUSB1_CFLAGS="-I$LIBUSB_DIR/libusb/" 
export LIBUSB1_LIBS="-L$LIBUSB_DIR/libusb/.libs/ -lusb-1.0 -lpthread" 
export LIBFTDI_CFLAGS="-I$LIBFTDI1_DIR/src/"
export LIBFTDI_LIBS="-L$LIBFTDI1_DIR/build/src/ -lftdi1 -lpthread"
export HIDAPI_CFLAGS="-I$HIDAPI_DIR/hidapi/"

if [[ ${ARCH} == *linux* ]]; then
export HIDAPI_LIBS="-L$HIDAPI_DIR/linux/.libs/ -L$HIDAPI_DIR/libusb/.libs/ -lhidapi-hidraw -lhidapi-libusb"
fi

if [[ ${ARCH} == *darwin* ]]; then
export HIDAPI_LIBS="-L$HIDAPI_DIR/mac/.libs/ -L$HIDAPI_DIR/libusb/.libs/ -lhidapi"
fi

if [[ ${ARCH} == *mingw* ]]; then
export HIDAPI_LIBS="-L$HIDAPI_DIR/windows/.libs/ -L$HIDAPI_DIR/libusb/.libs/ -lhidapi"
fi

if [[ ${ARCH} == *mingw* ]]; then
OPENOCD_COMPILE_SWITCHES="--enable-remote-bitbang --enable-stlink --enable-usb-blaster-2 --enable-ti-icdi --enable-jlink --enable-usbprog --enable-cmsis-dap"
else
OPENOCD_COMPILE_SWITCHES="--enable-remote-bitbang --enable-stlink --enable-usb-blaster-2 --enable-ti-icdi --enable-jlink --enable-usbprog --enable-cmsis-dap --enable-jtag_vpi --enable-ioutil"
fi

if [[ ${ARCH} == *linux* ]]; then
OPENOCD_COMPILE_SWITCHES="$OPENOCD_COMPILE_SWITCHES --enable-sysfsgpio"
fi

export CFLAGS="-DHAVE_LIBUSB_ERROR_NAME"
PKG_CONFIG_PATH=`pwd` ./configure $OPENOCD_COMPILE_SWITCHES --disable-werror --prefix=$PREFIX --host=${CROSS_COMPILE}
make clean
CFLAGS=-static make
make install
