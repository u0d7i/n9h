#!/bin/sh

# config
FORCE="NO"
CRINIT="NO"

BOOT="100MiB"
SWAP="768MiB"

ROOT="sd2"
MPOINT="/mnt"

SD="$1"

abort(){
  echo "$@"
  exit
}

cleanup(){
  echo "+ Cleanup..."
  umount ${MPOINT}/boot
  umount ${MPOINT}
  cryptsetup luksClose ${ROOT}

}

cryptoinit(){
  echo "+ Filling card with random data..."
  KEYFILE="$(mktemp)"
  CRNAME="sdcrypt_$(mktemp -u -d XXXX)"
  dd bs=512 count=4 if=/dev/urandom of=${KEYFILE} iflag=fullblock
  cryptsetup luksFormat -q -v -d ${KEYFILE} ${SD}
  cryptsetup luksOpen -d ${KEYFILE} ${SD} ${CRNAME}
  echo "++ issue 'sudo kill -USR1 $(pgrep ^dd)' in other term to see progress"
  dd if=/dev/zero of=/dev/mapper/${CRNAME}
  cryptsetup luksClose ${CRNAME}
  rm -f ${KEYFILE}
  dd if=/dev/urandom of=${SD} bs=512 count=2048
  parted -s ${SD} -- mklabel msdos
}

[ $# -ne 1 ] && abort "usage: $(basename $0) <device>"
[ $(id -u) -ne 0 ] && abort  "- Err: must be root"

echo "+ Testing..."
parted -s -- ${SD} print || abort  "- Err: can't continue"
[ "$FORCE" != "YES" ] && echo "About to modify ${SD}\nAre you sure?"
[ "$FORCE" != "YES" ] && read -r -p "Type CAPITAL YES to continue: " FORCE
[ "$FORCE" != "YES" ] && abort  "- Err: can't continue"

#continue
cleanup
[ "$CRINIT" != "YES" ] || cryptoinit

echo "+ Partitioning..."
parted -a optimal -s ${SD} -- mklabel msdos \
                              mkpart primary ext2 0% ${BOOT} \
                              mkpart primary ext2 ${BOOT} -${SWAP}  \
                              mkpart primary ext2 -${SWAP} 100%

parted -s -- ${SD} print


