#!/bin/sh
amd64_kernel_snap_source=https://public.apps.ubuntu.com/anon/download-snap/pYVQrBcKmBa0mZ4CCN7ExT6jH8rY1hza_2.snap
amd64_kernel_snap_file=$(basename $amd64_kernel_snap_source)

rm temp -rf
rm kernel-snap -rf

cwd=$(pwd)

if [ ! -f pc-kernel.snap ] ; then
	rm pc-kernel*.snap
	wget $amd64_kernel_snap_source
	mv $amd64_kernel_snap_file pc-kernel.snap
fi
mkdir temp kernel-snap
sudo mount pc-kernel.snap temp
sudo cp temp/* kernel-snap -r
sync
sudo umount temp

sudo chown $USER:$USER kernel-snap -R
cd kernel-snap
kern_ver=`cat meta/snap.yaml | grep modules: | awk '{print $2}'`
initrd=`cat meta/snap.yaml | grep initrd: | awk '{print $2}'`

mkdir initrd
cd initrd && lzcat ../$initrd | cpio -i
cd ..
echo $(pwd)
cp ../functions initrd/scripts
cp /sbin/insmod initrd/sbin
cat >> initrd/scripts/functions << EOF

load_extra()
{
	insmod /$kern_ver/kernel/drivers/mmc/mmc_block.ko
	insmod /$kern_ver/kernel/drivers/mmc/sdhci.ko
	insmod /$kern_ver/kernel/drivers/mmc/sdhci-acpi.ko
}
EOF

mkdir -p initrd/$kern_ver/kernel/drivers/mmc/
find . -name mmc_block.ko -exec cp '{}' initrd/$kern_ver/kernel/drivers/mmc \;
find . -name sdhci.ko -exec cp '{}' initrd/$kern_ver/kernel/drivers/mmc \;
find . -name sdhci-acpi.ko -exec cp '{}' initrd/$kern_ver/kernel/drivers/mmc \; 

cd initrd && find . | cpio --quiet -o -H newc  | lzma > ../${initrd}
cd ${cwd} && snapcraft snap kernel-snap/

rm temp -rf

