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