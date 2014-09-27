#!/bin/bash

OS=`uname -o`

if [[ $OS == "GNU/Linux" ]] ;
then
  MACHINE=`uname -m`
  if [[ $MACHINE == "x86_64" ]] ; then
    ./arch.linux64.build.bash
    exit 0
  fi

  if [[ $MACHINE == "i686" ]] ; then
    ./arch.linux32.build.bash
    exit 0
  fi
  echo Linux Machine not supported: $MACHINE
  exit 1
fi

if [[ $OS == "Msys" ]] ;
then
  ./arch.windows.build.bash
  exit 0
fi

echo OS Not supported: $OS
exit 2

