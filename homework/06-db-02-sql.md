# Домашнее задание к занятию "6.2. SQL"

## Введение

Перед выполнением задания вы можете ознакомиться с 
[дополнительными материалами](https://github.com/netology-code/virt-homeworks/tree/master/additional/README.md).

## Задача 1

Используя docker поднимите инстанс PostgreSQL (версию 12) c 2 volume, 
в который будут складываться данные БД и бэкапы.

Приведите получившуюся команду или docker-compose манифест.

```
version: "3.9"  # optional since v1.27.0
services:
  db:
    image: postgres:12.11-alpine
    container_name: postgres
    ports:
      - 5432:5432
    volumes:
      - /var/lib/docker/volumes/postgres:/var/lib/postgresql/data/
      - /var/lib/docker/volumes/postgres_backup:/var/lib/postgresql/backup
    environment:
      POSTGRES_PASSWORD: postgres
      POSTGRES_DB: postgres
    restart: always
```



## Задача 2

В БД из задачи 1: 
- создайте пользователя test-admin-user и БД test_db
  ```
  CREATE USER test_admin_user;
  CREATE DATABASE test_db;
  ```

- в БД test_db создайте таблицу orders и clients (спeцификация таблиц ниже)
  ```
  CREATE TABLE orders (id serial PRIMARY KEY, order_name varchar(30) NOT NULL, price integer NOT NULL);

  CREATE TABLE clients (id serial PRIMARY KEY, last_name varchar(50) NOT NULL, country varchar(30) NOT NULL, order_number integer REFERENCES orders);
  ```
- предоставьте привилегии на все операции пользователю test-admin-user на таблицы БД test_db
  ```
  GRANT ALL ON ALL TABLES IN SCHEMA "public" TO "test_admin_user";
  ```
- создайте пользователя test-simple-user  
  ```
  CREATE USER "test-simple-user";
  ```
- предоставьте пользователю test-simple-user права на SELECT/INSERT/UPDATE/DELETE данных таблиц БД test_db
  ```
  GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA "public" TO "test-simple-user";
  ```
Таблица orders:
- id (serial primary key)
- наименование (string)
- цена (integer)

Таблица clients:
- id (serial primary key)
- фамилия (string)
- страна проживания (string, index)
- заказ (foreign key orders)

Приведите:
- итоговый список БД после выполнения пунктов выше,
  ```
  test_db=# \dt
            List of relations
    Schema |  Name   | Type  |  Owner
    --------+---------+-------+----------
    public | clients | table | postgres
    public | orders  | table | postgres
    (2 rows)

    test_db=# select * from clients;
    id | last_name | country | order_number
    ----+-----------+---------+--------------
    (0 rows)

    test_db=# select * from orders;
    id | order_name | price
    ----+------------+-------
    (0 rows)

  ```
- описание таблиц (describe)
  ```
    test_db=# \d+ orders
                                                            Table "public.orders"
    Column   |         Type          | Collation | Nullable |              Default               | Storage  | Stats target | Description
    ------------+-----------------------+-----------+----------+------------------------------------+----------+--------------+-------------
    id         | integer               |           | not null | nextval('orders_id_seq'::regclass) | plain    |              |
    order_name | character varying(30) |           | not null |                                    | extended |              |
    price      | integer               |           | not null |                                    | plain    |              |
    Indexes:
        "orders_pkey" PRIMARY KEY, btree (id)
    Referenced by:
        TABLE "clients" CONSTRAINT "clients_order_number_fkey" FOREIGN KEY (order_number) REFERENCES orders(id)
    Access method: heap

    test_db=# \d+ clients
                                                            Table "public.clients"
        Column    |         Type          | Collation | Nullable |               Default               | Storage  | Stats target | Description
    --------------+-----------------------+-----------+----------+-------------------------------------+----------+--------------+-------------
    id           | integer               |           | not null | nextval('clients_id_seq'::regclass) | plain    |              |
    last_name    | character varying(50) |           | not null |                                     | extended |              |
    country      | character varying(30) |           | not null |                                     | extended |              |
    order_number | integer               |           |          |                                     | plain    |              |
    Indexes:
        "clients_pkey" PRIMARY KEY, btree (id)
    Foreign-key constraints:
        "clients_order_number_fkey" FOREIGN KEY (order_number) REFERENCES orders(id)
    Access method: heap

    ```
- SQL-запрос для выдачи списка пользователей с правами над таблицами test_db
    ```
    SELECT table_name, grantee, privilege_type 
	FROM information_schema.role_table_grants 
	WHERE table_name='orders';

    SELECT table_name, grantee, privilege_type 
	FROM information_schema.role_table_grants 
	WHERE table_name='clients';

    ```
- список пользователей с правами над таблицами test_db
```
    table_name |     grantee      | privilege_type
    ------------+------------------+----------------
    clients    | postgres         | INSERT
    clients    | postgres         | SELECT
    clients    | postgres         | UPDATE
    clients    | postgres         | DELETE
    clients    | postgres         | TRUNCATE
    clients    | postgres         | REFERENCES
    clients    | postgres         | TRIGGER
    clients    | test_admin_user  | INSERT
    clients    | test_admin_user  | SELECT
    clients    | test_admin_user  | UPDATE
    clients    | test_admin_user  | DELETE
    clients    | test_admin_user  | TRUNCATE
    clients    | test_admin_user  | REFERENCES
    clients    | test_admin_user  | TRIGGER
    clients    | test-simple-user | INSERT
    clients    | test-simple-user | SELECT
    clients    | test-simple-user | UPDATE
    clients    | test-simple-user | DELETE

     table_name |     grantee      | privilege_type
    ------------+------------------+----------------
    orders     | postgres         | INSERT
    orders     | postgres         | SELECT
    orders     | postgres         | UPDATE
    orders     | postgres         | DELETE
    orders     | postgres         | TRUNCATE
    orders     | postgres         | REFERENCES
    orders     | postgres         | TRIGGER
    orders     | test_admin_user  | INSERT
    orders     | test_admin_user  | SELECT
    orders     | test_admin_user  | UPDATE
    orders     | test_admin_user  | DELETE
    orders     | test_admin_user  | TRUNCATE
    orders     | test_admin_user  | REFERENCES
    orders     | test_admin_user  | TRIGGER
    orders     | test-simple-user | INSERT
    orders     | test-simple-user | SELECT
    orders     | test-simple-user | UPDATE
    orders     | test-simple-user | DELETE

```




## Задача 3

Используя SQL синтаксис - наполните таблицы следующими тестовыми данными:

Таблица orders

|Наименование|цена|
|------------|----|
|Шоколад| 10 |
|Принтер| 3000 |
|Книга| 500 |
|Монитор| 7000|
|Гитара| 4000|

```
INSERT INTO orders VALUES (1,'Шоколад',10),(2, 'Принтер', 3000),(3, 'Книга', 500),(4, 'Монитор', 7000),(5, 'Гитара', 4000);
```

Таблица clients

|ФИО|Страна проживания|
|------------|----|
|Иванов Иван Иванович| USA |
|Петров Петр Петрович| Canada |
|Иоганн Себастьян Бах| Japan |
|Ронни Джеймс Дио| Russia|
|Ritchie Blackmore| Russia|

```
INSERT INTO clients VALUES (1, 'Иванов Иван Иванович', 'USA'),(2, 'Петров Петр Петрович', 'Canada'),(3, 'Иоганн Себастьян Бах', 'Japan'),(4, 'Ронни Джеймс Дио', 'Russia'),(5, 'Ritchie Blackmore', 'Russia');
```


Используя SQL синтаксис:
- вычислите количество записей для каждой таблицы 
- приведите в ответе:
    - запросы 
    - результаты их выполнения.
```
test_db=# select count(*) from orders;
 count
-------
     5
(1 row)

test_db=# select count(*) from clients;
 count
-------
     5
(1 row)
```

## Задача 4

Часть пользователей из таблицы clients решили оформить заказы из таблицы orders.

Используя foreign keys свяжите записи из таблиц, согласно таблице:

|ФИО|Заказ|
|------------|----|
|Иванов Иван Иванович| Книга |
|Петров Петр Петрович| Монитор |
|Иоганн Себастьян Бах| Гитара |

Приведите SQL-запросы для выполнения данных операций.

```
test_db=# UPDATE clients SET order_number=3 WHERE id=1;
UPDATE 1
test_db=# UPDATE clients SET order_number=4 WHERE id=2;
UPDATE 1
test_db=# UPDATE clients SET order_number=5 WHERE id=3;
UPDATE 1

```

Приведите SQL-запрос для выдачи всех пользователей, которые совершили заказ, а также вывод данного запроса.

```
test_db=# SELECT * FROM clients WHERE order_number IS NOT NULL;
 id |      last_name       | country | order_number
----+----------------------+---------+--------------
  1 | Иванов Иван Иванович | USA     |            3
  2 | Петров Петр Петрович | Canada  |            4
  3 | Иоганн Себастьян Бах | Japan   |            5
```
 
Подсказк - используйте директиву `UPDATE`.

## Задача 5

Получите полную информацию по выполнению запроса выдачи всех пользователей из задачи 4 
(используя директиву EXPLAIN).

Приведите получившийся результат и объясните что значат полученные значения.

```
test_db=# EXPLAIN (FORMAT YAML) SELECT * FROM clients WHERE order_number IS NOT NULL;
                QUERY PLAN
------------------------------------------
 - Plan:                                 +
     Node Type: "Seq Scan"               +
     Parallel Aware: false               +
     Relation Name: "clients"            +
     Alias: "clients"                    +
     Startup Cost: 0.00                  +
     Total Cost: 13.50                   +
     Plan Rows: 348                      +
     Plan Width: 204                     +
     Filter: "(order_number IS NOT NULL)"
(1 row)

Показывает служебную информацию о запросе, необходимо при оптимизировании запроса
```

## Задача 6

Создайте бэкап БД test_db и поместите его в volume, предназначенный для бэкапов (см. Задачу 1).

```
sudo -u postgres pg_dumpall > /var/lib/postgresql/backup/db_backup_$(date +"%d-%m-%Y")

на localhost:

[root@node-2 postgres_backup]# pwd
/var/lib/docker/volumes/postgres_backup
[root@node-2 postgres_backup]# ll
total 8
-rw-r--r--. 1 root root 7984 May 25 11:19 db_backup_25-05-2022

```

Остановите контейнер с PostgreSQL (но не удаляйте volumes).

```
CONTAINER ID   IMAGE                   COMMAND                  CREATED         STATUS         PORTS                                       NAMES
dafc49ceaddc   postgres:12.11-alpine   "docker-entrypoint.s…"   9 minutes ago   Up 9 minutes   0.0.0.0:5432->5432/tcp, :::5432->5432/tcp   postgres

[root@node-2 postgres]# docker compose down
[+] Running 2/2
 ⠿ Container postgres        Removed                                                                                                                                                                          1.0s
 ⠿ Network postgres_default  Removed                                                                                                                                                                          0.6s
[root@node-2 postgres]# docker ps
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES
```

Поднимите новый пустой контейнер с PostgreSQL.

```
Запускам новый контейнер POSTGRES (пустой)

[root@node-2 postgres]# docker run -it -e POSTGRES_PASSWORD=postgres -d -p 5432:5432 -v /var/lib/docker/volumes/postgres_backup:/var/lib/postgresql/backup b76727572d69
aa2617223ae5fed8efcb0ad66555daeddfe28663f92f971355b889beb71b255f

[root@node-2 postgres]# docker ps
CONTAINER ID   IMAGE          COMMAND                  CREATED          STATUS          PORTS                                       NAMES
aa2617223ae5   b76727572d69   "docker-entrypoint.s…"   22 seconds ago   Up 20 seconds   0.0.0.0:5432->5432/tcp, :::5432->5432/tcp   sleepy_mendel

Проверка что БД пустая
[root@node-2 postgres]# docker exec -it aa2617223ae5 bash
bash-5.1# psql -Upostgres
psql (12.11)
Type "help" for help.

postgres=# \dt
Did not find any relations.
postgres=# exit
bash-5.1# psql -Upostgres test_db
psql: error: FATAL:  database "test_db" does not exist
```

Восстановите БД test_db в новом контейнере.

```
bash-5.1# cd /var/lib/postgresql/backup/
bash-5.1# ls -ltr
total 8
-rw-r--r--    1 root     root          7984 May 25 11:19 db_backup_25-05-2022

bash-5.1# sudo -u postgres psql < db_backup_25-05-2022

bash-5.1# psql -Upostgres test_db
psql (12.11)
Type "help" for help.

test_db=# \dt

test_db=# \dt
          List of relations
 Schema |  Name   | Type  |  Owner
--------+---------+-------+----------
 public | clients | table | postgres
 public | orders  | table | postgres
(2 rows)

test_db=# select * from orders;
 id | order_name | price
----+------------+-------
  1 | Шоколад    |    10
  2 | Принтер    |  3000
  3 | Книга      |   500
  4 | Монитор    |  7000
  5 | Гитара     |  4000
(5 rows)

test_db=# select * from clients;
 id |      last_name       | country | order_number
----+----------------------+---------+--------------
  4 | Ронни Джеймс Дио     | Russia  |
  5 | Ritchie Blackmore    | Russia  |
  1 | Иванов Иван Иванович | USA     |            3
  2 | Петров Петр Петрович | Canada  |            4
  3 | Иоганн Себастьян Бах | Japan   |            5
(5 rows)

```

Приведите список операций, который вы применяли для бэкапа данных и восстановления. 

---

### Как cдавать задание

Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.

---