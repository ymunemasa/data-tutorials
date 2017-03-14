---
title: Getting Started with Pivotal HAWQ on Hortonworks Sandbox
tutorial-id: 630
platform: hdp-2.5.0
tags: [Pivotal HAWQ]
---

# Getting Started with Pivotal HAWQ on Hortonworks Sandbox

## Introduction

Pivotal HAWQ provides strong support for low-latency analytic SQL queries, coupled with massively parallel machine learning capabilities on Hortonworks Data Platform (HDP). HAWQ is the World’s leading SQL on Hadoop tool. It provides the richest SQL dialect with an extensive data science library called MADlib at milliseconds query response times. HAWQ enables discovery-based analysis of large data sets via SQL and iterative development of data-driven analytics applications.

The tutorial is intended for someone completely new to using HAWQ. It should help you start working with the database, create tables, load data, and leverage HAWQ’s rich SQL dialect to query any data on HDFS, Hive, HBase, or other systems.

## Prerequisites

-   This tutorial assumes you have already already download the HAWQ-HDP Sandbox and have it running. If you haven’t downloaded the sandbox you can download it from [here](https://hortonworks.com/downloads/#sandbox)

## Outline

-   [Starting HAWQ and Checking State](#starting-hawq-and-checking-state)
-   [Connecting to HAWQ via PSQL Command Line](#connecting-to-hawq-via-psql-command-line)
-   [Load Sample Database](#load-sample-database)
-   [Running Queries](#running-queries)
-   [Using Other Tools to Work with HAWQ](#using-other-tools-to-work-with-hawq)
-   [Connecting to HAWQ via pgAdmin](#connecting-to-hawq-via-pgadmin)
-   [Further Reading](#further-reading)

## Starting HAWQ and Checking State

Start VirtualBox and log into your HDP-HAWQ virtual machine via the terminal. After logging into the virtual machine switch to HAWQ’s admin user called **gpadmin** and source the following file:

~~~
sudo su - gpadmin
source /usr/local/hawq/greenplum_path.sh
~~~

The gpadmin user is the power user of HAWQ and it’s mostly used by administrators.

You are able to run all of HAWQ’s administrative commands located under HAWQ’s bin directory. You can run any of these commands with –help option for complete description of its use and parameters. To see a list of available commands:

~~~
ls /usr/local/hawq/bin/
gpstate --help
~~~

Let’s start HAWQ by running either one of the following commands:

~~~
gpstart
~~~
or
~~~
gpstop -r -a
~~~

Now let’s check if HAWQ is running correctly. Run:

~~~
gpstate
~~~

**Image 1**

For complete list of HAWQ’s administrative commands refer to Management Utility Reference page. You can also read about Environment Variables, Server Configuration Parameters, and HAWQ toolkit.

## Connecting to HAWQ via PSQL Command Line

HAWQ uses Postgres’s psql command as its main front-end command line interface. psql is a terminal-based front-end to HAWQ. It enables you to type in queries interactively, see query results, and perform administrative tasks. In addition, it provides a number of meta-commands and various shell-like features to facilitate writing scripts and automating a wide variety of tasks.

To enter psql interface, still logged in as gpadmin user run:

~~~
psql
~~~

psql is capable of running your sql commands directly, like:

~~~
psql -c "select generate_series(1,10) as ids"
~~~

When you first start psql, you might feel a little lost! psql has a set of it’s own directives to view tables, schemas, databases, etc… but not to worry, every time you forget these directives just type:

~~~
gpadmin# ?
~~~

Or to get help for a particular SQL command use the h option like:

~~~
gpadmin# h CREATE ROLE
~~~

In the following sections you’ll see how to use psql to create tables, load data, and query tables.

**Note**: to exit psql type:

~~~
gpadmin# q
~~~

You can follow the complete guide for psql on Postgres documentation page or on HAWQ’s documentation page.

## Load Sample Database

Let’s start creating some tables and loading sample data. In order to get you jump started we’ve created a sample database that resembles a typical retailer datamart. Download hawq-quickstart package.

Copy hawq-quickstart.zip to your HDP Sandbox and unzip it.

**Note**: The gpadmin user password on the Sandbox is “gpadmin”.

~~~
scp hawq-quickstart.zip gpadmin@10.0.2.15:/tmp
ssh gpadmin@10.0.2.15
cd /tmp
unzip hawq-quickstart.zip
cd /tmp/hawq-quickstart/
~~~

To create the database and load the tables just run the setup.sh script:

~~~
./setup.sh
~~~

**Image 2**

Let’s take a closer look.

The script first executes /tmp/hawq-quickstart/lib/prep_database.sql (image 3) to setup the database, create schema, users, resources queues, and roles. Open this file and take a look at the SQL commands used to create and setup the database:

~~~
more /tmp/hawq-quickstart/lib/prep_database.sql
~~~

**Image 3**

The database is called “demo” and the schema is called “retail_demo”. To view objects in this schema let’s set back to psql and show you how to change your search_path and view objects in psql:

~~~
psql
~~~

~~~
gpadmin# c demo
demo# set search_path=retail_demo;
demo# d
                        List of relations
   Schema    |          Name          | Type  |  Owner  | Storage
-------------+------------------------+-------+---------+---------
 retail_demo | categories_dim         | table | gpadmin | parquet
 retail_demo | customer_addresses_dim | table | gpadmin | parquet
 retail_demo | customers_dim          | table | gpadmin | parquet
 retail_demo | date_dim               | table | gpadmin | parquet
 retail_demo | email_addresses_dim    | table | gpadmin | parquet
 retail_demo | order_lineitems        | table | gpadmin | parquet
 retail_demo | orders                 | table | gpadmin | parquet
 retail_demo | payment_methods        | table | gpadmin | parquet
 retail_demo | products_dim           | table | gpadmin | parquet
demo# q
~~~

The second script creates all the tables under retail_demo schema. Open /tmp/hawq-quickstart/lib/prep_tables.sql and pay attention to the syntax and table options choices. View the file:

~~~
more /tmp/hawq-quickstart/lib/prep_tables.sql
~~~

**Image 4**

You can review a table schema by using the psql d directive, like:

~~~
demo=# d products_dim
  Parquet Table "retail_demo.products_dim"
    Column    |       Type       | Modifiers
--------------+------------------+-----------
 product_id   | integer          |
 category_id  | integer          |
 price        | double precision |
 product_name | text             |
Compression Type: snappy
Compression Level: 0
Page Size: 1048576
RowGroup Size: 8388608
Checksum: f
Distributed randomly
~~~

## Running Queries
Now, let’s run some queries. Either get creative and try your own queries or open ./lib/queries.sql and try some of the sample queries. You can quickly see that HAWQ can run as complex as queries that you can throw at it!

For example, the following query checks for customers who have bought DVD’s in the past year and have bought as least one Blue-ray disc player in the past 6 months; but have not bought a Blu-ray disk to play! We can use the results to email these clients with our latest Blue-ray disc promotions.

~~~
SELECT customers.customer_id
,      email.email_address
,      DVDs_2010
,      customers.Last_BluRay_2010
,      customers.First_Player_2010
FROM  (SELECT oli.customer_id
       ,      SUM(CASE WHEN cat.category_name = 'DVD'
                  THEN item_quantity ELSE 0 END) AS DVDs_2010
       ,      SUM(CASE WHEN cat.category_name = 'DVD'
                       AND  prod.product_name LIKE '%Blu-ray%'
                       AND  oli.order_datetime BETWEEN date '06-01-2010' AND date '12-30-2010'
                  THEN item_quantity ELSE 0 END) AS Last_BluRay_2010
       ,      SUM(CASE WHEN cat.category_name = 'CE'
                       AND  prod.product_name LIKE '%Blu-ray%'
                       AND  oli.order_datetime BETWEEN date '06-01-2010' AND date '12-30-2010'
                  THEN item_quantity ELSE 0 END) AS First_Player_2010
       FROM   retail_demo.order_lineitems oli
       ,      retail_demo.products_dim prod
       ,      retail_demo.categories_dim cat
       WHERE  oli.product_id = prod.product_id
       AND    prod.category_id = cat.category_id
       AND    cat.category_name IN ('DVD', 'CE')
       GROUP BY oli.customer_id
      ) AS customers
,     retail_demo.email_addresses_dim email
WHERE customers.customer_id = email.customer_id
AND   DVDs_2010 > 0
AND   Last_BluRay_2010 > 0
AND   First_Player_2010 = 0
GROUP BY customers.customer_id
,      email.email_address
,      DVDs_2010
,      customers.Last_BluRay_2010
,      customers.First_Player_2010
ORDER BY DVDs_2010 DESC
limit 50;
~~~

free, play around! Try other SQL commands.

Refer to HAWQ documentation page on Working with Databases for an in-depth guide on loading data to HAWQ and submitting queries. You also have the complete SQL Commands reference guide.

## Using Other Tools to Work with HAWQ
Connecting to HAWQ via BI Tools (JDBC or ODBC)
Aside from psql or pgAdminIII, you can use any other tool of your preference that uses JDBC or ODBC. This could be tools like Tableau, Microstrategy, SQuirreL SQL, etc…

To use these tools:

You can download HAWQ JDBC/ODBC drivers from Pivotal Networks.
HAWQ uses Postgres drivers. Some tools like Tableau already come with pre-installed drivers. For example in Tableau you can either use the “Greenplum” or “Postgres” connections to connect to HAWQ.
Follow the instructions to enable client connections on HAWQ in “Opening Client Connections” section below.
To connect to the HAWQ instance running on your sandbox; use:

~~~
IP: your sandbox IP address
PORT: 15432
USER: gpadmin
PASSWORD: gpadmin
~~~

Opening Client Connections:

Before connecting to HAWQ via a client tool you have to let HAWQ know that is ok to trust client connections. In order to open the connection from client you must edit you pg_hba.conf file in your $MASTER_DATA_DIRECTORY.

~~~
vi /data/hawq/master/gpseg-1/pg_hba.conf
~~~

Add the following line to the end of this file:

~~~
host all gpadmin 0.0.0.0/0 trust
~~~

This line will open the gpadmin client connection from any host. For your changes to take effect, reload your configuration file by running:

~~~
gpstop -u
~~~

## Connecting to HAWQ via pgAdmin

Alternatively to psql command line interface, you can use pgAdmin3 as the graphical interface to interact with HAWQ. The graphical interface allows you to create tables, submit queries, and see the query results. Download and install pgAdmin3 from [http://www.pgadmin.org/](http://www.pgadmin.org/).

Follow image 5 to configure your connection to HAWQ master via pgAdmin.

**Image 5**

**Note**: The port that HAWQ is running on the sandbox is 15432.

**Note**: If you run into an issue similar to image 6 below; Follow “Opening Client Connections” in the previous section of this guide.

**Image 6**

After a successful connection you should see a screen similar to image 7:

**Image 7**

For complete guide on using pgAdminIII with HAWQ refer to pgAdmin III for HAWQ.

## Further Reading

To become more familiar with HAWQ and all its use-cases refer to HAWQ Documentation page online . Pivotal also offers in-depth online and instructor lead training on HAWQ. For more information please visit Pivotal Academy and Pivotal Training.

Pivotal also offers in-depth online and instructor lead training on HAWQ. For more information please visit Pivotal Academy and Pivotal Training.
