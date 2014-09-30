#!/bin/bash

export CFLAGS="-arch x86_64 -arch i386 -mmacosx-version-min=10.5"
export CXXFLAGS="-arch x86_64 -arch i386 -mmacosx-version-min=10.5"
export LDFLAGS="-arch x86_64 -arch i386"
export HIDAPI_LDFLAGS="-lhidapi"

./clean.bash
rm -rf objdir

./libusb.build.bash
./libusb-compat-0.1.build.bash
USE_LOCAL_LIBUSB=yes ./hidapi.build.bash
USE_LOCAL_LIBUSB=yes ./openocd.build.bash

if [[ -f objdir/bin/openocd ]] ;
then
	cd objdir/bin
	mv openocd openocd.bin
	echo "#!/bin/bash" >> openocd
	echo "DYLD_LIBRARY_PATH=\"\$(dirname \$0)/../lib\" \$0.bin \"\$1\" \"\$2\" \"\$3\" \"\$4\" \"\$5\" \"\$6\" \"\$7\" \"\$8\"" >> openocd
	chmod +x openocd
	cd -
fi

