# Домашнее задание к занятию "5.5. Оркестрация кластером Docker контейнеров на примере Docker Swarm"

## Задача 1

Дайте письменые ответы на следующие вопросы:

- В чём отличие режимов работы сервисов в Docker Swarm кластере: replication и global?
  ```
  replication запускает сервис на всех нодах, тогда как replication-только на указанных нодах в конфигурацц
  ```
- Какой алгоритм выбора лидера используется в Docker Swarm кластере?
  ```
  Raft — алгоритм для решения задач консенсуса в сети ненадёжных вычислений. Raft обеспечивает безопасную и эффективную реализацию машины состояний поверх кластерной вычислительной системы
  ```
- Что такое Overlay Network?
  ```
  Логическая сеть создаваемая поверх другой сети,  в случае с docker повзоляет обмениваться информацией между контеейнерами.
  ```

## Задача 2

Создать ваш первый Docker Swarm кластер в Яндекс.Облаке

Для получения зачета, вам необходимо предоставить скриншот из терминала (консоли), с выводом команды:
```
docker node ls

[root@node01 ~]# docker node ls
ID                            HOSTNAME             STATUS    AVAILABILITY   MANAGER STATUS   ENGINE VERSION
e8dxlafpmq5llv5vpkg5k66dp *   node01.netology.yc   Ready     Active         Leader           20.10.16
yrl4ekb85zklwzjo90kbo1k96     node02.netology.yc   Ready     Active         Reachable        20.10.16
wvgoiifezrttvqr8qilvzq9m0     node03.netology.yc   Ready     Active         Reachable        20.10.16
g729a4eb2x9fq6m44twwe8bcm     node04.netology.yc   Ready     Active                          20.10.16
mm8b709id2unz5xmohxd3f105     node05.netology.yc   Ready     Active                          20.10.16
c7ggvl81doa2zwc3e35a2uj44     node06.netology.yc   Ready     Active                          20.10.16
```
![](img/05-virt-05-docker-swarm_1.PNG)

## Задача 3

Создать ваш первый, готовый к боевой эксплуатации кластер мониторинга, состоящий из стека микросервисов.

Для получения зачета, вам необходимо предоставить скриншот из терминала (консоли), с выводом команды:
```
docker service ls

[root@node01 ~]# docker service ls
ID             NAME                                MODE         REPLICAS   IMAGE                                          PORTS
su17h55lgxy4   swarm_monitoring_alertmanager       replicated   1/1        stefanprodan/swarmprom-alertmanager:v0.14.0
uzmcjavaydqf   swarm_monitoring_caddy              replicated   1/1        stefanprodan/caddy:latest                      *:3000->3000/tcp, *:9090->9090/tcp, *:9093-9094->9093-9094/tcp
m3ei11v12iyd   swarm_monitoring_cadvisor           global       6/6        google/cadvisor:latest
66l5yoalhf43   swarm_monitoring_dockerd-exporter   global       6/6        stefanprodan/caddy:latest
h59slmugfhhm   swarm_monitoring_grafana            replicated   1/1        stefanprodan/swarmprom-grafana:5.3.4
76zpagysgapc   swarm_monitoring_node-exporter      global       6/6        stefanprodan/swarmprom-node-exporter:v0.16.0
klpahj9wyz2m   swarm_monitoring_prometheus         replicated   1/1        stefanprodan/swarmprom-prometheus:v2.5.0
vect8gqvwvjg   swarm_monitoring_unsee              replicated   1/1        cloudflare/unsee:v0.8.0
```

![](img/05-virt-05-docker-swarm_2.PNG)

## Задача 4 (*)

Выполнить на лидере Docker Swarm кластера команду (указанную ниже) и дать письменное описание её функционала, что она делает и зачем она нужна:
```
# см.документацию: https://docs.docker.com/engine/swarm/swarm_manager_locking/
docker swarm update --autolock=true


docker swarm update --autolock=true

Данная команда обеспечивает безопасность хранение трафика, логов, ключей шифрования, при рестарте все это помещается в память менеджеров. Пользователь становится владельцем заблокированных ключей. Чтобы разблокировать необходимо использовать ключ выданный при блокировке

[root@node01 ~]# docker swarm update --autolock=true
Swarm updated.
To unlock a swarm manager after it restarts, run the `docker swarm unlock`
command and provide the following key:

    SWMKEY-1-5M0zatCA4ZhflLCLLoKljGFl9si51D0OGpdCkRaVVqY

Please remember to store this key in a password manager, since without it you
will not be able to restart the manager.
[root@node01 ~]# service docker restart
Redirecting to /bin/systemctl restart docker.service
[root@node01 ~]# docker service ls
Error response from daemon: Swarm is encrypted and needs to be unlocked before it can be used. Please use "docker swarm unlock" to unlock it.
[root@node01 ~]# docker swarm unlock
Please enter unlock key:
[root@node01 ~]# docker service ls
ID             NAME                                MODE         REPLICAS   IMAGE                                          PORTS
rtyeq2zctxcr   swarm_monitoring_alertmanager       replicated   0/1        stefanprodan/swarmprom-alertmanager:v0.14.0
xcrdhag8ofip   swarm_monitoring_caddy              replicated   1/1        stefanprodan/caddy:latest                      *:3000->3000/tcp, *:9090->9090/tcp, *:9093-9094->9093-9094/tcp
17b7tgvfv40j   swarm_monitoring_cadvisor           global       5/5        google/cadvisor:latest
5rk3xvzjj0oi   swarm_monitoring_dockerd-exporter   global       5/5        stefanprodan/caddy:latest
oio4stv3f7yq   swarm_monitoring_grafana            replicated   1/1        stefanprodan/swarmprom-grafana:5.3.4
tlb3xg0pig0p   swarm_monitoring_node-exporter      global       5/5        stefanprodan/swarmprom-node-exporter:v0.16.0
nuqdfv2tb557   swarm_monitoring_prometheus         replicated   0/1        stefanprodan/swarmprom-prometheus:v2.5.0
vnzs16gmjh4w   swarm_monitoring_unsee              replicated   1/1        cloudflare/unsee:v0.8.0

```