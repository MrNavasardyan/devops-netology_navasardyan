# Домашнее задание к занятию "3.1. Работа в терминале, лекция 1"] 
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

