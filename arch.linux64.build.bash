#!/bin/bash -ex

export CFLAGS="-m64"
export CXXFLAGS="-m64"
export HIDAPI_LDFLAGS="-lhidapi-libusb"

./clean.bash
rm -rf objdir

./hidapi.build.bash
./openocd.build.bash

if [[ -f objdir/bin/openocd ]] ;
then
	cd objdir/bin
	strip --strip-all openocd
	mv openocd openocd.bin
	echo "#!/bin/bash" >> openocd
	echo "LD_LIBRARY_PATH=\"\$(dirname \$0)/../lib\" \$0.bin \"\$1\" \"\$2\" \"\$3\" \"\$4\" \"\$5\" \"\$6\" \"\$7\" \"\$8\"" >> openocd
	chmod +x openocd
	cd -
fi

ARCH=`gcc -v 2>&1 | awk '/Target/ { print $2 }'`

rm -rf OpenOCD-0.9.0-dev-arduino
rm -f OpenOCD-0.9.0-dev-arduino-$ARCH.tar.bz2
mv objdir OpenOCD-0.9.0-dev-arduino
tar cfvj OpenOCD-0.9.0-dev-arduino-$ARCH.tar.bz2 OpenOCD-0.9.0-dev-arduino

