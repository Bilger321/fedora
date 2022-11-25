#!/bin/bash
chattr -R +C /var/lib/libvirt
echo $'SUSE_BTRFS_SNAPSHOT_BOOTING="true"' >> /etc/default/grub
grub2-mkconfig -o /boot/grub2/grub.cfg
systemctl --enable /tmp/install_scripts/stage1.service
reboot