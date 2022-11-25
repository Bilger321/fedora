#!/bin/bash

chattr -R +C /var/lib/libvirt
echo $'SUSE_BTRFS_SNAPSHOT_BOOTING="true"' >> /etc/default/grub
grub2-mkconfig -o /boot/grub2/grub.cfg
reboot
