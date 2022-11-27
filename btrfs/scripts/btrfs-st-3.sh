#!/bin/bash
set -e

exec 5>> /var/debug.log
PS4='$LINENO: ' 
BASH_XTRACEFD="5" 

set -x

systemctl disable /opt/fedora-main/btrfs/scripts/install_stage_3.service

echo "STAGE 3 COMPLETE" >> /home/jbilger/STAGES.log
reboot