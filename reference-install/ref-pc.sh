#!/bin/bash
# reference install script to run on a pc

VANILLA="RX-51_2009SE_10.2010.13-2.VANILLA_PR_EMMC_MR0_ARM.bin"
COMBINED="RX-51_2009SE_21.2011.38-1_PR_COMBINED_MR0_ARM.bin"
FLASHER="./flasher-3.5"
ROOTFS="rootfs_RX-51_2009SE_21.2011.38-1_PR_MR0"
MNTPNT="/mnt/n900"
FILES="$(dirname $0)/files"

usage(){
    echo "usage: $0 <action>"
    echo "actions:"
    echo "  all - do everything (normal use)"
    echo "  md5 - check md5"
    echo "  patch - patch VANILLA"
    echo "  xtract - extract rootfs image"
    echo "  mount - mount rootfs"
    echo "  modify - modify rootfs"
    echo "  image - create new rootfs image"
    echo "  cleanup - unmount/clean"
    echo "  flash - flash modified firmware"
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

mount_rootfs(){
  echo "+ok: mounting rootfs..."
  modprobe nandsim first_id_byte=0x20 second_id_byte=0xaa third_id_byte=0x00 fourth_id_byte=0x15 parts=1,3,2,16,16,2010
  modprobe ubi
  modprobe ubifs
  ubiformat /dev/mtd5 -s 512 -O 512 -f ${ROOTFS}
  ubiattach /dev/ubi_ctrl -p /dev/mtd5
  mkdir -p ${MNTPNT}
  mount ubi:rootfs ${MNTPNT} -t ubifs
}

mod_rootfs(){
  if mountpoint -q ${MNTPNT}; then
    echo "+ok: modifying rootfs..."
    # gainroot
    if [ -e ${FILES}/gainroot ]; then
       echo "+ok: gainroot"
      cat ${FILES}/gainroot >  ${MNTPNT}/usr/sbin/gainroot
    else
      echo "-err: gainroot not found"
    fi
    # scripts / root
    for root in ref-md.sh connectivity.gconf.cpt
    do
      if [ -e ${FILES}/${root} ]; then
        echo "+ok: ${root}"
        cp ${FILES}/${root} ${MNTPNT}/root/
      else
        echo "-err: ${root} not found"
      fi
    done
    # binaries
    for bin in ccrypt qp apt-get
    do
      if [ -e ${FILES}/${bin} ]; then
        cp ${FILES}/${bin} ${MNTPNT}/usr/local/bin/ && echo "+ok: copy ${bin}"
      else
        echo "-err: ${bin} not found"
      fi
    done
    # keyboard
    if [ -e ${FILES}/rx-51.mod ]; then
      echo "+ok: remapping keyboard"
      cat ${FILES}/rx-51.mod > ${MNTPNT}/usr/share/X11/xkb/symbols/nokia_vndr/rx-51
    else
       echo "-err: rx-51.mod not found"
    fi
    # docpurge
    echo "+ok: docpurge"
    cp  ${MNTPNT}/usr/sbin/docpurge ${MNTPNT}/usr/sbin/docpurge-disabled
    echo '#!/bin/sh' >  ${MNTPNT}/usr/sbin/docpurge
    #FIXME/TODO: fix /etc/gconf/ for /apps/osso/hildon-desktop/applets
  else
    echo "-err: rootfs not mounted, can't modify."
  fi    
}

make_rootfs(){
  if mountpoint -q ${MNTPNT}; then
    echo "+ok: creating new rootfs image..."
    mkfs.ubifs -m 2048 -e 129024 -c 2047 -r ${MNTPNT} rootfs_ubifs.jffs2 || echo "-err: mkfs.ubifs"
    cat << EOF > rootfs_cfg.ini
[rootfs]
mode=ubi
image=rootfs_ubifs.jffs2
vol_id=0
vol_size=187729920
vol_type=dynamic
vol_name=rootfs
vol_flags=autoresize
vol_alignment=1
EOF
    ubinize -o mod-${ROOTFS} -p 128KiB -m 2048 -s 512 rootfs_cfg.ini || echo "-err: ubinize"
    rm rootfs_ubifs.jffs2 rootfs_cfg.ini
    if [ -e mod-${ROOTFS} ]; then
      echo "+ok: we have new rootfs image"
      return 0
    else
      return 1
    fi
  else
    echo "-err: rootfs not mounted, can't image"
    return 1
  fi
}

cleanup(){
  echo "+ok: cleanup..."
  umount ${MNTPNT}
  ubidetach /dev/ubi_ctrl -d 0
  rmmod ubifs
  rmmod ubi
  rmmod nandsim
}

flash(){
    for stuff in ${COMBINED} mod-${ROOTFS} mod-${VANILLA} ${FLASHER};
    do
        if [ ! -e $stuff ]; then
            echo "-err: $stuff not found"
            return 1
        fi
    done
}


# checks
if [ $(id -u) -ne 0 ]; then
  echo "-err: you are not root"
  exit
fi


# do stuff
case $1 in
    all)
        if md5s; then
          patch_vanilla || exit
          xtract_rootfs || exit
          mount_rootfs
          mod_rootfs
          make_rootfs
          cleanup
        fi
        ;;
    md5)
        md5s
        ;;
    patch)
        patch_vanilla
        ;;
    xtract)
        xtract_rootfs
        ;;
    mount)
        mount_rootfs
        ;;
    modify)
        mod_rootfs
        ;;
    image)
        make_rootfs
        ;;
    cleanup)
        cleanup
        ;;
    flash)
        flash
        ;;
    *)
        usage
        ;;
esac

