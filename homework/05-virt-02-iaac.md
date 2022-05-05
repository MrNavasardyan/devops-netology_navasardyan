
# Домашнее задание к занятию "5.2. Применение принципов IaaC в работе с виртуальными машинами"

## Как сдавать задания

Обязательными к выполнению являются задачи без указания звездочки. Их выполнение необходимо для получения зачета и диплома о профессиональной переподготовке.

Задачи со звездочкой (*) являются дополнительными задачами и/или задачами повышенной сложности. Они не являются обязательными к выполнению, но помогут вам глубже понять тему.

Домашнее задание выполните в файле readme.md в github репозитории. В личном кабинете отправьте на проверку ссылку на .md-файл в вашем репозитории.

Любые вопросы по решению задач задавайте в чате учебной группы.

---

## Задача 1

- Опишите своими словами основные преимущества применения на практике IaaC паттернов.
  ```
  IaC — это процесс управления и провизионирования датацентров и серверов с помощью машиночитаемых файлов определений, созданный как альтернатива физическому конфигурированию оборудования и оперируемым человеком инструментам. Теперь, вместо того, чтобы запускать сотню различных файлов конфигурации, IaC позволяет нам просто запускать скрипт, который каждое утро поднимает тысячу дополнительных машин, а вечером автоматически сокращает инфраструктуру до приемлемого вечернего масштаба.
  ```
- Какой из принципов IaaC является основополагающим?
  ```
  Основополагающем принципом, в рамках IaaC, является обеспеченеи идемпотентности. 
  ```
## Задача 2

- Чем Ansible выгодно отличается от других систем управление конфигурациями?
- Какой, на ваш взгляд, метод работы систем конфигурации более надёжный push или pull? 
  ```
  Преимущества Ansible по сравнению с другими аналогичными решениями:
  - на управляемые узлы не нужно устанавливать никакого дополнительного ПО, всё работает через SSH (в случае необходимости дополнительные модули можно взять из официального репозитория);
  - код программы, написанный на Python, очень прост; при необходимости написание дополнительных модулей не составляет особого труда;
  язык, на котором пишутся сценарии, также предельно прост;
  - низкий порог вхождения: обучиться работе с Ansible можно за очень короткое время;
  - документация к продукту написана очень подробно и вместе с тем — просто и понятно; она регулярно обновляется;
  - Ansible работает не только в режиме push, но и pull
  - имеется возможность последовательного обновления состояния узлов (rolling update).
  ```

## Задача 3

Установить на личный компьютер:

- VirtualBox
- Vagrant
- Ansible

 VirtualBox
 ```
 [root@node-1 ~]# VBoxManage --version
    6.1.34r150636
 ```
 Vagrant
 ```
 [root@node-1 ~]# vagrant --version
  Vagrant 2.2.19
 ```
 Ansible
 ```
 [root@node-1 ~]# ansible --version
    ansible 2.9.27
  config file = /etc/ansible/ansible.cfg
  configured module search path = ['/root/.ansible/plugins/modules', '/usr/share/ansible/plugins/modules']
  ansible python module location = /usr/lib/python3.6/site-packages/ansible
  executable location = /bin/ansible
  python version = 3.6.8 (default, Sep 10 2021, 09:13:53) [GCC 8.5.0 20210514 (Red Hat 8.5.0-3)]
 ```

*Приложить вывод команд установленных версий каждой из программ, оформленный в markdown.*

## Задача 4 (*)

Воспроизвести практическую часть лекции самостоятельно.

- Создать виртуальную машину.
- Зайти внутрь ВМ, убедиться, что Docker установлен с помощью команды
```
[root@node-1 vagrant]# vagrant up
Bringing machine 'server1.navasardyan' up with 'virtualbox' provider...
==> server1.navasardyan: Checking if box 'bento/ubuntu-20.04' version '202112.19.0' is up to date...
==> server1.navasardyan: Clearing any previously set forwarded ports...
==> server1.navasardyan: Clearing any previously set network interfaces...
==> server1.navasardyan: Preparing network interfaces based on configuration...
    server1.navasardyan: Adapter 1: nat
    server1.navasardyan: Adapter 2: hostonly
==> server1.navasardyan: Forwarding ports...
    server1.navasardyan: 22 (guest) => 20011 (host) (adapter 1)
    server1.navasardyan: 22 (guest) => 2222 (host) (adapter 1)
==> server1.navasardyan: Running 'pre-boot' VM customizations...
==> server1.navasardyan: Booting VM...
==> server1.navasardyan: Waiting for machine to boot. This may take a few minutes...
    server1.navasardyan: SSH address: 127.0.0.1:2222
    server1.navasardyan: SSH username: vagrant
    server1.navasardyan: SSH auth method: private key
    server1.navasardyan: Warning: Remote connection disconnect. Retrying...
    server1.navasardyan: Warning: Connection reset. Retrying...
    server1.navasardyan: Warning: Remote connection disconnect. Retrying...
==> server1.navasardyan: Machine booted and ready!
==> server1.navasardyan: Checking for guest additions in VM...
==> server1.navasardyan: Setting hostname...
==> server1.navasardyan: Configuring and enabling network interfaces...
==> server1.navasardyan: Mounting shared folders...
    server1.navasardyan: /vagrant => /root/vagrant/vagrant
==> server1.navasardyan: Machine already provisioned. Run `vagrant provision` or use the `--provision`
==> server1.navasardyan: flag to force provisioning. Provisioners marked to run always will still run.
[root@node-1 vagrant]# vagrant provision
==> server1.navasardyan: Running provisioner: ansible...
    server1.navasardyan: Running ansible-playbook...

PLAY [nodes] *******************************************************************

TASK [Gathering Facts] *********************************************************
ok: [server1.navasardyan]

TASK [Create directory for ssh-keys] *******************************************
ok: [server1.navasardyan]

TASK [Adding rsa-key in /root/.ssh/authorized_keys] ****************************
changed: [server1.navasardyan]

TASK [Checking DNS] ************************************************************
changed: [server1.navasardyan]

TASK [Installing tools] ********************************************************
ok: [server1.navasardyan] => (item=— git — curl)

TASK [Installing docker] *******************************************************

changed: [server1.navasardyan]

TASK [Add the current user to docker group] ************************************
changed: [server1.navasardyan]

PLAY RECAP *********************************************************************
server1.navasardyan        : ok=7    changed=4    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

[root@node-1 vagrant]#
[root@node-1 vagrant]# vagrant ssh
Welcome to Ubuntu 20.04.3 LTS (GNU/Linux 5.4.0-91-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

 System information disabled due to load higher than 1.0


This system is built by the Bento project by Chef Software
More information can be found at https://github.com/chef/bento
Last login: Thu May  5 12:02:22 2022 from 10.0.2.2
vagrant@server1:~$ docker --version
Docker version 20.10.14, build a224086
vagrant@server1:~$ docker ps
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES
```