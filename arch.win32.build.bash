#!/bin/bash -ex

CFLAGS="-m32" CXXFLAGS="-m32" HIDAPI_LDFLAGS="-lhidapi" ./build.all.bash

cp /cygdrive/c/cygwin/bin/cygwin1.dll objdir/bin
cp /cygdrive/c/cygwin/bin/cyggcc_s-1.dll objdir/bin


