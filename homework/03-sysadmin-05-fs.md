1. Узнайте о sparse (разряженных) файлах.

    **Ответ:**

    ***sparse -Разрежённый файл (англ. sparse file) — файл, в котором последовательности нулевых байтов[1] заменены на информацию об этих последовательностях (список дыр).***
    
    ***Разрежённые файлы используются для хранения контейнеров, например:***
    
    ***- образов дисков виртуальных машин;***

    ***- резервных копий дисков и/или разделов, созданных спец. ПО.***
    
2. Могут ли файлы, являющиеся жесткой ссылкой на один объект, иметь разные права доступа и владельца? Почему?
   
   **Ответ:**
   ***Нет, не могут, т.к. создавая жесткую ссылку на файл, мы привязываемся к его индексному номеру, получая тот же самый файл (с новым именем), на который указывает ссылка, но без физического создании копии. Чтобы сменить права и владельца требуется это сделать для самого объекта, тогда и сменятся права и у файла жесткой ссылки***

3. Сделайте vagrant destroy на имеющийся инстанс Ubuntu. Замените содержимое Vagrantfile следующим:
   
   **Ответ:**
   <details><summary>Вывод:</summary>
        ```
        root@vagrant:~# fdisk -l
        Disk /dev/sda: 64 GiB, 68719476736 bytes, 134217728 sectors
        Disk model: VBOX HARDDISK
        Units: sectors of 1 * 512 = 512 bytes
        Sector size (logical/physical): 512 bytes / 512 bytes
        I/O size (minimum/optimal): 512 bytes / 512 bytes
        Disklabel type: dos
        Disk identifier: 0x3f94c461
        
        Device     Boot   Start       End   Sectors  Size Id Type
        /dev/sda1  *       2048   1050623   1048576  512M  b W95 FAT32
        /dev/sda2       1052670 134215679 133163010 63.5G  5 Extended
        /dev/sda5       1052672 134215679 133163008 63.5G 8e Linux LVM
        ```
        
        Disk /dev/sdb: 2.51 GiB, 2684354560 bytes, 5242880 sectors
        Disk model: VBOX HARDDISK
        Units: sectors of 1 * 512 = 512 bytes
        Sector size (logical/physical): 512 bytes / 512 bytes
        I/O size (minimum/optimal): 512 bytes / 512 bytes
        ```

        Disk /dev/sdc: 2.51 GiB, 2684354560 bytes, 5242880 sectors
        Disk model: VBOX HARDDISK
        Units: sectors of 1 * 512 = 512 bytes
        Sector size (logical/physical): 512 bytes / 512 bytes
        I/O size (minimum/optimal): 512 bytes / 512 bytes
        ```
    </details>
   
4. Используя fdisk, разбейте первый диск на 2 раздела: 2 Гб, оставшееся пространство.
   **Ответ:**
   ```
    Device     Boot   Start     End Sectors  Size Id Type
    /dev/sdb1          2048 4196351 4194304    2G 83 Linux
    /dev/sdb2       4196352 5220351 1024000  500M 83 Linux
   ```
5. Используя sfdisk, перенесите данную таблицу разделов на второй диск.

    **Ответ:**
    <details><summary>Вывод</summary>
        root@vagrant:~# sfdisk -d /dev/sdb | sfdisk -f /dev/sdc
        Checking that no-one is using this disk right now ... OK
        
        Disk /dev/sdc: 2.51 GiB, 2684354560 bytes, 5242880 sectors
        Disk model: VBOX HARDDISK
        Units: sectors of 1 * 512 = 512 bytes
        Sector size (logical/physical): 512 bytes / 512 bytes
        I/O size (minimum/optimal): 512 bytes / 512 bytes
        ```
        >>> Script header accepted.
        >>> Script header accepted.
        >>> Script header accepted.
        >>> Script header accepted.
        >>> Created a new DOS disklabel with disk identifier 0x8dfe0d85.
        ```
        /dev/sdc1: Created a new partition 1 of type 'Linux' and of size 2 GiB.
        /dev/sdc2: Created a new partition 2 of type 'Linux' and of size 500 MiB.
        /dev/sdc3: Done.

        New situation:
        Disklabel type: dos
        Disk identifier: 0x8dfe0d85

        Device     Boot   Start     End Sectors  Size Id Type
        /dev/sdc1          2048 4196351 4194304    2G 83 Linux
        /dev/sdc2       4196352 5220351 1024000  500M 83 Linux

        The partition table has been altered.
        Calling ioctl() to re-read partition table.
        Syncing disks.

        Disk /dev/sdb: 2.51 GiB, 2684354560 bytes, 5242880 sectors
        Disk model: VBOX HARDDISK
        Units: sectors of 1 * 512 = 512 bytes
        Sector size (logical/physical): 512 bytes / 512 bytes
        I/O size (minimum/optimal): 512 bytes / 512 bytes
        Disklabel type: dos
        Disk identifier: 0x8dfe0d85

        Device     Boot   Start     End Sectors  Size Id Type
        /dev/sdb1          2048 4196351 4194304    2G 83 Linux
        /dev/sdb2       4196352 5220351 1024000  500M 83 Linux


        Disk /dev/sdc: 2.51 GiB, 2684354560 bytes, 5242880 sectors
        Disk model: VBOX HARDDISK
        Units: sectors of 1 * 512 = 512 bytes
        Sector size (logical/physical): 512 bytes / 512 bytes
        I/O size (minimum/optimal): 512 bytes / 512 bytes
        Disklabel type: dos
        Disk identifier: 0x8dfe0d85
        
        Device     Boot   Start     End Sectors  Size Id Type
        /dev/sdc1          2048 4196351 4194304    2G 83 Linux
        /dev/sdc2       4196352 5220351 1024000  500M 83 Linux
        
    </details>

