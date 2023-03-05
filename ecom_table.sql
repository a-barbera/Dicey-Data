DROP TABLE IF EXISTS "ecommerce_cb";
CREATE TABLE "ecommerce_cb" (
    "com_id" int  NOT NULL,
    "order_id" int   NOT NULL,
    "user_id" int   NOT NULL,
    "order_number" int   NOT NULL,
    "order_dow" int   NOT NULL,
    "order_hour_of_day" int   NOT NULL,
    "days_since_prior_order" int   NOT NULL,
    "product_id" int   NOT NULL,
    "add_to_cart_order" int   NOT NULL,
    "reordered" int  NOT NULL,
    "department_id" int   NOT NULL,
    "department" varchar (150)   NOT NULL,
    "product_name" varchar (150)   NOT NULL,
    CONSTRAINT "com_id" PRIMARY KEY (
        "com_id"
     )
);

DROP TABLE IF EXISTS "product_categories";
CREATE TABLE product_categories
(product_name varchar(50),
category varchar(20))
;

CREATE VIEW ecb_summaries as
    select ocount1.user_id, ocount1.order_count, ahour1.avg_hour, aprior1.avg_prior,
    osum.resum, pro1.strpro
    from 
        (select user_id, count(order_number) as order_count
        from ecommerce_cb group by user_id) as ocount1
    inner join
        (select user_id, Round(avg(Cast(order_hour_of_day as decimal)),4) as avg_hour
       from ecommerce_cb group by user_id) as ahour1
       on ocount1.user_id = ahour1.user_id
    inner join
       (select user_id, Round(avg(Cast(days_since_prior_order as decimal)),4) as avg_prior
        from ecommerce_cb group by user_id) as aprior1
        on ocount1.user_id = aprior1.user_id
    inner join
       (select user_id, string_agg(Cast(product_id as varchar),',') as strpro
       from ecommerce_cb group by user_id) as pro1
        on ocount1.user_id = pro1.user_id
    inner join
        (select user_id,sum(reordered) as resum from ecommerce_cb group by user_id) as osum
       on ocount1.user_id = osum.user_id
;

CREATE VIEW ecommerce_2 as 
select ecommerce_cb.*, product_categories.category from ecommerce_cb
left outer join product_categories on ecommerce_cb.product_name = product_categories.product_name
;

CREATE VIEW order_avg as
select distinct pro2.order_id, ecb.user_id, pro2.pro_count
from
ecommerce_cb as ecb
inner join
(select count(product_id) as pro_count, order_id from ecommerce_cb group by order_id) pro2
on ecb.order_id = pro2.order_id
;

CREATE VIEW avg_customer_ord as 
select oc3.user_id, oc3.ordco, pc3.proco, round(pc3.proco/oc3.ordco,2) as ordersize
from
(select user_id, count(order_id) as ordco from order_avg group by user_id) oc3
inner join
(select user_id, sum(pro_count) as proco from order_avg group by user_id) pc3
on oc3.user_id = pc3.user_id
order by user_id;

create view customer_summaries as 
select ecb_summaries.*, avg_customer_ord.proco, avg_customer_ord.ordersize from ecb_summaries
left outer join avg_customer_ord on ecb_summaries.user_id = avg_customer_ord.userid;
