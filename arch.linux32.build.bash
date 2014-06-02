#!/bin/bash -ex

CFLAGS="-m32" CXXFLAGS="-m32" HIDAPI_LDFLAGS="-lhidapi-libusb" ./build.all.bash

if [[ -f objdir/bin/openocd ]] ;
then
	cd objdir/bin
	mv openocd openocd.bin
	echo "#!/bin/bash" >> openocd
	echo "LD_LIBRARY_PATH=\"\$(dirname \$0)/../lib\" \$0.bin \$*" >> openocd
	chmod +x openocd
	cd -
fi

