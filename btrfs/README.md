## Btrfs Automated Install

#### To Run
To use this on your system, input the following boot line option from the install media:
```
inst.ks=https://jacobbilger.com/projects/fedora/btrfs/ks.cfg
```

The system will reboot 3 times, and land on a login prompt, fully configured(!)

#### Execution Flow
`===KICKSTART===`
1. Kickstart file `ks.cfg` does the following:
   * Provision primary drive with btrfs
   * Install required packages, including [snapper](https://github.com/openSUSE/snapper)
   * Creates symlinks to systemd service `install_stage_1.service`
      * This is equivalent to "enabling" a service with `systemctl enable install_stage_1.service`
      * By enabling a service, we are able to maintain control flow through a reboot
      * We will use this method throughout the install
   * Reboot the system

`===REBOOT===`

3. `install_stage_1.service` executes `btrfs-st-1.sh`
4. `btrfs-st-1.sh` preforms the initial steps to:
   * Configure grub for Btrfs
   * Disable `install_stage_1.service`
   * Enable `install_stage_2.service`
   * Reboot the system

`===REBOOT===`

5. `install_stage_2.service` executes `btrfs-st-2.sh`
6. `btrfs-st-2.sh` preforms the following actions:
   * Configures snapper to work with btrfs
   * Clones down [grub-btrfs](https://github.com/Antynea/grub-btrfs)
   * Configures `grub-btrfs`
   * Installs `grub-btrfs`
   * Disable `install_stage_2.service`
   * Enable `install_stage_3.service`
   * Reboot the system

`===REBOOT===`

7. `install_stage_3.service` executes `btrfs-st-3.sh`
8. `btrfs-st-3.sh` preforms the following actions:
   * Disable `install_stage_3.service`
   * Reboot the system

#### Logging
Logs are stored at:
* The users home directory, under `~/STAGES.log`
   * Basic staging information, logged after each stages compeltion
* `/var/debug.log`
   * Trace logs of execution, recorded by each stage

#### Caveats
The following paramters are built into the kickstart file and `btrfs-st-2.sh` to cater to my specific laptop:
* NVMe primary storage medium by default
* Default user account of `jbilger`

#### TODO
* Encrpyt drive
* Remove final reboot, or do some more actions in stage 3.