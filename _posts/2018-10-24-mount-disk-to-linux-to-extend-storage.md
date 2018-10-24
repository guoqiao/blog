---
layout: post
title:  "给 Linux 主机挂载新的磁盘用于存储数据"
date:   2018-10-24 00:00:00 +1200
categories: posts
---
## 问题
openstack 默认的磁盘大小只有 10G， 如何挂载一个 volume 来扩展存储空间呢？

## 干货

    create and attach volume

    check:

        fdisk -l

    create partition(s):

        fdisk /dev/vdb

    n to create new partition
    p to create primary partition
    w to write changes
    q to quit

    You will get only 1 primary partition /dev/vdb1 in disk /dev/vdb

    format partition to ext4:

        mkfs.ext4 /dev/vdb1

    mount partition to dir:

        mkdir /data
        mount -t ext4 /dev/vdb1 /data


## 详情

### Attach

在 openstack 创建一个 volume(相当于物理机上的 hard drive disk) 并 attach 到 instance 很容易，不赘述.
(disk 和 volume 是一回事.)

查看已有磁盘列表方法:

    > fdisk -l
    Disk /dev/vda: 10 GiB, 10737418240 bytes, 20971520 sectors
    Units: sectors of 1 * 512 = 512 bytes
    Sector size (logical/physical): 512 bytes / 512 bytes
    I/O size (minimum/optimal): 512 bytes / 512 bytes
    Disklabel type: dos
    Disk identifier: 0x7dabc05a

    Device     Boot Start      End  Sectors Size Id Type
    /dev/vda1  *     2048 20971486 20969439  10G 83 Linux


    Disk /dev/vdb: 30 GiB, 32212254720 bytes, 62914560 sectors
    Units: sectors of 1 * 512 = 512 bytes
    Sector size (logical/physical): 512 bytes / 512 bytes
    I/O size (minimum/optimal): 512 bytes / 512 bytes


你可以看到，我们 attach 的 volume vdb 已经从出现在列表中，显示为一个 disk.

不过，并不是这样你就可以使用这个 disk 存储数据了. 相当于你连接了一块新硬盘
到你的电脑上, 硬件也能检测到. 但是操作系统(软件层面)还没有配置好.

在正式使用前, 你还需要对这个新的 disk 进行分区, 格式化和挂载.

### Partition

分区:

    > fdisk /dev/vdb

    Welcome to fdisk (util-linux 2.27.1).
    Changes will remain in memory only, until you decide to write them.
    Be careful before using the write command.

    Device does not contain a recognized partition table.
    Created a new DOS disklabel with disk identifier 0x3445993c.

    Command (m for help): m

注意此时你已经进入了 fdisk 的命令交互模式.
你所有的操作都是在内存中，相当于草稿, 并没有真的提交执行.
只有输入 w 才会真的写入。

fdisk 提示说设备没有可识别的分区表. 根据提示输入 m 查看帮助:


    Command (m for help): m
    Help:

      DOS (MBR)
       a   toggle a bootable flag
       b   edit nested BSD disklabel
       c   toggle the dos compatibility flag

      Generic
       d   delete a partition
       F   list free unpartitioned space
       l   list known partition types
       n   add a new partition
       p   print the partition table
       t   change a partition type
       v   verify the partition table
       i   print information about a partition

      Misc
       m   print this menu
       u   change display/entry units
       x   extra functionality (experts only)

      Script
       I   load disk layout from sfdisk script file
       O   dump disk layout to sfdisk script file

      Save & Exit
       w   write table to disk and exit
       q   quit without saving changes

      Create a new label
       g   create a new empty GPT partition table
       G   create a new empty SGI (IRIX) partition table
       o   create a new empty DOS partition table
       s   create a new empty Sun partition table

输入 n 新建分区, 然而又出现新的提示：

    Command (m for help): n
    Partition type
       p   primary (0 primary, 0 extended, 4 free)
       e   extended (container for logical partitions)
    Select (default p):

问题来了: 我只是存储数据, 应该选哪一个呢?

### Extended and Logical Partitions

一个 disk 可以分割为多个 partition.

这样设计的作用很多.
比如: 你可以在同一块 disk 上安装多个操作系统且互不干扰.
又比如: Linux 上的 swap 文件放在单独分区可以提供性能.
等等.

根据最开始的设计，一个 disk 最多包含4个 partition.
这显然不够用，于是扩展分区(Extended Partition)的概念被发明出来.
原来的不可分割分区现在被称为 Primary Partition.
如果你需要更多 partition, 可以创建最多1个 Extended Partition.
它可以进一步被分割为逻辑分区(Logical Partition).

对于我们的情况，一个分区就够了. 选择默认的 p. 再次查看:

    > fdisk -l /dev/vdb
    Disk /dev/vdb: 30 GiB, 32212254720 bytes, 62914560 sectors
    Units: sectors of 1 * 512 = 512 bytes
    Sector size (logical/physical): 512 bytes / 512 bytes
    I/O size (minimum/optimal): 512 bytes / 512 bytes
    Disklabel type: dos
    Disk identifier: 0x89043b88

    Device     Boot Start      End  Sectors Size Id Type
    /dev/vdb1        2048 62914559 62912512  30G 83 Linux


### Mount

    mount -t ext4 /dev/vdb1 /data

不知道何故，我必须挂载 /dev/vdb1 这个 partition, 不能挂载 /dev/vdb 这个 disk.
但 `man mount` 说明了两者都可以.

获取 type 列表的两种方法:

    mount
    cat /proc/filesystems

另外，openstack 里一个 volume 只能被挂载到一个 instance.
