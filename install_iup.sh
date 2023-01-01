#!/usr/bin/env sh
set -eu

LIB_DIR=lib

IUP_VERSION="3.30"
IUP_PLATFORM="Linux54_64"
IUP_ZIP=iup-"$IUP_VERSION"_"$IUP_PLATFORM"_lib.tar.gz

echo "Downloading $IUP_ZIP..."
rm -rf $LIB_DIR/iup
mkdir -p $LIB_DIR/iup && cd $LIB_DIR/iup
curl https://ufpr.dl.sourceforge.net/project/iup/$IUP_VERSION/Linux%20Libraries/$IUP_ZIP --output $IUP_ZIP
echo "Extracting $IUP_ZIP..."
tar -xf "$IUP_ZIP"
rm "$IUP_ZIP"
if command -v sudo; then
sudo ./install
else
./install
fi
cd ../..

IM_VERSION="3.15"
IM_PLATFORM="Linux54_64"
IM_ZIP=im-"$IM_VERSION"_"$IM_PLATFORM"_lib.tar.gz

echo "Downloading $IM_ZIP..."
rm -rf $LIB_DIR/im
mkdir -p $LIB_DIR/im && cd $LIB_DIR/im
curl https://ufpr.dl.sourceforge.net/project/imtoolkit/$IM_VERSION/Linux%20Libraries/$IM_ZIP --output $IM_ZIP
echo "Extracting $IM_ZIP..."
tar -xf "$IM_ZIP"
rm "$IM_ZIP"
if command -v sudo; then
sudo ./install
else
./install
fi
cd ../..

CD_VERSION="5.14"
CD_PLATFORM="Linux54_64"
CD_ZIP=cd-"$CD_VERSION"_"$CD_PLATFORM"_lib.tar.gz

echo "Downloading $CD_ZIP..."
rm -rf $LIB_DIR/cd
mkdir -p $LIB_DIR/cd && cd $LIB_DIR/cd
curl https://ufpr.dl.sourceforge.net/project/canvasdraw/$CD_VERSION/Linux%20Libraries/$CD_ZIP --output $CD_ZIP
echo "Extracting $CD_ZIP..."
tar -xf "$CD_ZIP"
rm "$CD_ZIP"
if command -v sudo; then
sudo ./install
else
./install
fi
cd ../..