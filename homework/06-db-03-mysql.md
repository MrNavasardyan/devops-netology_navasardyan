# Домашнее задание к занятию "6.3. MySQL"

## Введение

Перед выполнением задания вы можете ознакомиться с 
[дополнительными материалами](https://github.com/netology-code/virt-homeworks/tree/master/additional/README.md).

## Задача 1

Используя docker поднимите инстанс MySQL (версию 8). Данные БД сохраните в volume.

```
version: "3.9"  # optional since v1.27.0
services:
  db:
    image: mysql
    command: --default-authentication-plugin=mysql_native_password
    restart: always
    environment:
      MYSQL_ROOT_PASSWORD: example
    container_name: mysql
    ports:
      - 8080:8080
    volumes:
      - /var/lib/docker/volumes/mySQL:/var/lib/mysql/
      - /var/lib/docker/volumes/mySQL_backup:/var/lib/mysql/backup
```

Изучите [бэкап БД](https://github.com/netology-code/virt-homeworks/tree/master/06-db-03-mysql/test_data) и 
восстановитесь из него.

Перейдите в управляющую консоль `mysql` внутри контейнера.

Используя команду `\h` получите список управляющих команд.

Найдите команду для выдачи статуса БД и **приведите в ответе** из ее вывода версию сервера БД.

```
Server version:         8.0.29 MySQL Community Server - GPL
```

Подключитесь к восстановленной БД и получите список таблиц из этой БД.


**Приведите в ответе** количество записей с `price` > 300.

```
mysql> SHOW TABLES FROM test_db;
+-------------------+
| Tables_in_test_db |
+-------------------+
| orders            |
+-------------------+
1 row in set (0.00 sec)
```

В следующих заданиях мы будем продолжать работу с данным контейнером.

## Задача 2

Создайте пользователя test в БД c паролем test-pass, используя:
- плагин авторизации mysql_native_password
- срок истечения пароля - 180 дней 
- количество попыток авторизации - 3 
- максимальное количество запросов в час - 100
- аттрибуты пользователя:
    - Фамилия "Pretty"
    - Имя "James"

Предоставьте привелегии пользователю `test` на операции SELECT базы `test_db`.

```
create user 'test'@'localhost' 
    identified with mysql_native_password by 'test-pass' 
    with max_queries_per_hour 100
    password expire interval 180 day 
    failed_login_attempts 3 
    attribute '{"fname": "James","lname": "Pretty"}';

GRANT SELECT ON *.* TO 'test'@'localhost'
FLUSH PRIVILEGES;
```
    
Используя таблицу INFORMATION_SCHEMA.USER_ATTRIBUTES получите данные по пользователю `test` и 
**приведите в ответе к задаче**.
```
mysql> select * from INFORMATION_SCHEMA.USER_ATTRIBUTES where user = 'test';
+------+-----------+---------------------------------------+
| USER | HOST      | ATTRIBUTE                             |
+------+-----------+---------------------------------------+
| test | localhost | {"fname": "James", "lname": "Pretty"} |
+------+-----------+---------------------------------------+
1 row in set (0.00 sec)
```

## Задача 3

Установите профилирование `SET profiling = 1`.
Изучите вывод профилирования команд `SHOW PROFILES;`.

```
mysql> SET profiling = 1;
Query OK, 0 rows affected, 1 warning (0.01 sec)

mysql> SHOW PROFILES;
Empty set, 1 warning (0.00 sec)
```

Исследуйте, какой `engine` используется в таблице БД `test_db` и **приведите в ответе**.

```
mysql> show table status where name = 'orders';
+--------+--------+---------+------------+------+----------------+-------------+-----------------+--------------+-----------+----------------+---------------------+---------------------+------------+--------------------+----------+----------------+---------+
| Name   | Engine | Version | Row_format | Rows | Avg_row_length | Data_length | Max_data_length | Index_length | Data_free | Auto_increment | Create_time         | Update_time         | Check_time | Collation          | Checksum | Create_options | Comment |
+--------+--------+---------+------------+------+----------------+-------------+-----------------+--------------+-----------+----------------+---------------------+---------------------+------------+--------------------+----------+----------------+---------+
| orders | InnoDB |      10 | Dynamic    |    5 |           3276 |       16384 |               0 |            0 |         0 |              6 | 2022-05-26 07:15:31 | 2022-05-26 07:15:31 | NULL       | utf8mb4_0900_ai_ci |     NULL |                |         |
+--------+--------+---------+------------+------+----------------+-------------+-----------------+--------------+-----------+----------------+---------------------+---------------------+------------+--------------------+----------+----------------+---------+
1 row in set (0.02 sec)

Engine: InnoDB
```

Измените `engine` и **приведите время выполнения и запрос на изменения из профайлера в ответе**:
- на `MyISAM`
- на `InnoDB`

```
mysql> SHOW PROFILES;
+----------+------------+-----------------------------------------+
| Query_ID | Duration   | Query                                   |
+----------+------------+-----------------------------------------+
|        1 | 0.00570700 | select * from orders                    |
|        2 | 0.01702325 | show table status where name = 'orders' |
|        3 | 0.04916725 | ALTER TABLE orders ENGINE=MyISAM        |
|        4 | 0.03573600 | ALTER TABLE orders ENGINE=InnoDB        |
+----------+------------+-----------------------------------------+
```
## Задача 4 

Изучите файл `my.cnf` в директории /etc/mysql.

Измените его согласно ТЗ (движок InnoDB):
- Скорость IO важнее сохранности данных
- Нужна компрессия таблиц для экономии места на диске
- Размер буффера с незакомиченными транзакциями 1 Мб
- Буффер кеширования 30% от ОЗУ
- Размер файла логов операций 100 Мб

Приведите в ответе измененный файл `my.cnf`.
```
[mysqld]
pid-file        = /var/run/mysqld/mysqld.pid
socket          = /var/run/mysqld/mysqld.sock
datadir         = /var/lib/mysql
secure-file-priv= NULL

innodb_flush_log_at_trx_commit = 0 
innodb_file_per_table = 1
autocommit = 0
innodb_log_buffer_size	= 1M
key_buffer_size = 256М
max_binlog_size	= 100M
```
---