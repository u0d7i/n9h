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

<pre>
 000000c0  72 75 65 3b 0d 0a 09 7d  0d 0a 09 70 61 72 74 69  |rue;...}...parti|
<span style="color:green">-000000d0</span>  74 69 6f 6e 20 7b 0d 0a  09 <span style="background:silver"><span style="background:red">09</span> 73 69 7a 65 20 3d</span>  |tion {...<span style="background:red">.</span>size =|
<span style="color:green">-000000e0</span>  <span style="background:silver">20 32 <span style="color:red">30 34 38</span></span> 3b 0d 0a  09 09 66 73 5f 74 79 70  | <span style="color:red">2048</span>;....fs_typ|
 000000f0  65 20 3d 20 22 65 78 74  33 22 3b 0d 0a 09 09 70  |e = "ext3";....p|
 00000100  72 65 66 69 78 20 3d 20  22 68 6f 6d 65 22 3b 0d  |refix = "home";.|
</pre>

<pre>
 000000c0  72 75 65 3b 0d 0a 09 7d  0d 0a 09 70 61 72 74 69  |rue;...}...parti|
<span style="color:green">+000000d0</span>  74 69 6f 6e 20 7b 0d 0a  09 <span style="background:silver">73 69 7a 65 20 3d 20</span>  |tion {...size = |
<span style="color:green">+000000e0</span>  <span style="background:silver">32 <span style="color:red">34 35 37 36</span></span> 3b 0d 0a  09 09 66 73 5f 74 79 70  |<span style="color:red">24576</span>;....fs_typ|
 000000f0  65 20 3d 20 22 65 78 74  33 22 3b 0d 0a 09 09 70  |e = "ext3";....p|
 00000100  72 65 66 69 78 20 3d 20  22 68 6f 6d 65 22 3b 0d  |refix = "home";.|
</pre>

