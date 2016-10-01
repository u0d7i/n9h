# Backup and restore

## Prerequisites
* [N900 reference install](../reference-install)
* [rescueOS](http://n900.quitesimple.org/rescueOS/) ([github](https://github.com/NIN101/N900_RescueOS), [releases](https://github.com/NIN101/N900_RescueOS/releases))

### Installing rescueOS on-device via u-boot

install u-boot (if not already):

```
# apt-get install u-boot-flasher kernel-power-bootimg
# ln -sf /etc/bootmenu.d/*kernel-power*.item /etc/default/bootmenu.item
# u-boot-update-bootmenu
```

Download latest rescueOS from above. Convert kernel and initrd images to uImage format:

```
$ mkimage -A arm -O linux -T kernel -C none -a 80008000 -e 80008000 -n rescueOS-1.2-kernel -d n900.quitesimple.org/rescueOS/rescueOS-1.2/rescueOS_n900_kernel_1.2.zImage rescueOS-1.2-kernel.uImage
Image Name:   rescueOS-1.2-kernel
Created:      Sun Aug 14 14:08:57 2016
Image Type:   ARM Linux Kernel Image (uncompressed)
Data Size:    1866988 Bytes = 1823.23 kB = 1.78 MB
Load Address: 80008000
Entry Point:  80008000

$ mkimage -A arm -O linux -T ramdisk -n rescueOS-1.2-initrd -d n900.quitesimple.org/rescueOS/rescueOS-1.2/rescueOS-1.2.img rescueOS-1.2-initrd.uImage
Image Name:   rescueOS-1.2-initrd
Created:      Sun Aug 14 14:08:12 2016
Image Type:   ARM Linux RAMDisk Image (gzip compressed)
Data Size:    5386240 Bytes = 5260.00 kB = 5.14 MB
Load Address: 00000000
Entry Point:  00000000
```

Place both images to /opt/boot/

Create /etc/bootmenu.d/99-rescueOS-1.2.item , containing 

```
ITEM_NAME="rescueOS-1.2"
ITEM_DEVICE="${INT_CARD}p2"
ITEM_FSTYPE="ext3"
ITEM_KERNEL="/opt/boot/rescueOS-1.2-kernel.uImage"
ITEM_INITRD="/opt/boot/rescueOS-1.2-initrd.uImage"
ITEM_CMDLINE="rootdelay root=/dev/ram0"
```

and update bootmenu:

```
# u-boot-update-bootmenu
```
