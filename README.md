# Домашнее задание к занятию "3.5. Файловые системы"

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


    Disk /dev/sdb: 2.51 GiB, 2684354560 bytes, 5242880 sectors
    Disk model: VBOX HARDDISK
    Units: sectors of 1 * 512 = 512 bytes
    Sector size (logical/physical): 512 bytes / 512 bytes
    I/O size (minimum/optimal): 512 bytes / 512 bytes


    Disk /dev/sdc: 2.51 GiB, 2684354560 bytes, 5242880 sectors
    Disk model: VBOX HARDDISK
    Units: sectors of 1 * 512 = 512 bytes
    Sector size (logical/physical): 512 bytes / 512 bytes
    I/O size (minimum/optimal): 512 bytes / 512 bytes
    </details>
   
4. Используя fdisk, разбейте первый диск на 2 раздела: 2 Гб, оставшееся пространство.
   **Ответ:**
   ```
    Device     Boot   Start     End Sectors  Size Id Type
    /dev/sdb1          2048 4196351 4194304    2G 83 Linux
    /dev/sdb2       4196352 5220351 1024000  500M 83 Linux
   ```
5. Используя sfdisk, перенесите данную таблицу разделов на второй диск.










# Домашнее задание к занятию "3.4. Операционные системы, лекция 2"

