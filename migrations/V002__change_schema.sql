alter table product add column if not exists price float8;
alter table product add constraint pk_product primary key (id); 										

alter table orders add column if not exists date_created date default CURRENT_DATE;
alter table orders add constraint pk_order primary key (id); 											

alter table order_product add constraint fk_product foreign key (product_id) references product(id); 	
alter table order_product add constraint fk_order foreign key (order_id) references orders(id); 		

drop table if exists product_info;
drop table if exists orders_date;

