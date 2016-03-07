# Debian chroot on Nokia N900

## Contents

* [Prerequisites](#prerequisites)
* [cryptsetup and kernel versions](#cryptsetup-and-kernel-versions)
* [Create LUKS encrypted filesystem on a microSD](#create-luks-encrypted-filesystem-on-a-microsd)
* [Install Debian armhf](#install-debian-armhf)
* [APT]($APT)


## Prerequisites

* [N900 reference install](../reference-install)
* [kernel-power](https://wiki.maemo.org/Kernel_power)
* [Easy_Debian](https://wiki.maemo.org/Easy_Debian) (actually, [easy-chroot](http://maemo.org/packages/view/easy-chroot/) is enough)
* cryptsetup
* dmsetup (optional)
* microSD card


```
Nokia-N900:~# apt-get install cryptsetup dmsetup easy-chroot
```

## cryptsetup and kernel versions

Some tests. On mobile device:

```
Nokia-N900:~# uname -a
Linux Nokia-N900 2.6.28.10-power53 #1 PREEMPT Wed Dec 10 13:52:39 UTC 2014 armv7l GNU/Linux

Nokia-N900:~# cryptsetup --version
cryptsetup 1.0.7

Nokia-N900:~# modprobe dm_mod

Nokia-N900:~# dd if=/dev/zero of=test-md.img bs=1MB count=10
10+0 records in
10+0 records out
10000000 bytes (10 MB) copied, 0,653229 s, 15,3 MB/s

Nokia-N900:~# losetup /dev/loop0 ./test-md.img

Nokia-N900:~# cryptsetup luksFormat /dev/loop0 

WARNING!
========
This will overwrite data on /dev/loop0 irrevocably.

Are you sure? (Type uppercase yes): YES
Enter LUKS passphrase: 
Verify passphrase: 
Command successful.

Nokia-N900:~# losetup -d /dev/loop
```

On modern Debian (jessie):

```
root@pc:~# uname -a
Linux pc 3.16.0-4-686-pae #1 SMP Debian 3.16.7-ckt20-1+deb8u3 (2016-01-17) i686 GNU/Linux

root@pc:~# cryptsetup --version
cryptsetup 1.6.6

root@pc:~# dd if=/dev/zero of=test-pc.img bs=1MB count=10
10+0 records in
10+0 records out
10000000 bytes (10 MB) copied, 0.0939569 s, 106 MB/s

root@pc:~# cryptsetup luksFormat test-pc.img 

WARNING!
========
This will overwrite data on test-pc.img irrevocably.

Are you sure? (Type uppercase yes): YES
Enter passphrase: 
Verify passphrase: 
```

Now we can compare both images (on a pc):

```
root@pc:~# file test-*.img
test-md.img: LUKS encrypted file, ver 1 [aes, cbc-essiv:sha256, sha1] UUID: 5b3e3b40-9dfe-40db-89f1-c2a407622c31
test-pc.img: LUKS encrypted file, ver 1 [aes, xts-plain64, sha1] UUID: 9ac7bd84-89aa-493b-b989-f31596235a99
```

We see different cypher defaults. Detailed info:

```
root@pc:~# cryptsetup luksDump test-md.img 
LUKS header information for test-md.img

Version:        1
Cipher name:    aes
Cipher mode:    cbc-essiv:sha256
Hash spec:      sha1
Payload offset: 1032
MK bits:        128
MK digest:      86 d2 ec 03 04 91 bf aa 10 d3 11 32 e5 0d 5f bb 2d 99 13 24 
MK salt:        0c 04 e3 dc 6e f2 bc ea 97 09 81 60 80 b0 14 5a 
                ae 52 03 33 53 b9 6e c5 64 05 15 b5 3c c2 7a 18 
MK iterations:  10
UUID:           5b3e3b40-9dfe-40db-89f1-c2a407622c31

Key Slot 0: ENABLED
        Iterations:             52718
        Salt:                   58 72 cc 53 72 72 5f b7 9e 61 ca 80 96 bf 31 26 
                                7d 74 d3 a8 cb 9b 0d 46 51 f0 f7 07 d9 b9 9b af 
        Key material offset:    8
        AF stripes:             4000
Key Slot 1: DISABLED
Key Slot 2: DISABLED
Key Slot 3: DISABLED
Key Slot 4: DISABLED
Key Slot 5: DISABLED
Key Slot 6: DISABLED
Key Slot 7: DISABLED
```

```
root@pc:~# cryptsetup luksDump test-pc.img
LUKS header information for test-pc.img

Version:        1
Cipher name:    aes
Cipher mode:    xts-plain64
Hash spec:      sha1
Payload offset: 4096
MK bits:        256
MK digest:      ee b9 f9 5e 69 29 2e e2 f7 83 56 ff 4e b1 d5 7f 8f 46 18 fa 
MK salt:        ba 86 4b de 17 7a d4 68 4b 03 6a ce 57 a3 53 b1 
                09 58 6d 44 e5 18 ab 61 11 c4 2b e4 13 f9 74 04 
MK iterations:  16375
UUID:           9ac7bd84-89aa-493b-b989-f31596235a99

Key Slot 0: ENABLED
        Iterations:             65305
        Salt:                   20 14 3f 93 cc e6 a6 61 b5 df 7d 0f 4b d4 77 19 
                                e3 f7 f0 2d 84 97 80 1d 9f 03 41 31 e9 6f df 0f 
        Key material offset:    8
        AF stripes:             4000
Key Slot 1: DISABLED
Key Slot 2: DISABLED
Key Slot 3: DISABLED
Key Slot 4: DISABLED
Key Slot 5: DISABLED
Key Slot 6: DISABLED
Key Slot 7: DISABLED
```

To resemble older cryptsetup defaults present on N900 Maemo we should explicityly specify parameters on modern Debian:

```
root@pc:~# cryptsetup -c aes-cbc-essiv:sha256  -s 128 --align-payload 1032  luksFormat test-new.img
```

## Create LUKS encrypted filesystem on a microSD

On a PC (/dev/sdd is a microSD card, yes I am root):

```
root@pc:~# fdisk -l /dev/sdd 

Disk /dev/sdd: 7.5 GiB, 8026849280 bytes, 15677440 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: dos
Disk identifier: 0xe93edc2a

Device     Boot Start      End  Sectors  Size Id Type
/dev/sdd1        2048 15677439 15675392  7.5G  b W95 FAT32

```

wipe partition table:

```
root@pc~# dd if=/dev/zero of=/dev/sdd bs=512 count=1
```

Create partition table and single 'Linux' type partition:

```
root@pc:~# echo -e "o\nn\np\n1\n\n\nw" | fdisk /dev/sdd
```

Verify:

```
root@pc:~# fdisk -l /dev/sdd 

Disk /dev/sdd: 7.5 GiB, 8026849280 bytes, 15677440 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: dos
Disk identifier: 0xbfb41717

Device     Boot Start      End  Sectors  Size Id Type
/dev/sdd1        2048 15677439 15675392  7.5G 83 Linux
```

Create LUKS encrypted volume:

```
root@pc:~# cryptsetup -c aes-cbc-essiv:sha256  -s 128 --align-payload 1032  luksFormat /dev/sdd1
```

## Install Debian armhf

```
root@pc:~# cryptsetup luksOpen /dev/sdd1 luks001

root@pc:~# mkfs.ext3 /dev/mapper/luks001

root@pc:~# mount /dev/mapper/luks001 /mnt/

root@pc:~# apt-get install qemu-user-static binfmt-support debootstrap

root@pc:~# qemu-debootstrap --arch armhf wheezy /mnt http://ftp.debian.org/debian

root@pc:~# for d in dev proc sys dev/pts; do mount -o bind /${d} /mnt/${d}; done

root@pc:~# chroot /mnt

# cat > /etc/apt/sources.list << EOF
deb http://httpredir.debian.org/debian wheezy main contrib non-free
deb http://security.debian.org/ wheezy/updates main contrib non-free
deb http://httpredir.debian.org/debian/ wheezy-updates main contrib non-free
EOF

# cat > /etc/apt/apt.conf.d/10recommends <<EOF
APT::Install-Recommends "0";
APT::Install-Suggests "0";
EOF

# apt-get update && apt-get -y upgrade

# apt-get install locales && dpkg-reconfigure locales
>> select all en_GB* and en_US*, default to en_US.UTF-8

# exit

root@pc:~# for d in dev/pts dev proc sys; do umount /mnt/${d}; done
root@pc:~# umount /mnt
root@pc:~# cryptsetup luksClose luks001
```

Now remove SD card from PC and place it back into N900.

## APT

/etc/apt/sources.list

```
deb http://httpredir.debian.org/debian wheezy main contrib non-free
deb http://security.debian.org/ wheezy/updates main contrib non-free
deb http://httpredir.debian.org/debian/ wheezy-updates main contrib non-free
deb http://httpredir.debian.org/debian wheezy-backports main contrib non-free
deb http://httpredir.debian.org/debian wheezy-backports-sloppy main contrib non-free
```

/etc/apt/preferences.d/backports 

```
Package: *
Pin: release a=wheezy-backports
Pin-Priority: 500

Package: *
Pin: release a=wheezy-backports-sloppy
Pin-Priority: 500
```

## On-device scripts

There are 2 possible scenarios on device:

* Adapt chroot to stock easy-chroot scripts
* Customize scripts to reflect our specific needs

We will combine both:

~~~
Nokia-N900:~# diff -u /sbin/qchroot.dist /sbin/qchroot
--- /sbin/qchroot.dist
+++ /sbin/qchroot
@@ -54,10 +54,10 @@
   #Gentoo wiki says this will make X work
   echo .. >/dev/stderr
   mount -t devpts none "$CHROOT/dev/pts"
-  mount -o bind /tmp "$CHROOT/tmp"
+  #mount -o bind /tmp "$CHROOT/tmp"
 
   #Open e-mail attachments, etc
-  mount -o bind /var/tmp "$CHROOT/var/tmp"
+  #mount -o bind /var/tmp "$CHROOT/var/tmp"
 
   #ArchLinux suggestions
   mount -o bind /dev/shm "$CHROOT/dev/shm"
@@ -79,8 +79,8 @@
   #mount -o bind /home/user "$CHROOT/home/user"
 
   # Do it the Fremantle way.
-  mount /dev/mmcblk0p2 "$CHROOT/home"
-  mount /dev/mmcblk0p1 "$CHROOT/home/user/MyDocs"
+  #mount /dev/mmcblk0p2 "$CHROOT/home"
+  #mount /dev/mmcblk0p1 "$CHROOT/home/user/MyDocs"
   
   #Make DBus work
   mount -o bind /var/run/dbus "$CHROOT/var/run/dbus"
~~~

~~~
Nokia-N900:~# diff -u /sbin/closechroot.dist /sbin/closechroot
--- /sbin/closechroot.dist
+++ /sbin/closechroot
@@ -80,7 +80,7 @@
 
 #Any external mounts
 
-umount -fl $CHROOT/home/user/MyDocs
+umount -fl $CHROOT/home/user/MyDocs 2>/dev/null
 umount -fl $CHROOT/dev/pts
 umount -fl $CHROOT/dev/shm
 
~~~

In chroot:

~~~
# cd /var
# rm run
# ln -sf ../run
# rm lock
# ln -sf ../run/lock
# mkdir /var/run/dbus
# mkdir /var/run/pulse
# mkdir /var/lib/dbus
~~~

