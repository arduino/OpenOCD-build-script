#!/bin/bash -ex

./clean.bash
rm -rf objdir

./libusb.build.bash
#./libusb-compat-0.1.build.bash
./hidapi.build.bash
./openocd.build.bash

