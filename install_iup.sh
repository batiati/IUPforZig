#!/usr/bin/env sh
set -eu

IUP_VERSION="3.30"
IUP_PLATFORM="Linux54_64"
IUP_ZIP=iup-"$IUP_VERSION"_"$IUP_PLATFORM"_lib.tar.gz
LIB_DIR=lib

echo "Downloading $IUP_ZIP..."
rm -rf $LIB_DIR
mkdir $LIB_DIR && cd $LIB_DIR
curl https://ufpr.dl.sourceforge.net/project/iup/$IUP_VERSION/Linux%20Libraries/$IUP_ZIP --output $IUP_ZIP
echo "Extracting $IUP_ZIP..."
tar -xf "$IUP_ZIP"
rm "$IUP_ZIP"
cd ..