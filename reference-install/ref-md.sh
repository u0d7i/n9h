#!/bin/sh
# reference install script to run on a mobile device

# settings
apt_src="/etc/apt/sources.list.d/hildon-application-manager.list"
conn_cfg="connectivity.gconf.cpt"

usage(){
    echo "usage: $(basename $0) <action>"
    echo "actions:"
    echo "  all  - do everything (normal use)"
    echo "  apt  - set apt sources file"
    echo "  conn - set up connectivity"
    echo "  cssu - install CSSU"
    echo "  purge - remove crap"
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
        echo "!warn: no connectivity cfg, do it manually"
    fi
    # add status check and cli enable later
    # start gui and use dirty loos for now
    #dbus-send --system --type=method_call \
    #    --dest=com.nokia.icd_ui /com/nokia/icd_ui \
    #    com.nokia.icd_ui.show_conn_dlg boolean:false
}

apttest(){
    # check for internet connection
    # there are several ways to do it
    # but the only reliable one - try using actual resource you need
    #
    url=$(head -1 $apt_src | cut -d' ' -f2)
    if ! echo $url | grep 'repository.maemo.org' > /dev/null 2>&1; then
        echo "-err: unexpected apt source"
        return 1
    fi
    if wget -q -O - $url >/dev/null 2>&1; then
        [ "$1" == "q" ] || echo "+ok: apt source is reachable"
        return 0
    else
        [ "$1" == "q" ] || echo "-err: apt source is not reachable"
        return 1
    fi
}

cssu(){
    if apttest; then
        echo "+ok: install cssu"
        apt-get update
        apt-get install mp-fremantle-community-pr
        apt-get clean
        return 0
    else
        return 1
    fi
}

purge(){
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
        echo "not implemented yet"
        aptfile
        conn
        while ! apttest q
        do
            echo -n .
            sleep 1
        done
        echo
        cssu
        purge
        ;;
    apt)
        aptfile
        ;;
    conn)
        conn
        ;;
    cssu)
        cssu
        ;;
    purge)
        purge
        ;;
    *)
        usage
        ;;
esac
