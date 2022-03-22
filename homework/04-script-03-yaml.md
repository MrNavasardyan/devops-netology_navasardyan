### Как сдавать задания

Вы уже изучили блок «Системы управления версиями», и начиная с этого занятия все ваши работы будут приниматься ссылками на .md-файлы, размещённые в вашем публичном репозитории.

Скопируйте в свой .md-файл содержимое этого файла; исходники можно посмотреть [здесь](https://raw.githubusercontent.com/netology-code/sysadm-homeworks/devsys10/04-script-03-yaml/README.md). Заполните недостающие части документа решением задач (заменяйте `???`, ОСТАЛЬНОЕ В ШАБЛОНЕ НЕ ТРОГАЙТЕ чтобы не сломать форматирование текста, подсветку синтаксиса и прочее, иначе можно отправиться на доработку) и отправляйте на проверку. Вместо логов можно вставить скриншоты по желани.

# Домашнее задание к занятию "4.3. Языки разметки JSON и YAML"


## Обязательная задача 1
Мы выгрузили JSON, который получили через API запрос к нашему сервису:
```
    { "info" : "Sample JSON output from our service\t",
        "elements" :[
            { "name" : "first",
            "type" : "server",
            "ip" : 7175 
            },
            { "name" : "second",
            "type" : "proxy",
            "ip : 71.78.22.43
            }
        ]
    }

    {
	"info": "Sample JSON output from our service\t",
	"elements": [
	{
		"name": "first",
		"type": "server",
		"ip": 7175
	},
	{
		"name": "second",
		"type": "proxy",
		"ip" : "71.78.22.43"
	}]
}
```
  Нужно найти и исправить все ошибки, которые допускает наш сервис

## Обязательная задача 2
В прошлый рабочий день мы создавали скрипт, позволяющий опрашивать веб-сервисы и получать их IP. К уже реализованному функционалу нам нужно добавить возможность записи JSON и YAML файлов, описывающих наши сервисы. Формат записи JSON по одному сервису: `{ "имя сервиса" : "его IP"}`. Формат записи YAML по одному сервису: `- имя сервиса: его IP`. Если в момент исполнения скрипта меняется IP у сервиса - он должен так же поменяться в yml и json файле.

### Ваш скрипт:
```python
import os
import socket
import time
import json
import yaml

s = {'drive.google.com':'10.10.0.0', 'mail.google.com':'172.4.0.0', 'google.com':'172.3.10.0'}

while True:
    for h in s:
        ping = os.system("ping -c 1 " + s[h] + '> /dev/null 2>&1')
        if ping != 0:
            new_ip = socket.gethostbyname(h)
            print('[ERROR]: ' + str(h) + ' IP mismatch: ' + s[h] + ' ' + new_ip)
            s[h]=new_ip
            with open(f'{h}'+'.json','w') as js:
                 json_data= json.dumps({h : new_ip})
                 jsf.write(json_data)
            with open(f'{h}'+'.yaml','w') as ym:
                 yaml_data= yaml.dump([{h : new_ip}])
                 ymf.write(yaml_data)
        else:
            print('[SUCCESS]: ' + str(h) + ' '+ s[h])
        time.sleep(10)
```

### Вывод скрипта при запуске при тестировании:
```
[root@node-2 ~]# python3 et.py
[ERROR]: drive.google.com IP mismatch: 10.10.0.0 172.217.16.142
[ERROR]: mail.google.com IP mismatch: 172.4.0.0 142.250.185.229
[ERROR]: google.com IP mismatch: 172.3.10.0 142.250.186.142
[SUCCESS]: drive.google.com 172.217.16.142
[SUCCESS]: mail.google.com 142.250.185.229
[SUCCESS]: google.com 142.250.186.142

[root@node-2 ~]# ll
total 4376
-rw-r--r--. 1 root root      38 Mar 22 16:19 drive.google.com.json
-rw-r--r--. 1 root root      37 Mar 22 16:19 drive.google.com.yaml
-rw-r--r--. 1 root root      33 Mar 22 16:19 google.com.json
-rw-r--r--. 1 root root      32 Mar 22 16:19 google.com.yaml
-rw-r--r--. 1 root root      38 Mar 22 16:19 mail.google.com.json
-rw-r--r--. 1 root root      37 Mar 22 16:19 mail.google.com.yaml
```

### json-файл(ы), который(е) записал ваш скрипт:
```json

[root@node-2 ~]# cat drive.google.com.json
{"drive.google.com": "172.217.16.142"}
[root@node-2 ~]# cat google.com.json
{"google.com": "142.250.186.142"}
[root@node-2 ~]# cat mail.google.com.json
{"mail.google.com": "142.250.185.229"}

```

### yml-файл(ы), который(е) записал ваш скрипт:
```yaml
[root@node-2 ~]# cat drive.google.com.yaml
- {drive.google.com: 172.217.16.142}
[root@node-2 ~]# cat google.com.yaml
- {google.com: 142.250.186.142}
[root@node-2 ~]# cat mail.google.com.yaml
- {mail.google.com: 142.250.185.229}

```

## Дополнительное задание (со звездочкой*) - необязательно к выполнению

Так как команды в нашей компании никак не могут прийти к единому мнению о том, какой формат разметки данных использовать: JSON или YAML, нам нужно реализовать парсер из одного формата в другой. Он должен уметь:
   * Принимать на вход имя файла
   * Проверять формат исходного файла. Если файл не json или yml - скрипт должен остановить свою работу
   * Распознавать какой формат данных в файле. Считается, что файлы *.json и *.yml могут быть перепутаны
   * Перекодировать данные из исходного формата во второй доступный (из JSON в YAML, из YAML в JSON)
   * При обнаружении ошибки в исходном файле - указать в стандартном выводе строку с ошибкой синтаксиса и её номер
   * Полученный файл должен иметь имя исходного файла, разница в наименовании обеспечивается разницей расширения файлов

### Ваш скрипт:
```python
???
```

### Пример работы скрипта:
???
