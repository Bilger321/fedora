#!/bin/bash

git apply -C  name-of-file.patch
grub2-mkconfig -o /boot/grub2/grub.cfg
systemctl enable --now grub-btrfsd.service
reboot
