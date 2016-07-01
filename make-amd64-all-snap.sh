#!/bin/sh

set -e

TODAY=$(date +%Y%m%d)
MINOR_RELEASE=$1
CHANNEL=$2

if [ -z $CHANNEL ] ; then
	CHANNEL=stable
fi
./ubuntu-device-flash --verbose core 16 \
	--channel $CHANNEL \
	--size 4 \
	--enable-ssh \
	--gadget canonical-pc \
	--kernel canonical-pc-linux_4.4.0-23+20160518.15-43_amd64.snap \
	--os ubuntu-core \
	--install webdm \
	--install network-manager \
	--install bluez \
	-o havasu-$TODAY-$MINOR_RELEASE.img
