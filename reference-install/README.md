# Nokia n900 reference install

## Prerequisites

* flashers:
  * Nokia official [flasher-3.5] (https://wiki.maemo.org/Documentation/Maemo_5_Developer_Guide/Development_Environment/Maemo_Flasher-3.5)
  * [0xFFFF] (https://talk.maemo.org/showthread.php?t=87996)
* firmware images:
  * eMMC aka VANILLA (latest: `RX-51_2009SE_10.2010.13-2.VANILLA_PR_EMMC_MR0_ARM.bin`)
  * FIASCO aka COMBINED aka rootfs (latest: `RX-51_2009SE_10.2010.13-2.VANILLA_PR_EMMC_MR0_ARM.bin` )

MD5:

    488809ff96a0a05479d692e9f77aeb4f  RX-51_2009SE_10.2010.13-2.VANILLA_PR_EMMC_MR0_ARM.bin
    095259c2380e894dc1d6a2999526ec9f  RX-51_2009SE_21.2011.38-1_PR_COMBINED_MR0_ARM.bin

## Firmware modifications

### eMMC

    $ sed -e "s/.size = 2048/size = 24576/" RX-51_2009SE_10.2010.13-2.VANILLA_PR_EMMC_MR0_ARM.bin  > patched-RX-51_2009SE_10.2010.13-2.VANILLA_PR_EMMC_MR0_ARM.bin

![eMMC bindiff](bindiff.png "eMMC bindiff")

