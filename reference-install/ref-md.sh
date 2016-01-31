#!/bin/sh
# reference install script to run on a mobile device

# settings
apt_src="/etc/apt/sources.list.d/hildon-application-manager.list"
conn_cfg="connectivity.gconf.cpt"
AP="DefaultWifi"

usage(){
    echo "usage: $(basename $0) <action>"
    echo "actions:"
    echo "  all     - do everything (normal use)"
    echo "  apt     - set apt sources file"
    echo "  conn    - set up connectivity"
    echo "  apttest -  test apt sources (implies conn)"
    echo "  cssu    - install CSSU"
    echo "  purge   - remove crap"
    echo "  install - install stuff"
    echo "  tune    - final touch"
    echo
    exit
}

aptfile(){
    echo "+ok: updating apt sources"
    cat > $apt_src << 'EOF'
deb http://repository.maemo.org/community/ fremantle free non-free
deb http://repository.maemo.org/extras/ fremantle-1.3 free non-free
deb http://repository.maemo.org/extras-devel fremantle free non-free
deb http://repository.maemo.org/extras-testing fremantle free non-free
deb http://repository.maemo.org/ fremantle/4bc37c7c77ebe90177c050b805a8dc79 nokia-binaries
deb http://repository.maemo.org/ fremantle/sdk free non-free
deb http://repository.maemo.org/ fremantle/tools free non-free
EOF
}

conn(){
    echo "+ok: setting connectivity"
    if [ -f $conn_cfg ]; then
        if [ -z "$(command -v ccrypt)" ]; then
            echo "-err: ccrypt not installed"
        else
            echo "+ok: importing connectivity cfg"
            ccrypt -c $conn_cfg | gconftool --load -
        fi
    else
        echo "!warn: no connectivity cfg, skipping import"
    fi
    # try connecting to default AP
    echo "+ok: connecting to default AP..."
    dbus-send --system --type=method_call --print-reply\
        --dest=com.nokia.icd /com/nokia/icd \
        com.nokia.icd.connect \
        string:${AP} uint32:0 > /dev/null 2>&1 && \
            echo "+ok: connected" || \
            echo "-err: can't conect, do it manually"
}

apttest(){
    # check for internet connection
    # there are several ways to do it
    # but the only reliable one - try using actual resource you need
    #
    WGET="wget"
    if  [ -z "$(command -v ${WGET})" ]; then
      WGET="wget.static"
    fi
    url=$(head -1 $apt_src | cut -d' ' -f2)
    if ! echo $url | grep 'repository.maemo.org' > /dev/null 2>&1; then
        echo "-err: unexpected apt source"
        return 1
    fi
    if ${WGET} -q -O - $url >/dev/null 2>&1; then
        [ "$1" == "q" ] || echo "+ok: apt source is reachable"
        return 0
    else
        [ "$1" == "q" ] || echo "-err: apt source is not reachable"
        return 1
    fi
}

aptupd(){
    # DIXME pgp keys
    if apttest; then
        echo "+ok: updating apt..."
        apt-get update
        return 0
    else
        return 1
    fi
}

cssu(){
    if apttest; then
        echo "+ok: installing cssu..."
        apt-get -y install mp-fremantle-community-pr
        apt-get clean
        return 0
    else
        return 1
    fi
}

