# Домашнее задание к занятию "3.3. Операционные системы, лекция 1"

1. Какой системный вызов делает команда `cd`? В прошлом ДЗ мы выяснили, что `cd` не является самостоятельной  программой, это `shell builtin`, поэтому запустить `strace` непосредственно на `cd` не получится. Тем не менее, вы можете запустить `strace` на `/bin/bash -c 'cd /tmp'`. В этом случае вы увидите полный список системных вызовов, которые делает сам `bash` при старте. Вам нужно найти тот единственный, который относится именно к `cd`. Обратите внимание, что `strace` выдаёт результат своей работы в поток stderr, а не в stdout.
   
   **Ответ:**
   ```
   vagrant@vagrant:~$ strace /bin/bash -c 'cd /tmp' 2>&1 | grep cd
   execve("/bin/bash", ["/bin/bash", "-c", "cd /tmp"], 0x7ffe6ed7e780 /* 24 vars */) = 0
   Системный вызов chdir("/tmp")
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
    ```
    echo > file1.txt
    /home/vagrant/.file1.txt.swp
    открытый удаленный файл расположен по адресу /proc/1333/fd/4 , где 1333 - PID
    
    ```

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
