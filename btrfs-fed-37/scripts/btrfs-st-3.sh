#!/bin/bash

git apply -C /opt/grub-btrfs /opt/btrfs-enable.patch
grub2-mkconfig -o /boot/grub2/grub.cfg
systemctl enable --now grub-btrfsd.service
reboot