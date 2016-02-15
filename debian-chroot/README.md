# Debian chroot on Nokia N900

## Prerequisites

* [N900 reference install](../reference-install)
* [kernel-power](https://wiki.maemo.org/Kernel_power)
* [Easy_Debian](https://wiki.maemo.org/Easy_Debian)
* cryptsetup
* dmsetup
* microSD card


`~# apt-get install cryptsetup dmsetup easy-deb-chroot`

## cryptsetup and kernel versions

```
Nokia-N900:~# dd if=/dev/zero of=test-md.img bs=1MB count=10
10+0 records in
10+0 records out
10000000 bytes (10 MB) copied, 0,653229 s, 15,3 MB/s
```

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
