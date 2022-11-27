## Btrfs Automated Install
### To Run
To use this on your system, input the following boot line option from the install media:
```
inst.ks=https://jacobbilger.com/projects/fedora/btrfs/ks.cfg
```

The system will reboot 4 times and land on a login prompt, fully configured(!)

Any software installed via DNF will be tracked as a snapshot

You can view these snapshots by running `snapper ls`

You can roll back any install to an RO instance via the grub menu

To rollback to a RW instanace, run `snapper --ambit classic rollback <NUM>`

### Execution Flow
`===KICKSTART===`
1. Kickstart file `ks.cfg` does the following:
   * Provision primary drive with btrfs
   * Install required packages, including [snapper](https://github.com/openSUSE/snapper)
   * Create symlinks to systemd service `install_stage_1.service`
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
   * Configure `snapper` to work with btrfs
   * Clone down [grub-btrfs](https://github.com/Antynea/grub-btrfs)
   * Configure `grub-btrfs`
   * Install `grub-btrfs`
   * Disable `install_stage_2.service`
   * Enable `install_stage_3.service`
   * Reboot the system

`===REBOOT===`

7. `install_stage_3.service` executes `btrfs-st-3.sh`
8. `btrfs-st-3.sh` preforms the following actions:
   * Disable `install_stage_3.service`
   * Reboot the system

`===REBOOT===`

9. Install is complete!

### Logging
Logs are stored at:
* The users home directory, under `~/STAGES.log`
   * Basic staging information, logged after each stages compeltion
* `/var/debug.log`
   * Trace logs of execution, recorded by each stage

### Caveats
The following paramters are built into the kickstart file and `btrfs-st-2.sh` to cater to my specific laptop:
* NVMe primary storage medium by default
* Default user account of `jbilger`

### TODO
* Encrpyted drive
* Remove final reboot, or do some more actions in stage 3
   * Cleanup?
* User configurable username/storage

Shouts [lordofpipes](https://github.com/lordofpipes) for the great [tutorial](https://lordofpipes.github.io/obscure-tutorials/docs/linux-tutorials/fedora-snapper/)
