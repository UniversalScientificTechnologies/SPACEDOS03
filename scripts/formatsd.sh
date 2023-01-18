#!/bin/bash

start=$(date +%s)

if [ "$1" = "" ]
then
  echo "Usage: $0 <sd-card name>"
  echo "This tool can be dangerous. Beware of the correct device name."
  exit
fi

umount $1

sudo badblocks -wsvt 0xff $1
sudo badblocks -wsvt 0x00 $1
sudo badblocks -wsvt 0xff $1
sudo mkfs.vfat -F32 $1 -I -v



end=$(date +%s)
echo " "
echo "Elapsed Time: $(($end-$start)) seconds"
