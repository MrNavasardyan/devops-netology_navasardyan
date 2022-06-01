# Домашнее задание к занятию "6.4. PostgreSQL"

## Задача 1

Используя docker поднимите инстанс PostgreSQL (версию 13). Данные БД сохраните в volume.

```
version: "3.9"  # optional since v1.27.0
services:
  db:
    image: postgres:13.7
    container_name: postgres
    ports:
      - 5432:5432
    volumes:
      - /var/lib/docker/volumes/postgres_13:/var/lib/postgresql/data/
      - /var/lib/docker/volumes/postgres_backup_13:/var/lib/postgresql/backup
    environment:
      POSTGRES_PASSWORD: postgres
      POSTGRES_DB: postgres
    restart: always
```


Подключитесь к БД PostgreSQL используя `psql`.

Воспользуйтесь командой `\?` для вывода подсказки по имеющимся в `psql` управляющим командам.

**Найдите и приведите** управляющие команды для:
- вывода списка БД
  ```
  \db
  ```
- подключения к БД
  ```
  \c {[DBNAME|- USER|- HOST|- PORT]}
  ```
- вывода списка таблиц
  ```
  \dt
  ```
- вывода описания содержимого таблиц
  ```
   \d[S+]  NAME
  ```
- выхода из psql
  ```
  exit
  ```

## Задача 2

Используя `psql` создайте БД `test_database`.

```
postgres=# CREATE DATABASE test_database
```
Изучите [бэкап БД](https://github.com/netology-code/virt-homeworks/tree/master/06-db-04-postgresql/test_data).

Восстановите бэкап БД в `test_database`.
```
root@4439adf204be:/var/lib/postgresql/backup# sudo -u postgres psql test_database < test_dump.sql
SET
SET
SET
SET
SET
 set_config
------------

(1 row)

SET
SET
SET
SET
SET
SET
CREATE TABLE
ALTER TABLE
CREATE SEQUENCE
ALTER TABLE
ALTER SEQUENCE
ALTER TABLE
COPY 8
 setval
--------
      8
(1 row)

ALTER TABLE
```

Перейдите в управляющую консоль `psql` внутри контейнера.

Подключитесь к восстановленной БД и проведите операцию ANALYZE для сбора статистики по таблице.
```
test_database=# ANALYZE VERBOSE orders ;
INFO:  analyzing "public.orders"
INFO:  "orders": scanned 1 of 1 pages, containing 8 live rows and 0 dead rows; 8 rows in sample, 8 estimated total rows
ANALYZE
```

Используя таблицу [pg_stats](https://postgrespro.ru/docs/postgresql/12/view-pg-stats), найдите столбец таблицы `orders` 
с наибольшим средним значением размера элементов в байтах.

**Приведите в ответе** команду, которую вы использовали для вычисления и полученный результат.
```
test_database=# select avg_width from pg_stats where tablename='orders';
 avg_width
-----------
         4
        16
         4
(3 rows)


Столбец avg_width показывает средний размер элементов в столбце, в байтах
```
## Задача 3

Архитектор и администратор БД выяснили, что ваша таблица orders разрослась до невиданных размеров и
поиск по ней занимает долгое время. Вам, как успешному выпускнику курсов DevOps в нетологии предложили
провести разбиение таблицы на 2 (шардировать на orders_1 - price>499 и orders_2 - price<=499).

Предложите SQL-транзакцию для проведения данной операции.

```
begin;
    create table orders_shared (
        id integer NOT NULL,
        title varchar(80) NOT NULL,
        price integer) partition by range(price);
    create table orders_less partition of orders_shared for values from (0) to (499);
    create table orders_more partition of orders_shared for values from (499) to (99999);
    insert into orders_shared (id, title, price) select * from orders;
commit;
```

Можно ли было изначально исключить "ручное" разбиение при проектировании таблицы orders?
```
Да, необходимо было определить тип partitioned table
```
## Задача 4

Используя утилиту `pg_dump` создайте бекап БД `test_database`.
```
root@4439adf204be:/var/lib/postgresql/backup# sudo -u postgres pg_dump -d test_database > backup_$(date +"%d-%m-%Y")
```

Как бы вы доработали бэкап-файл, чтобы добавить уникальность значения столбца `title` для таблиц `test_database`?

```
Можно использовать индекс для уникальности
```

---

### Как cдавать задание

Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.

---