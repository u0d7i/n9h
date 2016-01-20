# Nokia n900 reference install

## Prerequisites

* flashers:
  * Nokia official [flasher-3.5] (https://wiki.maemo.org/Documentation/Maemo_5_Developer_Guide/Development_Environment/Maemo_Flasher-3.5)
  * [0xFFFF] (https://talk.maemo.org/showthread.php?t=87996)
* firmware images:
  * eMMC aka VANILLA (latest: `RX-51_2009SE_10.2010.13-2.VANILLA_PR_EMMC_MR0_ARM.bin`)
  * FIASCO aka COMBINED aka rootfs (latest: `RX-51_2009SE_21.2011.38-1_PR_COMBINED_MR0_ARM.bin` )

MD5:

    488809ff96a0a05479d692e9f77aeb4f  RX-51_2009SE_10.2010.13-2.VANILLA_PR_EMMC_MR0_ARM.bin
    095259c2380e894dc1d6a2999526ec9f  RX-51_2009SE_21.2011.38-1_PR_COMBINED_MR0_ARM.bin

## Firmware modifications

### eMMC

Edit VANILLA image starting at 0xcb. Make sure it says:

    partition {size = 2048; fs_type = "ext3"; prefix = "home";}

Stealing whitespace like described [here](http://wiki.maemo.org/User:Joerg_rw/tools#increase_size_of_.2Fhome_-_if_you_like_that) overcomes '9999' limit described [here](http://wiki.maemo.org/Repartitioning_the_flash#Solution_.235:_Edit_eMMC_image_.28works_on_PR1.2.2C_by_globalbus.29). You can do it in Hex etitor (like hte), or simply with sed:

    $ sed -e "s/.size = 2048/size = 24576/" RX-51_2009SE_10.2010.13-2.VANILLA_PR_EMMC_MR0_ARM.bin  > mod-RX-51_2009SE_10.2010.13-2.VANILLA_PR_EMMC_MR0_ARM.bin

Resulting in:

![eMMC bindiff](bindiff.png "eMMC bindiff")

Modification increases /home patrition from 2G to 24G, leaving 5.1G to VFAT MyDocs.

### rootfs

rootfs is included in COMBINED/FIASCO image, and first must be extracted.

with flasher-3.5:

    $ ./flasher-3.5 -F RX-51_2009SE_21.2011.38-1_PR_COMBINED_MR0_ARM.bin --unpack=dump/
    <...> 
    Unpacking rootfs image to file 'dump/rootfs.jffs2'...
    <...>

or with 0xFFFF:

    $ ./flasher-0xFFFF -M RX-51_2009SE_21.2011.38-1_PR_COMBINED_MR0_ARM.bin -u dump/
    <...>
    Output file: rootfs_RX-51_2009SE_21.2011.38-1_PR_MR0
    <...>

we are going to follow latter naming convention.
