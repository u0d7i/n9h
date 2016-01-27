#!/bin/bash
# reference install script to run on a pc

VANILLA="RX-51_2009SE_10.2010.13-2.VANILLA_PR_EMMC_MR0_ARM.bin"
COMBINED="RX-51_2009SE_21.2011.38-1_PR_COMBINED_MR0_ARM.bin"
FLASHER="./flasher-3.5"
ROOTFS="rootfs_RX-51_2009SE_21.2011.38-1_PR_MR0"

usage(){
    echo "usage: $0 <action>"
    echo "actions:"
    echo "  all - do everything (normal use)"
    echo "  cleanup - subj"
    echo
    exit
}


md5s(){
  echo "+ok: checking md5..."
  if cat << EOF | md5sum -c -
488809ff96a0a05479d692e9f77aeb4f  RX-51_2009SE_10.2010.13-2.VANILLA_PR_EMMC_MR0_ARM.bin
095259c2380e894dc1d6a2999526ec9f  RX-51_2009SE_21.2011.38-1_PR_COMBINED_MR0_ARM.bin
EOF
  then
    echo "+ok: md5 are ok"
    return 0
  else
    echo "-err: can't validate md5"
    return 1
  fi
}

patch_vanilla(){
  echo "+ok: patching VANILLA..."
  if sed -e "s/.size = 2048/size = 24576/" ${VANILLA}  > mod-${VANILLA}; then
    echo "+ok: patching done"
    return 0
  else
    echo "-err: patching failed"
    return 1
  fi
}

xtract_rootfs(){
  if [ -x ${FLASHER} ]; then
    echo "+ok: extracting rootfs..."
    mkdir -p dump
    ${FLASHER} -F ${COMBINED} --unpack=dump/ 2>&1 | grep rootfs | grep ^Image
    mv dump/rootfs.jffs2 ${ROOTFS}
    rm -rf dump
    if [ -e ${ROOTFS} ]; then
      echo "+ok: we have rootfs image"
      return 0
    else
      echo "-err: extracting rootfs failed"
      return 1
    fi
  fi
}

cleanup(){
  echo "+ok: cleanup..."
  umount /mnt/n900
  ubidetach /dev/ubi_ctrl -d 0
  rmmod ubifs
  rmmod ubi
  rmmod nandsim
}

# do stuff
case $1 in
    all)
        if md5s; then
          patch_vanilla || exit
          xtract_rootfs || exita
          cleanup
        fi
        ;;
    cleanup)
        cleanup
        ;;

    *)
        usage
        ;;
esac