1. На лекции мы познакомились с node_exporter. В демонстрации его исполняемый файл запускался в background. Этого достаточно для демо, но не для настоящей production-системы, где процессы должны находиться под внешним управлением. Используя знания из лекции по systemd, создайте самостоятельно простой unit-файл для node_exporter:

    * поместите его в автозагрузку,
    * предусмотрите возможность добавления опций к запускаемому процессу через внешний файл (посмотрите, например, на `systemctl cat cron`),
    * удостоверьтесь, что с помощью systemctl процесс корректно стартует, завершается, а после перезагрузки автоматически поднимается.
  
    **Ответ:**
    ```
    Unit-файл:
    vagrant@vagrant:~$ cat /etc/systemd/system/node_exporter.service
    [Unit]
    Description=Prometheus Node Exporter
    Wants=network-online.target
    After=network-online.target

    [Service]
    Type=simple
    Restart=always
    User=node_exporter
    Group=node_exporter
    ExecStart=/usr/local/bin/node_exporter


    [Install]
    WantedBy=multi-user.target
    В автозагрузку добавил через systemctl enable node_exporter

    Чтобы допустить возможность запускать сервис с доп.опциями требуется добавить в unit файл, секция [Service] следующее:

    EnvironmentFile=/etc/sysconfig/node_exporter
    ExecStart=/usr/sbin/node_exporter $OPTIONS


    ```
    ```
    root@vagrant:~/node_exporter-1.3.1.linux-amd64# systemctl status node_exporter
	● node_exporter.service - Prometheus Node Exporter
     Loaded: loaded (/etc/systemd/system/node_exporter.service; enabled; vendor preset: enabled)
     Active: active (running) since Tue 2022-01-25 09:09:51 UTC; 14s ago
     Main PID: 22084 (node_exporter)
     Tasks: 4 (limit: 1071)
     Memory: 2.4M
     CGroup: /system.slice/node_exporter.service
             └─22084 /usr/local/bin/node_exporter

	Jan 25 09:09:51 vagrant node_exporter[22084]: ts=2022-01-25T09:09:51.911Z caller=node_exporter.go:115 level=info collector=thermal_zone
	Jan 25 09:09:51 vagrant node_exporter[22084]: ts=2022-01-25T09:09:51.911Z caller=node_exporter.go:115 level=info collector=time
	Jan 25 09:09:51 vagrant node_exporter[22084]: ts=2022-01-25T09:09:51.911Z caller=node_exporter.go:115 level=info collector=timex
	Jan 25 09:09:51 vagrant node_exporter[22084]: ts=2022-01-25T09:09:51.911Z caller=node_exporter.go:115 level=info collector=udp_queues
	Jan 25 09:09:51 vagrant node_exporter[22084]: ts=2022-01-25T09:09:51.911Z caller=node_exporter.go:115 level=info collector=uname
	Jan 25 09:09:51 vagrant node_exporter[22084]: ts=2022-01-25T09:09:51.911Z caller=node_exporter.go:115 level=info collector=vmstat
	Jan 25 09:09:51 vagrant node_exporter[22084]: ts=2022-01-25T09:09:51.911Z caller=node_exporter.go:115 level=info collector=xfs
	Jan 25 09:09:51 vagrant node_exporter[22084]: ts=2022-01-25T09:09:51.911Z caller=node_exporter.go:115 level=info collector=zfs
	Jan 25 09:09:51 vagrant node_exporter[22084]: ts=2022-01-25T09:09:51.911Z caller=node_exporter.go:199 level=info msg="Listening on" address=:9100
	Jan 25 09:09:51 vagrant node_exporter[22084]: ts=2022-01-25T09:09:51.911Z caller=tls_config.go:195 level=info msg="TLS is disabled." http2=false
	
	root@vagrant:~/node_exporter-1.3.1.linux-amd64# systemctl stop node_exporter
	root@vagrant:~/node_exporter-1.3.1.linux-amd64# systemctl status node_exporter
	● node_exporter.service - Prometheus Node Exporter
     Loaded: loaded (/etc/systemd/system/node_exporter.service; enabled; vendor preset: enabled)
     Active: inactive (dead) since Tue 2022-01-25 09:12:33 UTC; 4s ago
    Process: 22084 ExecStart=/usr/local/bin/node_exporter (code=killed, signal=TERM)
    Main PID: 22084 (code=killed, signal=TERM)

	Jan 25 09:09:51 vagrant node_exporter[22084]: ts=2022-01-25T09:09:51.911Z caller=node_exporter.go:115 level=info collector=udp_queues
	Jan 25 09:09:51 vagrant node_exporter[22084]: ts=2022-01-25T09:09:51.911Z caller=node_exporter.go:115 level=info collector=uname
	Jan 25 09:09:51 vagrant node_exporter[22084]: ts=2022-01-25T09:09:51.911Z caller=node_exporter.go:115 level=info collector=vmstat
	Jan 25 09:09:51 vagrant node_exporter[22084]: ts=2022-01-25T09:09:51.911Z caller=node_exporter.go:115 level=info collector=xfs
	Jan 25 09:09:51 vagrant node_exporter[22084]: ts=2022-01-25T09:09:51.911Z caller=node_exporter.go:115 level=info collector=zfs
	Jan 25 09:09:51 vagrant node_exporter[22084]: ts=2022-01-25T09:09:51.911Z caller=node_exporter.go:199 level=info msg="Listening on" address=:9100
	Jan 25 09:09:51 vagrant node_exporter[22084]: ts=2022-01-25T09:09:51.911Z caller=tls_config.go:195 level=info msg="TLS is disabled." http2=false
	Jan 25 09:12:33 vagrant systemd[1]: Stopping Prometheus Node Exporter...
	Jan 25 09:12:33 vagrant systemd[1]: node_exporter.service: Succeeded.
	Jan 25 09:12:33 vagrant systemd[1]: Stopped Prometheus Node Exporter.
	
	root@vagrant:~/node_exporter-1.3.1.linux-amd64# systemctl start node_exporter.service
	root@vagrant:~/node_exporter-1.3.1.linux-amd64# systemctl status node_exporter
	● node_exporter.service - Prometheus Node Exporter
     	Loaded: loaded (/etc/systemd/system/node_exporter.service; enabled; vendor preset: enabled)
     	Active: active (running) since Tue 2022-01-25 09:13:37 UTC; 3s ago
  	 Main PID: 22147 (node_exporter)
     	 Tasks: 4 (limit: 1071)
     	Memory: 2.4M
     	CGroup: /system.slice/node_exporter.service
             └─22147 /usr/local/bin/node_exporter
	
	
2. Ознакомьтесь с опциями node_exporter и выводом /metrics по-умолчанию. Приведите несколько опций, которые вы бы выбрали для базового мониторинга хоста по CPU, памяти, диску и сети.
   
   **Ответ:**
   
   ```  curl http://localhost:9100/metrics | grep "cpu_" ```
   
   <details> 
		<summary>Вывод:</summary>
		  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
					 Dload  Upload   Total   Spent    Left  Speed
		  0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0# HELP go_memstats_gc_cpu_fraction The fraction of this program's available CPU 			time used 	by the GC since the program started.
		# TYPE go_memstats_gc_cpu_fraction gauge
		go_memstats_gc_cpu_fraction 4.149665287238637e-06
		# HELP node_cpu_guest_seconds_total Seconds the CPUs spent in guests (VMs) for each mode.
		# TYPE node_cpu_guest_seconds_total counter
		node_cpu_guest_seconds_total{cpu="0",mode="nice"} 0
		node_cpu_guest_seconds_total{cpu="0",mode="user"} 0
		node_cpu_guest_seconds_total{cpu="1",mode="nice"} 0
		node_cpu_guest_seconds_total{cpu="1",mode="user"} 0
		# HELP node_cpu_seconds_total Seconds the CPUs spent in each mode.
		# TYPE node_cpu_seconds_total counter
		node_cpu_seconds_total{cpu="0",mode="idle"} 23925
		node_cpu_seconds_total{cpu="0",mode="iowait"} 2.27
		node_cpu_seconds_total{cpu="0",mode="irq"} 0
		node_cpu_seconds_total{cpu="0",mode="nice"} 0.01
		node_cpu_seconds_total{cpu="0",mode="softirq"} 0.74
		node_cpu_seconds_total{cpu="0",mode="steal"} 0
		node_cpu_seconds_total{cpu="0",mode="system"} 46.96
		node_cpu_seconds_total{cpu="0",mode="user"} 34.35
		node_cpu_seconds_total{cpu="1",mode="idle"} 23904.57
		node_cpu_seconds_total{cpu="1",mode="iowait"} 2.18
		node_cpu_seconds_total{cpu="1",mode="irq"} 0
		node_cpu_seconds_total{cpu="1",mode="nice"} 0
		node_cpu_seconds_total{cpu="1",mode="softirq"} 1.63
		node_cpu_seconds_total{cpu="1",mode="steal"} 0
		node_cpu_seconds_total{cpu="1",mode="system"} 48.48
		node_cpu_seconds_total{cpu="1",mode="user"} 32.54
		# HELP node_memory_Percpu_bytes Memory information field Percpu_bytes.
		# TYPE node_memory_Percpu_bytes gauge
		node_memory_Percpu_bytes 1.531904e+06
		# HELP node_pressure_cpu_waiting_seconds_total Total time in seconds that processes have waited for CPU time
		# TYPE node_pressure_cpu_waiting_seconds_total counter
		node_pressure_cpu_waiting_seconds_total 48.724306
		1# HELP process_cpu_seconds_total Total user and system CPU time spent in seconds.
		# TYPE process_cpu_seconds_total counter
		process_cpu_seconds_total 0.06
		00 61447    0 61447    0     0  7500k      0 --:--:-- --:--:-- --:--:-- 7500k
		
	</details>
   	
   	```curl http://localhost:9100/metrics | grep "memory_"```
	<details> 
		<summary>Вывод:</summary>
		  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
		  0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0# HELP node_memory_Active_anon_bytes Memory information field Active_anon_bytes.
		# TYPE node_memory_Active_anon_bytes gauge
		node_memory_Active_anon_bytes 1.17628928e+08
		# HELP node_memory_Active_bytes Memory information field Active_bytes.
		# TYPE node_memory_Active_bytes gauge
		node_memory_Active_bytes 1.7977344e+08
		# HELP node_memory_Active_file_bytes Memory information field Active_file_bytes.
		# TYPE node_memory_Active_file_bytes gauge
		node_memory_Active_file_bytes 6.2144512e+07
		# HELP node_memory_AnonHugePages_bytes Memory information field AnonHugePages_bytes.
		# TYPE node_memory_AnonHugePages_bytes gauge
		node_memory_AnonHugePages_bytes 0
		# HELP node_memory_AnonPages_bytes Memory information field AnonPages_bytes.
		# TYPE node_memory_AnonPages_bytes gauge
		node_memory_AnonPages_bytes 2.13389312e+08
		# HELP node_memory_Bounce_bytes Memory information field Bounce_bytes.
		# TYPE node_memory_Bounce_bytes gauge
		node_memory_Bounce_bytes 0
		# HELP node_memory_Buffers_bytes Memory information field Buffers_bytes.
		# TYPE node_memory_Buffers_bytes gauge
		node_memory_Buffers_bytes 1.3258752e+07
		# HELP node_memory_Cached_bytes Memory information field Cached_bytes.
		# TYPE node_memory_Cached_bytes gauge
		node_memory_Cached_bytes 1.25681664e+08
		# HELP node_memory_CmaFree_bytes Memory information field CmaFree_bytes.
		# TYPE node_memory_CmaFree_bytes gauge
		node_memory_CmaFree_bytes 0
		# HELP node_memory_CmaTotal_bytes Memory information field CmaTotal_bytes.
		# TYPE node_memory_CmaTotal_bytes gauge
		node_memory_CmaTotal_bytes 0
		# HELP node_memory_CommitLimit_bytes Memory information field CommitLimit_bytes.
		# TYPE node_memory_CommitLimit_bytes gauge
		node_memory_CommitLimit_bytes 1.541947392e+09
		# HELP node_memory_Committed_AS_bytes Memory information field Committed_AS_bytes.
		# TYPE node_memory_Committed_AS_bytes gauge
		node_memory_Committed_AS_bytes 7.26880256e+08
		# HELP node_memory_DirectMap2M_bytes Memory information field DirectMap2M_bytes.
		# TYPE node_memory_DirectMap2M_bytes gauge
		node_memory_DirectMap2M_bytes 9.60495616e+08
		# HELP node_memory_DirectMap4k_bytes Memory information field DirectMap4k_bytes.
		# TYPE node_memory_DirectMap4k_bytes gauge
		node_memory_DirectMap4k_bytes 1.13180672e+08
		# HELP node_memory_Dirty_bytes Memory information field Dirty_bytes.
		# TYPE node_memory_Dirty_bytes gauge
		node_memory_Dirty_bytes 20480
		# HELP node_memory_FileHugePages_bytes Memory information field FileHugePages_bytes.
		# TYPE node_memory_FileHugePages_bytes gauge
		node_memory_FileHugePages_bytes 0
		# HELP node_memory_FilePmdMapped_bytes Memory information field FilePmdMapped_bytes.
		# TYPE node_memory_FilePmdMapped_bytes gauge
		node_memory_FilePmdMapped_bytes 0
		# HELP node_memory_HardwareCorrupted_bytes Memory information field HardwareCorrupted_bytes.
		# TYPE node_memory_HardwareCorrupted_bytes gauge
		node_memory_HardwareCorrupted_bytes 0
		# HELP node_memory_HugePages_Free Memory information field HugePages_Free.
		# TYPE node_memory_HugePages_Free gauge
		node_memory_HugePages_Free 0
		# HELP node_memory_HugePages_Rsvd Memory information field HugePages_Rsvd.
		# TYPE node_memory_HugePages_Rsvd gauge
		node_memory_HugePages_Rsvd 0
		# HELP node_memory_HugePages_Surp Memory information field HugePages_Surp.
		# TYPE node_memory_HugePages_Surp gauge
		node_memory_HugePages_Surp 0
		# HELP node_memory_HugePages_Total Memory information field HugePages_Total.
		# TYPE node_memory_HugePages_Total gauge
		node_memory_HugePages_Total 0
		# HELP node_memory_Hugepagesize_bytes Memory information field Hugepagesize_bytes.
		# TYPE node_memory_Hugepagesize_bytes gauge
		node_memory_Hugepagesize_bytes 2.097152e+06
		# HELP node_memory_Hugetlb_bytes Memory information field Hugetlb_bytes.
		# TYPE node_memory_Hugetlb_bytes gauge
		node_memory_Hugetlb_bytes 0
		# HELP node_memory_Inactive_anon_bytes Memory information field Inactive_anon_bytes.
		# TYPE node_memory_Inactive_anon_bytes gauge
		node_memory_Inactive_anon_bytes 9.1119616e+07
		# HELP node_memory_Inactive_bytes Memory information field Inactive_bytes.
		# TYPE node_memory_Inactive_bytes gauge
		node_memory_Inactive_bytes 1.59219712e+08
		# HELP node_memory_Inactive_file_bytes Memory information field Inactive_file_bytes.
		# TYPE node_memory_Inactive_file_bytes gauge
		node_memory_Inactive_file_bytes 6.8100096e+07
		# HELP node_memory_KReclaimable_bytes Memory information field KReclaimable_bytes.
		# TYPE node_memory_KReclaimable_bytes gauge
		node_memory_KReclaimable_bytes 3.0961664e+07
		# HELP node_memory_KernelStack_bytes Memory information field KernelStack_bytes.
		# TYPE node_memory_KernelStack_bytes gauge
		node_memory_KernelStack_bytes 2.658304e+06
		# HELP node_memory_Mapped_bytes Memory information field Mapped_bytes.
		# TYPE node_memory_Mapped_bytes gauge
		node_memory_Mapped_bytes 4.9934336e+07
		# HELP node_memory_MemAvailable_bytes Memory information field MemAvailable_bytes.
		# TYPE node_memory_MemAvailable_bytes gauge
		node_memory_MemAvailable_bytes 5.8462208e+08
		# HELP node_memory_MemFree_bytes Memory information field MemFree_bytes.
		# TYPE node_memory_MemFree_bytes gauge
		node_memory_MemFree_bytes 5.69344e+08
		# HELP node_memory_MemTotal_bytes Memory information field MemTotal_bytes.
		# TYPE node_memory_MemTotal_bytes gauge
		node_memory_MemTotal_bytes 1.028694016e+09
		# HELP node_memory_Mlocked_bytes Memory information field Mlocked_bytes.
		# TYPE node_memory_Mlocked_bytes gauge
		node_memory_Mlocked_bytes 1.8972672e+07
		# HELP node_memory_NFS_Unstable_bytes Memory information field NFS_Unstable_bytes.
		# TYPE node_memory_NFS_Unstable_bytes gauge
		node_memory_NFS_Unstable_bytes 0
		# HELP node_memory_PageTables_bytes Memory information field PageTables_bytes.
		# TYPE node_memory_PageTables_bytes gauge
		node_memory_PageTables_bytes 2.564096e+06
		# HELP node_memory_Percpu_bytes Memory information field Percpu_bytes.
		# TYPE node_memory_Percpu_bytes gauge
		node_memory_Percpu_bytes 1.531904e+06
		# HELP node_memory_SReclaimable_bytes Memory information field SReclaimable_bytes.
		# TYPE node_memory_SReclaimable_bytes gauge
		node_memory_SReclaimable_bytes 3.0961664e+07
		# HELP node_memory_SUnreclaim_bytes Memory information field SUnreclaim_bytes.
		# TYPE node_memory_SUnreclaim_bytes gauge
		node_memory_SUnreclaim_bytes 4.9250304e+07
		# HELP node_memory_ShmemHugePages_bytes Memory information field ShmemHugePages_bytes.
		# TYPE node_memory_ShmemHugePages_bytes gauge
		node_memory_ShmemHugePages_bytes 0
		# HELP node_memory_ShmemPmdMapped_bytes Memory information field ShmemPmdMapped_bytes.
		# TYPE node_memory_ShmemPmdMapped_bytes gauge
		node_memory_ShmemPmdMapped_bytes 0
		# HELP node_memory_Shmem_bytes Memory information field Shmem_bytes.
		# TYPE node_memory_Shmem_bytes gauge
		node_memory_Shmem_bytes 303104
		# HELP node_memory_Slab_bytes Memory information field Slab_bytes.
		# TYPE node_memory_Slab_bytes gauge
		node_memory_Slab_bytes 8.0211968e+07
		# HELP node_memory_SwapCached_bytes Memory information field SwapCached_bytes.
		# TYPE node_memory_SwapCached_bytes gauge
		node_memory_SwapCached_bytes 7.098368e+06
		# HELP node_memory_SwapFree_bytes Memory information field SwapFree_bytes.
		# TYPE node_memory_SwapFree_bytes gauge
		node_memory_SwapFree_bytes 9.91162368e+08
		# HELP node_memory_SwapTotal_bytes Memory information field SwapTotal_bytes.
		# TYPE node_memory_SwapTotal_bytes gauge
		node_memory_SwapTotal_bytes 1.027600384e+09
		# HELP node_memory_Unevictable_bytes Memory information field Unevictable_bytes.
		# TYPE node_memory_Unevictable_bytes gauge
		node_memory_Unevictable_bytes 1.8972672e+07
		# HELP node_memory_VmallocChunk_bytes Memory information field VmallocChunk_bytes.
		# TYPE node_memory_VmallocChunk_bytes gauge
		node_memory_VmallocChunk_bytes 0
		# HELP node_memory_VmallocTotal_bytes Memory information field VmallocTotal_bytes.
		# TYPE node_memory_VmallocTotal_bytes gauge
		node_memory_VmallocTotal_bytes 3.5184372087808e+13
		# HELP node_memory_VmallocUsed_bytes Memory information field VmallocUsed_bytes.
		# TYPE node_memory_VmallocUsed_bytes gauge
		node_memory_VmallocUsed_bytes 1.0166272e+07
		# HELP node_memory_WritebackTmp_bytes Memory information field WritebackTmp_bytes.
		# TYPE node_memory_WritebackTmp_bytes gauge
		node_memory_WritebackTmp_bytes 0
		# HELP node_memory_Writeback_bytes Memory information field Writeback_bytes.
		# TYPE node_memory_Writeback_bytes gauge
		node_memory_Writeback_bytes 0
		# HELP node_pressure_memory_stalled_seconds_total Total time in seconds no process could make progress due to memory congestion
		# TYPE node_pressure_memory_stalled_seconds_total counter
		node_pressure_memory_stalled_seconds_total 0.434042
		# HELP node_pressure_memory_waiting_seconds_total Total time in seconds that processes have waited for memory
		# TYPE node_pressure_memory_waiting_seconds_total counter
		node_pressure_memory_waiting_seconds_total 2.681051
		100 61430    0 61430    0     0  9998k      0 --:--:-- --:--:-- --:--:-- 9998k
		# HELP process_resident_memory_bytes Resident memory size in bytes.
		# TYPE process_resident_memory_bytes gauge
		process_resident_memory_bytes 1.6248832e+07
		# HELP process_virtual_memory_bytes Virtual memory size in bytes.
		# TYPE process_virtual_memory_bytes gauge
		process_virtual_memory_bytes 7.34851072e+08
		# HELP process_virtual_memory_max_bytes Maximum amount of virtual memory available in bytes.
		# TYPE process_virtual_memory_max_bytes gauge
		process_virtual_memory_max_bytes 1.8446744073709552e+19
	
	</details>
	
	
   	```curl http://localhost:9100/metrics | grep "hdd_"```
	
	<details><summary>Вывод:</summary>
	
 	 % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
	100 61464    0 61464    0     0   9.7M      0 --:--:-- --:--:-- --:--:-- 11.7M
	</details>
      

