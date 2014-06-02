#!/bin/bash -ex

if [[ ! -d hidapi ]] ;
then
	git clone git://github.com/signal11/hidapi.git
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

../hidapi/configure --prefix=$PREFIX

if [ -z "$MAKE_JOBS" ]; then
	MAKE_JOBS="2"
fi

nice -n 10 make -j $MAKE_JOBS

make install

