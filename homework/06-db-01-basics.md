# Домашнее задание к занятию "6.1. Типы и структура СУБД"

## Введение

Перед выполнением задания вы можете ознакомиться с 
[дополнительными материалами](https://github.com/netology-code/virt-homeworks/tree/master/additional/README.md).

## Задача 1

Архитектор ПО решил проконсультироваться у вас, какой тип БД 
лучше выбрать для хранения определенных данных.

Он вам предоставил следующие типы сущностей, которые нужно будет хранить в БД:

- Электронные чеки в json виде
  ```
  document-oriented database (CouchDB, MongoDb)
  ```
- Склады и автомобильные дороги для логистической компании
  ```
  Графовая база данных
  ```
- Генеалогические деревья
  ```
  Иерархическая модель данных.
  ```
- Кэш идентификаторов клиентов с ограниченным временем жизни для движка аутенфикации
  ```
  База данных на основе пар «ключ‑значение»
  ```
- Отношения клиент-покупка для интернет-магазина
  ```
  Реляционные БД
  ```

Выберите подходящие типы СУБД для каждой сущности и объясните свой выбор.

## Задача 2

Вы создали распределенное высоконагруженное приложение и хотите классифицировать его согласно 
CAP-теореме. Какой классификации по CAP-теореме соответствует ваша система, если 
(каждый пункт - это отдельная реализация вашей системы и для каждого пункта надо привести классификацию):

- Данные записываются на все узлы с задержкой до часа (асинхронная запись)
- При сетевых сбоях, система может разделиться на 2 раздельных кластера
- Система может не прислать корректный ответ или сбросить соединение
```
CA | PC/EL
PA | PA/EL
PC | PA/EC
```

А согласно PACELC-теореме, как бы вы классифицировали данные реализации?

## Задача 3

Могут ли в одной системе сочетаться принципы BASE и ACID? Почему?

```
ACID и BASE - две разные философии

Теория BASE является расширением теоремы CAP. Ее основная идея состоит в том, что даже если нельзя добиться сильной согласованности, для достижения окончательной согласованности необходимо использовать соответствующий метод.

Базовая доступность: когда система выходит из строя, часть доступности может быть потеряна, чтобы гарантировать, что ядро ​​доступно.
Мягкое состояние: позволяет системе иметь промежуточное состояние, и это промежуточное состояние не влияет на общую доступность системы. (В распределенном хранилище обычно есть три копии фрагмента данных. Разрешение задержки копий между различными узлами является проявлением мягкого состояния.)
Окончательная согласованность: все копии в системе могут наконец достичь согласованности данных через определенный период времени. (Окончательная консистенция - проявление слабой консистенции)

ACID - это традиционная концепция проектирования реляционных баз данных, основанная на модели согласованности. BASE поддерживает крупномасштабные распределенные системы и предлагает добиться высокой доступности, жертвуя согласованностью.

Соответсвенно, при проектировании такой системы ее необходимо разделить на две части, часть будет построенна по BASE, и другая часть по ACID
```

## Задача 4

Вам дали задачу написать системное решение, основой которого бы послужили:

- фиксация некоторых значений с временем жизни
- реакция на истечение таймаута

Вы слышали о key-value хранилище, которое имеет механизм [Pub/Sub](https://habr.com/ru/post/278237/). 
Что это за система? Какие минусы выбора данной системы?
```
Redis (от англ. remote dictionary server) — резидентная система управления базами данных класса NoSQL с открытым исходным кодом, работающая со структурами данных типа «ключ — значение». Используется как для баз данных, так и для реализации кэшей, брокеров сообщений.

Минусы:
Только тривиальная модель pub/sub
Отсутствие очередей сообщений

```
---

### Как cдавать задание

Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.

---