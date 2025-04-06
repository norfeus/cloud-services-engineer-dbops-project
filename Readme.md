# dbops-project
Исходный репозиторий для выполнения проекта дисциплины "DBOps"



# Запрос для анализа продаж сосисок за предыдущую неделю

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





## Анализ производительности с помощью EXPLAIN (ANALYZE)
Для анализа выполнения запроса используется команда EXPLAIN (ANALYZE). Она позволяет увидеть, как PostgreSQL выполняет запрос, какие индексы используются и сколько времени затрачивается на каждый этап.

### Запрос с анализом:
