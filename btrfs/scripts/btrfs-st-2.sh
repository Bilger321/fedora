#!/bin/bash -x

exec 5> /var/debug.log
PS4='$LINENO: ' 
BASH_XTRACEFD="5" 

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
grub2-mkconfig -o /boot/grub2/grub.cfg
systemctl enable grub-btrfsd.service
systemctl disable /opt/fedora-main/btrfs/scripts/install_stage_2.service
systemctl enable /opt/fedora-main/btrfs/scripts/install_stage_3.service
echo "STAGE 2 COMPLETE" >> /home/jbilger/STAGES.log
reboot