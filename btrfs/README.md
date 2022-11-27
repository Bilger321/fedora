# Btrfs Automated Install

## To Run

To use this on your system, input the following boot line option from the install media:

```ini
inst.ks=https://jacobbilger.com/projects/fedora/btrfs/ks.cfg
```

The system will reboot 4 times and land on a login prompt, fully configured(!)

Any software installed via DNF will be tracked as a snapshot

You can view these snapshots by running `snapper ls`

You can roll back any install to an RO instance via the grub menu

To rollback to a RW instance, run `snapper --ambit classic rollback <NUM>`

## Execution Flow

1. Kickstart file `ks.cfg` performs the following actions:
   * Provision primary drive with btrfs
   * Install required packages, including [snapper](https://github.com/openSUSE/snapper)
   * Create symlinks to systemd service `install_stage_1.service`
      * This is equivalent to "enabling" a service with `systemctl enable install_stage_1.service`
      * By enabling a service, we are able to maintain control flow through a reboot
      * We will use this method throughout the install
   * **Reboot the system**

2. On boot, enabled service `install_stage_1.service` executes `btrfs-st-1.sh`
3. `btrfs-st-1.sh` performs the following actions:
   * Configure grub for btrfs
   * Disable `install_stage_1.service`
   * Enable `install_stage_2.service`
   * **Reboot the system**

4. On boot, enabled service `install_stage_2.service` executes `btrfs-st-2.sh`
5. `btrfs-st-2.sh` performs the following actions:
   * Configure `snapper` to work with btrfs
   * Clone down [grub-btrfs](https://github.com/Antynea/grub-btrfs)
   * Configure `grub-btrfs`
   * Install `grub-btrfs`
   * Disable `install_stage_2.service`
   * Enable `install_stage_3.service`
   * **Reboot the system**

6. On boot, enabled service `install_stage_3.service` executes `btrfs-st-3.sh`
7. `btrfs-st-3.sh` performs the following actions:
   * Disable `install_stage_3.service`
   * **Reboot the system**

8. Install is complete!

## Logging

Logs are stored at:

* The users home directory, under `~/STAGES.log`
  * Basic staging information, logged after each stage's completion
* `/var/debug.log`
* Trace logs of execution, recorded by each stage

## Caveats

The following parameters are built into the kickstart file and `btrfs-st-2.sh` to cater to my specific laptop:

* NVMe primary storage medium by default
* Default user account of `jbilger`

## TODO

* Encrypted drive
* Remove final reboot, or do some more actions in stage 3
  * Cleanup?
* User configurable username/storage

___

Shouts [lordofpipes](https://github.com/lordofpipes) for the great [tutorial](https://lordofpipes.github.io/obscure-tutorials/docs/linux-tutorials/fedora-snapper/)
