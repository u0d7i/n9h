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

# Setup

## Hardware key event mapping

Kernel is lacking acpi support, but acpid is present in default install - `power key` and `screen lock key` are generating acpi events
which can be handled by acpid. The rest of hardware buttons/sensors, even generating input events (see /dev/input/) are not genetrating
acpi events, so, `inputlirc` can be used to handle the rest.

```
# acpi_listen 
button/screenlock SCRNLCK 00000080 00000000
^C
```

```
# apt-get install evtest

# evtest 
No device specified, trying to scan all of /dev/input/event*
Available devices:
/dev/input/event0:      twl4030_pwrbutton
/dev/input/event1:      TWL4030 Keypad
/dev/input/event2:      RX-51 AV Jack
/dev/input/event3:      twl4030:vibrator
/dev/input/event4:      ST LIS3LV02DL Accelerometer
/dev/input/event5:      TSC200X touchscreen
/dev/input/event6:      gpio_keys
Select the device event number [0-6]: 6
Input driver version is 1.0.1
Input device ID: bus 0x19 vendor 0x1 product 0x1 version 0x100
Input device name: "gpio_keys"
Supported events:
  Event type 0 (EV_SYN)
  Event type 1 (EV_KEY)
    Event code 152 (KEY_SCREENLOCK)
    Event code 212 (KEY_CAMERA)
    Event code 528 (?)
  Event type 5 (EV_SW)
    Event code 9 (SW_CAMERA_LENS_COVER)
    Event code 10 (SW_KEYPAD_SLIDE)
    Event code 11 (SW_FRONT_PROXIMITY)
Properties:
Testing ... (interrupt to exit)
Event: time 1482764483.629455, type 5 (EV_SW), code 10 (SW_KEYPAD_SLIDE), value 1
Event: time 1482764483.629455, -------------- EV_SYN ------------
Event: time 1482764485.010314, type 5 (EV_SW), code 10 (SW_KEYPAD_SLIDE), value 0
Event: time 1482764485.010314, -------------- EV_SYN ------------
Event: time 1482764487.062957, type 1 (EV_KEY), code 152 (KEY_SCREENLOCK), value 1
Event: time 1482764487.062957, -------------- EV_SYN ------------
Event: time 1482764487.217742, type 1 (EV_KEY), code 152 (KEY_SCREENLOCK), value 0
Event: time 1482764487.217742, -------------- EV_SYN ------------
Event: time 1482764491.275604, type 5 (EV_SW), code 9 (SW_CAMERA_LENS_COVER), value 0
Event: time 1482764491.275604, -------------- EV_SYN ------------
Event: time 1482764492.174255, type 5 (EV_SW), code 9 (SW_CAMERA_LENS_COVER), value 1
Event: time 1482764492.174255, -------------- EV_SYN ------------
```
## Modem and mobile data

Setting up modem for mobile data with [ofono](https://en.wikipedia.org/wiki/OFono) is described
[here](http://musicnaut.iki.fi/txt/nokia_modem.txt) (local copy [here](nokia_modem.txt)).

There is a bunch of [very handy python scripts](https://github.com/rilmodem/ofono/tree/master/test)
on ofono github repo, based on which I crafted (bulky and hacky) version of
[my own modem management script](ofo)
until I find/code an easy direct way without dbus/ofono.

# TODO

- performance tests for encrypted swap on SD card
- keyboard led off on lid close
- kbd lock, kbd led, screen off/on on slide
- unicode setup on boot/login

