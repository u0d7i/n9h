#!/bin/sh

CFG="connectivity.gconf.cpt"
# prepate it with
# gconftool -R /system/osso/connectivity/IAP/<conn_id>
# encrypt with ccrypt
# save to modified rootfs together with this script

if [ -z "$(command -v ccrypt)" ]; then
        echo "ccrypt not installed"
        exit
fi

if [ ! -f ${CFG} ]; then
        echo "configuration file not found"
        exit
fi

# clean
gconftool -R /system/osso/connectivity/IAP | grep "^ /" | sed 's/:$//' | while read line
do
        gconftool --dump ${line} | gconftool --unload -
done

# load
ccrypt -c ${CFG} | gconftool --load -
