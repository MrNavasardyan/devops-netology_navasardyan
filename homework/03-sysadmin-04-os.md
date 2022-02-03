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
    EnvironmentFile=/etc/sysconfig/node_exporter
    ExecStart=/usr/sbin/node_exporter $OPTIONS

    [Install]
    WantedBy=multi-user.target
    В автозагрузку добавил через systemctl enable node_exporter

    Доработка, передача дополнительных опций при запуске службы:
    в /etc/sysconfig/node_exporter мы прописываем опции.
    OPTIONS="--collector.textfile.directory=/var/lib/node_exporter/textfile_collector" (text_collector, прописываем нужные собираемые метрики"
    либо 
    OPTIONS="-h"
    Служба при перезапуске будет запускаться с опциями которые описаны в файле /etc/sysconfig/node_exporter
    
    Еще вариант:
    systemctl start node_exporter -опции запуска
    
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
   
   <details><summary>Вывод:</summary>
      
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

   	
   	```  curl http://localhost:9100/metrics | grep "memory_" ```

	<details><summary>Вывод:</summary>

    ```
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
	```        
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

    ```
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
    ```    
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
