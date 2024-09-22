#!/bin/bash

set -e -u

qcow2=$1
image=$2
shortname=${qcow2##*/}
echo "shortname: $shortname"
namewithoutqcow2=${shortname%.*}
echo "namewithoutqcow2 : $namewithoutqcow2"

modprobe nbd max_part=8

mount|grep $namewithoutqcow2 && umount $namewithoutqcow2

qemu-nbd --disconnect /dev/nbd0 &> /dev/null || true
qemu-nbd --connect=/dev/nbd0 $qcow2 && sleep 3

rm -rf $namewithoutqcow2
mkdir $namewithoutqcow2

echo mount qcow
mount /dev/nbd0p1 $namewithoutqcow2

cd ./$namewithoutqcow2 && tar --exclude='etc/fstab' -czf ../$namewithoutqcow2.tar.gz . && cd ..
umount ./$namewithoutqcow2 && rm -rf ./$namewithoutqcow2
echo "generate image successfully "

cat ./$namewithoutqcow2.tar.gz | docker import -c "EXPOSE 22" - $namewithoutqcow2
rm -rf ./$namewithoutqcow2.tar.gz
echo "imported in docker"

echo create final tag
docker image tag $namewithoutqcow2:latest $image
docker image rm $namewithoutqcow2:latest

echo end
