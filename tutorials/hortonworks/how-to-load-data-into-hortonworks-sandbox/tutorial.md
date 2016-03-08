---
title: How to Load Data into the Hortonworks Sandbox
tutorial-id: 230
tutorial-series: Introduction
tutorial-version: hdp-2.4.0
intro-page: true
components: [ ambari, hive ]
---


# How to Load Data Into the Hortonworks Sandbox

### Introduction

The Hortonworks Sandbox is a fully contained Hortonworks Data Platform (HDP) environment. The sandbox includes the core Hadoop components, as well as all the tools needed for data ingestion and processing. You can access and analyze sandbox data with many Business Intelligence (BI) applications.

In this tutorial, we will load and review data for a fictitious web retail store in what has become an established use case for Hadoop: deriving insights from large data sources such as web logs. By combining web logs with more traditional customer data, we can better understand our customers, and also understand how to optimize future promotions and advertising.

## Pre-Requisites
*  Downloaded and Installed latest [Hortonworks Sandbox](http://hortonworks.com/products/hortonworks-sandbox/#install)
*  [Learning the Ropes of the Hortonworks Sandbox](http://hortonworks.com/hadoop-tutorial/learning-the-ropes-of-the-hortonworks-sandbox/)

## Outline

To load data into the Hortonworks sandbox, you will:

*   [Step 1: Download the sample data](#download-sample-data)
*   [Step 2: Upload the Data Files into the Sandbox](#upload-the-data-files-into-the-sandbox)
*   [Step 3: Create Hive Tables](#create-hive-tables)
*   [Step 4: Load data into new tables](#load-data-into-new-tables)
*   [Step 5: View and Refine the Data in the Sandbox](#view-and-refine-the-data-in-the-sandbox)
*   [Further Resources](#further-resources)

### Step 1: Download the Sample Data <a id="download-sample-data"></a>

You can download a set of sample data contained in a compressed (.zip) folder here:

[RefineDemoData.zip](https://s3.amazonaws.com/hw-sandbox/tutorial8/RefineDemoData.zip)

Save the sample data .zip file to your computer, then extract the files and unzip Omniture.0.tsv.gz, users.tsv.gz and products.tsv.gz.

**Note**: The extracted data files should have a .tsv file extension at the end.

### Step 2: Upload the Data Files into the Sandbox <a id="upload-the-data-files-into-the-sandbox"></a>

2.1) Select the `HDFS Files view` from the Off-canvas menu at the top. The HDFS Files view allows you to view the Hortonworks Data Platform(HDP) file store. The HDP file system is separate from the local file system. 

![](/assets/hello-hdp/hdfs_files_view_hello_hdp_lab1.png)

2.2) Navigate to `/tmp`, create an **maria_dev** folder

![](/assets/how-to-load-data-into-sandbox/tmp_maria_dev_folder_load_data_sandbox.png)

2.3) right click on **maria_dev** and select **Permissions**:

![](/assets/how-to-load-data-into-sandbox/permissions_maria_dev_folder_load_data_sandbox.png)

2.4) Now we check the `Write buttons` and `modify recursively` and press save.

![](/assets/how-to-load-data-into-sandbox/write_buttons_modify_recursive_load_data_sandbox.png)

2.5) Verify that the permissions look now like the image below:

![](/assets/how-to-load-data-into-sandbox/verify_permissions_load_data_sandbox.png)

2.6) Now, we navigate to `/tmp/maria_dev`, click on upload and browse the `Omniture.0.tsv`.

Repeat this procedure for `users.tsv` file and for `products.tsv`.

![](/assets/how-to-load-data-into-sandbox/upload_refine_demo_data_load_data_sandbox.png)

### Step 3: Create Hive tables <a id="create-hive-tables"></a>

3.1) Let’s open the `Hive  View` by clicking on the Hive button from the `views menu`.

![](/assets/how-to-load-data-into-sandbox/hive_view_icon_load_data_sandbox.png)

3.2) Create the tables users, products and omniturelogs.

~~~
create table users (swid STRING, birth_dt STRING, gender_cd CHAR(1)) ROW FORMAT DELIMITED
FIELDS TERMINATED by '\t' stored as textfile 
tblproperties ("skip.header.line.count"="1");
~~~

![](/assets/how-to-load-data-into-sandbox/create_table_users_load_data_sandbox.png)

~~~
create table products (url STRING, category STRING) ROW FORMAT DELIMITED
FIELDS TERMINATED by '\t' stored as textfile 
tblproperties ("skip.header.line.count"="1");
~~~

![](/assets/how-to-load-data-into-sandbox/create_table_products_load_data_sandbox.png)

~~~
create table omniturelogs (col_1 STRING,col_2 STRING,col_3 STRING,col_4 STRING,col_5 STRING,col_6 STRING,col_7 STRING,col_8 STRING,col_9 STRING,col_10 STRING,col_11 STRING,col_12 STRING,col_13 STRING,col_14 STRING,col_15 STRING,col_16 STRING,col_17 STRING,col_18 STRING,col_19 STRING,col_20 STRING,col_21 STRING,col_22 STRING,col_23 STRING,col_24 STRING,col_25 STRING,col_26 STRING,col_27 STRING,col_28 STRING,col_29 STRING,col_30 STRING,col_31 STRING,col_32 STRING,col_33 STRING,col_34 STRING,col_35 STRING,col_36 STRING,col_37 STRING,col_38 STRING,col_39 STRING,col_40 STRING,col_41 STRING,col_42 STRING,col_43 STRING,col_44 STRING,col_45 STRING,col_46 STRING,col_47 STRING,col_48 STRING,col_49 STRING,col_50 STRING,col_51 STRING,col_52 STRING,col_53 STRING) 
ROW FORMAT DELIMITED
FIELDS TERMINATED by '\t' stored as textfile 
tblproperties ("skip.header.line.count"="1");
~~~

![](/assets/how-to-load-data-into-sandbox/create_table_omniturelogs_load_data_sandbox.png)

### Step 4: Load data into new tables <a id="load-data-into-new-tables"></a>

4.1) To load the data into the tables, we have to execute the following queries.

