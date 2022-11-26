#!/bin/bash

umount /.snapshots
rmdir /.snapshots
snapper -c root create-config /
btrfs subvolume delete /.snapshots
mkdir /.snapshots
systemctl daemon-reload
mount -a
snapper -c root set-config ALLOW_USERS=jbilger SYNC_ACL=yes
chown -R :jbilger /.snapshots
grub2-editenv - unset menu_auto_hide
git clone https://github.com/Antynea/grub-btrfs.git /opt/grub-btrfs
git -C /opt/grub-brtfs apply /opt/fedora-main/btrfs/scripts/btrfs.patch
make -C /opt/grub-btrfs install
systemctl disable /opt/fedora-main/btrfs/scripts/install_stage_2.service
systemctl enable /opt/fedora-main/btrfs/scripts/install_stage_3.service
reboot