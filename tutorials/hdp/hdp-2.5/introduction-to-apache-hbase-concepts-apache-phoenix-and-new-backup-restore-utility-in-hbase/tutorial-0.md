---
title: Introduction to Apache HBase Concepts, Apache Phoenix and New Backup & Restore Utility in HBase
tutorial-id: 650
platform: hdp-2.5.0
tags: [hbase, ambari]
---

# Introduction to Apache HBase Concepts, Apache Phoenix and New Backup & Restore Utility in HBase

## Lab 1: Introducing Apache HBase Concepts

## Introduction

HBase is a distributed column-oriented database built on top of the Hadoop file system. It is an open-source project and is horizontally scalable. HBase is a data model that is similar to Google’s big table designed to provide quick random access to huge amounts of unstructured data. It leverages the fault tolerance provided by the Hadoop File System (HDFS).

The components of HBase data model consist of tables, rows, column families, columns, cells and versions. Tables are like logical collection of rows stored in separate partitions. A row is one instance of data in a table and is identified by a  rowkey. Data in a row are grouped together as Column Families. Each Column Family has one or more Columns and these Columns in a family are stored together. Column Families form the basic unit of physical storage, hence it’s important that proper care be taken when designing Column Families in table. A Column is identified by a Column Qualifier that consists of the Column Family name concatenated with the Column name using a colon. A Cell stores data and is essentially a unique combination of rowkey, Column Family and the Column (Column Qualifier). The data stored in a cell is versioned and versions of data are identified by the timestamp.

