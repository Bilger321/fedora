#!/bin/bash
set -e

exec 5>> /var/debug.log
PS4='$LINENO: ' 
BASH_XTRACEFD="5" 

set -x

chattr -R +C /var/lib/libvirt
echo $'SUSE_BTRFS_SNAPSHOT_BOOTING="true"' >> /etc/default/grub
grub2-mkconfig -o /boot/grub2/grub.cfg
systemctl disable install_stage_1.service
systemctl enable /opt/fedora-main/btrfs/scripts/install_stage_2.service
echo "STAGE 1 COMPLETE" >> /home/jbilger/STAGES.log
reboot