3. Установите в свою виртуальную машину [Netdata](https://github.com/netdata/netdata). Воспользуйтесь [готовыми пакетами](https://packagecloud.io/netdata/netdata/install) для установки (`sudo apt install -y netdata`). После успешной установки:
    * в конфигурационном файле `/etc/netdata/netdata.conf` в секции [web] замените значение с localhost на `bind to = 0.0.0.0`,
    * добавьте в Vagrantfile проброс порта Netdata на свой локальный компьютер и сделайте `vagrant reload`:

    ```bash
    config.vm.network "forwarded_port", guest: 19999, host: 19999
    ```

    После успешной перезагрузки в браузере *на своем ПК* (не в виртуальной машине) вы должны суметь зайти на `localhost:19999`. Ознакомьтесь с метриками, которые по умолчанию собираются Netdata и с комментариями, которые даны к этим метрикам.

    **Ответ:**
    ***NetData успешно установлен, порт 19999 проброшен на хостовую машину, web-интерфейс NetData по адресу localhost:19999 доступен***

    
    <details><summary>Вывод:</summary>
    
    vagrant@vagrant:~$ sudo lsof -i :19999
    COMMAND PID    USER   FD   TYPE DEVICE SIZE/OFF NODE NAME
    netdata 706 netdata    4u  IPv4  23391      0t0  TCP *:19999 (LISTEN)
    netdata 706 netdata   25u  IPv4  28413      0t0  TCP vagrant:19999->_gateway:64266 (ESTABLISHED)
    netdata 706 netdata   30u  IPv4  29124      0t0  TCP vagrant:19999->_gateway:64267 (ESTABLISHED)
    netdata 706 netdata   50u  IPv4  28415      0t0  TCP vagrant:19999->_gateway:64272 (ESTABLISHED)
    netdata 706 netdata   51u  IPv4  28417      0t0  TCP vagrant:19999->_gateway:64275 (ESTABLISHED)
    netdata 706 netdata   52u  IPv4  28419      0t0  TCP vagrant:19999->_gateway:64276 (ESTABLISHED)
    netdata 706 netdata   53u  IPv4  28420      0t0  TCP vagrant:19999->_gateway:64277 (ESTABLISHED)
    
    <img src="https://cdn1.savepice.ru/uploads/2022/1/23/1aa9ea5f564aca99fb001cfef1b68668-full.png">
    
    </details>
    
    

4. Можно ли по выводу `dmesg` понять, осознает ли ОС, что загружена не на настоящем оборудовании, а на системе виртуализации?
   
   **Ответ:**
   ```
   vagrant@vagrant:~$ dmesg | grep virtual
    [    0.001477] CPU MTRRs all blank - virtualized system.
    [    0.052783] Booting paravirtualized kernel on KVM
    [    0.190823] Performance Events: PMU not available due to virtualization, using software events only.
    [    4.955111] systemd[1]: Detected virtualization oracle.
    
    Исходя из полученной информации, ОС осознает что загружена на системе виртуализации
    ```

5. Как настроен sysctl `fs.nr_open` на системе по-умолчанию? Узнайте, что означает этот параметр. Какой другой существующий лимит не позволит достичь такого числа (`ulimit --help`)?

    **Ответ:**

    ***fs.nr_open - максимальное количество открытых файлов пользователем.
    По умолчанию значение:***
    ```
    vagrant@vagrant:~$ sysctl fs.nr_open
    fs.nr_open = 1048576
    ```
6. Запустите любой долгоживущий процесс (не `ls`, который отработает мгновенно, а, например, `sleep 1h`) в отдельном неймспейсе процессов; покажите, что ваш процесс работает под PID 1 через `nsenter`. Для простоты работайте в данном задании под root (`sudo -i`). Под обычным пользователем требуются дополнительные опции (`--map-root-user`) и т.д.

    **Ответ:**
    ```
    root@vagrant:~# unshare -f --pid --mount-proc sleep 1h
    
    root@vagrant:~/node_exporter-1.3.1.linux-amd64# nsenter --target 22436 --pid --mount
	root@vagrant:/# ps
	Error, do this: mount -t proc proc /proc
	root@vagrant:/# mount -t proc proc /proc
	root@vagrant:/# ps
	    PID TTY          TIME CMD
   	  21 pts/1    00:00:00 bash
   	  33 pts/1    00:00:00 ps
	root@vagrant:/# ps aux
	USER         PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
	root           1  0.0  0.4   9876  4168 pts/0    S    11:32   0:00 /bin/bash
	root           9  0.0  0.0   8076   528 pts/0    T    11:32   0:00 sleep 1h
	root          19  0.0  0.0   8080   592 pts/0    S+   13:20   0:00 unshare -f --pid --mount-proc sleep 1h
	root          20  0.0  0.0   8076   596 pts/0    S+   13:20   0:00 sleep 1h
	root          21  0.0  0.4   9876  4164 pts/1    S    13:22   0:00 -bash
	root          34  0.0  0.3  11492  3388 pts/1    R+   13:22   0:00 ps aux
	```
    
    
    
7. Найдите информацию о том, что такое `:(){ :|:& };:`. Запустите эту команду в своей виртуальной машине Vagrant с Ubuntu 20.04 (**это важно, поведение в других ОС не проверялось**). Некоторое время все будет "плохо", после чего (минуты) – ОС должна стабилизироваться. Вызов `dmesg` расскажет, какой механизм помог автоматической стабилизации. Как настроен этот механизм по-умолчанию, и как изменить число процессов, которое можно создать в сессии?

    **Ответ:**
    ***fork-бомба, функция, которая параллельно запускает два своих экземпляра. Каждый запускает ещё по два и т.д. 
	При отсутствии лимита на число процессов машина быстро исчерпывает физическую память и уходит в своп.***
	
	`[20066.596248] cgroup: fork rejected by pids controller in /user.slice/user-1000.slice/session-9.scope`




# Домашнее задание к занятию "3.3. Операционные системы, лекция 1"

1. Какой системный вызов делает команда `cd`? В прошлом ДЗ мы выяснили, что `cd` не является самостоятельной  программой, это `shell builtin`, поэтому запустить `strace` непосредственно на `cd` не получится. Тем не менее, вы можете запустить `strace` на `/bin/bash -c 'cd /tmp'`. В этом случае вы увидите полный список системных вызовов, которые делает сам `bash` при старте. Вам нужно найти тот единственный, который относится именно к `cd`. Обратите внимание, что `strace` выдаёт результат своей работы в поток stderr, а не в stdout.
   
   **Ответ:**
   ```
   vagrant@vagrant:~$ strace /bin/bash -c 'cd /tmp' 2>&1 | grep cd
   execve("/bin/bash", ["/bin/bash", "-c", "cd /tmp"], 0x7ffe6ed7e780 /* 24 vars */) = 0
   ```

2. Попробуйте использовать команду `file` на объекты разных типов на файловой системе. Например:
    ```bash
    vagrant@netology1:~$ file /dev/tty
    /dev/tty: character special (5/0)
    vagrant@netology1:~$ file /dev/sda
    /dev/sda: block special (8/0)
    vagrant@netology1:~$ file /bin/bash
    /bin/bash: ELF 64-bit LSB shared object, x86-64
    ```
    Используя `strace` выясните, где находится база данных `file` на основании которой она делает свои догадки.

    **Ответ:**
    ***Информацию из man:***
    ```
        The information identifying these files is read from
     /etc/magic and the compiled magic file /usr/share/misc/magic.mgc, or the files in the directory /usr/share/misc/magic if the compiled file does not exist.  In addition, if $HOME/.magic.mgc or $HOME/.magic exists, it will be used in prefer‐
     ence to the system magic files.
    
    
    vagrant@vagrant:~$ vagrant@vagrant:~$ strace file 2>&1 | grep magic
    openat(AT_FDCWD, "/lib/x86_64-linux-gnu/libmagic.so.1", O_RDONLY|O_CLOEXEC) = 3
    stat("/home/vagrant/.magic.mgc", 0x7ffda0c437f0) = -1 ENOENT (No such file or directory)
    stat("/home/vagrant/.magic", 0x7ffda0c437f0) = -1 ENOENT (No such file or directory)
    openat(AT_FDCWD, "/etc/magic.mgc", O_RDONLY) = -1 ENOENT (No such file or directory)
    stat("/etc/magic", {st_mode=S_IFREG|0644, st_size=111, ...}) = 0
    openat(AT_FDCWD, "/etc/magic", O_RDONLY) = 3
    openat(AT_FDCWD, "/usr/share/misc/magic.mgc", O_RDONLY) = 3
            [-m <magicfiles>] [-P <parameter=value>] <file> ...
       file -C [-m <magicfiles>]

       Могу предположить что бд file находится в директории /usr/share/misc/magic.mgc
    ```
3. Предположим, приложение пишет лог в текстовый файл. Этот файл оказался удален (deleted в lsof), однако возможности сигналом сказать приложению переоткрыть файлы или просто перезапустить приложение – нет. Так как приложение продолжает писать в удаленный файл, место на диске постепенно заканчивается. Основываясь на знаниях о перенаправлении потоков предложите способ обнуления открытого удаленного файла (чтобы освободить место на файловой системе).

    **Ответ:**
    ```echo > file1.txt```

4. Занимают ли зомби-процессы какие-то ресурсы в ОС (CPU, RAM, IO)?
   
   **Ответ:**
   
   ***Зомби не занимают памяти, но блокируют записи в таблице процессов, размер которой ограничен для каждого пользователя и системы в целом.***

5. В iovisor BCC есть утилита `opensnoop`:
    ```bash
    root@vagrant:~# dpkg -L bpfcc-tools | grep sbin/opensnoop
    /usr/sbin/opensnoop-bpfcc
    ```
    На какие файлы вы увидели вызовы группы `open` за первую секунду работы утилиты? Воспользуйтесь пакетом `bpfcc-tools` для Ubuntu 20.04. Дополнительные [сведения по установке](https://github.com/iovisor/bcc/blob/master/INSTALL.md).
    
    **Ответ:**
    ```
    vagrant@vagrant:~$ sudo opensnoop-bpfcc
    PID    COMM               FD ERR PATH
    781    vminfo              4   0 /var/run/utmp
    576    dbus-daemon        -1   2 /usr/local/share/dbus-1/system-services
    576    dbus-daemon        18   0 /usr/share/dbus-1/system-services
    576    dbus-daemon        -1   2 /lib/dbus-1/system-services
    576    dbus-daemon        18   0 /var/lib/snapd/dbus-1/system-services/
    781    vminfo              4   0 /var/run/utmp
    576    dbus-daemon        -1   2 /usr/local/share/dbus-1/system-services
    576    dbus-daemon        18   0 /usr/share/dbus-1/system-services
    576    dbus-daemon        -1   2 /lib/dbus-1/system-services
    576    dbus-daemon        18   0 /var/lib/snapd/dbus-1/system-services/
    604    irqbalance          6   0 /proc/interrupts
    604    irqbalance          6   0 /proc/stat
    604    irqbalance          6   0 /proc/irq/20/smp_affinity
    604    irqbalance          6   0 /proc/irq/0/smp_affinity
    604    irqbalance          6   0 /proc/irq/1/smp_affinity
    604    irqbalance          6   0 /proc/irq/8/smp_affinity
    604    irqbalance          6   0 /proc/irq/12/smp_affinity
    604    irqbalance          6   0 /proc/irq/14/smp_affinity
    604    irqbalance          6   0 /proc/irq/15/smp_affinity
    781    vminfo              4   0 /var/run/utmp
    ```

6. Какой системный вызов использует `uname -a`? Приведите цитату из man по этому системному вызову, где описывается альтернативное местоположение в `/proc`, где можно узнать версию ядра и релиз ОС.

   **Ответ:**

   ***Альтернативное расположение /proc/sys/kernel/ {ostype, hostname, osrelease, version, domainname}.***
   
   ```
   vagrant@vagrant:~$ strace uname
    execve("/usr/bin/uname", ["uname"], 0x7ffc5fb4d960 /* 24 vars */) = 0

    Используется системный вызов uname
    ```

7.  Чем отличается последовательность команд через `;` и через `&&` в bash? Например:
    ```bash
    root@netology1:~# test -d /tmp/some_dir; echo Hi
    Hi
    root@netology1:~# test -d /tmp/some_dir && echo Hi
    root@netology1:~#
    ```
    Есть ли смысл использовать в bash `&&`, если применить `set -e`?
    
    **Ответ:**

    ***При использовании ';' команда2 выполнится в любом случае, даже если команда1 вернула ошибку.***

    ***При использолвании '&&' команда2 выполнится только при успешном выполнении команды1***

    ***`set -e` немедленно прерывает выполнение команд при ненулевом статусе, смысла использовать нет, т.к. это приведет к прерыванию***

8. Из каких опций состоит режим bash `set -euxo pipefail` и почему его хорошо было бы использовать в сценариях?

    **Ответ:**
    ```
    set -euxo pipefail

    -e  Exit immediately if a command exits with a non-zero status.
    -u  Treat unset variables as an error when substituting.
    -x  Print commands and their arguments as they are executed.
    -o pipefail     the return value of a pipeline is the status of
            the last command to exit with a non-zero status,
            or zero if no command exited with a non-zero status

    Вывод логгирования и завершение работы скрипта (кроме последней команды в скрипте) при наличии ошибок
    ```
9. Используя `-o stat` для `ps`, определите, какой наиболее часто       встречающийся статус у процессов в системе. В `man ps` ознакомьтесь (`/PROCESS STATE CODES`) что значат дополнительные к основной заглавной буквы статуса процессов. Его можно не учитывать при расчете (считать S, Ss или Ssl равнозначными).

    **Ответ:**
    ```
    vagrant@vagrant:~$ ps -o stat
    STAT
    Ss
    R+

    Ss - Обычный спящий процесс(в ожидании события для выполнения), s - текущая сессия
    R - Запущенный процесс или ожидает запуска, + - не в фоне
    ```

    


# Домашнее задание к занятию "3.2. Работа в терминале, лекция 2"
1. Какого типа команда `cd`? Попробуйте объяснить, почему она именно такого типа; опишите ход своих мыслей, если считаете что она могла бы быть другого типа.
   
    **Ответ:**
   ***Команда cd является встроенной командой shell, и не является программой***

2. Какая альтернатива без pipe команде `grep <some_string> <some_file> | wc -l`? `man grep` поможет в ответе на этот вопрос. Ознакомьтесь с [документом](http://www.smallo.ruhr.de/award.html) о других подобных некорректных вариантах использования pipe.
   
   **Ответ:**
   ***Альтернатива команде без pipe: `grep -c <some_string> <some_file>`***

3. Какой процесс с PID `1` является родителем для всех процессов в вашей виртуальной машине Ubuntu 20.04?
   
    **Ответ:**
    ***Процесс systemd(1)***

4. Как будет выглядеть команда, которая перенаправит вывод stderr `ls` на другую сессию терминала?

    **Ответ:**
    ***ls 2>/dev/pts/(id_терминала)***

5. Получится ли одновременно передать команде файл на stdin и вывести ее stdout в другой файл? Приведите работающий пример.

    **Ответ:**
    ***cat < file1.txt > file2.txt***


6. Получится ли находясь в графическом режиме, вывести данные из PTY в какой-либо из эмуляторов TTY? Сможете ли вы наблюдать выводимые данные?
   
   **Ответ:**
   ***При попытке вывести данные в tty получаю ошибку:***
   	```
	vagrant@vagrant:~$ sudo echo Hello netology >/dev/tty0
	-bash: /dev/tty0: Permission denied
	```

7. Выполните команду `bash 5>&1`. К чему она приведет? Что будет, если вы выполните `echo netology > /proc/$$/fd/5`? Почему так происходит?
   
   **Ответ:**
   ***bash 5>&1 - Создаст дескриптор с №5 и перенаправит его в stdout
    echo netology > /proc/$$/fd/5 - выведет в дескриптор "5", который был пернеаправлен в stdout***

8. Получится ли в качестве входного потока для pipe использовать только stderr команды, не потеряв при этом отображение stdout на pty? Напоминаем: по умолчанию через pipe передается только stdout команды слева от `|` на stdin команды справа.
   
   **Ответ:**
   	```
   	vagrant@vagrant:~$ cat file3.txt 5>&2 2>&1 1>&5 |grep file
	cat: file3.txt: No such file or directory
	```

9.  Что выведет команда `cat /proc/$$/environ`? Как еще можно получить аналогичный по содержанию вывод?
    
    **Ответ:**
    ***Команда выведет список переменных окружения, этот же список можно получить командой `env`***

10. Используя `man`, опишите что доступно по адресам `/proc/<PID>/cmdline`, `/proc/<PID>/exe`.
    
    **Ответ:**
    ***Каждому запущенному процессу соответствует подкаталог с именем, соответствующим идентификатору этого процесса (его pid). Каждый из этих подкаталогов содержит следующие псевдо-файлы и каталоги.***

    ***`/proc/<PID>/cmdline` Этот файл содержит полную командную строку запуска процесса, кроме тех процессов, что полностью ушли в своппинг, а также тех, что превратились в зомби. В этих двух случаях в файле ничего нет, то есть чтение этого файла вернет 0 символов. Аргументы командной строки в этом файле указаны как список строк, каждая из которых завешается нулевым символом, с добавочным нулевым байтом после последней строки.***

    ***`/proc/<PID>/exe` является символьной ссылкой, содержащей фактическое полное имя выполняемого файла. Символьная ссылка `exe` может использоваться обычным образом - при попытке открыть `exe` будет открыт исполняемый файл***

11. Узнайте, какую наиболее старшую версию набора инструкций SSE поддерживает ваш процессор с помощью `/proc/cpuinfo`.

    **Ответ:** `sudo cat /proc/cpuinfo | grep sse`

    ***flags: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt rdtscp lm constant_tsc rep_good nopl nonstop_tsc cpuid extd_apicid tsc_known_freq pni pclmulqdq ssse3 cx16 sse4_1 sse4_2 x2apic movbe popcnt aes xsave avx rdrand hypervisor lahf_lm cmp_legacy cr8_legacy abm sse4a misalignsse 3dnowprefetch vmmcall fsgsbase avx2 invpcid rdseed clflushopt arat***

    ***Исходя из полученного ответа версия sse sse2 ssse3 sse4_1 sse4_2 sse4a***
    
12. При открытии нового окна терминала и `vagrant ssh` создается новая сессия и выделяется pty. Это можно подтвердить командой `tty`, которая упоминалась в лекции 3.2. Однако:

    ```bash
	vagrant@netology1:~$ ssh localhost 'tty'
	not a tty
    ```
    ***Ответ: чтобы удалось подключиться нужно добавить параметр -t***

    ```ssh -t localhost 'tty'``` (-t создаст псевдотерминал)

13. Бывает, что есть необходимость переместить запущенный процесс из одной сессии в другую. Попробуйте сделать это, воспользовавшись `reptyr`. Например, так можно перенести в `screen` процесс, который вы запустили по ошибке в обычной SSH-сессии.
    
    **Ответ:**
    ***reptyr -PID***

14. `sudo echo string > /root/new_file` не даст выполнить перенаправление под обычным пользователем, так как перенаправлением занимается процесс shell'а, который запущен без `sudo` под вашим пользователем. Для решения данной проблемы можно использовать конструкцию `echo string | sudo tee /root/new_file`. Узнайте что делает команда `tee` и почему в отличие от `sudo echo` команда с `sudo tee` будет работать.

    ***Ответ: tee читает с stdin и пишет в файл и в stdout***
    
    ***sudo tee получает вывод из stdin, направленный через pipe от stdout команды echo, в данном случае команда выполнится корректно***




# Домашнее задание к занятию "3.1. Работа в терминале, лекция 1"

### 1. Установите средство виртуализации Oracle VirtualBox.
    Выполнено

### 2. Установите средство автоматизации Hashicorp Vagrant.
    Выполнено

### 3. В вашем основном окружении подготовьте удобный для дальнейшей работы терминал. Можно предложить:
    В качестве терминала выбран PowerShell

### 4. С помощью базового файла конфигурации запустите Ubuntu 20.04 в VirtualBox посредством Vagrant:

```
PS C:\Windows\system32> cd C:\Users\ngrac\Vagrant\
PS C:\Users\ngrac\Vagrant> vagrant init
A `Vagrantfile` has been placed in this directory. You are now
ready to `vagrant up` your first virtual environment! Please read
the comments in the Vagrantfile as well as documentation on
`vagrantup.com` for more information on using Vagrant.
PS C:\Users\ngrac\Vagrant> vagrant up
Bringing machine 'default' up with 'virtualbox' provider...
==> default: Box 'bento/ubuntu-20.04' could not be found. Attempting to find and install...
    default: Box Provider: virtualbox
    default: Box Version: >= 0
==> default: Loading metadata for box 'bento/ubuntu-20.04'
    default: URL: https://vagrantcloud.com/bento/ubuntu-20.04
==> default: Adding box 'bento/ubuntu-20.04' (v202107.28.0) for provider: virtualbox
    default: Downloading: https://vagrantcloud.com/bento/boxes/ubuntu-20.04/versions/202107.28.0/providers/virtualbox.box
    default:
==> default: Successfully added box 'bento/ubuntu-20.04' (v202107.28.0) for 'virtualbox'!
==> default: Importing base box 'bento/ubuntu-20.04'...
==> default: Matching MAC address for NAT networking...
==> default: Checking if box 'bento/ubuntu-20.04' version '202107.28.0' is up to date...
==> default: Setting the name of the VM: Vagrant_default_1639585438763_89339
Vagrant is currently configured to create VirtualBox synced folders with
the `SharedFoldersEnableSymlinksCreate` option enabled. If the Vagrant
guest is not trusted, you may want to disable this option. For more
information on this option, please refer to the VirtualBox manual:

  https://www.virtualbox.org/manual/ch04.html#sharedfolders

This option can be disabled globally with an environment variable:

  VAGRANT_DISABLE_VBOXSYMLINKCREATE=1

or on a per folder basis within the Vagrantfile:

  config.vm.synced_folder '/host/path', '/guest/path', SharedFoldersEnableSymlinksCreate: false
==> default: Clearing any previously set network interfaces...
==> default: Preparing network interfaces based on configuration...
    default: Adapter 1: nat
==> default: Forwarding ports...
    default: 22 (guest) => 2222 (host) (adapter 1)
==> default: Booting VM...
==> default: Waiting for machine to boot. This may take a few minutes...
    default: SSH address: 127.0.0.1:2222
    default: SSH username: vagrant
    default: SSH auth method: private key
    default:
    default: Vagrant insecure key detected. Vagrant will automatically replace
    default: this with a newly generated keypair for better security.
    default:
    default: Inserting generated public key within guest...
    default: Removing insecure key from the guest if it's present...
    default: Key inserted! Disconnecting and reconnecting using new SSH key...
==> default: Machine booted and ready!
==> default: Checking for guest additions in VM...
==> default: Mounting shared folders...
    default: /vagrant => C:/Users/ngrac/Vagrant
PS C:\Users\ngrac\Vagrant> vagrant up
Bringing machine 'default' up with 'virtualbox' provider...
==> default: Checking if box 'bento/ubuntu-20.04' version '202107.28.0' is up to date...
==> default: Machine already provisioned. Run `vagrant provision` or use the `--provision`
==> default: flag to force provisioning. Provisioners marked to run always will still run.
```

### 5. Ознакомьтесь с графическим интерфейсом VirtualBox, посмотрите как выглядит виртуальная машина, которую создал для вас Vagrant, какие аппаратные ресурсы ей выделены. Какие ресурсы выделены по-умолчанию?
    Оперативная память: 1024 МБ
    Процессоры: 2
    Порядок загрузки: Жесткий диск, Оптический диск
    Видеопамять: 4МБ
    Контроллер: SATA контроллер SATA порт 0, 64 ГБ
    Сеть: Intel PRO/1000 MT Desktop

### 6. Ознакомьтесь с возможностями конфигурации VirtualBox через Vagrantfile: документация. Как добавить оперативной памяти или ресурсов процессора виртуальной машине?
    Прописать в Vagrantfile следующую конфигурацию:

    config.vm.provider "virtualbox" do |v|
        v.memory = 1024  #Добавить ОЗУ
        v.cpus = 2       #Добавить ЦПУ
    end

### 7. Команда vagrant ssh из директории, в которой содержится Vagrantfile, позволит вам оказаться внутри виртуальной машины без каких-либо дополнительных настроек. Попрактикуйтесь в выполнении обсуждаемых команд в терминале Ubuntu.

```
PS C:\Users\ngrac\Vagrant> vagrant ssh
Welcome to Ubuntu 20.04.2 LTS (GNU/Linux 5.4.0-80-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

  System information as of Wed 15 Dec 2021 04:43:36 PM UTC

  System load:  0.0               Processes:             109
  Usage of /:   2.4% of 61.31GB   Users logged in:       0
  Memory usage: 15%               IPv4 address for eth0: 10.0.2.15
  Swap usage:   0%


This system is built by the Bento project by Chef Software
More information can be found at https://github.com/chef/bento
vagrant@vagrant:~$ pwd
/home/vagrant
vagrant@vagrant:~$ mkdir devops-netology_15_12_2021
vagrant@vagrant:~$ ll
total 40
drwxr-xr-x 5 vagrant vagrant 4096 Dec 15 16:44 ./
drwxr-xr-x 3 root    root    4096 Jul 28 17:50 ../
-rw-r--r-- 1 vagrant vagrant  220 Jul 28 17:50 .bash_logout
-rw-r--r-- 1 vagrant vagrant 3771 Jul 28 17:50 .bashrc
drwx------ 2 vagrant vagrant 4096 Jul 28 17:51 .cache/
drwxrwxr-x 2 vagrant vagrant 4096 Dec 15 16:44 devops-netology_15_12_2021/
-rw-r--r-- 1 vagrant vagrant  807 Jul 28 17:50 .profile
drwx------ 2 vagrant root    4096 Dec 15 16:24 .ssh/
-rw-r--r-- 1 vagrant vagrant    0 Jul 28 17:51 .sudo_as_admin_successful
-rw-r--r-- 1 vagrant vagrant    6 Jul 28 17:51 .vbox_version
-rw-r--r-- 1 root    root     180 Jul 28 17:55 .wget-hsts
```
### 8. Ознакомиться с разделами man bash, почитать о настройках самого bash:
    8.1 Какой переменной можно задать длину журнала history, и на какой строчке manual это описывается?
    HISTFILESIZE
              The  maximum number of lines contained in the history file.  When this variable is assigned a value, the history file is truncated, if necessary, to contain no more than that number of lines by removing the oldest entries.  The his‐
              tory file is also truncated to this size after writing it when a shell exits.  If the value is 0, the history file is truncated to zero size.  Non-numeric values and numeric values less than zero inhibit truncation.  The shell  sets
              the default value to the value of HISTSIZE after reading any startup files.

    #Нашёл на line 510

    8.2 Что делает директива ignoreboth в bash?
        Входит в опцию HISTCONTROL и включает в себя 2 команды:
        ignorespace — не сохранять строки начинающиеся с символа <пробел>
        ignoredups — не сохранять строки, совпадающие с последней выполненной командой

### 9.В каких сценариях использования применимы скобки {} и на какой строчке man bash это описано?
    {} - используется в условных циклах, условных операторах, или ограничивает тело функции
    
### 10. С учётом ответа на предыдущий вопрос, как создать однократным вызовом touch 100000 файлов? Получится ли аналогичным образом создать 300000? Если нет, то почему?
    touch {000001..100000}.file
    300000 не получится создать, т.к. получится длинный список аргументов (видимо стоит ограничение)

### 11. В man bash поищите по `/\[\[`. Что делает конструкция `[[ -d /tmp ]]`

        Команда [[ -d /tmp ]] проверяет наличие директории /tmp, используется в условных конструкциях

### 12. Основываясь на знаниях о просмотре текущих (например, PATH) и установке новых переменных; командах, которые мы рассматривали, добейтесь в выводе type -a bash в виртуальной машине наличия первым пунктом в списке:
    root@vagrant:/tmp# cd new_path_dir/
    root@vagrant:/tmp/new_path_dir# PATH=/tmp/new_path_dir/:$PATH
    root@vagrant:/tmp/new_path_dir# type -a bash
    bash is /usr/bin/bash
    bash is /bin/bash
    root@vagrant:/tmp/new_path_dir# cp /bin/bash /tmp/new_path_dir/
    root@vagrant:/tmp/new_path_dir# type -a bash
    bash is /tmp/new_path_dir/bash
    bash is /usr/bin/bash
    bash is /bin/bash
    root@vagrant:/tmp/new_path_dir#

### 13. Чем отличается планирование команд с помощью batch и at?
    at используется для назначения одноразового задания на заданное время
    batch — для назначения одноразовых задач, которые должны выполняться, когда загрузка системы становится меньше 0,8.

### 14. Завершите работу виртуальной машины чтобы не расходовать ресурсы компьютера и/или батарею ноутбука.
    vagrant@vagrant:/tmp$ exit
    logout
    Connection to 127.0.0.1 closed.
    PS C:\Users\ngrac\Vagrant> vagrant suspend
    ==> default: Saving VM state and suspending execution...





# devops-netology_navasardyan
MyFirstProjectOnGit
These files will be ignored in directory /terraform :
*.tfstate
*.tfstate.*
crash.log
*.tfvars
override.tf
override.tf.json
*_override.tf
*_override.tf.json
.terraformrc
terraform.rc

Hello from PyCharm

Домашнее задание к занятию «2.4. Инструменты Git»
# 1. Найдите полный хеш и комментарий коммита, хеш которого начинается на aefea.

### git log --pretty=oneline | grep aefea
### aefead2207ef7e2aa5dc81a34aedf0cad4c32545 Update CHANGELOG.md (то что искали)
### 8619f566bbd60bbae22baefea9a702e7778f8254 validate providers passed to a module exist
### 3593ea8b0aefea1b4b5e14010b4453917800723f build: Remove format check from plugin-dev
###  0196a0c2aefea6b85f495b0bbe32a855021f0a24 Changed Required: false to Optional: true in the ### SNS topic schema

# 2.Какому тегу соответствует коммит 85024d3?
### git show 85024d3
### commit 85024d3100126de36331c6982bfaac02cdab9e76 (tag: v0.12.23)
### Author: tf-release-bot <terraform@hashicorp.com>
### Date:   Thu Mar 5 20:56:10 2020 +0000

###    v0.12.23

### diff --git a/CHANGELOG.md b/CHANGELOG.md
### index 1a9dcd0f9..faedc8bf4 100644
### --- a/CHANGELOG.md
### +++ b/CHANGELOG.md
### @@ -1,4 +1,4 @@
### -## 0.12.23 (Unreleased)
### +## 0.12.23 (March 05, 2020)
### 0.12.22 (March 05, 2020)

### ENHANCEMENTS:
### diff --git a/version/version.go b/version/version.go
### index 33ac86f5d..bcb6394d2 100644
### --- a/version/version.go
### +++ b/version/version.go
### @@ -16,7 +16,7 @@ var Version = "0.12.23"
###  // A pre-release marker for the version. If this is "" (empty string)
###  // then it means that it is a final release. Otherwise, this is a pre-release
###  // such as "dev" (in development), "beta", "rc1", etc.
### -var Prerelease = "dev"
### +var Prerelease = ""

# 3.Сколько родителей у коммита b8d720? Напишите их хеши.
### git show --pretty=format:' %P' b8d720
###  56cd7859e05c36c06b56d013b55a252d0bb7e158 9ea88f22fc6269854151c571162c5bcf958bee2b

# 4.Перечислите хеши и комментарии всех коммитов которые были сделаны между тегами v0.12.23 и v0.12.24.
### git log  v0.12.23..v0.12.24  --oneline
### 33ff1c03b (tag: v0.12.24) v0.12.24
### b14b74c49 [Website] vmc provider links
### 3f235065b Update CHANGELOG.md
### 6ae64e247 registry: Fix panic when server is unreachable
### 5c619ca1b website: Remove links to the getting started guide's old location
### 06275647e Update CHANGELOG.md
### d5f9411f5 command: Fix bug when using terraform login on Windows
### 4b6d06cc5 Update CHANGELOG.md
### dd01a3507 Update CHANGELOG.md
### 225466bc3 Cleanup after v0.12.23 release

# 5. Найдите коммит в котором была создана функция func providerSource, ее определение в коде выглядит так func providerSource(...) (вместо троеточего перечислены аргументы).

### git log -S'func providerSource' --oneline
### 5af1e6234 main: Honor explicit provider_installation CLI config when present
### 8c928e835 main: Consult local directories as potential mirrors of providers

# 6.Найдите все коммиты в которых была изменена функция globalPluginDirs.
### git log -L :'func globalPluginDirs':plugins.go --oneline 

# 7.Кто автор функции synchronizedWriters?
###  git log -S'func synchronizedWriters' --pretty=format:'%h - %an %ae'
### bdfea50cc - James Bardin j.bardin@gmail.com
### 5ac311e2a - Martin Atkins mart@degeneration.co.uk
