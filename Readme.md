# Проект `dbops-project`

Этот проект содержит миграции базы данных, настройки для выполнения миграций через GitHub Actions и SQL-запросы для анализа данных. В файле описаны все шаги, выполненные в рамках проекта.

---

## Содержание

1. [Миграции](#миграции)
2. [GitHub Workflow](#github-workflow)
3. [SQL-запросы](#sql-запросы)
4. [Выдача прав пользователям](#выдача-прав-пользователям)
5. [Анализ продаж сосисок](#анализ-продаж-сосисок)

---

## Миграции

В проект добавлены следующие миграции:

- [Создание таблиц](migrations/V001__create_tables.sql)
- [Нормализация схемы](migrations/V002__change_schema.sql)
- [Заполнение данными](migrations/V003__insert_data.sql)
- [Создание индексов](migrations/V004__create_index.sql)


---

## GitHub Workflow

В GitHub Actions добавлен шаг для выполнения миграций Flyway. Если необходимо, можно выполнить шаг `repair` для исправления контрольных сумм миграций. 

## Опциональный шаг в workflow с Flyway repair
Команда flyway repair — это одна из утилит Flyway, предназначенная для исправления проблем в истории миграций (таблица flyway_schema_history). Она помогает восстановить согласованность между состоянием базы данных и файлами миграций.

Этот шаг является опциональным и выполняется только при явном указании переменной **RUN_REPAIR**. Это позволяет гибко управлять процессом миграций и избежать ненужных операций.


---

## SQL-запросы 

### Создание БД **'store'**

```sql
-- Создание базы данных store
CREATE DATABASE store;

-- Создание пользователя autotest с паролем
CREATE USER autotest WITH PASSWORD 'autotest';

-- Установка прав подключения к базе данных store
GRANT CONNECT ON DATABASE store TO autotest;
```

### Выдача прав

Для выполнения миграций и автотестов были предоставлены права пользователю `autotest`:

```sql
-- Подключение к базе данных store
\c store;

-- Права на использование схемы public
GRANT ALL PRIVILEGES ON SCHEMA public TO autotest;
GRANT CREATE ON SCHEMA public TO autotest;

-- Права на таблицы
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO autotest;
```

---

## Анализ продаж сосисок

Запрос показывает, какое количество сосисок было продано за каждый день предыдущей недели. Выборка включает два столбца: дата заказа и суммарное количество сосисок. Учитываются только доставленные заказы (`status = 'shipped'`).

## SQL-запрос

```sql
SELECT 
    o.date_created AS order_date,
    SUM(op.quantity) AS total_sausages_sold
FROM 
    orders AS o
JOIN 
    order_product AS op ON o.id = op.order_id
WHERE 
    o.status = 'shipped' 
    AND o.date_created > NOW() - INTERVAL '7 DAY'
GROUP BY 
    o.date_created
ORDER BY 
    o.date_created;
```



## Измерение времени выполнения запроса

Для измерения времени выполнения запроса используется команда \timing в PostgreSQL. Результаты выполнения запроса с индексами и без них показывают значительное улучшение производительности.

### Без индексов
Запрос выполняется без использования индексов:

```sql
\timing
SELECT 
    o.date_created AS order_date,
    SUM(op.quantity) AS total_sausages_sold
FROM 
    orders AS o
JOIN 
    order_product AS op ON o.id = op.order_id
WHERE 
    o.status = 'shipped' 
    AND o.date_created > NOW() - INTERVAL '7 DAY'
GROUP BY 
    o.date_created
ORDER BY 
    o.date_created;
```
Вывод:

```sql
Time: 197.769 ms
```

### С добавленными индексами

Вывод:

```sql
Time: 92.120 ms
```


---

## Результаты

- **Автотесты выполнены успешно.**
- Все миграции применяются корректно.
- SQL-запросы работают без ошибок.