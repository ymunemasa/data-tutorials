create database if not exists foodmart;
use foodmart;

DROP TABLE IF EXISTS sales_fact_1998;
CREATE EXTERNAL TABLE sales_fact_dec_1998(product_id INT,time_id INT,customer_id INT,promotion_id INT,store_id INT,store_sales DECIMAL(10,4),store_cost DECIMAL(10,4),unit_sales DECIMAL(10,4))
stored as orc
location '/apps/hive/warehouse/foodmart.db/sales_fact_1998'
tblproperties ("orc.compress"="SNAPPY");

DROP TABLE IF EXISTS inventory_fact_1998;
CREATE EXTERNAL TABLE inventory_fact_1998(product_id INT,time_id INT,warehouse_id INT,store_id INT,units_ordered INT,units_shipped INT,warehouse_sales DECIMAL(10,4),warehouse_cost DECIMAL(10,4),supply_time SMALLINT,store_invoice DECIMAL(10,4))
stored as orc
location '/apps/hive/warehouse/foodmart.db/inventory_fact_1998'
tblproperties ("orc.compress"="SNAPPY");

DROP TABLE IF EXISTS customer;
CREATE EXTERNAL TABLE customer(customer_id INT,account_num BIGINT,lname VARCHAR(30),fname VARCHAR(30),mi VARCHAR(30),address1 VARCHAR(30),address2 VARCHAR(30),address3 VARCHAR(30),address4 VARCHAR(30),city VARCHAR(30),state_province VARCHAR(30),postal_code VARCHAR(30),country VARCHAR(30),customer_region_id INT,phone1 VARCHAR(30),phone2 VARCHAR(30),birthdate DATE,marital_status VARCHAR(30),yearly_income VARCHAR(30),gender VARCHAR(30),total_children SMALLINT,num_children_at_home SMALLINT,education VARCHAR(30),date_accnt_opened DATE,member_card VARCHAR(30),occupation VARCHAR(30),houseowner VARCHAR(30),num_cars_owned INT,fullname VARCHAR(60))
stored as orc
location '/apps/hive/warehouse/foodmart.db/customer'
tblproperties ("orc.compress"="SNAPPY");

DROP TABLE IF EXISTS product;
CREATE EXTERNAL TABLE product(product_class_id INT,product_id INT,brand_name VARCHAR(60),product_name VARCHAR(60),SKU BIGINT,SRP DECIMAL(10,4),gross_weight DOUBLE,net_weight DOUBLE,recyclable_package BOOLEAN,low_fat BOOLEAN,units_per_case SMALLINT,cases_per_pallet SMALLINT,shelf_width DOUBLE,shelf_height DOUBLE,shelf_depth DOUBLE)
stored as orc
location '/apps/hive/warehouse/foodmart.db/product'
tblproperties ("orc.compress"="SNAPPY");

DROP TABLE IF EXISTS store;
CREATE EXTERNAL TABLE store(store_id INT,store_type VARCHAR(30),region_id INT,store_name VARCHAR(30),store_number INT,store_street_address VARCHAR(30),store_city VARCHAR(30),store_state VARCHAR(30),store_postal_code VARCHAR(30),store_country VARCHAR(30),store_manager VARCHAR(30),store_phone VARCHAR(30),store_fax VARCHAR(30),first_opened_date TIMESTAMP,last_remodel_date TIMESTAMP,store_sqft INT,grocery_sqft INT,frozen_sqft INT,meat_sqft INT,coffee_bar BOOLEAN,video_store BOOLEAN,salad_bar BOOLEAN,prepared_food BOOLEAN,florist BOOLEAN)
stored as orc
location '/apps/hive/warehouse/foodmart.db/store'
tblproperties ("orc.compress"="SNAPPY");