6. Соберите mdadm RAID1 на паре разделов 2 Гб.  
   **Ответ:**
   ```
   root@vagrant:~# mdadm --create --verbose /dev/md0 --level=1  --raid-devices=3 /dev/sdb1 /dev/hdf2 /dev/sdc1
    mdadm: Note: this array has metadata at the start and
    may not be suitable as a boot device.  If you plan to
    store '/boot' on this device please ensure that
    your boot-loader understands md/v1.x metadata, or use
    --metadata=0.90
    mdadm: cannot open /dev/hdf2: No such file or directory
    root@vagrant:~# mdadm --create --verbose /dev/md0 --level=1  --raid-devices=2 /dev/sdb1 /dev/sdc1
    mdadm: Note: this array has metadata at the start and
    may not be suitable as a boot device.  If you plan to
    store '/boot' on this device please ensure that
    your boot-loader understands md/v1.x metadata, or use
    --metadata=0.90
    mdadm: size set to 2094080K
    ontinue creating array? y
    mdadm: Defaulting to version 1.2 metadata
    mdadm: array /dev/md0 started.
    root@vagrant:~# cat /proc/mdstat
    Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] [raid4] [raid10]
    md0 : active raid1 sdc1[1] sdb1[0]
      2094080 blocks super 1.2 [2/2] [UU]
    unused devices: <none>
     ```
7.  Соберите mdadm RAID0 на второй паре маленьких разделов.
    **Ответ:**
    ```
    root@vagrant:~# mdadm --create --verbose /dev/md1 --level=0  --raid-devices=2 /dev/sdb2 /dev/sdc2
    mdadm: chunk size defaults to 512K
    mdadm: Defaulting to version 1.2 metadata
    mdadm: array /dev/md1 started.
    root@vagrant:~# cat /proc/mdstat
    Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] [raid4] [raid10]
    md1 : active raid0 sdc2[1] sdb2[0]
      1019904 blocks super 1.2 512k chunks
      ```
8. Создайте 2 независимых PV на получившихся md-устройствах.
    **Ответ:**
    ```
    root@vagrant:~# pvcreate data /dev/md1
    Device data not found.
    Physical volume "/dev/md1" successfully created.
    root@vagrant:~# pvcreate data /dev/md0
    Device data not found.
    Physical volume "/dev/md0" successfully created.
    root@vagrant:~# psv
    -bash: psv: command not found
    root@vagrant:~# pvs
    PV         VG        Fmt  Attr PSize   PFree
    /dev/md0             lvm2 ---   <2.00g  <2.00g
    /dev/md1             lvm2 ---  996.00m 996.00m
    /dev/sda5  vgvagrant lvm2 a--  <63.50g      0
    ```
9. Создайте общую volume-group на этих двух PV.
    **Ответ:**
    ```
    root@vagrant:~# vgcreate data /dev/md1 /dev/md0
    Volume group "data" successfully created
    ```
    <details><summary>Вывод vgroups</summary>

        --- Volume group ---
        VG Name               vgvagrant
        System ID
        Format                lvm2
        Metadata Areas        1
        Metadata Sequence No  3
        VG Access             read/write
        VG Status             resizable
        MAX LV                0
        Cur LV                2
        Open LV               2
        Max PV                0
        Cur PV                1
        Act PV                1
        VG Size               <63.50 GiB
        PE Size               4.00 MiB
        Total PE              16255
        Alloc PE / Size       16255 / <63.50 GiB
        Free  PE / Size       0 / 0
        VG UUID               PaBfZ0-3I0c-iIdl-uXKt-JL4K-f4tT-kzfcyE

        --- Volume group ---
        VG Name               data
        System ID
        Format                lvm2
        Metadata Areas        2
        Metadata Sequence No  1
        VG Access             read/write
        VG Status             resizable
        MAX LV                0
        Cur LV                0
        Open LV               0
        Max PV                0
        Cur PV                2
        Act PV                2
        VG Size               2.96 GiB
        PE Size               4.00 MiB
        Total PE              759
        Alloc PE / Size       0 / 0
        Free  PE / Size       759 / 2.96 GiB
        VG UUID               QhNmAi-IHc0-LWEc-WKxU-gUZI-bHxo-v0WgZM
    </details>
