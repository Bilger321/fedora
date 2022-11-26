#!/bin/bash

exec 5> /var/debug.log
PS4='$LINENO: ' 
BASH_XTRACEFD="5" 

chattr -R +C /var/li
git apply -C /opt/grub-btrfs /opt/btrfs-enable.patch
grub2-mkconfig -o /boot/grub2/grub.cfg
systemctl disable /opt/fedora-main/btrfs/scripts/install_stage_3.service
systemctl enable --now grub-btrfsd.service
echo "STAGE 3 COMPLETE" >> /home/jbilger/STAGES.log
reboot