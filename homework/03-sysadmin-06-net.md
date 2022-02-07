# Домашнее задание к занятию "3.6. Компьютерные сети, лекция 1"
1. Работа c HTTP через телнет.
- Подключитесь утилитой телнет к сайту stackoverflow.com
`telnet stackoverflow.com 80`
- отправьте HTTP запрос
```bash
GET /questions HTTP/1.0
HOST: stackoverflow.com
[press enter]
[press enter]
```
- В ответе укажите полученный HTTP код, что он означает?

***Ответ:***
```
Получен код ответа 301, показывает, что запрошенный ресурс был окончательно перемещён в URL, указанный в заголовке Location (en-US), в данном случае это https://stackoverflow.com/questions
HTTP/1.1 301 Moved Permanently
cache-control: no-cache, no-store, must-revalidate
location: https://stackoverflow.com/questions
x-request-guid: 3096935f-3b13-48b5-a3ca-9debe33af4a9
feature-policy: microphone 'none'; speaker 'none'
content-security-policy: upgrade-insecure-requests; frame-ancestors 'self' https://stackexchange.com
Accept-Ranges: bytes
Date: Mon, 07 Feb 2022 17:39:10 GMT
Via: 1.1 varnish
Connection: close
X-Served-By: cache-hhn4051-HHN
X-Cache: MISS
X-Cache-Hits: 0
X-Timer: S1644255551.848695,VS0,VE78
Vary: Fastly-SSL
X-DNS-Prefetch-Control: off
Set-Cookie: prov=a6dfb53e-06af-9052-2f3e-39c1a5377fe0; domain=.stackoverflow.com; expires=Fri, 01-Jan-2055 00:00:00 GMT; path=/; HttpOnly
```
2. Повторите задание 1 в браузере, используя консоль разработчика F12.
- откройте вкладку `Network`
- отправьте запрос http://stackoverflow.com
- найдите первый ответ HTTP сервера, откройте вкладку `Headers`
- укажите в ответе полученный HTTP код.
- проверьте время загрузки страницы, какой запрос обрабатывался дольше всего?
- приложите скриншот консоли браузера в ответ.
***Ответ:***
```
-Был получен код Status Code: 307 Internal Redirect, означает, что запрошенный ресурс был временно перемещён в URL-адрес, указанный в заголовке Location (en-US), в данном случае https://stackoverflow.com/
-Дольше всего обрабатывался запрос загрузки скрипта:
Request URL: https://cdn.sstatic.net/Js/full-anon.en.js?v=0ae96d7d0c87
Request Method: GET
Status Code: 200
```

![alt](img/3_6_1.png)

3. Какой IP адрес у вас в интернете?
   
   ***Ответ:***
![alt](img/3_6_2.png)   

4. Какому провайдеру принадлежит ваш IP адрес? Какой автономной системе AS? Воспользуйтесь утилитой `whois`

    ***Ответ:***
    ```
    vagrant@vagrant:~$ whois -h whois.radb.net 185.76.221.239
    route:          185.76.220.0/22
    origin:         AS41148
    mnt-by:         MNT-ZOLOTAYALINIA
    created:        2020-10-23T06:55:20Z
    last-modified:  2020-10-23T06:55:20Z
    source:         RIPE
    remarks:        ****************************
    remarks:        * THIS OBJECT IS MODIFIED
    remarks:        * Please note that all data that is generally regarded as personal
    remarks:        * data has been removed from this object.
    remarks:        * To view the original object, please query the RIPE Database at:
    remarks:        * http://www.ripe.net/whois
    remarks:        ****************************
    ```

5. Через какие сети проходит пакет, отправленный с вашего компьютера на адрес 8.8.8.8? Через какие AS? Воспользуйтесь утилитой `traceroute`
   
   ***Ответ:***
    ```
        С виртуалки Vagrant получаю такие данные:

        1  10.0.2.2 [*]  0.246 ms  0.227 ms  0.188 ms
        2  * * *
        3  * * *
        4  * * *
        5  * * *
        6  * * *
        7  * * *
        8  * * *
        9  * * *
        10  * * *
        11  * * *
        12  * * *
        13  * * *
        14  * * *
        15  * * *
        16  * * *
        17  * * *
        18  * * *
        19  * * *
        20  * * *
        21  * * *
        22  * * *
        23  * * *
        24  * * *
        25  * * *
        26  * * *
        27  * * *
        28  * * *
        29  * * *
        30  * * *
        Но если сделать ping:
        vagrant@vagrant:~$ ping -c 4 8.8.8.8
        PING 8.8.8.8 (8.8.8.8) 56(84) bytes of data.
        64 bytes from 8.8.8.8: icmp_seq=1 ttl=111 time=36.0 ms
        64 bytes from 8.8.8.8: icmp_seq=2 ttl=108 time=37.9 ms
        64 bytes from 8.8.8.8: icmp_seq=3 ttl=111 time=35.7 ms
        64 bytes from 8.8.8.8: icmp_seq=4 ttl=110 time=37.3 ms
        --- 8.8.8.8 ping statistics ---
        4 packets transmitted, 4 received, 0% packet loss, time 3006ms
        rtt min/avg/max/mdev = 35.718/36.734/37.918/0.890 ms
    ```

6. Повторите задание 5 в утилите `mtr`. На каком участке наибольшая задержка - delay?

***Ответ:***
![alt](img/3_6_3.png)

    Наибольшая задержка на участке 11. AS15169  216.239.51.32

7. Какие DNS сервера отвечают за доменное имя dns.google? Какие A записи? воспользуйтесь утилитой `dig`
   
   ***Ответ:***
   ```
   gmail.com.              300     IN      A       216.58.210.133
   ```

8. Проверьте PTR записи для IP адресов из задания 7. Какое доменное имя привязано к IP? воспользуйтесь утилитой `dig`
   ```
   vagrant@vagrant:~$ dig -x 216.58.210.133

    ; <<>> DiG 9.16.1-Ubuntu <<>> -x 216.58.210.133
    ;; global options: +cmd
    ;; Got answer:
    ;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 13843
    ;; flags: qr rd ra; QUERY: 1, ANSWER: 3, AUTHORITY: 0, ADDITIONAL: 1

    ;; OPT PSEUDOSECTION:
    ; EDNS: version: 0, flags:; udp: 65494
    ;; QUESTION SECTION:
    ;133.210.58.216.in-addr.arpa.   IN      PTR

    ;; ANSWER SECTION:
    133.210.58.216.in-addr.arpa. 3600 IN    PTR     mad06s09-in-f133.1e100.net.
    133.210.58.216.in-addr.arpa. 3600 IN    PTR     hem08s06-in-f5.1e100.net.
    133.210.58.216.in-addr.arpa. 3600 IN    PTR     mad06s09-in-f5.1e100.net.

    ;; Query time: 115 msec
    ;; SERVER: 127.0.0.53#53(127.0.0.53)
    ;; WHEN: Mon Feb 07 18:49:33 UTC 2022
    ;; MSG SIZE  rcvd: 154
    привязаны следующие имена:
    mad06s09-in-f133.1e100.net.
    hem08s06-in-f5.1e100.net.
    mad06s09-in-f5.1e100.net.
   ```
   
В качестве ответов на вопросы можно приложите лог выполнения команд в консоли или скриншот полученных результатов.

---