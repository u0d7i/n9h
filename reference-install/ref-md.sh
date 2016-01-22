#!/bin/sh
# reference install script to run on a mobile device

usage(){
    echo "usage: $0 <action>"
    echo "actions:"
    echo "  all - do everything (normal use)"
    echo "  apt - set apt sources file"
    echo
    exit
}

aptfile(){
    SRC="/etc/apt/sources.list.d/hildon-application-manager.list"
    cat > $SRC << 'EOF'
deb http://repository.maemo.org/community/ fremantle free non-free
deb http://repository.maemo.org/extras/ fremantle-1.3 free non-free
deb http://repository.maemo.org/extras-devel fremantle free non-free
deb http://repository.maemo.org/extras-testing fremantle free non-free
deb http://repository.maemo.org/ fremantle/4bc37c7c77ebe90177c050b805a8dc79 nokia-binaries
deb http://repository.maemo.org/ fremantle/sdk free non-free
deb http://repository.maemo.org/ fremantle/tools free non-free
EOF
}


# fascis checks
    grep "RX-51" /proc/cpuinfo > /dev/null && \
    grep "Maemo" /etc/issue > /dev/null | {
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
        ;;
    apt)
        aptfile
        ;;
    *)
        usage
        ;;
esac
