#!/bin/bash -ex
# Copyright (c) 2014-2016 Arduino LLC
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

OUTPUT_VERSION=0.10.0-arduino9-static

export OS=`uname -o || uname`
export TARGET_OS=$OS

if [ x$CROSS_COMPILER == x ]; then
CROSS_COMPILER=${CROSS_COMPILE}-gcc
fi

OUTPUT_TAG=`$CROSS_COMPILER -v 2>&1 | awk '/Target/ { print $2 }'`

./compile_cross.sh

cd distrib
if [[ $CROSS_COMPILE == *mingw* ]] ; then
zip -r ../openocd-${OUTPUT_VERSION}-${OUTPUT_TAG}.zip ${OUTPUT_TAG}
else
tar -cjvf ../openocd-${OUTPUT_VERSION}-${OUTPUT_TAG}.tar.bz2 ${OUTPUT_TAG}
fi
cd -
