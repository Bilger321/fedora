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
make -C /opt/grub-btrfs install
systemctl enable /opt/fedora-main/btrfs-fed-37/scripts/install_stage_3.service
reboot