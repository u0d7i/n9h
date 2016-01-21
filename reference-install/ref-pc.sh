#!/bin/bash
# reference install script to run on a pc

usage(){
    echo "usage: $0 <action>"
    echo "actions:"
    echo "  all - do everything (normal use)"
    echo
    exit
}

firmware(){
    VANILLA="RX-51_2009SE_10.2010.13-2.VANILLA_PR_EMMC_MR0_ARM.bin"
    COMBINED="RX-51_2009SE_21.2011.38-1_PR_COMBINED_MR0_ARM.bin"
}

# do stuff
case $1 in
    all)
        echo "not implemented yet"
        ;;
    *)
        usage
        ;;
esac

