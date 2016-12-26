# Debian native

## Prerequisites
* [N900 reference install](../reference-install)
* [u-boot](http://talk.maemo.org/showthread.php?t=81613)

```
# apt-get install u-boot-flasher kernel-power-bootimg
# ln -sf /etc/bootmenu.d/*kernel-power*.item /etc/default/bootmenu.item
# u-boot-update-bootmenu
```

# Prepare

On a desktop machine, insert microSD card:

```
$ dmesg | tail -2
[2000327.247450]  sdd: sdd1
[2000327.249741] sd 19:0:0:0: [sdd] Attached SCSI removable disk
```

```
$ dd bs=512 count=4 if=/dev/urandom of=/tmp/keyfile iflag=fullblock
$ sudo cryptsetup luksFormat -q -v -d /tmp/keyfile /dev/sdd
$ sudo cryptsetup luksOpen -d /tmp/keyfile /dev/sdd sdd_crypt
$ sudo dd if=/dev/zero of=/dev/mapper/sdd_crypt
$ sudo cryptsetup luksClose sdd_crypt
$ sudo dd if=/dev/urandom of=/dev/sdd bs=512 count=20480
$ rm /tmp/keyfile

$ sudo cfdisk -l /dev/sdd

$ /sbin/fdisk -l /dev/sdd

Disk /dev/sdd: 58.9 GiB, 63232278528 bytes, 123500544 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: dos
Disk identifier: 0xd3adb3af

Device     Boot     Start       End   Sectors  Size Id Type
/dev/sdd1            2048    616447    614400  300M 83 Linux
/dev/sdd2          616448 121997311 121380864 57.9G 83 Linux
/dev/sdd3       121997312 123500543   1503232 2734M 83 Linux
```

```
$ sudo mkfs.ext4 /dev/sdd1
$ sudo cryptsetup luksFormat /dev/sdd2
$ sudo cryptsetup luksOpen /dev/sdd2 crypt_sd2
$ sudo mkfs.ext4 /dev/mapper/crypt_sd2
```

```
$ sudo mount /dev/mapper/crypt_sd2 /mnt/
$ sudo mkdir /mnt/boot
$ sudo mount /dev/sdd1 /mnt/boot/
```

# Install
Follow the procedure described [here](https://github.com/dderby/debian900)

I did some modification to my [fork](https://github.com/u0d7i/debian900) of original debian900 repo
to include the following:
- encrypted root support
- keyboard led support in initrd
- debian.conf.local is included to illustrate the usage

```
$ git clone https://github.com/u0d7i/debian900
$ cd debian900
$ ./build_kernel.sh
$ sudo ./install_debian.sh
$ sudo cp configure_u-boot.sh /mnt/boot
$ sudo chmod +x /mnt/boot/configure_u-boot.sh
$ sudo umount /mnt/boot
$ sudo umount /mnt
$ sudo cryptsetup luksClose crypt_sd2
```

# TODO

- performance tests for encrypted swap on SD card
- keyboard led off on lid close
- kbd lock, kbd led, screen off/on on slide
- unicode setup on boot/login
- modem for mobile data

