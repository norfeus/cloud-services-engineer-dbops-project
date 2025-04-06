-- Добавление столбца `price`, первичного ключа `pk_product` в таблицу `product`
ALTER TABLE product ADD COLUMN IF NOT EXISTS price FLOAT8;
ALTER TABLE product ADD CONSTRAINT pk_product PRIMARY KEY (id); 

-- Добавление столбца `date_created`, первичного ключа `pk_order` в таблицу `orders`
ALTER TABLE orders ADD COLUMN IF NOT EXISTS date_created DATE DEFAULT CURRENT_DATE;
ALTER TABLE orders ADD CONSTRAINT pk_order PRIMARY KEY (id); 

-- Добавление внешнего ключа `fk_product`, `fk_order` в таблицу `order_product`
ALTER TABLE order_product ADD CONSTRAINT fk_product FOREIGN KEY (product_id) REFERENCES product(id); 
ALTER TABLE order_product ADD CONSTRAINT fk_order FOREIGN KEY (order_id) REFERENCES orders(id); 

-- Удаление таблиц, если они существуют
DROP TABLE IF EXISTS product_info;
DROP TABLE IF EXISTS orders_date;