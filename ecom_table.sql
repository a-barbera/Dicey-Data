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