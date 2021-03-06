### Как сдавать задания

Вы уже изучили блок «Системы управления версиями», и начиная с этого занятия все ваши работы будут приниматься ссылками на .md-файлы, размещённые в вашем публичном репозитории.

Скопируйте в свой .md-файл содержимое этого файла; исходники можно посмотреть [здесь](https://raw.githubusercontent.com/netology-code/sysadm-homeworks/devsys10/04-script-02-py/README.md). Заполните недостающие части документа решением задач (заменяйте `???`, ОСТАЛЬНОЕ В ШАБЛОНЕ НЕ ТРОГАЙТЕ чтобы не сломать форматирование текста, подсветку синтаксиса и прочее, иначе можно отправиться на доработку) и отправляйте на проверку. Вместо логов можно вставить скриншоты по желани.

# Домашнее задание к занятию "4.2. Использование Python для решения типовых DevOps задач"

## Обязательная задача 1

Есть скрипт:
```python
#!/usr/bin/env python3
a = 1
b = '2'
c = a + b
```

### Вопросы:
| Вопрос  | Ответ |
| ------------- | ------------- |
| Какое значение будет присвоено переменной `c`?  | TypeError: unsupported operand type(s) for +: 'int' and 'str'  |
| Как получить для переменной `c` значение 12?  | c=str(a)+b  |
| Как получить для переменной `c` значение 3?  | c=a+int(b)  |

## Обязательная задача 2
Мы устроились на работу в компанию, где раньше уже был DevOps Engineer. Он написал скрипт, позволяющий узнать, какие файлы модифицированы в репозитории, относительно локальных изменений. Этим скриптом недовольно начальство, потому что в его выводе есть не все изменённые файлы, а также непонятен полный путь к директории, где они находятся. Как можно доработать скрипт ниже, чтобы он исполнял требования вашего руководителя?

```python
#!/usr/bin/env python3

import os

bash_command = ["cd ~/netology/sysadm-homeworks", "git status"]
result_os = os.popen(' && '.join(bash_command)).read()
is_change = False
for result in result_os.split('\n'):
    if result.find('modified') != -1:
        prepare_result = result.replace('\tmodified:   ', '')
        print(prepare_result)
        break
```

### Ваш скрипт:
```python
#!/usr/bin/env python3

import os

bash_command = ["cd /home/homework/devops-netology_navasardyan", "git status"]
path = os.getcwd() # доработка с путями
result_os = os.popen(' && '.join(bash_command)).read()
#is_change = False нигде не используется
for result in result_os.split('\n'):
    if result.find('modified') != -1:
        prepare_result = result.replace('\tmodified:   ', '')
        print(path + ' ' + prepare_result)
        #break так же требуется убрать,т.к. прерывает цикл

```

### Вывод скрипта при запуске при тестировании:
```
изменил файлы в локальном репозитории README.md 
[root@node-1 devops-netology_navasardyan]# python3 script1.py
/home/homework/devops-netology_navasardyan README.md

README.md

```

## Обязательная задача 3
1. Доработать скрипт выше так, чтобы он мог проверять не только локальный репозиторий в текущей директории, а также умел воспринимать путь к репозиторию, который мы передаём как входной параметр. Мы точно знаем, что начальство коварное и будет проверять работу этого скрипта в директориях, которые не являются локальными репозиториями.

### Ваш скрипт:
```python

#!/usr/bin/env python3

import os
import sys

path = os.getcwd()

def checking(result_os):
       for result in result_os.split('\n'):
                if result.find('modified') != -1:
                        prepare_result = result.replace('\tmodified:   ', '')
                        print(path + ' ' + prepare_result)

if len(sys.argv) == 2:
        path = sys.argv[1]
        bash_path = ["cd " + path, "git status"]
        result_os = os.popen(' && '.join(bash_path)).read()
        res=checking(result_os)
else:
        bash_command = [f"cd {path}", "git status"]
        result_os = os.popen(' && '.join(bash_command)).read()
        res=checking(result_os)

```

### Вывод скрипта при запуске при тестировании:
```
[root@node-1 JSFREE-4]# python3 scripttt.py
/home/JSFREE-4 README.md

[root@node-1 JSFREE-4]# python3 scripttt.py /home/devops-netology_navasardyan/
/home/devops-netology_navasardyan/README.md

[root@node-1 ~]# python3 scripttt.py
fatal: not a git repository (or any of the parent directories): .git

```

## Обязательная задача 4
1. Наша команда разрабатывает несколько веб-сервисов, доступных по http. Мы точно знаем, что на их стенде нет никакой балансировки, кластеризации, за DNS прячется конкретный IP сервера, где установлен сервис. Проблема в том, что отдел, занимающийся нашей инфраструктурой очень часто меняет нам сервера, поэтому IP меняются примерно раз в неделю, при этом сервисы сохраняют за собой DNS имена. Это бы совсем никого не беспокоило, если бы несколько раз сервера не уезжали в такой сегмент сети нашей компании, который недоступен для разработчиков. Мы хотим написать скрипт, который опрашивает веб-сервисы, получает их IP, выводит информацию в стандартный вывод в виде: <URL сервиса> - <его IP>. Также, должна быть реализована возможность проверки текущего IP сервиса c его IP из предыдущей проверки. Если проверка будет провалена - оповестить об этом в стандартный вывод сообщением: [ERROR] <URL сервиса> IP mismatch: <старый IP> <Новый IP>. Будем считать, что наша разработка реализовала сервисы: `drive.google.com`, `mail.google.com`, `google.com`.



### Ваш скрипт:
```python
# import os
# import socket
# import time
# import requests

# s = {'drive.google.com':'10.10.0.0', 'mail.google.com':'172.4.0.0', 'google.com':'172.3.10.0'}

# while True: # Цикл сделал бесконечным, понимаю что он должен опрашивать постоянно?
#         for h in s:
#                 #ping = os.system("ping -c 1 " + s[h] + '> /dev/null 2>&1')
#                 if ping != 0:
#                         new_ip = socket.gethostbyname(h)
#                         print('[ERROR]: ' + str(h) + ' IP mismatch: ' + s[h] + ' ' + new_ip)
#                         s[h]=new_ip # Добавил замену старого IP на новый, чтобы при следующей итерации подставлялся новый, просьба подсказать корректно ли это?
#                 else:
#                         print('[SUCCESS]: ' + str(h) + ' '+ s[h])
#         time.sleep(10)
        
Доработка без использования bash:

import socket
import time
from pythonping import ping


s = {'drive.google.com':'10.0.0.0', 'mail.google.com':'172.4.0.0', 'google.com':'172.3.0.0'}

while True:
        for h in s:
                print(s[h])
                p = ping(s[h], verbose=True)

                if p.success():
                        print('[SUCCESS]: ' + str(h) + ' ' + s[h])

                else:
                        new_ip = socket.gethostbyname(h)
                        print('[ERROR]: ' + str(h) + ' IP mismatch: ' + s[h] + ' ' + new_ip)
                        s[h] = new_ip

        time.sleep(10)

```

### Вывод скрипта при запуске при тестировании:
```
10.0.0.0
Request timed out
Request timed out
Request timed out
Request timed out
Request timed out
Request timed out
Request timed out
Request timed out

Round Trip Times min/avg/max is 2000/2000.0/2000 ms
[ERROR]: drive.google.com IP mismatch: 10.0.0.0 209.85.233.100
172.4.0.0
Request timed out
Request timed out
Request timed out
Request timed out
Request timed out
Request timed out
Request timed out
Request timed out

Round Trip Times min/avg/max is 2000/2000.0/2000 ms
[ERROR]: mail.google.com IP mismatch: 172.4.0.0 64.233.165.18
172.3.0.0
Request timed out
Request timed out
Request timed out
Request timed out
Request timed out
Request timed out
Request timed out
Request timed out

Round Trip Times min/avg/max is 2000/2000.0/2000 ms
[ERROR]: google.com IP mismatch: 172.3.0.0 142.250.150.138
209.85.233.100
Reply from 209.85.233.100, 29 bytes in 74.73ms
Reply from 209.85.233.100, 29 bytes in 71.22ms
Reply from 209.85.233.100, 29 bytes in 71.52ms
Reply from 209.85.233.100, 29 bytes in 70.96ms
Reply from 209.85.233.100, 29 bytes in 74.73ms
Reply from 209.85.233.100, 29 bytes in 71.22ms
Reply from 209.85.233.100, 29 bytes in 71.52ms
Reply from 209.85.233.100, 29 bytes in 70.96ms

Round Trip Times min/avg/max is 70.96/72.11/74.73 ms
[SUCCESS]: drive.google.com 209.85.233.100
64.233.165.18
Reply from 64.233.165.18, 29 bytes in 34.52ms
Reply from 64.233.165.18, 29 bytes in 33.21ms
Reply from 64.233.165.18, 29 bytes in 34.31ms
Reply from 64.233.165.18, 29 bytes in 32.68ms
Reply from 64.233.165.18, 29 bytes in 34.52ms
Reply from 64.233.165.18, 29 bytes in 33.21ms
Reply from 64.233.165.18, 29 bytes in 34.31ms
Reply from 64.233.165.18, 29 bytes in 32.68ms

Round Trip Times min/avg/max is 32.68/33.68/34.52 ms
[SUCCESS]: mail.google.com 64.233.165.18
142.250.150.138
Reply from 142.250.150.138, 29 bytes in 33.97ms
Reply from 142.250.150.138, 29 bytes in 35.89ms
Reply from 142.250.150.138, 29 bytes in 33.97ms
Reply from 142.250.150.138, 29 bytes in 37.89ms
Reply from 142.250.150.138, 29 bytes in 33.97ms
Reply from 142.250.150.138, 29 bytes in 35.89ms
Reply from 142.250.150.138, 29 bytes in 33.97ms
Reply from 142.250.150.138, 29 bytes in 37.89ms

Round Trip Times min/avg/max is 33.97/35.43/37.89 ms
[SUCCESS]: google.com 142.250.150.138

```

## Дополнительное задание (со звездочкой*) - необязательно к выполнению

Так получилось, что мы очень часто вносим правки в конфигурацию своей системы прямо на сервере. Но так как вся наша команда разработки держит файлы конфигурации в github и пользуется gitflow, то нам приходится каждый раз переносить архив с нашими изменениями с сервера на наш локальный компьютер, формировать новую ветку, коммитить в неё изменения, создавать pull request (PR) и только после выполнения Merge мы наконец можем официально подтвердить, что новая конфигурация применена. Мы хотим максимально автоматизировать всю цепочку действий. Для этого нам нужно написать скрипт, который будет в директории с локальным репозиторием обращаться по API к github, создавать PR для вливания текущей выбранной ветки в master с сообщением, которое мы вписываем в первый параметр при обращении к py-файлу (сообщение не может быть пустым). При желании, можно добавить к указанному функционалу создание новой ветки, commit и push в неё изменений конфигурации. С директорией локального репозитория можно делать всё, что угодно. Также, принимаем во внимание, что Merge Conflict у нас отсутствуют и их точно не будет при push, как в свою ветку, так и при слиянии в master. Важно получить конечный результат с созданным PR, в котором применяются наши изменения. 

### Ваш скрипт:
```python
???
```

### Вывод скрипта при запуске при тестировании:
```
???
```
