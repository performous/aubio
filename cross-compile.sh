#!/bin/bash

echo "Removing 'win-build-out' directory."
rm -rf win-build-out

echo "Creating output directories: 'win-build-out/64bit' && 'win-build-out/32bit'."
mkdir -p win-build-output/64bit
mkdir -p win-build-output/32bit

echo "Cross compiling 64bit build to Windows 64bit."
# Create 64bit build
CC=x86_64-w64-mingw32-gcc python waf --with-target-platform='win64' --disable-intelipp --disable-complex --disable-jack --disable-jack --disable-sndfile  --disable-avcodec --disable-samplerate --disable-memcpy --disable-double --disable-fat --enable-accelerate --disable-apple-audio --disable-blas --disable-atlas --disable-wavread --disable-wavwrite --disable-docs --disable-tests --disable-examples configure build install --prefix=./win-build-out/64bit

echo "Cross compiling 32bit build to Windows 32bit."
# Create 32bit build
CC=i686-w64-mingw32-gcc python waf --with-target-platform='win32' --disable-intelipp --disable-complex --disable-jack --disable-jack --disable-sndfile  --disable-avcodec --disable-samplerate --disable-memcpy --disable-double --disable-fat --enable-accelerate --disable-apple-audio --disable-blas --disable-atlas --disable-wavread --disable-wavwrite --disable-docs --disable-tests --disable-examples configure build install --prefix=./win-build-out/32bit