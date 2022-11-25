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
git clone https://github.com/Antynea/grub-btrfs.git /tmp/grub-btrfs
make -C /tmp/grub-btrfs install
systemctl enable /tmp/install_scripts/stage2.service
reboot