purge(){
    echo "+ok: purging crap..."
    apt-get -y remove --purge cherry ap-installer amazon-installer \
        foreca-installer facebook-installer dtg-installer \
        tutorial-home-applet osso-tutorial-l10n-engb \
        osso-tutorial-l10n-ptpt osso-tutorial-l10n-frca \
        osso-tutorial-l10n-nlnl osso-tutorial-l10n-cscz \
        osso-tutorial-l10n-itit osso-tutorial-l10n-eses \
        osso-tutorial-l10n-svse osso-tutorial-l10n-frfr \
        osso-tutorial-l10n-dede osso-tutorial-l10n-fifi \
        osso-tutorial-l10n-nono osso-tutorial-l10n-esmx \
        osso-tutorial-l10n-enus osso-tutorial-l10n-ruru \
        osso-tutorial-l10n-mr0 osso-tutorial-l10n-plpl \
        osso-systemui-splashscreen sharing-service-flickr \
        sharing-service-ovi chinese-font google-search-widget \
        tutorial-home-applet ovi-promotion-widget gnuchess \
        hildon-theme-beta maemoblocks osso-chess-ui \
        osso-graphics-game-chess osso-graphics-game-lmarbles \
        osso-graphics-game-mahjong osso-lmarbles osso-mahjong \
        osso-sounds-game-chess osso-sounds-game-mahjong \
        hildon-welcome hildon-welcome-default-logo
}

install(){
    if apttest; then
        echo "+ok: installing stuff..."
        apt-get -y --force-yes install bash4 busybox-power cell-modem-ui \
            coreutils-gnu cpumem-applet findutils-gnu i2c-tools \
            iptables kernel-power-bootimg kernel-power-flasher \
            kernel-power-settings kexec-tools less locate \
            man-db-n900 mtd-utils openssh procps rootsh ssh-status \
            u-boot-flasher usbip vim
        apt-get clean
        return 0
    else
        return 1
    fi

}

tune(){
    echo "+ok: final touch..."

    ## dbus
    # silent profile
    dbus-send --type=method_call --dest=com.nokia.profiled /com/nokia/profiled com.nokia.profiled.set_profile string:"silent"

    ## gconf
    # update check interval to 5 years
    gconftool -s /apps/hildon/update-notifier/check_interval -t int 2628000
    # kbd fix
    gconftool -s /apps/osso/inputmethod/ext_kb_repeat_enabled --type boolean true
    # display dim to 2 minutes
    gconftool -s /system/osso/dsm/display -t int 120
    # leave only one desktop
    gconftool -s /apps/osso/hildon-desktop/views/active -t list --list-type int [1]
    # xterm  reverse colours
    gconftool -s /apps/osso/xterm/reverse -t boolean true
    # disable positioning
    gconftool -s /system/nokia/location/gps-disabled -t boolean true
    gconftool -s /system/nokia/location/network-disabled -t boolean true
    # disable auto-connect (always ask)
    gconftool -s /system/osso/connectivity/network_type/auto_connect -t list --list-type string "[]"

    ## misc
    # tracker
    sed -i -e "s/Throttle=0/Throttle=10/" /home/user/.config/tracker/tracker.cfg
    # remove startup wizard after battery swap
    if [ -e /etc/X11/Xsession.d/30osso_startup_wizard ]; then
        mv /etc/X11/Xsession.d/30osso_startup_wizard /root/
    fi
    # setup bash
    if [ -x /bin/bash4 ]; then
        ln -sf /bin/bash4 /bin/bash
        # danger
        sed -i 's@/root:/bin/sh@/root:/bin/bash@' /etc/passwd
    fi

}

# fascist checks
grep "RX-51" /proc/cpuinfo > /dev/null && \
grep "Maemo" /etc/issue > /dev/null || {
    echo "-err: run it on a mobile device"
    exit
}
if [ $(id -u) -ne 0 ]; then
    echo "-err: you are not root"
    exit
fi

# do stuff
case $1 in
    all)
        aptfile
        conn
        while ! apttest q
        do
            echo -n .
            sleep 1
        done && echo
        aptupd
        cssu
        purge
        install
        tune
        ;;
    apt)
        aptfile
        ;;
    conn)
        conn
        ;;
    apttest)
        apttest
        ;;
    cssu)
        aptupd
        cssu
        ;;
    purge)
        purge
        ;;
    install)
        aptupd
        install
        ;;
    tune)
        tune
        ;;
    *)
        usage
        ;;
esac
