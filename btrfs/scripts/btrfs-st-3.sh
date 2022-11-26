#!/bin/bash

git apply -C /opt/grub-btrfs /opt/btrfs-enable.patch
grub2-mkconfig -o /boot/grub2/grub.cfg
systemctl disable /opt/fedora-main/btrfs/scripts/install_stage_3.service
systemctl enable --now grub-btrfsd.service
reboot