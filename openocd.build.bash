#!/bin/bash -ex

if [[ ! -d OpenOCD ]] ;
then
	git clone git://github.com/arduino/OpenOCD.git -b arduino
fi

cd OpenOCD
./bootstrap
cd -

mkdir -p objdir
cd objdir
PREFIX=`pwd`
cd -

mkdir -p openocd-build
cd openocd-build

if [[ x$USE_LOCAL_LIBUSB == xyes ]];
then
	CFLAGS="-w -O2 $CFLAGS" CXXFLAGS="-w -O2 $CXXFLAGS" LDFLAGS="$LDFLAGS" ../OpenOCD/configure \
		--prefix=$PREFIX \
		LIBUSB0_CFLAGS=-I${PREFIX}/include/ \
		LIBUSB1_CFLAGS=-I${PREFIX}/include/libusb-1.0 \
		HIDAPI_CFLAGS=-I${PREFIX}/include/hidapi \
		LIBUSB0_LIBS="-L${PREFIX}/lib -lusb" \
		LIBUSB1_LIBS="-L${PREFIX}/lib -lusb-1.0" \
		HIDAPI_LIBS="-L${PREFIX}/lib ${HIDAPI_LDFLAGS}"
else
	CFLAGS="-w -O2 $CFLAGS" CXXFLAGS="-w -O2 $CXXFLAGS" LDFLAGS="$LDFLAGS" ../OpenOCD/configure \
		--prefix=$PREFIX \
		HIDAPI_CFLAGS=-I${PREFIX}/include/hidapi \
		HIDAPI_LIBS="-L${PREFIX}/lib ${HIDAPI_LDFLAGS}"
fi

if [ -z "$MAKE_JOBS" ]; then
	MAKE_JOBS="4"
fi

nice -n 10 make -j $MAKE_JOBS

make install

