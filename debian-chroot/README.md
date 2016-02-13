# Debian chroot on Nokia N900

## Prerequisites

* [N900 reference install](../reference-install)
* [kernel-power](https://wiki.maemo.org/Kernel_power)
* [Easy_Debian](https://wiki.maemo.org/Easy_Debian)
* cryptsetup
* microSD card

    ~# apt-get install cryptsetup easy-deb-chroot

## APT

/etc/apt/sources.list

    deb http://httpredir.debian.org/debian wheezy main contrib non-free
    deb http://security.debian.org/ wheezy/updates main contrib non-free
    deb http://httpredir.debian.org/debian/ wheezy-updates main contrib non-free
    deb http://httpredir.debian.org/debian wheezy-backports main contrib non-free
    deb http://httpredir.debian.org/debian wheezy-backports-sloppy main contrib non-free

/etc/apt/preferences.d/backports 

    Package: *
    Pin: release a=wheezy-backports
    Pin-Priority: 500
    
    Package: *
    Pin: release a=wheezy-backports-sloppy
    Pin-Priority: 500


