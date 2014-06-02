#!/bin/bash

CFLAGS="-arch x86_64 -arch i386 -mmacosx-version-min=10.5" CXXFLAGS="-arch x86_64 -arch i386 -mmacosx-version-min=10.5" LDFLAGS="-arch x86_64 -arch i386" ./build.all.bash

if [[ -f objdir/bin/openocd ]] ;
then
	cd objdir/bin
	mv openocd openocd.bin
	echo "#!/bin/bash" >> openocd
	echo "DYLD_LIBRARY_PATH=\"\$(dirname \$0)/../lib\" \$0.bin \$*" >> openocd
	chmod +x openocd
	cd -
fi

