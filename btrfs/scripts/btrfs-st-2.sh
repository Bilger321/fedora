#!/bin/bash
set -e

exec 5>> /var/debug.log
PS4='$LINENO: ' 
BASH_XTRACEFD="5"

set -x

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
git clone https://github.com/Antynea/grub-btrfs.git /opt/grub-btrfs >> /var/debug.log 2>&1
sed -i '/GRUB_BTRFS_GRUB_DIRNAME/s/^#//g; /GRUB_BTRFS_MKCONFIG=/s/^#//g; /GRUB_BTRFS_MKCONFIG=/s/bin/sbin/g; /GRUB_BTRFS_SCRIPT_CHECK/s/^#//g; /GRUB_BTRFS_GBTRFS_DIRNAME/s/^#//g; /GRUB_BTRFS_GBTRFS_DIRNAME/s/grub/grub2/g' /opt/grub-btrfs/config
make -C /opt/grub-btrfs install
grub2-mkconfig -o /boot/grub2/grub.cfg
systemctl enable grub-btrfsd.service
systemctl disable /opt/fedora-main/btrfs/scripts/install_stage_2.service
systemctl enable /opt/fedora-main/btrfs/scripts/install_stage_3.service
echo "STAGE 2 COMPLETE" >> /var/STAGES.log
reboot