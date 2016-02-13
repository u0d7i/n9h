
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


