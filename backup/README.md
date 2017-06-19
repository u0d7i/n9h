# Backup and restore

## Prerequisites
* [N900 reference install](../reference-install)
* [rescueOS](http://n900.quitesimple.org/rescueOS/) ([github](https://github.com/NIN101/N900_RescueOS), [releases](https://github.com/NIN101/N900_RescueOS/releases))

### Installing rescueOS on-device via u-boot

install u-boot on n900 (if not already):

```
# apt-get install u-boot-flasher kernel-power-bootimg
# ln -sf /etc/bootmenu.d/*kernel-power*.item /etc/default/bootmenu.item
# u-boot-update-bootmenu
```

Download latest rescueOS from the links above.

Modify and repack initrd if needed (I add custom keyboard layout and backup/restore scripts, you need cramfs support in kernel):

```
$ sudo apt-get install cramfsprogs
$ mv rescueOS-1.3.img rescueOS-1.3.img.orig
$ mkdir initrd-{old,new}
$ sudo mount -t cramfs rescueOS-1.3.img.orig initrd-old/
$ cd initrd-old/
$ sudo find . | sudo cpio -pdm ../initrd-new
$ cd ..
$ sudo umount initrd-old/
$ sudo cp mod.bkeymap initrd-new/rescueOS/nokia-n900.kmap
$ sudo cp backup.sh initrd-new/rescueOS/
$ sudo cp restore.sh initrd-new/rescueOS/
$ sudo mkcramfs initrd-new/ rescueOS-1.3.img
```

Convert kernel and initrd images to uImage format:

```
$ sudo apt-get install u-boot-tools

$ mkimage -A arm -O linux -T kernel -C none -a 80008000 -e 80008000 -n rescueOS-1.3-kernel -d rescueOS_n900_kernel_1.3.zImage rescueOS-1.3-kernel.uImage
Image Name:   rescueOS-1.3-kernel
Created:      Sat Oct  1 22:41:07 2016
Image Type:   ARM Linux Kernel Image (uncompressed)
Data Size:    1866988 Bytes = 1823.23 kB = 1.78 MB
Load Address: 80008000
Entry Point:  80008000

$ mkimage -A arm -O linux -T ramdisk -n rescueOS-1.3-initrd -d rescueOS-1.3.img rescueOS-1.3-initrd.uImage
Image Name:   rescueOS-1.3-initrd
Created:      Sat Oct  1 22:44:27 2016
Image Type:   ARM Linux RAMDisk Image (gzip compressed)
Data Size:    5386240 Bytes = 5260.00 kB = 5.14 MB
Load Address: 00000000
Entry Point:  00000000
```

Place both images to /opt/boot/

Create /etc/bootmenu.d/99-rescueOS-1.3.item , containing 

```
ITEM_NAME="rescueOS-1.3"
ITEM_DEVICE="${INT_CARD}p2"
ITEM_FSTYPE="ext3"
ITEM_KERNEL="/opt/boot/rescueOS-1.3-kernel.uImage"
ITEM_INITRD="/opt/boot/rescueOS-1.3-initrd.uImage"
ITEM_CMDLINE="rootdelay root=/dev/ram0"
```

and update bootmenu:

```
# u-boot-update-bootmenu
```

#### Notes

telnetd credentials:

```
user: root
pass: rootme
```
