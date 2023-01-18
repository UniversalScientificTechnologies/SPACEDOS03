#!/bin/bash

if [ "$1" = "" ]
then
  echo "Usage: $0 <sd-card name>"
  exit
fi

umount $1p1

sudo badblocks -wsvt 0xff $1 
sudo badblocks -wsvt 0x00 $1 
sudo badblocks -wsvt 0xff $1 
sudo mkfs.vfat -F32 $1 -I -v 

