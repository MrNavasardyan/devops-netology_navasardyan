# Домашнее задание к занятию "3.8. Компьютерные сети, лекция 3"

1. Подключитесь к публичному маршрутизатору в интернет. Найдите маршрут к вашему публичному IP
```
telnet route-views.routeviews.org
Username: rviews
show ip route x.x.x.x/32
show bgp x.x.x.x/32
```

***Ответ:***
<details>
    vagrant@vagrant:~$ telnet route-views.routeviews.org
    Trying 128.223.51.103...
    Connected to route-views.routeviews.org.
    Escape character is '^]'.
    C

                        RouteViews BGP Route Viewer
                        route-views.routeviews.org

    route views data is archived on http://archive.routeviews.org

    This hardware is part of a grant by the NSF.
    Please contact help@routeviews.org if you have questions, or
    if you wish to contribute your view.

    This router has views of full routing tables from several ASes.
    The list of peers is located at http://www.routeviews.org/peers
    in route-views.oregon-ix.net.txt

    NOTE: The hardware was upgraded in August 2014.  If you are seeing
    the error message, "no default Kerberos realm", you may want to
    in Mac OS X add "default unset autologin" to your ~/.telnetrc

    To login, use the username "rviews".

    **********************************************************************

    User Access Verification

    Username: rviews
    route-views>ip route 185.76.221.239/32
                ^
    % Invalid input detected at '^' marker.

    route-views>show ip route 185.76.221.239/32
                                            ^
    % Invalid input detected at '^' marker.

    route-views>show ip route 185.76.221.239
    Routing entry for 185.76.220.0/22
    Known via "bgp 6447", distance 20, metric 0
    Tag 2497, type external
    Last update from 202.232.0.2 19:14:20 ago
    Routing Descriptor Blocks:
    * 202.232.0.2, from 202.232.0.2, 19:14:20 ago
        Route metric is 0, traffic share count is 1
        AS Hops 3
        Route tag 2497
        MPLS label: none
    route-views>show bgp 6447
                        ^
    % Invalid input detected at '^' marker.

    route-views>show bgp 185.76.221.239
    BGP routing table entry for 185.76.220.0/22, version 307719360
    Paths: (23 available, best #18, table default)
    Not advertised to any peer
    Refresh Epoch 1
    701 3356 20485 41148
        137.39.3.55 from 137.39.3.55 (137.39.3.55)
        Origin IGP, localpref 100, valid, external
        path 7FE1637235C8 RPKI State not found
        rx pathid: 0, tx pathid: 0
    Refresh Epoch 1
    3549 3356 20485 41148
        208.51.134.254 from 208.51.134.254 (67.16.168.191)
        Origin IGP, metric 0, localpref 100, valid, external
        Community: 3356:2 3356:22 3356:100 3356:123 3356:501 3356:903 3356:2065 3549:2581 3549:30840 20485:10058
        path 7FE14E627748 RPKI State not found
        rx pathid: 0, tx pathid: 0
    Refresh Epoch 1
    53767 174 31133 41148
        162.251.163.2 from 162.251.163.2 (162.251.162.3)
        Origin IGP, localpref 100, valid, external
        Community: 174:21101 174:22028 53767:5000
        path 7FE17D486F48 RPKI State not found
        rx pathid: 0, tx pathid: 0
    Refresh Epoch 1
    3356 20485 41148
        4.68.4.46 from 4.68.4.46 (4.69.184.201)
        Origin IGP, metric 0, localpref 100, valid, external
        Community: 3356:2 3356:22 3356:100 3356:123 3356:501 3356:903 3356:2065 20485:10058
        path 7FE0F6919488 RPKI State not found
        rx pathid: 0, tx pathid: 0
    Refresh Epoch 1
    8283 31133 41148
        94.142.247.3 from 94.142.247.3 (94.142.247.3)
        Origin IGP, metric 0, localpref 100, valid, external
        Community: 8283:1 8283:101
        unknown transitive attribute: flag 0xE0 type 0x20 length 0x18
            value 0000 205B 0000 0000 0000 0001 0000 205B
                0000 0005 0000 0001
        path 7FE11F214DB0 RPKI State not found
        rx pathid: 0, tx pathid: 0
    Refresh Epoch 1
    4901 6079 9002 9002 9049 41148
        162.250.137.254 from 162.250.137.254 (162.250.137.254)
        Origin IGP, localpref 100, valid, external
        Community: 65000:10100 65000:10300 65000:10400
        path 7FE0CA875098 RPKI State not found
        rx pathid: 0, tx pathid: 0
    Refresh Epoch 1
    57866 9002 9049 41148
        37.139.139.17 from 37.139.139.17 (37.139.139.17)
        Origin IGP, metric 0, localpref 100, valid, external
        Community: 9002:0 9002:64667
        path 7FE1853CF728 RPKI State not found
        rx pathid: 0, tx pathid: 0
    Refresh Epoch 1
    852 3491 20485 20485 41148
        154.11.12.212 from 154.11.12.212 (96.1.209.43)
        Origin IGP, metric 0, localpref 100, valid, external
        path 7FE0D558BAC8 RPKI State not found
        rx pathid: 0, tx pathid: 0
    Refresh Epoch 1
    20912 3257 174 31133 41148
        212.66.96.126 from 212.66.96.126 (212.66.96.126)
        Origin IGP, localpref 100, valid, external
        Community: 3257:8070 3257:30155 3257:50001 3257:53900 3257:53902 20912:65004
        path 7FE16473AFA8 RPKI State not found
        rx pathid: 0, tx pathid: 0
    Refresh Epoch 1
    7660 2516 6762 20485 41148
        203.181.248.168 from 203.181.248.168 (203.181.248.168)
        Origin IGP, localpref 100, valid, external
        Community: 2516:1030 7660:9003
        path 7FE14236FB70 RPKI State not found
        rx pathid: 0, tx pathid: 0
    Refresh Epoch 1
    3303 31133 41148
        217.192.89.50 from 217.192.89.50 (138.187.128.158)
        Origin IGP, localpref 100, valid, external
        Community: 3303:1004 3303:1006 3303:1030 3303:3056
        path 7FE186FAAA78 RPKI State not found
        rx pathid: 0, tx pathid: 0
    Refresh Epoch 1
    3333 31133 41148
        193.0.0.56 from 193.0.0.56 (193.0.0.56)
        Origin IGP, localpref 100, valid, external
        path 7FE0FD71DA98 RPKI State not found
        rx pathid: 0, tx pathid: 0
    Refresh Epoch 1
    7018 1299 31133 41148
        12.0.1.63 from 12.0.1.63 (12.0.1.63)
        Origin IGP, localpref 100, valid, external
        Community: 7018:5000 7018:37232
        path 7FE03438FF20 RPKI State not found
        rx pathid: 0, tx pathid: 0
    Refresh Epoch 1
    3561 3910 3356 20485 41148
        206.24.210.80 from 206.24.210.80 (206.24.210.80)
        Origin IGP, localpref 100, valid, external
        path 7FE09E7336F8 RPKI State not found
        rx pathid: 0, tx pathid: 0
    Refresh Epoch 1
    1351 6939 20485 41148
        132.198.255.253 from 132.198.255.253 (132.198.255.253)
        Origin IGP, localpref 100, valid, external
        path 7FE12DAF9B38 RPKI State not found
        rx pathid: 0, tx pathid: 0
    Refresh Epoch 1
    20130 6939 20485 41148
        140.192.8.16 from 140.192.8.16 (140.192.8.16)
        Origin IGP, localpref 100, valid, external
        path 7FE0C9473C60 RPKI State not found
        rx pathid: 0, tx pathid: 0
    Refresh Epoch 1
    101 3491 20485 20485 41148
        209.124.176.223 from 209.124.176.223 (209.124.176.223)
        Origin IGP, localpref 100, valid, external
        Community: 101:20300 101:22100 3491:300 3491:311 3491:9001 3491:9080 3491:9081 3491:9087 3491:62210 3491:62220 20485:10058
        path 7FE0A645EFB8 RPKI State not found
        rx pathid: 0, tx pathid: 0
    Refresh Epoch 2
    2497 20485 41148
        202.232.0.2 from 202.232.0.2 (58.138.96.254)
        Origin IGP, localpref 100, valid, external, best
        path 7FE0D499E528 RPKI State not found
        rx pathid: 0, tx pathid: 0x0
    Refresh Epoch 1
    49788 12552 31133 41148
        91.218.184.60 from 91.218.184.60 (91.218.184.60)
        Origin IGP, localpref 100, valid, external
        Community: 12552:12000 12552:12100 12552:12101 12552:22000
        Extended Community: 0x43:100:1
        path 7FE11E5D4768 RPKI State not found
        rx pathid: 0, tx pathid: 0
    Refresh Epoch 1
    1221 4637 31133 41148
        203.62.252.83 from 203.62.252.83 (203.62.252.83)
        Origin IGP, localpref 100, valid, external
        path 7FE0A2C3B218 RPKI State not found
        rx pathid: 0, tx pathid: 0
    Refresh Epoch 1
    3257 3356 20485 41148
        89.149.178.10 from 89.149.178.10 (213.200.83.26)
        Origin IGP, metric 10, localpref 100, valid, external
        Community: 3257:8794 3257:30043 3257:50001 3257:54900 3257:54901
        path 7FE0BE365950 RPKI State not found
        rx pathid: 0, tx pathid: 0
    Refresh Epoch 1
    19214 174 31133 41148
        208.74.64.40 from 208.74.64.40 (208.74.64.40)
        Origin IGP, localpref 100, valid, external
        Community: 174:21101 174:22028
        path 7FE08CD064B0 RPKI State not found
        rx pathid: 0, tx pathid: 0
    Refresh Epoch 1
    6939 20485 41148
        64.71.137.241 from 64.71.137.241 (216.218.252.164)
        Origin IGP, localpref 100, valid, external
        path 7FE0C7318368 RPKI State not found
        rx pathid: 0, tx pathid: 0
    route-views>  
        
        
</details>





2. Создайте dummy0 интерфейс в Ubuntu. Добавьте несколько статических маршрутов. Проверьте таблицу маршрутизации.
   ***Ответ:***
```
    root@vagrant:~# ifconfig -a
    dummy0: flags=195<UP,BROADCAST,RUNNING,NOARP>  mtu 1500
            inet 192.168.1.150  netmask 255.255.255.0  broadcast 0.0.0.0
            inet6 fe80::b460:6bff:fefb:11ed  prefixlen 64  scopeid 0x20<link>
            ether b6:60:6b:fb:11:ed  txqueuelen 1000  (Ethernet)
            RX packets 0  bytes 0 (0.0 B)
            RX errors 0  dropped 0  overruns 0  frame 0
            TX packets 6  bytes 718 (718.0 B)
            TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

    eth0: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
            inet 10.0.2.15  netmask 255.255.255.0  broadcast 10.0.2.255
            inet6 fe80::a00:27ff:fe73:60cf  prefixlen 64  scopeid 0x20<link>
            ether 08:00:27:73:60:cf  txqueuelen 1000  (Ethernet)
            RX packets 14625  bytes 15302480 (15.3 MB)
            RX errors 0  dropped 0  overruns 0  frame 0
            TX packets 8549  bytes 857278 (857.2 KB)
            TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

    lo: flags=73<UP,LOOPBACK,RUNNING>  mtu 65536
            inet 127.0.0.1  netmask 255.0.0.0
            inet6 ::1  prefixlen 128  scopeid 0x10<host>
            loop  txqueuelen 1000  (Local Loopback)
            RX packets 92  bytes 7984 (7.9 KB)
            RX errors 0  dropped 0  overruns 0  frame 0
            TX packets 92  bytes 7984 (7.9 KB)
            TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0


    root@vagrant:~# ip route add 192.168.1.0/24 dev dummy0

    root@vagrant:~# netstat -n -r
    Kernel IP routing table
    Destination  Gateway   Genmask         Flags   MSS Window  irtt Iface
    0.0.0.0      10.0.2.2  0.0.0.0         UG        0 0          0 eth0
    10.0.2.0     0.0.0.0   255.255.255.0   U         0 0          0 eth0
    10.0.2.2     0.0.0.0   255.255.255.255 UH        0 0          0 eth0
    192.168.1.0  0.0.0.0   255.255.255.0   U         0 0          0 dummy0
```



3. Проверьте открытые TCP порты в Ubuntu, какие протоколы и приложения используют эти порты? Приведите несколько примеров.
    ***Ответ:***
```
    root@vagrant:~# ss -p
    Netid       State        Recv-Q       Send-Q                           Local Address:Port                  Peer Address:Port       Process
    tcp         ESTAB        0            0                                    10.0.2.15:ssh                       10.0.2.2:56876       users:(("sshd",pid=14763,fd=4),("sshd",pid=14715,fd=4))

    Порт 56876 Использует процессы с pid=14763, pid=14715
```


4. Проверьте используемые UDP сокеты в Ubuntu, какие протоколы и приложения используют эти порты?
***Ответ:***

```
    root@vagrant:~# ss -p
    Netid       State        Recv-Q       Send-Q                           Local Address:Port                  Peer Address:Port       Process
    u_str       ESTAB        0            0                                            * 58863                            * 58862       users:(("sshd",pid=14715,fd=7))
    u_str       ESTAB        0            0                                            * 22488                            * 22489       users:(("networkd-dispat",pid=609,fd=3))
    u_str       ESTAB        0            0                                            * 22364                            * 22365       users:(("systemd-logind",pid=617,fd=14))
    u_str       ESTAB        0            0                                            * 21235                            * 21236       users:(("accounts-daemon",pid=585,fd=2),("accounts-daemon",pid=585,fd=1))
    u_str       ESTAB        0            0                                            * 22041                            * 22040       users:(("dbus-daemon",pid=587,fd=9))
    u_str       ESTAB        0            0                  /run/systemd/journal/stdout 25094                            * 25093       users:(("systemd-journal",pid=362,fd=28),("systemd",pid=1,fd=84))
    u_str       ESTAB        0            0                  /run/systemd/journal/stdout 58781                            * 58775       users:(("systemd-journal",pid=362,fd=23),("systemd",pid=1,fd=34))
    u_str       ESTAB        0            0                  /run/systemd/journal/stdout 20944                            * 20942       users:(("systemd-journal",pid=362,fd=22),("systemd",pid=1,fd=91))
    u_str       ESTAB        0            0                                            * 21309                            * 21311       users:(("dbus-daemon",pid=587,fd=2),("dbus-daemon",pid=587,fd=1))
    u_str       ESTAB        0            0                                            * 58775                            * 58781       users:(("(sd-pam",pid=14729,fd=2),("(sd-pam",pid=14729,fd=1),("systemd",pid=14728,fd=2),("systemd",pid=14728,fd=1))
    u_str       ESTAB        0            0                                            * 56518                            * 56520       users:(("fwupd",pid=14575,fd=2),("fwupd",pid=14575,fd=1))
    u_str       ESTAB        0            0                                            * 22493                            * 22492       users:(("networkd-dispat",pid=609,fd=6))
    u_str       ESTAB        0            0                                            * 20942                            * 20944       users:(("systemd-resolve",pid=558,fd=2),("systemd-resolve",pid=558,fd=1))
    u_str       ESTAB        0            0                  /run/dbus/system_bus_socket 22365                            * 22364       users:(("dbus-daemon",pid=587,fd=14))
    u_str       ESTAB        0            0                  /run/systemd/journal/stdout 21311                            * 21309       users:(("systemd-journal",pid=362,fd=27),("systemd",pid=1,fd=89))
    u_str       ESTAB        0            0                                            * 58862                            * 58863       users:(("sshd",pid=14763,fd=5))
    u_str       ESTAB        0            0                                            * 22492                            * 22493       users:(("networkd-dispat",pid=609,fd=5))
    u_str       ESTAB        0            0                  /run/systemd/journal/stdout 21236                            * 21235       users:(("systemd-journal",pid=362,fd=26),("systemd",pid=1,fd=90))
    u_str       ESTAB        0            0                                            * 22040                            * 22041       users:(("dbus-daemon",pid=587,fd=8))
    u_str       ESTAB        0            0                  /run/dbus/system_bus_socket 23124                            * 23123       users:(("dbus-daemon",pid=587,fd=17))
    u_str       ESTAB        0            0                  /run/dbus/system_bus_socket 22489                            * 22488       users:(("dbus-daemon",pid=587,fd=16))
    u_str       ESTAB        0            0                  /run/systemd/journal/stdout 56520                            * 56518       users:(("systemd-journal",pid=362,fd=29),("systemd",pid=1,fd=39))
    u_str       ESTAB        0            0                                            * 25093                            * 25094       users:(("cron",pid=2570,fd=2),("cron",pid=2570,fd=1))
    u_str       ESTAB        0            0                                            * 23123                            * 23124       users:(("VBoxService",pid=1018,fd=6))
    u_str       ESTAB        0            0                                            * 56529                            * 56530       users:(("fwupd",pid=14575,fd=16))
    u_str       ESTAB        0            0                  /run/dbus/system_bus_socket 22045                            * 20226       users:(("dbus-daemon",pid=587,fd=13))
    u_str       ESTAB        0            0                  /run/dbus/system_bus_socket 56530                            * 56529       users:(("dbus-daemon",pid=587,fd=19))
    u_str       ESTAB        0            0                                            * 20226                            * 22045       users:(("accounts-daemon",pid=585,fd=5))
    u_str       ESTAB        0            0                                            * 20093                            * 22043       users:(("systemd-resolve",pid=558,fd=14))
    u_str       ESTAB        0            0                                            * 19860                            * 20847       users:(("rpcbind",pid=557,fd=2),("rpcbind",pid=557,fd=1))
    u_str       ESTAB        0            0                                            * 17865                            * 17867       users:(("systemd-network",pid=400,fd=2),("systemd-network",pid=400,fd=1))
    u_str       ESTAB        0            0                  /run/dbus/system_bus_socket 22044                            * 20108       users:(("dbus-daemon",pid=587,fd=12))
    u_str       ESTAB        0            0                  /run/systemd/journal/stdout 17867                            * 17865       users:(("systemd-journal",pid=362,fd=16),("systemd",pid=1,fd=94))
    u_str       ESTAB        0            0                                            * 20092                            * 22042       users:(("systemd-network",pid=400,fd=17))
    u_str       ESTAB        0            0                  /run/dbus/system_bus_socket 22043                            * 20093       users:(("dbus-daemon",pid=587,fd=11))
    u_str       ESTAB        0            0                  /run/dbus/system_bus_socket 22042                            * 20092       users:(("dbus-daemon",pid=587,fd=10))
    u_str       ESTAB        0            0                                            * 17264                            * 17738       users:(("systemd-udevd",pid=390,fd=2),("systemd-udevd",pid=390,fd=1))
    u_str       ESTAB        0            0                  /run/systemd/journal/stdout 20847                            * 19860       users:(("systemd-journal",pid=362,fd=24),("systemd",pid=1,fd=92))
    u_str       ESTAB        0            0                                            * 42713                            * 42712       users:(("lldpd",pid=13285,fd=6))
    u_str       ESTAB        0            0                  /run/systemd/journal/stdout 19236                            * 19599       users:(("systemd-journal",pid=362,fd=18),("systemd",pid=1,fd=93))
    u_str       ESTAB        0            0                                            * 20108                            * 22044       users:(("systemd",pid=1,fd=69))
    u_str       ESTAB        0            0                                            * 42712                            * 42713       users:(("lldpd",pid=13287,fd=5))
    u_str       ESTAB        0            0                                            * 19599                            * 19236       users:(("multipathd",pid=528,fd=2),("multipathd",pid=528,fd=1))
    u_str       ESTAB        0            0                  /run/systemd/journal/stdout 17738                            * 17264       users:(("systemd-journal",pid=362,fd=20),("systemd",pid=1,fd=95))
    u_str       ESTAB        0            0                                            * 59471                            * 58796       users:(("systemd",pid=14728,fd=20))
    u_str       ESTAB        0            0                  /run/systemd/journal/stdout 26607                            * 26917       users:(("systemd-journal",pid=362,fd=19),("systemd",pid=1,fd=83))
    u_str       ESTAB        0            0                  /run/systemd/journal/stdout 22535                            * 21733       users:(("systemd-journal",pid=362,fd=35),("systemd",pid=1,fd=86))
    u_str       ESTAB        0            0                  /run/systemd/journal/stdout 22529                            * 21568       users:(("systemd-journal",pid=362,fd=32),("systemd",pid=1,fd=87))
    u_str       ESTAB        0            0                                            * 59403                            * 0           users:(("sshd",pid=14763,fd=6),("sshd",pid=14715,fd=6))
    u_str       ESTAB        0            0                  /run/systemd/journal/stdout 21423                            * 20466       users:(("systemd-journal",pid=362,fd=31),("systemd",pid=1,fd=88))
    u_str       ESTAB        0            0                  /run/dbus/system_bus_socket 22455                            * 22454       users:(("dbus-daemon",pid=587,fd=15))
    u_str       ESTAB        0            0                                            * 26917                            * 26607       users:(("sshd",pid=2969,fd=2),("sshd",pid=2969,fd=1))
    u_str       ESTAB        0            0                  /run/dbus/system_bus_socket 58796                            * 59471       users:(("dbus-daemon",pid=587,fd=20))
    u_str       ESTAB        0            0                                            * 21733                            * 22535       users:(("systemd-logind",pid=617,fd=2),("systemd-logind",pid=617,fd=1))
    u_str       ESTAB        0            0                                            * 22454                            * 22455       users:(("polkitd",pid=653,fd=6))
    u_str       ESTAB        0            0                                            * 21568                            * 22529       users:(("irqbalance",pid=607,fd=2),("irqbalance",pid=607,fd=1))
    u_str       ESTAB        0            0                                            * 20466                            * 21423       users:(("networkd-dispat",pid=609,fd=2),("networkd-dispat",pid=609,fd=1))
```

   

5. Используя diagrams.net, создайте L3 диаграмму вашей домашней сети или любой другой сети, с которой вы работали. 
    ***Ответ:***

![alt](https://github.com/MrNavasardyan/devops-netology_navasardyan/blob/main/homework/img/3_6_8.PNG)
 ---
## Задание для самостоятельной отработки (необязательно к выполнению)

6*. Установите Nginx, настройте в режиме балансировщика TCP или UDP.

7*. Установите bird2, настройте динамический протокол маршрутизации RIP.

8*. Установите Netbox, создайте несколько IP префиксов, используя curl проверьте работу API.

 ---