10. Создайте LV размером 100 Мб, указав его расположение на PV с RAID0.
    **Ответ:**
    ```
    root@vagrant:~# lvcreate -L 100M data /dev/md1
    Logical volume "lvol0" created.
    ```
11. Создайте mkfs.ext4 ФС на получившемся LV.
    **Ответ:**
    ```
    root@vagrant:~# mkfs.ext4 /dev/mapper/data-lvol0
    mke2fs 1.45.5 (07-Jan-2020)
    Creating filesystem with 25600 4k blocks and 25600 inodes

    Allocating group tables: done
    Writing inode tables: done
    Creating journal (1024 blocks): done
    Writing superblocks and filesystem accounting information: done
    ```
12. Смонтируйте этот раздел в любую директорию, например, /tmp/new.
    **Ответ:**
    ```
    root@vagrant:~# mount /dev/mapper/data-lvol0 /tmp/new
    ```

13. Поместите туда тестовый файл, например wget https://mirror.yandex.ru/ubuntu/ls-lR.gz -O /tmp/new/test.gz
    **Ответ:**
    ```
    wget https://mirror.yandex.ru/ubuntu/ls-lR.gz -O /tmp/new/test.gz /tmp/new
    ```
14. Прикрепите вывод lsblk.
    **Ответ:**
    ```
    root@vagrant:~# lsblk
    NAME                 MAJ:MIN RM  SIZE RO TYPE  MOUNTPOINT
    sda                    8:0    0   64G  0 disk
    ├─sda1                 8:1    0  512M  0 part  /boot/efi
    ├─sda2                 8:2    0    1K  0 part
    └─sda5                 8:5    0 63.5G  0 part
    ├─vgvagrant-root   253:0    0 62.6G  0 lvm   /
    └─vgvagrant-swap_1 253:1    0  980M  0 lvm   [SWAP]
    sdb                    8:16   0  2.5G  0 disk
    ├─sdb1                 8:17   0    2G  0 part
    │ └─md0                9:0    0    2G  0 raid1
    └─sdb2                 8:18   0  500M  0 part
    └─md1                9:1    0  996M  0 raid0
        └─data-lvol0     253:2    0  100M  0 lvm   /tmp/new
    sdc                    8:32   0  2.5G  0 disk
    ├─sdc1                 8:33   0    2G  0 part
    │ └─md0                9:0    0    2G  0 raid1
    └─sdc2                 8:34   0  500M  0 part
    └─md1                9:1    0  996M  0 raid0
        └─data-lvol0     253:2    0  100M  0 lvm   /tmp/new
    ```
15. Протестируйте целостность файла:
    **Ответ:**
    ```
    root@vagrant:~# gzip -t /tmp/new/test.gz
    root@vagrant:~# echo $?
    0
    ```
16. Используя pvmove, переместите содержимое PV с RAID0 на RAID1.
    **Ответ:**
    ```
    root@vagrant:~# pvmove /dev/md1 /dev/md0
    /dev/md1: Moved: 20.00%
    /dev/md1: Moved: 100.00%
    ```
17. Сделайте --fail на устройство в вашем RAID1 md.
    **Ответ:**
    ```
    root@vagrant:~# mdadm /dev/md0 --fail /dev/sdb1
    mdadm: set /dev/sdb1 faulty in /dev/md0
    ```
18. Подтвердите выводом dmesg, что RAID1 работает в деградированном состоянии.

    **Ответ:**
    ```
    root@vagrant:~# dmesg |grep md1
    [14271.993660] md1: detected capacity change from 0 to 1044381696
    root@vagrant:~# dmesg |grep md0
    [14100.711916] md/raid1:md0: not clean -- starting background reconstruction
    [14100.711918] md/raid1:md0: active with 2 out of 2 mirrors
    [14100.711943] md0: detected capacity change from 0 to 2144337920
    [14100.712549] md: resync of RAID array md0
    [14111.122962] md: md0: resync done.
    [24862.627709] md/raid1:md0: Disk failure on sdb1, disabling device.
                md/raid1:md0: Operation continuing on 1 devices.
    ```
19. Протестируйте целостность файла, несмотря на "сбойный" диск он должен продолжать быть доступен:
     **Ответ:**
    ```
    root@vagrant:~# gzip -t /tmp/new/test.gz
    root@vagrant:~# echo $?
    0
    ```