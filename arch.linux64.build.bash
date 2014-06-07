#!/bin/bash -ex

CFLAGS="-m64" CXXFLAGS="-m64" HIDAPI_LDFLAGS="-lhidapi-libusb" ./build.all.bash

if [[ -f objdir/bin/openocd ]] ;
then
	cd objdir/bin
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

