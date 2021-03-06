# Домашнее задание к занятию "6.5. Elasticsearch"

## Задача 1

В этом задании вы потренируетесь в:
- установке elasticsearch
- первоначальном конфигурировании elastcisearch
- запуске elasticsearch в docker

Используя докер образ [centos:7](https://hub.docker.com/_/centos) как базовый и 
[документацию по установке и запуску Elastcisearch](https://www.elastic.co/guide/en/elasticsearch/reference/current/targz.html):

- составьте Dockerfile-манифест для elasticsearch
- соберите docker-образ и сделайте `push` в ваш docker.io репозиторий
- запустите контейнер из получившегося образа и выполните запрос пути `/` c хост-машины

Требования к `elasticsearch.yml`:
- данные `path` должны сохраняться в `/var/lib`
- имя ноды должно быть `netology_test`

В ответе приведите:
- текст Dockerfile манифеста
```
FROM centos:centos7

RUN yum -y install wget && yum clean all && \
        groupadd --gid 1000 elasticsearch && \
        adduser --uid 1000 --gid 1000 --home /usr/share/elasticsearch elasticsearch && \
        mkdir /var/lib/elasticsearch/ && \
        chown -R 1000:1000 /var/lib/elasticsearch/

USER 1000:1000

WORKDIR /usr/share/elasticsearch

ENV EL_VER=8.2.2

RUN wget -q https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-${EL_VER}-linux-x86_64.tar.gz && \
        tar -xzf elasticsearch-${EL_VER}-linux-x86_64.tar.gz && \
        cp -rp elasticsearch-${EL_VER}/* ./ && \
        rm -rf elasticsearch-${EL_VER}*

COPY ./config/elasticsearch.yml /usr/share/elasticsearch/config/

VOLUME [ "/opt/elasticsearch-data", "/opt/elasticsearch-logs" ]

EXPOSE 9200

CMD ["bin/elasticsearch"]
```
- ссылку на образ в репозитории dockerhub
```
https://hub.docker.com/repository/docker/ngrachik/elastic
```
  
- ответ `elasticsearch` на запрос пути `/` в json виде

```
[root@node-2 ~]# curl http://localhost:9200/?format=json
{
  "name" : "netology_test",
  "cluster_name" : "elasticsearch",
  "cluster_uuid" : "4QvPt8cYQ3KvA_MyNd6QIg",
  "version" : {
    "number" : "7.17.0",
    "build_flavor" : "default",
    "build_type" : "tar",
    "build_hash" : "bee86328705acaa9a6daede7140defd4d9ec56bd",
    "build_date" : "2022-01-28T08:36:04.875279988Z",
    "build_snapshot" : false,
    "lucene_version" : "8.11.1",
    "minimum_wire_compatibility_version" : "6.8.0",
    "minimum_index_compatibility_version" : "6.0.0-beta1"
  },
  "tagline" : "You Know, for Search"
}
```

Далее мы будем работать с данным экземпляром elasticsearch.

## Задача 2

В этом задании вы научитесь:
- создавать и удалять индексы
- изучать состояние кластера
- обосновывать причину деградации доступности данных

Ознакомтесь с [документацией](https://www.elastic.co/guide/en/elasticsearch/reference/current/indices-create-index.html) 
и добавьте в `elasticsearch` 3 индекса, в соответствии со таблицей:

| Имя | Количество реплик | Количество шард |
|-----|-------------------|-----------------|
| ind-1| 0 | 1 |
| ind-2 | 1 | 2 |
| ind-3 | 2 | 4 |

Получите список индексов и их статусов, используя API и **приведите в ответе** на задание.
```
[root@node-2 ~]# curl -X PUT http://localhost:9200/ind-1?pretty -H 'Content-Type: application/json' -d'{ "settings": { "index": { "number_of_shards": 1, "number_of_replicas": 0 }}}'
{
  "acknowledged" : true,
  "shards_acknowledged" : true,
  "index" : "ind-1"
}
[root@node-2 ~]# curl -X PUT http://localhost:9200/ind-2?pretty -H 'Content-Type: application/json' -d'{ "settings": { "index": { "number_of_shards": 2, "number_of_replicas": 1 }}}'
{
  "acknowledged" : true,
  "shards_acknowledged" : true,
  "index" : "ind-2"
}
[root@node-2 ~]# curl -X PUT http://localhost:9200/ind-3?pretty -H 'Content-Type: application/json' -d'{ "settings": { "index": { "number_of_shards": 4, "number_of_replicas": 2 }}}'
{
  "acknowledged" : true,
  "shards_acknowledged" : true,
  "index" : "ind-3"
}
```
Получите состояние кластера `elasticsearch`, используя API.
```
[root@node-2 ~]# curl http://localhost:9200/_cluster/health?pretty
{
  "cluster_name" : "elasticsearch",
  "status" : "yellow",
  "timed_out" : false,
  "number_of_nodes" : 1,
  "number_of_data_nodes" : 1,
  "active_primary_shards" : 10,
  "active_shards" : 10,
  "relocating_shards" : 0,
  "initializing_shards" : 0,
  "unassigned_shards" : 10,
  "delayed_unassigned_shards" : 0,
  "number_of_pending_tasks" : 0,
  "number_of_in_flight_fetch" : 0,
  "task_max_waiting_in_queue_millis" : 0,
  "active_shards_percent_as_number" : 50.0
}
```

Как вы думаете, почему часть индексов и кластер находится в состоянии yellow?
```
Из за того что у нас развернут одиночный сервер
ElasticSearch является отказоустойчивой системой хранения данных, которая расчитана для запуска не на одном сервере, а на группе (кластере) из нескольких связанных серверов (узлов, “nodes”).
```

Удалите все индексы.
```
[root@node-2 ~]# curl -X DELETE http://localhost:9200/ind-1?pretty
{
  "acknowledged" : true
}
[root@node-2 ~]# curl -X DELETE http://localhost:9200/ind-2?pretty
{
  "acknowledged" : true
}
[root@node-2 ~]# curl -X DELETE http://localhost:9200/ind-3?pretty
{
  "acknowledged" : true
}
```

**Важно**

При проектировании кластера elasticsearch нужно корректно рассчитывать количество реплик и шард,
иначе возможна потеря данных индексов, вплоть до полной, при деградации системы.

## Задача 3

В данном задании вы научитесь:
- создавать бэкапы данных
- восстанавливать индексы из бэкапов

Создайте директорию `{путь до корневой директории с elasticsearch в образе}/snapshots`.
```
В конфиг elasticsearch.yml был добавлен путь:
path.repo: /usr/share/elasticsearch/snapshots
```

Используя API [зарегистрируйте](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-register-repository.html#snapshots-register-repository) 
данную директорию как `snapshot repository` c именем `netology_backup`.

**Приведите в ответе** запрос API и результат вызова API для создания репозитория.
```
[root@node-2 ~]# curl -X PUT http://localhost:9200/_snapshot/netology_backup?pretty -H 'Content-Type: application/json' -d' { "type": "fs", "settings": { "location": "/usr/share/elasticsearch/snapshots"}}'
{
  "acknowledged" : true
}

```

Создайте индекс `test` с 0 реплик и 1 шардом и **приведите в ответе** список индексов.
```
[root@node-2 ~]# curl -X PUT http://localhost:9200/test_1?pretty -H 'Content-Type: application/json' -d'{ "settings": { "index": { "number_of_shards": 1, "number_of_replicas": 0 }}}'
{
  "acknowledged" : true,
  "shards_acknowledged" : true,
  "index" : "test_1"
}
[root@node-2 ~]# curl http://localhost:9200/_cat/indices?v
health status index            uuid                   pri rep docs.count docs.deleted store.size pri.store.size
green  open   .geoip_databases 9bPLuXoCQ1CwyDrNX0IRwg   1   0         40            0       38mb           38mb
green  open   test_1           SUPgO0RWR9Cd16jA6hxYCQ   1   0          0            0       226b           226b
```


[Создайте `snapshot`](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-take-snapshot.html) 
состояния кластера `elasticsearch`.

**Приведите в ответе** список файлов в директории со `snapshot`ами.
```
[elasticsearch@e8e77d336749 ~]$ ls -la /usr/share/elasticsearch/snapshots
total 0
drwxr-xr-x. 2 elasticsearch elasticsearch  6 Jun 26 18:57 .
drwx------. 1 elasticsearch elasticsearch 63 Jun 26 18:50 ..

[root@node-2 ~]# curl -X PUT http://localhost:9200/_snapshot/netology_backup/%3Cmy_snapshot_%7Bnow%2Fd%7D%3E
{"accepted":true}

Директория после создания:

[elasticsearch@dc96a362e1ae ~]$ ls -lah /usr/share/elasticsearch/snapshots/
total 44K
drwxr-xr-x. 3 elasticsearch elasticsearch  134 Jun 26 20:01 .
drwx------. 1 elasticsearch elasticsearch   63 Jun 26 19:44 ..
-rw-r--r--. 1 elasticsearch elasticsearch 1.2K Jun 26 20:01 index-0
-rw-r--r--. 1 elasticsearch elasticsearch    8 Jun 26 20:01 index.latest
drwxr-xr-x. 5 elasticsearch elasticsearch   96 Jun 26 20:01 indices
-rw-r--r--. 1 elasticsearch elasticsearch  29K Jun 26 20:01 meta-t3rso32qRZ-mbpsHqyzqCw.dat
-rw-r--r--. 1 elasticsearch elasticsearch  638 Jun 26 20:01 snap-t3rso32qRZ-mbpsHqyzqCw.dat

```

Удалите индекс `test` и создайте индекс `test-2`. **Приведите в ответе** список индексов.

```
[root@node-2 ~]# curl -X DELETE http://localhost:9200/test_1?pretty
{
  "acknowledged" : true
}

[root@node-2 ~]# curl -X PUT http://localhost:9200/test_2?pretty -H 'Content-Type: application/json' -d'{ "settings": { "index": { "number_of_shards": 1, "number_of_replicas": 0 }}}'
{
  "acknowledged" : true,
  "shards_acknowledged" : true,
  "index" : "test_2"
}

[root@node-2 ~]# curl http://localhost:9200/_cat/indices?v
health status index            uuid                   pri rep docs.count docs.deleted store.size pri.store.size
green  open   test_2           tfySDRKZQQeU-Iw18F13XQ   1   0          0            0       226b           226b

```

[Восстановите](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-restore-snapshot.html) состояние
кластера `elasticsearch` из `snapshot`, созданного ранее. 

**Приведите в ответе** запрос к API восстановления и итоговый список индексов.

```
[root@node-2 ~]# curl -X POST http://localhost:9200/_snapshot/netology_backup/my_snapshot_2022.06.26/_restore?pretty


[root@node-2 ~]# curl http://localhost:9200/_cat/indices?v
health status index            uuid                   pri rep docs.count docs.deleted store.size pri.store.size
green  open   test_2           tfySDRKZQQeU-Iw18F13XQ   1   0          0            0       226b           226b
green  open   test_1           SUPgO0RWR9Cd16jA6hxYCQ   1   0          0            0       226b           226b
```

Подсказки:
- возможно вам понадобится доработать `elasticsearch.yml` в части директивы `path.repo` и перезапустить `elasticsearch`

---

### Как cдавать задание

Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.

---