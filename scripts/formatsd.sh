#!/bin/bash
umount /dev/mmcblk0p1
sudo badblocks -wsvt 0xff /dev/mmcblk0
sudo badblocks -wsvt 0x00 /dev/mmcblk0
sudo badblocks -wsvt 0xff /dev/mmcblk0
sudo mkfs.vfat -F32 /dev/mmcblk0 -I -v

