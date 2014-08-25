#!/bin/bash -ex

if [[ ! -d hidapi ]] ;
then
	git clone git://github.com/arduino/hidapi.git
fi

cd hidapi
./bootstrap
cd -

mkdir -p objdir
cd objdir
PREFIX=`pwd`
cd -

mkdir -p hidapi-build
cd hidapi-build

if [[ x$USE_LOCAL_LIBUSB == xyes ]];
then
	../hidapi/configure --prefix=$PREFIX \
		libusb_CFLAGS="-I${PREFIX}/include/libusb-1.0" \
		libusb_LIBS="-L${PREFIX}/lib -lusb-1.0"
else
	../hidapi/configure --prefix=$PREFIX
fi

if [ -z "$MAKE_JOBS" ]; then
	MAKE_JOBS="2"
fi

nice -n 10 make -j $MAKE_JOBS

make install