~~~
LOAD DATA INPATH '/tmp/maria_dev/products.tsv' OVERWRITE INTO TABLE products; 
LOAD DATA INPATH '/tmp/maria_dev/users.tsv' OVERWRITE INTO TABLE users; 
LOAD DATA INPATH '/tmp/maria_dev/Omniture.0.tsv' OVERWRITE INTO TABLE omniturelogs;
~~~

![](/assets/how-to-load-data-into-sandbox/load_demo_data_load_data_sandbox.png)

4.2) To check if the data was loaded, click on the icon next to the table name. It executes a sample query.

![](/assets/how-to-load-data-into-sandbox/users_sample_data_load_data_sandbox.png)  
![](/assets/how-to-load-data-into-sandbox/products_sample_data_load_data_sandbox.png)  
![](/assets/how-to-load-data-into-sandbox/omniturelogs_sample_data_load_data_sandbox.png)

### Step 5: View and Refine the Data in the Sandbox <a id="view-and-refine-the-data-in-the-sandbox"></a>

In the previous section, we created sandbox tables from uploaded data files. Now let’s take a closer look at that data.

Here’s a summary of the data we’re working with:

**omniturelogs** – website logs containing information such as URL, timestamp, IP address, geocoded IP, and session ID.

![](/assets/how-to-load-data-into-sandbox/ominturelog_file_firsthalf_load_data_sandbox.png)  
![](/assets/how-to-load-data-into-sandbox/omniturelog_file_secondhalf_load_data_sandbox.png)

**users** – CRM user data listing SWIDs (Software User IDs) along with date of birth and gender.

![](/assets/how-to-load-data-into-sandbox/users_file_load_data_sandbox.png)

**products** – CMS data that maps product categories to website URLs.
> **Note:** your products image should look similar to users image above.

![](/assets/how-to-load-data-into-sandbox/products_data_file_load_data_sandbox.png)

5.1) Now let’s use a Hive script to generate an “omniture” view that contains a subset of the data in the Omniture log table.

~~~
CREATE VIEW omniture AS  
SELECT col_2 ts, col_8 ip, col_13 url, col_14 swid, col_50 city, col_51 country, col_53 state 
FROM omniturelogs
~~~

![](/assets/how-to-load-data-into-sandbox/generate_omniture_subset_data_load_data_sandbox.png)

5.2) Click Save as. On the “Saving item” pop-up, type “omniture” in the box, then click OK.

![](/assets/how-to-load-data-into-sandbox/save_as_omniture_load_data_sandbox.png)

5.3) You can see your saved query now by clicking on the “Save Queries” button at the top.

![](/assets/how-to-load-data-into-sandbox/saved_query_save_queries_tab_load_data_sandbox.png)

5.4) Click Execute to run the script.

To view the data generated by the saved script, click on the icon next to the view’s name at the Database Explorer.  
The query results will appear, and you can see that the results include the data from the omniturelogs table that were specified in the query.

![](/assets/how-to-load-data-into-sandbox/omniture_sample_data_load_data_sandbox.png)

5.5) Finally, we’ll create a script that joins the omniture website log data to the CRM data (registered users) and CMS data (products). Click Query Editor, then paste the following text in the Query box:

~~~
create table webloganalytics 
as select to_date(o.ts) logdate, o.url, o.ip, o.city, upper(o.state) state, o.country, p.category, CAST(datediff( from_unixtime( unix_timestamp() ), from_unixtime( unix_timestamp(u.birth_dt, 'dd-MMM-yy'))) / 365 AS INT) age,  u.gender_cd from omniture o inner join products p on o.url = p.url left outer join users u on o.swid = concat('{', u.swid , '}');
~~~

5.6) Save this script as “webloganalytics” and execute the script.

![](/assets/how-to-load-data-into-sandbox/create_table_join_omniturelogs_crm_cms_load_data_sandbox.png)

You can view the data generated by the script as described in the preceding steps.

![](/assets/how-to-load-data-into-sandbox/view_webloganalytics_data_load_data_sandbox.png)

Now that you have loaded data into the Hortonworks Platform, you can use Business Intelligence (BI) applications such as Microsoft Excel to access and analyze the data.  

## Further Resources <a id="further-resources"></a>
- [Apache Hive](http://hortonworks.com/hadoop/hive/)
- [Hive Tutorials](http://hortonworks.com/hadoop/hive/#tutorials)
- [Hive Language Manual](https://cwiki.apache.org/confluence/display/Hive/LanguageManual+DDL)
- [HDP Developer: Apache Pig and Hive](http://hortonworks.com/training/class/hadoop-2-data-analysis-pig-hive/)