For more information, refer HBase documentation [here](https://hortonworks.com/apache/hbase/).

In this tutorial, we are going to walk you through some basic HBase shell commands, how to use Apache Phoenix which enables OLTP and operational analytics in Hadoop by combining the power of standard SQL and JDBC APIs and the flexibility of late-bound, schema-on-read capabilities from the NoSQL world by leveraging HBase as its backing store.

## Prerequisites

-   [Download Hortonworks 2.5 Sandbox](https://hortonworks.com/downloads/#sandbox)
-   Complete the [Learning the Ropes of the Hortonworks Sandbox tutorial,](https://hortonworks.com/hadoop-tutorial/learning-the-ropes-of-the-hortonworks-sandbox/) you will need it for logging into Ambari as an administrator user.

## Outline

-   [1. Start HBase](#start-hbase)
    -   [1.1 View the HBase Services page](#view-hbase-service)
    -   [1.2 Start HBase Service](#start-hbase-service)
-   [2. Enter HBase Shell](#enter-hbase-shell)
-   [3. Data Definition Language Commands in HBase](#ddl-hbase)
    -   [3.1 Create](#create)
    -   [3.2 List](#list)
-   [4. Data Manipulation Commands in HBase](#dml-hbase)
    -   [4.1 Scan](#scan)
    -   [4.2 Put](#put)
    -   [4.3 Get](#get)
-   [Summary](#summary)
-   [Appendix](#appendix)

## 1. Start HBase <a id="start-hbase"></a>

### 1.1 View the HBase Services page <a id="view-hbase-service"></a>

In order to start/stop HBase service, you must log into Ambari as an administrator. The default account (maria_dev) will not allow you to do this. Please follow these step to setup password for admin account.
First SSH into the Hortonworks Sandbox with the command:

~~~
$>ssh root@127.0.0.1 -p 2222
~~~

![sshTerminal](assets/sshTerminal.png)

If do do not have ssh client, you can also access the shell via `http://localhost:4200/`
Now run the following command to reset the password for user `admin`:

~~~
$>ambari-admin-password-reset
~~~

![admin_password_reset](assets/admin_password_reset.png)

Now navigate to Ambari on 127.0.0.1:8080 on the browser and give your credentials

From the Dashboard page of Ambari, click on `HBase` from the list of installed services.

![hbaseServiceOnOff](assets/hbase_service_on_off_iot.png)

### 1.2 Start HBase Service <a id="start-hbase-service"></a>

From the HBase page, click on Service Actions -> `Start`

![starthbaseService](assets/start_hbase_service_iot.png)

Check the box and click on Confirm Start:

![confirmhbaseStartIot](assets/confirm_hbase_start_iot.png)

Check the box to turn off the Maintenance Mode as it suppresses alerts, warnings and status change indicators generated for the object.
Wait for HBase to start (It may take a few minutes to turn green)

![hbaseStartedIot](assets/hbase_started_iot.png)

## 2. Enter HBase Shell <a id="enter-hbase-shell"></a>

HBase comes with an interactive shell from where you can communicate with HBase components and perform operations on them.

First SSH into the Hortonworks Sandbox with the command:

Switch the user to hbase.

~~~
$>su hbase
~~~

![switchTohbase](assets/switch_to_hbase.png)

Type `hbase shell` and you will see the following screen:

![enterhbaseShell](assets/enter_HBase_shell.png)

To exit the interactive shell, type `exit` or use `<ctrl+c>`. But wait, it is time to explore more features of the shell.

## 3. Data Definition Language Commands in HBase <a id="ddl-hbase"></a>

These are the commands that operate on tables in HBase.

### 3.1 Create <a id="create"></a>

The syntax to create a table in HBase is `create '<table_name>','<column_family_name>'`. Let’s create a table called '**driver_dangerous_event'** with a column family of name **events**. Run the following command:

~~~
hbase> create 'driver_dangerous_event','events'
~~~

![create_table](assets/create_table.png)

### 3.2 List <a id="list"></a>

Let’s check the table we’ve just created, type the following command in the HBase shell

~~~
hbase> list
~~~

![list_table](assets/list_table.png)

## 4. Data Manipulation Commands in HBase <a id="dml-hbase"></a>

Let’s import some data into the table. We’ll use a sample dataset that tracks driving record of a logistics company.

Open a new terminal and ssh into the Sandbox. Download the data.csv file and let’s copy the file in HDFS,

~~~
$>ssh root@127.0.0.1 -p 2222

$>curl -o ~/data.csv https://raw.githubusercontent.com/hortonworks/data-tutorials/d0468e45ad38b7405570e250a39cf998def5af0f/tutorials/hdp/hdp-2.5/introduction-to-apache-hbase-concepts-apache-phoenix-and-new-backup-restore-utility-in-hbase/assets/data.csv

$>hadoop fs -copyFromLocal ~/data.csv /tmp
~~~

![copyFromLocal_data_csv](assets/copyFromLocal_data_csv.png)

Now execute the `LoadTsv` from hbase user statement as following:

~~~
$>su hbase

$>hbase org.apache.hadoop.hbase.mapreduce.ImportTsv -Dimporttsv.separator=,  -Dimporttsv.columns="HBASE_ROW_KEY,events:driverId,events:driverName,events:eventTime,events:eventType,events:latitudeColumn,events:longitudeColumn,events:routeId,events:routeName,events:truckId" driver_dangerous_event hdfs://sandbox.hortonworks.com:/tmp/data.csv
~~~

![importtsv_command](assets/importtsv_command.png)

Now let’s check whether the data got imported in the table `driver_dangerous_events` or not. Go back to the `hbase shell`.

### 4.1 Scan <a id="scan"></a>

The scan command is used to view the data in the HBase table. Type the following command:
`scan 'driver_dangerous_event'`

You will see all the data present in the table with row keys and the different values for different columns in a column family.

![scan_command](assets/scan_command.png)

### 4.2 Put <a id="put"></a>

Using put command, you can insert rows in a HBase table. The syntax of put command is as follows:
`put '<table_name>','row1','<column_family:column_name>','value'`

Copy following lines to put the data in the table.

~~~
put 'driver_dangerous_event','4','events:driverId','78'
put 'driver_dangerous_event','4','events:driverName','Carl'
put 'driver_dangerous_event','4','events:eventTime','2016-09-23 03:25:03.567'
put 'driver_dangerous_event','4','events:eventType','Normal'
put 'driver_dangerous_event','4','events:latitudeColumn','37.484938'
put 'driver_dangerous_event','4','events:longitudeColumn','-119.966284'
put 'driver_dangerous_event','4','events:routeId','845'
put 'driver_dangerous_event','4','events:routeName','Santa Clara to San Diego'
put 'driver_dangerous_event','4','events:truckId','637'
~~~

![put_command](assets/put_command.png)

Now let’s view a data from scan command.

~~~
hbase>scan 'driver_dangerous_event'
~~~

![scan_command1](assets/scan_command1.png)

You can also update an existing cell value using the `put` command. The syntax for replacing is same as inserting a new value.

So let’s update a route name value of row key 4, from `'Santa Clara to San Diego'` to `'Santa Clara to Los Angeles'`. Type the following command in HBase shell:

~~~
hbase>put 'driver_dangerous_event','4','events:routeName','Santa Clara to Los Angeles'
~~~

![update_table](assets/update_table.png)

Now scan the table to see the updated data:

~~~
hbase>scan 'driver_dangerous_event'
~~~

![scan_command2](assets/scan_command2.png)

### 4.3 Get <a id="get"></a>

It is used to read the data from HBase table. It gives a single row of data at a time. Syntax for get command is:
`get '<table_name>','<row_number>'`

Try typing `get 'driver_dangerous_event','1'` in the shell. You will see the all the column families (in our case, there is only 1 column family) along with all the columns in the row.

![get_command](assets/get_command.png)

You can also read a specific column from get command. The syntax is as follows:
`get 'table_name', 'row_number', {COLUMN ⇒ 'column_family:column-name '}`

Type the following statement to get the details from the row 1 and the driverName of column family events.

~~~
hbase>get 'driver_dangerous_event','1',{COLUMN => 'events:driverName'}
~~~

![get_command_column](assets/get_command_column.png)

If you want to view the data from two columns, just add it to the {COLUMN =>...} section. Run the following command to get the details from row key 1 and the driverName and routeId of column family events:

~~~
hbase>get 'driver_dangerous_event','1',{COLUMNS => ['events:driverName','events:routeId']}
~~~

![get_command_two_columns](assets/get_command_two_columns.png)

## Summary <a id="summary"></a>

In this tutorial, we learned about the basic concepts of Apache HBase and different types of data definition and data manipulation commands that are available in HBase shell. Check out the lab 2 of this tutorial where we are going to learn how to use Apache Phoenix with Apache HBase.

## Appendix <a id="appendix"></a>

**ImportTsv Utility in HBase:**

ImportTsv is a utility that will load data in TSV or CSV format into a specified HBase table. The column names of the TSV data must be specified using the -Dimporttsv.columns option. This option takes the form of comma-separated column names, where each column name is either a simple column family, or a columnfamily:qualifier. The special column name HBASE_ROW_KEY is used to designate that this column should be used as the row key for each imported record. You must specify exactly one column to be the row key, and you must specify a column name for every column that exists in the input data. In our case, events is a column family and driverId, driverName,etc are columns.

Next argument is the table name where you want the data to be imported
Third argument specifies the input directory of CSV data.
