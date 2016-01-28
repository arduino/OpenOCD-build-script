#!/bin/bash -ex

export HIDAPI_LDFLAGS="-lhidapi-libusb"

./clean.bash
rm -rf objdir

./libusb.build.bash
USE_LOCAL_LIBUSB=yes ./hidapi.build.bash
./openocd.build.bash

if [[ -f objdir/bin/openocd ]] ;
then
	strip --strip-all objdir/bin/openocd
	mv objdir/bin/openocd objdir/bin/openocd.bin
	cp launchers/openocd.linux objdir/bin/openocd
	chmod +x objdir/bin/openocd
fi

ARCH=`gcc -v 2>&1 | awk '/Target/ { print $2 }'`

rm -rf OpenOCD-0.9.0-dev-arduino
rm -f OpenOCD-0.9.0-dev-arduino-$ARCH.tar.bz2
mv objdir OpenOCD-0.9.0-dev-arduino
tar cfvj OpenOCD-0.9.0-dev-arduino-$ARCH.tar.bz2 OpenOCD-0.9.0-dev-arduino

