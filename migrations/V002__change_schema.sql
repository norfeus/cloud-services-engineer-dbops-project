-- Добавление столбца `price`, первичного ключа `pk_product` в таблицу `product`
alter table product add column if not exists price float8;
alter table product add constraint pk_product primary key (id); 

-- Добавление столбца `date_created`, ервичного ключа `pk_order` в таблицу `orders`
alter table orders add column if not exists date_created date default CURRENT_DATE;
alter table orders add constraint pk_order primary key (id); 

-- Добавление внешнего ключа `fk_product`, `fk_order` в таблицу `order_product`
alter table order_product add constraint fk_product foreign key (product_id) references product(id); 
alter table order_product add constraint fk_order foreign key (order_id) references orders(id); 

-- Удаление таблиц, если они есть
drop table if exists product_info;
drop table if exists orders_date;