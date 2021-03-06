# Nokia N900 reference install

## Contents

* [Prerequisites](#prerequisites)
    * [Flashers](#flashers)
    * [Firmware images](#firmware-images)
* [Summary](#summary)
* [Firmware modifications](#firmware-modifications)
    * [eMMC](#emmc)
    * [rootfs](#rootfs)
      * [Changes in mounted rootfs image](#changes-in-mounted-rootfs-image)
        * [gainroot](#gainroot)
        * [remapping keyboard](#remapping-keyboard)
        * [replacing busybox](#replacing-busybox)
    * [Flashing](#flashing)
* [On-device modifications](#on-device-modifications)


## Prerequisites

### Flashers
* Nokia official [flasher-3.5](https://wiki.maemo.org/Documentation/Maemo_5_Developer_Guide/Development_Environment/Maemo_Flasher-3.5)
* [0xFFFF](https://talk.maemo.org/showthread.php?t=87996)

Running Nokia flasher-3.5 `i386` binary on `x86_64`  Debian:

```
# uname -a
Linux base 3.16.0-4-amd64 #1 SMP Debian 3.16.7-ckt20-1+deb8u3 (2016-01-17) x86_64 GNU/Linux

# ./flasher-3.5-i386
-bash: ./flasher-3.5-i386: No such file or directory

# apt-get install libc6-i386

# ./flasher-3.5-i386
./flasher-3.5-i386: error while loading shared libraries: libusb-0.1.so.4:
                cannot open shared object file: No such file or directory

# ldd flasher-3.5-i386
        linux-gate.so.1 (0xf7702000)
        libusb-0.1.so.4 => not found
        libc.so.6 => /lib32/libc.so.6 (0xf7548000)
        /lib/ld-linux.so.2 (0xf7705000)

# dpkg --add-architecture i386
# apt-get update
# apt-get install libusb-0.1-4:i386
```

### Firmware images
* eMMC aka VANILLA (latest: `RX-51_2009SE_10.2010.13-2.VANILLA_PR_EMMC_MR0_ARM.bin`)
* FIASCO aka COMBINED aka rootfs (latest: `RX-51_2009SE_21.2011.38-1_PR_COMBINED_MR0_ARM.bin` )

MD5:

```
488809ff96a0a05479d692e9f77aeb4f  RX-51_2009SE_10.2010.13-2.VANILLA_PR_EMMC_MR0_ARM.bin
095259c2380e894dc1d6a2999526ec9f  RX-51_2009SE_21.2011.38-1_PR_COMBINED_MR0_ARM.bin
```
## Summary

TL;DR

```
$ git clone https://github.com/u0d7i/n9h
$ sudo n9h/reference-install/ref-pc.sh all
```

## Firmware modifications

### eMMC

Edit VANILLA image starting at 0xcb. Make sure it says:

```
partition {size = 2048; fs_type = "ext3"; prefix = "home";}
```

Stealing whitespace like described [here](http://wiki.maemo.org/User:Joerg_rw/tools#increase_size_of_.2Fhome_-_if_you_like_that) overcomes '9999' limit described [here](http://wiki.maemo.org/Repartitioning_the_flash#Solution_.235:_Edit_eMMC_image_.28works_on_PR1.2.2C_by_globalbus.29). You can do it in Hex etitor (like hte), or simply with sed:


```
 $ sed -e "s/.size = 2048/size = 24576/" RX-51_2009SE_10.2010.13-2.VANILLA_PR_EMMC_MR0_ARM.bin  > \
         mod-RX-51_2009SE_10.2010.13-2.VANILLA_PR_EMMC_MR0_ARM.bin
```

Resulting in:

![eMMC bindiff](bindiff.png "eMMC bindiff")

Modification increases /home patrition from 2G to 24G, leaving 5.1G to VFAT MyDocs.

### rootfs

Rootfs is included in COMBINED/FIASCO image, and first must be extracted.

with flasher-3.5:

```
$ ./flasher-3.5 -F RX-51_2009SE_21.2011.38-1_PR_COMBINED_MR0_ARM.bin --unpack=dump/
<...> 
Unpacking rootfs image to file 'dump/rootfs.jffs2'...
<...>
```

or with 0xFFFF:

```
$ ./flasher-0xFFFF -M RX-51_2009SE_21.2011.38-1_PR_COMBINED_MR0_ARM.bin -u dump/
<...>
Output file: rootfs_RX-51_2009SE_21.2011.38-1_PR_MR0
<...>
```

we are going to follow latter naming convention.

Rootfs image is an [UBI](http://www.linux-mtd.infradead.org/doc/ubi.html) image. Creating modified rootfs image involves several steps.

Install mtd-utils if not installed:

```
$ sudo apt-get install mtd-utils
```

Follow instructions [courtesy of Pali](https://talk.maemo.org/showpost.php?p=1325044&postcount=13):

1.) Load nandsim module (which emulates nand mtd device) with the same layout as N900:

```
$ modprobe nandsim first_id_byte=0x20 second_id_byte=0xaa \
           third_id_byte=0x00 fourth_id_byte=0x15 parts=1,3,2,16,16,2010
```

2.) Load ubi and ubifs modules:

```
$ modprobe ubi
$ modprobe ubifs
```

3.) Flash rootfs ubi image to emulated nand mtd device:

```
$ ubiformat /dev/mtd5 -s 512 -O 512 -f <rootfs_image>
```

4.) Attach mtd device to ubi:

```
$ ubiattach /dev/ubi_ctrl -p /dev/mtd5
```

5.) Mount rootfs volume (ubifs image) from ubi to /mnt/n900:

```
$ mkdir -p /mnt/n900
$ mount ubi:rootfs /mnt/n900 -t ubifs
```

And then rootfs image should be mounted to /mnt/n900

Creating modified rootfs image from mounted directory:

```
$ mkfs.ubifs -m 2048 -e 129024 -c 2047 -r /mnt/n900 rootfs_ubifs.jffs2

$ cat << EOF > rootfs_cfg.ini
[rootfs]
mode=ubi
image=rootfs_ubifs.jffs2
vol_id=0
vol_size=200MiB
vol_type=dynamic
vol_name=rootfs
vol_flags=autoresize
vol_alignment=1
EOF

$ ubinize -o mod-<rootfs_image> -p 128KiB -m 2048 -s 512 rootfs_cfg.ini

$ rm rootfs_ubifs.jffs2 rootfs_cfg.ini
```

Cleaning up:

```
$ umount /mnt/n900
$ ubidetach /dev/ubi_ctrl -d 0
$ rmmod ubifs
$ rmmod ubi
$ rmmod nandsim
```

#### Changes in mounted rootfs image

All needed files or symlinks are placed in [files/](files/) directory.

##### gainroot

The most important thing is being able to gain root access on a device without need to install anything.
This change resembles installing [rootsh](https://wiki.maemo.org/Root_access#rootsh) package.
It also creates "Root terminal" shotrcut in menu.

```
# cat files/gainroot > /mnt/n900/usr/sbin/gainroot
# cp files/root /mnt/n900/usr/bin/
# cp files/root.desktop /mnt/n900/usr/share/applications/hildon/
```

##### remapping keyboard

As described [here](http://wiki.maemo.org/Remapping_keyboard).

```
# cat files/rx-51.mod > /mnt/n900/usr/share/X11/xkb/symbols/nokia_vndr/rx-51
```
Levels:
* L1 - (key)
* L2 - shif+(key)
* L3 - blue/fn+(key)
* L4 - shift+fn+(key)

Changes are visible in a diff [here](../kbd/rx-51.diff):
* braces on L4 `h` and `j` (on L3 parentheses) - `fn+shift(h)` gives `{`
* brackets on L4 `g` and `k` (nearby L3 parentheses)
* move `?` to L4 and leave `.` in L3 to make typing IP adresses in locked `fn` easier
* move `@` to L4 to use spacebar normally in locked `fn`
* move `€` and `£` to L4, and replace them with `|` and `%` on L3
* `UP` arrow - L2 `^` and L3 `PageUp`
* `DOWN` arrow - L2 `~` and L3 `PageDown`
* `LEFT` arrow - L2 `<` and L3 `Escape`
* `RIGHT` arrow - L2 `>` and L3 `Tab`

##### replacing busybox

Native busybox lacks plenty of stuff. We can replace original `busybox` binary with
the one, present in [busybox-power](http://maemo.org/packages/view/busybox-power/)
package.

```
# echo "f018846a83de458e40d875af819c4e8a files/busybox" | md5sum -c
files/busybox: OK

# cat files/busybox > /mnt/n900/bin/busybox
```

### Flashing

As root, start flasher (assuming firmware binaries are in the same directory):

```
# ./flasher-3.5 -f -F RX-51_2009SE_21.2011.38-1_PR_COMBINED_MR0_ARM.bin && \
  ./flasher-3.5 -f -r mod-rootfs_RX-51_2009SE_21.2011.38-1_PR_MR0 && \
  ./flasher-3.5 -f -F mod-RX-51_2009SE_10.2010.13-2.VANILLA_PR_EMMC_MR0_ARM.bin

...
Suitable USB device not found, waiting.
```

Remove battery from N900, plug N900 to a primary (non-hub) USB port.
Then insert battery, which should result in flasher continuing.

Full flashing session takes aproximetely 5-6 minutes on a decent hardware.
When flasher is done, remove battery, unplug USB, then reinsert battery
and let device boot and init system.

## On-device modifications

TL;DR

Launch 'Root terminal', navigate to `ref` directory, and execute `ref-md.sh` script.

