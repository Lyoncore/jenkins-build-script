#!/bin/sh
amd64_os_snap_source=https://public.apps.ubuntu.com/anon/download-snap/b8X2psL1ryVrPt5WEmpYiqfr5emixTd7_115.snap
amd64_os_snap_file=$(basename $amd64_os_snap_source)

rm ubuntu-core*.snap
rm ubuntu-core -rf

cwd=$(pwd)

if [ ! -f ubuntu-core.snap ] ; then
	wget $amd64_os_snap_source
	mv $amd64_os_snap_file ubuntu-core.snap
fi
mkdir temp ubuntu-core
sudo mount ubuntu-core.snap temp
sudo cp temp/* ubuntu-core -rp
sync
sudo umount temp

# network-manager
cp /etc/dbus-1/system.d/org.freedesktop.NetworkManager.conf ubuntu-core/etc/dbus-1/system.d/

# bluez
cp /etc/dbus-1/system.d/bluetooth.conf ubuntu-core/etc/dbus-1/system.d/

cd ${cwd} && snapcraft snap ubuntu-core/

rm temp -rf

