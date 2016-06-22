#!/bin/sh

set -e

TODAY=$(date +%Y%m%d)
MINOR_RELEASE=$1
CHANNEL=$2
PROJECT=$3

if [ -z $CHANNEL ] ; then
	CHANNEL=stable
fi

if [ -z $PROJECT ] ; then
	PROJECT=snappy-16
fi

./ubuntu-device-flash --verbose core 16 \
	--channel $CHANNEL \
	--size 4 \
	--enable-ssh \
	--gadget canonical-pc \
	--kernel canonical-pc-linux \
	--os ubuntu-core \
	--install webdm \
	-o $PROJECT-$TODAY-$MINOR_RELEASE.img
