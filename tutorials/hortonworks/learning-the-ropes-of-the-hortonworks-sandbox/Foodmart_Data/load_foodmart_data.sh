#!/bin/bash

cd ~
wget https://raw.githubusercontent.com/hortonworks/tutorials/hdp-2.5/tutorials/hortonworks/learning-the-ropes-of-the-hortonworks-sandbox/Foodmart_Data/foodmart_data.zip
wget https://raw.githubusercontent.com/hortonworks/tutorials/hdp-2.5/tutorials/hortonworks/learning-the-ropes-of-the-hortonworks-sandbox/Foodmart_Data/create_table_script.hql
sudo cp ~/foodmart_data.zip /home/hive/
sudo cp ~/create_table_script.hql /home/hive/

sudo chown hive /home/hive/create_table_script.hql
sudo chown hive /home/hive/foodmart_data.zip
sudo -u hive unzip /home/hive/foodmart_data.zip -d /home/hive

# creating HDFS directories for foodamrt tables
sudo -u hive hdfs dfs -mkdir /apps/hive/warehouse/foodmart.db
sudo -u hive hdfs dfs -mkdir /apps/hive/warehouse/foodmart.db/product
sudo -u hive hdfs dfs -mkdir /apps/hive/warehouse/foodmart.db/store
sudo -u hive hdfs dfs -mkdir /apps/hive/warehouse/foodmart.db/customer
sudo -u hive hdfs dfs -mkdir /apps/hive/warehouse/foodmart.db/sales_fact_1998
sudo -u hive hdfs dfs -mkdir /apps/hive/warehouse/foodmart.db/inventory_fact_1998

# copying sample data files to HDFS corresponding directories 
sudo -u hive hdfs dfs -copyFromLocal /home/hive/foodmart_data/product /apps/hive/warehouse/foodmart.db/product/
sudo -u hive hdfs dfs -copyFromLocal /home/hive/foodmart_data/store /apps/hive/warehouse/foodmart.db/store/
sudo -u hive hdfs dfs -copyFromLocal /home/hive/foodmart_data/customer /apps/hive/warehouse/foodmart.db/customer/
sudo -u hive hdfs dfs -copyFromLocal /home/hive/foodmart_data/sales_fact_1998 /apps/hive/warehouse/foodmart.db/sales_fact_1998/
sudo -u hive hdfs dfs -copyFromLocal /home/hive/foodmart_data/inventory_fact_1998 /apps/hive/warehouse/foodmart.db/inventory_fact_1998/
sudo -u hive hdfs dfs -chmod -R 777 /apps/hive/warehouse/foodmart.db

sudo -u hive hive -f /home/hive/create_table_script.hql
