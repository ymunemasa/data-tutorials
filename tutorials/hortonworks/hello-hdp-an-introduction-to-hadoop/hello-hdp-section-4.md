# Lab 2: Hive - Data ETL

## Data manipulation with Hive

## Introduction

In this section of tutorial, you will be introduced to Apache Hive. In the earlier section, we covered how to load data into HDFS. So now you have **geolocation** and **trucks** files stored in HDFS as csv files. In order to use this data in Hive, we will tell you how to create a table and how to move data into Hive warehouse, from where it can be queried upon. We will analyze this data using SQL queries in Hive User Views and store it as ORC. We will also walk through Apache Tez and how a DAG is created when you specify Tez as execution engine for Hive. Lets start..!!

## Pre-Requisites

The tutorial is a part of series of hands on tutorial to get you started on HDP using Hortonworks sandbox. Please ensure you complete the prerequisites before proceeding with this tutorial.

*   [Learning the Ropes of the Hortonworks Sandbox](http://hortonworks.com/hadoop-tutorial/learning-the-ropes-of-the-hortonworks-sandbox/)
*   Downloaded and Installed latest [Hortonworks Sandbox](http://hortonworks.com/products/hortonworks-sandbox/#install)
*   Lab 1: Load sensor data into HDFS
*   Allow yourself around **one hour** to complete this tutorial.

## Outline

*   [Hive basics](#hive-basics)
*   [Step 2.1: Use Ambari Hive User Views](#use-ambari-hive-user-views)
*   [Step 2.2: Define a Hive Table](#define-a-hive-table)
*   [Step 2.3: Load Data into Hive Table](#load-data-hive-table)
*   [Step 2.4: Define an ORC table in Hive](#define-orc-table-hive)
*   [Step 2.5: Review Hive Settings](#review-hive-settings)
*   [Step 2.6: Analyze Truck Data](#analyze-truck-data)
*   [Suggested readings](#suggested-readings)

## Hive <a id="hive-basics"></a>

Hive is a SQL like query language that enables analysts familiar with SQL to run queries on large volumes of data.  Hive has three main functions: data summarization, query and analysis. Hive provides tools that enable easy data extraction, transformation and loading (ETL).

## Step 2.1: Become Familiar with Ambari Hive User View <a id="use-ambari-hive-user-views"></a>

Apache Hive™ presents a relational view of data in HDFS and ensures that users need not worry about where or in what format their data is stored.  Hive can display data from RCFile format, text files, ORC, JSON, parquet,  sequence files and many of other formats in a tabular view.   Through the use of SQL you can view your data as a table and create queries like you would in an RDBMS.

To make it easy to interact with Hive we use a tool in the Hortonworks Sandbox called the Ambari Hive User View.   Ambari Hive User View provides an interactive interface to Hive.   We can create, edit, save and run queries, and have Hive evaluate them for us using a series of MapReduce jobs or Tez jobs.

Let’s now open the Ambari Hive User View and get introduced to the environment, go to the 9 square Ambari User View icon and select **Hive**:


![Screen Shot 2015-07-21 at 10.10.18 AM](/assets/hello-hdp/hive_view_hdp_2_4_current.png)


The Ambari Hive User View looks like the following:


![Lab2_2](/assets/hello-hdp/ambari_hive_user_view_interface_hello_hdp_concepts.png)


Now let’s take a closer look at the SQL editing capabilities in the User View:

1.  There are _five tabs_ to interact with SQL:
    1.  **Query**: This is the interface shown above and the primary interface to write, edit and execute new SQL statements
    2.  **Saved Queries**: You can save your favorite queries and quickly have access to them to rerun or edit.
    3.  **History**: This allows you to look at past queries or currently running queries to view, edit and rerun.  It also allows you to see all SQL queries you have authority to view.  For example, if you are an operator and an analyst needs help with a query, then the Hadoop operator can use the History feature to see the query that was sent from the reporting tool.
    4.  **UDFs**:  Allows you to define UDF interfaces and associated classes so you can access them from the SQL editor.
    5.  **Upload Table**: Allows you to upload your hive query tables to your preferred database and appears instantly in the Query Editor for execution.
2.  **Database Explorer:**  The Database Explorer helps you navigate your database objects.  You can either search for a database object in the Search tables dialog box, or you can navigate through Database -> Table -> Columns in the navigation pane.
3.  The principle pane to write and edit SQL statements. This editor includes content assist via **CTRL + Space** to help you build queries. Content assist helps you with SQL syntax and table objects.
4.  Once you have created your SQL statement you have 3 options:
    1.  **Execute**: This runs the SQL statement.
    2.  **Explain**: This provides you a visual plan, from the Hive optimizer, of how the SQL statement will be executed.
    3.  **Save as**:  Allows you to persist your queries into your list of saved queries.
    4.  **Kill Session**: Terminates the SQL statement.
5.  When the query is executed you can see the Logs or the actual query results.
    1.  **Logs:** When the query is executed you can see the logs associated with the query execution.  If your query fails this is a good place to get additional information for troubleshooting.
    2.  **Results**: You can view results in sets of 50 by default.
6.  There are five sliding views on the right hand side with the following capabilities, which are in context of the tab you are in:
    1.  **Query**: This is the default operation,which allows you to write and edit SQL.
    2.  **Settings**:  This allows you to set properties globally or associated with an individual query.
    3.  **Data Visualization**: Allows you to visualize your numeric data through different charts.
    4.  **Visual Explain**: This will generate an explain for the query.  This will also show the progress of the query.
    5.  **TEZ**: If you use TEZ as the query execution engine then you can view the DAG associated with the query.  This integrates the TEZ User View so you can check for correctness and helps with performance tuning by visualizing the TEZ jobs associated with a SQL query.
    6.  **Notifications**: This is how to get feedback on query execution.

Take a few minutes to explore the various Hive User View features.

## Step 2.2: Define a Hive Table <a id="define-a-hive-table"></a>

Now that you are familiar with the Hive User View, let’s create the initial staging tables for the geolocation and trucks data. In this section we will learn how to use the Ambari Hive User View to create four tables: geolocaiton_stage, trucking_stage, geolocation, trucking.  First we are going to create 2 tables to stage the data in their original csv text format and then will create two more tables where we will optimize the storage with ORC. Here is a **visual representation of the Data Flow**:


![Lab2_3](/assets/hello-hdp/Lab2_31.png)


### 2.2.1 Create Table geolocation_stage For Staging Initial Load

Copy-and-paste the the following table DDL into the empty **Worksheet** of the **Query Editor** to define a new table named geolocation_stage:

~~~
CREATE TABLE geolocation_stage (truckid string, driverid string, event string, latitude DOUBLE, longitude DOUBLE, city string, state string, velocity BIGINT, event_ind BIGINT, idling_ind BIGINT)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
STORED AS TEXTFILE
TBLPROPERTIES ("skip.header.line.count"="1");
~~~

### 2.2.2 Execute Query

Click the green **Execute** button to run the command. If successful, you should see the **Succeeded** status in the **Query Process Results** section:


![Lab2_4](/assets/hello-hdp/create_geolocation_stage_table_hello_hdp_lab2.png)


### 2.2.3 Create New Worksheet

Click the blue **New Worksheet** button:


![Lab2_5](/assets/hello-hdp/Lab2_51.png)


### 2.2.4 Rename Query Worksheet

Notice the tab of your new Worksheet is labeled **“Worksheet (1)”**. Double-click on this tab to rename the label to **"trucks_stage"**:


![Lab2_6](/assets/hello-hdp/Lab2_6.png)


### 2.2.5 Create Table trucks_stage For Staging Initial Load

Copy-and-paste the following table DDL into your **trucks_stage** worksheet to define a new table named trucks_stage:

~~~
CREATE TABLE trucks_stage(driverid string, truckid string, model string, jun13_miles bigint, jun13_gas bigint, may13_miles bigint, may13_gas bigint, apr13_miles bigint, apr13_gas bigint, mar13_miles bigint, mar13_gas bigint, feb13_miles bigint, feb13_gas bigint, jan13_miles bigint, jan13_gas bigint, dec12_miles bigint, dec12_gas bigint, nov12_miles bigint, nov12_gas bigint, oct12_miles bigint, oct12_gas bigint, sep12_miles bigint, sep12_gas bigint, aug12_miles bigint, aug12_gas bigint, jul12_miles bigint, jul12_gas bigint, jun12_miles bigint, jun12_gas bigint,may12_miles bigint, may12_gas bigint, apr12_miles bigint, apr12_gas bigint, mar12_miles bigint, mar12_gas bigint, feb12_miles bigint, feb12_gas bigint, jan12_miles bigint, jan12_gas bigint, dec11_miles bigint, dec11_gas bigint, nov11_miles bigint, nov11_gas bigint, oct11_miles bigint, oct11_gas bigint, sep11_miles bigint, sep11_gas bigint, aug11_miles bigint, aug11_gas bigint, jul11_miles bigint, jul11_gas bigint, jun11_miles bigint, jun11_gas bigint, may11_miles bigint, may11_gas bigint, apr11_miles bigint, apr11_gas bigint, mar11_miles bigint, mar11_gas bigint, feb11_miles bigint, feb11_gas bigint, jan11_miles bigint, jan11_gas bigint, dec10_miles bigint, dec10_gas bigint, nov10_miles bigint, nov10_gas bigint, oct10_miles bigint, oct10_gas bigint, sep10_miles bigint, sep10_gas bigint, aug10_miles bigint, aug10_gas bigint, jul10_miles bigint, jul10_gas bigint, jun10_miles bigint, jun10_gas bigint, may10_miles bigint, may10_gas bigint, apr10_miles bigint, apr10_gas bigint, mar10_miles bigint, mar10_gas bigint, feb10_miles bigint, feb10_gas bigint, jan10_miles bigint, jan10_gas bigint, dec09_miles bigint, dec09_gas bigint, nov09_miles bigint, nov09_gas bigint, oct09_miles bigint, oct09_gas bigint, sep09_miles bigint, sep09_gas bigint, aug09_miles bigint, aug09_gas bigint, jul09_miles bigint, jul09_gas bigint, jun09_miles bigint, jun09_gas bigint, may09_miles bigint, may09_gas bigint, apr09_miles bigint, apr09_gas bigint, mar09_miles bigint, mar09_gas bigint, feb09_miles bigint, feb09_gas bigint, jan09_miles bigint, jan09_gas bigint)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
STORED AS TEXTFILE
TBLPROPERTIES ("skip.header.line.count"="1");
~~~


![create_trucks_stage_table](/assets/hello-hdp/create_trucks_stage_hello_hdp_lab2.png)


### 2.2.6 Execute the Query and Verify it Runs Successfully

Let’s review some aspects of the **CREATE TABLE** statements issued above.  If you have a SQL background this statement should seem very familiar except for the last 3 lines after the columns definition:

*   The **ROW FORMAT** clause specifies each row is terminated by the new line character.
*   The **FIELDS TERMINATED** BY clause specifies that the fields associated with the table (in our case, the two csv files) are to be delimited by a comma.
*   The **STORED AS** clause specifies that the table will be stored in the TEXTFILE format.

For details on these clauses consult the [Apache Hive Language Manual](https://cwiki.apache.org/confluence/display/Hive/LanguageManual+DDL).

### 2.2.7 Verify New Tables Exist

To verify the tables were defined successfully, click the **“refresh”** icon in the Database Explorer. Under Databases, click default database to expand the list of table and the new tables should appear:


![Lab2_7](/assets/hello-hdp/Lab2_7.png)


### 2.2.8 View trucks_stage Schema

Click on the **trucks_stage** table name to view its schema.

### 2.2.9 Load Sample Data of trucks_stage

Click on the **Load sample data** icon to generate and execute a select SQL statement to query the table for a 100 rows. Notice your two new tables are currently empty.

- You can have multiple SQL statements within each editor worksheet, but each statement needs to be separated by a semicolon **“;”**.

- If you have multiple statements within a worksheet but you only want to run one of them just highlight the statement you want ran and then click the Execute button.

**A few additional commands to explore tables:**

- `show tables;` List the tables created in the database by looking up the list of tables from the metadata stored in HCatalogdescribe
-`{table_name}`;Provides a list of columns for a particular table (ie `describe geolocation_stage;`)
- `show create {table_name};`Provides the DDL to recreate a table (ie `show create table geolocation_stage;`)

 By default, when you create a table in Hive, a directory with the same name gets created in the /apps/hive/warehouse folder in HDFS.  Using the Ambari Files User View, navigate to the /apps/hive/warehouse folder. You should see both a geolocation_stage and trucks_stage directory:


![Lab2_8](/assets/hello-hdp/geolocation_tables_created_hive_warehouse_hello_hdp_lab2.png)


- The definition of a Hive table and its associated metadata (i.e., the directory the data is stored in, the file format, what Hive properties are set, etc.) are stored in the Hive metastore, which on the Sandbox is a MySQL database.

## Step 2.3: Load Data into a Hive table <a id="load-data-hive-table"></a>

### 2.3.1 Manual Approach: Populate Hive Table with Data

Let’s load some data into your two Hive tables. Populating a Hive table can be done in various ways. A simple way to populate a table is to put a file into the directory associated with the table. Using the Ambari Files User View, click on the **Move** icon next to the file `/tmp/maria_dev/data/geolocation.csv`. (Clicking on **Move** is similar to “cut” in cut-and-paste.)


![Screen Shot 2015-07-27 at 9.45.11 PM](/assets/hello-hdp/move_geolocation_csv_file_hello_hdp_lab2.png)


#### 2.3.1.1 After clicking on the Move arrow, your screen should look like the following:


![Lab2_10](/assets/hello-hdp/cut_paste_geolocation_csv_file_hello_hdp_lab2.png)


#### 2.3.1.2 Notice two things have changed:

1.  The file name geolocation.csv has grayed out some
2.  The icons associated with the operations on the files are removed. This is to indicate that this file is in a special state that is ready to be moved.

#### 2.3.1.3 Navigate to Destination Path and Paste File

Now navigate to the destination path /apps/hive/warehouse/geolocation_stage.  You might notice that as you navigate through the directories that the file is pinned at the top.  Once you get to the appropriate directory click on the **Paste** icon to move the file:


![Lab2_11](/assets/hello-hdp/paste_geolocation_to_warehouse_hello_hdp_lab2.png)


#### 2.3.1.4 Load Sample Data of geolocation_stage

Go back to the Ambari Hive View and click on the **Load sample data** icon next to the geolocation_stage table. Notice the table is no longer empty, and you should see the first 100 rows of the table:


![Lab2_12](/assets/hello-hdp/Lab2_12.png)


### 2.3.2 Automatic Approach: Populate Hive Table with Data

Enter the following SQL command into an empty Worksheet in the Ambari Hive User View:

~~~
LOAD DATA INPATH '/tmp/maria_dev/data/trucks.csv' OVERWRITE INTO TABLE trucks_stage;
~~~

#### 2.3.2.1 Load Sample Data of trucks_stage

You should now see data in the trucks_stage table:


![Lab2_13](/assets/hello-hdp/Lab2_13.png)


#### 2.3.2.2 Click on HDFS Files View

Navigate to the `/tmp/maria_dev/data` folder. Notice the folder is empty! The **LOAD DATA INPATH** command moved the `trucks.csv` file from the `/user/maria_dev/data` folder to the `/apps/hive/warehouse/trucks_stage` folder.

## Step 2.4: Define an ORC Table in Hive <a id="define-orc-table-hive"></a>

**Introducing** [**Apache ORC**](https://cwiki.apache.org/confluence/display/Hive/LanguageManual+ORC)

The Optimized Row Columnar ([new Apache ORC project](http://hortonworks.com/blog/apache-orc-launches-as-a-top-level-project/)) file format provides a highly efficient way to store Hive data. It was designed to overcome limitations of the other Hive file formats. Using ORC files improves performance when Hive is reading, writing, and processing data.

To use the ORC format, specify ORC as the file format when creating the table:

~~~
CREATE TABLE … **STORED AS ORC**
~~~

In this step, you will create two ORC tables (geolocation and trucks) that are created from the text data in your geolocation_stage and trucks_stage tables.

### 2.4.1 Create Table geolocation as ORC From geolocation_stage Table  

From the Ambari Hive User View, execute the following table DDL to define a new table named geolocation:

~~~
CREATE TABLE geolocation STORED AS ORC AS SELECT * FROM geolocation_stage;
~~~

### 2.4.2 Verify table geolocation is in default database

Refresh the **Database Explorer** and verify you have a table named geolocation in the default database:


![Lab2_14](/assets/hello-hdp/Lab2_14.png)


1) View the contents of the geolocation table and notice it contains the same rows as geolocation_stage.

2) Verify geolocation is an ORC Table, execute the following query:

~~~
describe formatted geolocation;
~~~

3) Scroll down to the bottom of the **Results** tab and you will see a section labeled **Storage Information**. The output should look like:


![Lab2_15](/assets/hello-hdp/Lab2_15.png)


### 2.4.3 Create Table trucks As ORC From trucks_stage Table

Execute the following query to define a new ORC table named trucks that contains the data from trucks_stage:

~~~
CREATE TABLE trucks STORED AS ORC TBLPROPERTIES ("orc.compress.size"="1024") AS SELECT * FROM trucks_stage;
~~~

### 2.4.4 Verify Table was Properly Created

Refresh the **Database Explorer** and view the contents of trucks:


![Lab2_16](/assets/hello-hdp/Lab2_16.png)


### 2.4.5 Enter Hive Shell

If you want to try running some of these commands from the Hive Shell, follow the following steps from your terminal shell (or putty if using Windows):


i.  `ssh root@127.0.0.1 -p 2222` Root password is hadoop
    1. (for azure users enter `ssh <_username_>@<_ipaddress_> -p <_port_>`). Username is the name you gave your sandbox, and ip address is located on the dashboard.
ii.  `su hive`  
iii.  `hive` Starts Hive shell and now you can enter commands and SQL  
iv.  `quit;` Exits out of the Hive shell.


## Step 2.5: Review Hive Settings <a id="review-hive-settings"></a>

### 2.5.1 Open Ambari Dashboard in New Tab

Open the Ambari Dashboard in another tab by right clicking on the Ambari icon:


![Lab2_17](/assets/hello-hdp/Lab2_17.png)


### 2.5.2 Open Hive Settings

Go to the **Hive page** then select the **Configs tab** then click on **Settings tab**:


![Lab2_18](/assets/hello-hdp/hive_settings_hello_hdp_lab2.png)


Once you click on the Hive page you should see a page similar to above:

1.  **Hive** Page
2.  Hive **Configs** Tab
3.  Hive **Settings** Tab
4.  Version **History** of Configuration

Scroll down to the **Optimization Settings**:


![Lab2_19](/assets/hello-hdp/hive_optimization_settings_hello_hdp_lab2.png)


In the above screenshot we can see:

1.  **Tez** is set as the optimization engine
2.  **Cost Based Optimizer** (CBO) is turned on

This shows the new HDP 2.4 **Ambari Smart Configurations**, which simplifies setting configurations

- Hadoop is configured by a **collection of XML files**.
- In early versions of Hadoop, operators would need to do **XML editing** to **change settings**.  There was no default versioning.
- Early Ambari interfaces made it **easier to change values** by showing the settings page with **dialog boxes** for the various settings and allowing you to edit them.  However, you needed to know what needed to go into the field and understand the range of values.
- Now with Smart Configurations you can **toggle binary features** and use the slider bars with settings that have ranges.

By default the key configurations are displayed on the first page.  If the setting you are looking for is not on this page you can find additional settings in the **Advanced** tab:


![Lab2_20](/assets/hello-hdp/hive_advanced_settings.png)


For example, what if we wanted to **improve SQL performance** by using the new **Hive vectorization features**, where would we find the setting and how would we turn it on?   You would need to do the following steps:

1.  Click on the **Advanced** tab and scroll to find the **property**
2.  Or, start typing in the property into the property search field and then this would filter the setting you scroll for.

As you can see from the green circle above, the `Enable Vectorization and Map Vectorization` is turned on already.

Some **key resources** to **learn more about vectorization** and some of the **key settings in Hive tuning:**

* Apache Hive docs on [Vectorized Query Execution](https://cwiki.apache.org/confluence/display/Hive/Vectorized+Query+Execution)
* [HDP Docs Vectorization docs](http://docs.hortonworks.com/HDPDocuments/HDP2/HDP-2.0.9.0/bk_dataintegration/content/ch_using-hive-1a.html)
* [Hive Blogs](http://hortonworks.com/blog/category/hive/)
* [5 Ways to Make Your Hive Queries Run Faster](http://hortonworks.com/blog/5-ways-make-hive-queries-run-faster/)
* [Interactive Query for Hadoop with Apache Hive on Apache Tez](http://hortonworks.com/hadoop-tutorial/supercharging-interactive-queries-hive-tez/)
* [Evaluating Hive with Tez as a Fast Query Engine](http://hortonworks.com/blog/evaluating-hive-with-tez-as-a-fast-query-engine/)

## Step 2.6: Analyze the Trucks Data <a id="analyze-truck-data"></a>

Next we will be using Hive, Pig and Excel to analyze derived data from the geolocation and trucks tables.  The business objective is to better understand the risk the company is under from fatigue of drivers, over-used trucks, and the impact of various trucking events on risk.   In order to accomplish this, we will apply a series of transformations to the source data, mostly though SQL, and use Pig or Spark to calculate risk.   In the last 3 labs on Data Visualization, we will be using _Microsoft Excel, Zeppelin or Zoomdata_ to **generate a series of charts to better understand risk**.  


![Lab2_21](/assets/hello-hdp/Lab2_211.png)


Let’s get started with the first transformation.   We want to **calculate the miles per gallon for each truck**. We will start with our _truck data table_.  We need to _sum up all the miles and gas columns on a per truck basis_. Hive has a series of functions that can be used to reformat a table. The keyword [LATERAL VIEW](https://cwiki.apache.org/confluence/display/Hive/LanguageManual+LateralView) is how we invoke things. The **stack function** allows us to _restructure the data into 3 columns_ labeled rdate, gas and mile with 54 rows. We pick truckid, driverid, rdate, miles, gas from our original table and add a calculated column for mpg (miles/gas).  And then we will **calculate average mileage**.

### 2.6.1 Create Table truck_mileage From Existing Trucking Data

Using the Ambari Hive User View, execute the following query:

~~~
CREATE TABLE truck_mileage STORED AS ORC AS SELECT truckid, driverid, rdate, miles, gas, miles / gas mpg FROM trucks LATERAL VIEW stack(54, 'jun13',jun13_miles,jun13_gas,'may13',may13_miles,may13_gas,'apr13',apr13_miles,apr13_gas,'mar13',mar13_miles,mar13_gas,'feb13',feb13_miles,feb13_gas,'jan13',jan13_miles,jan13_gas,'dec12',dec12_miles,dec12_gas,'nov12',nov12_miles,nov12_gas,'oct12',oct12_miles,oct12_gas,'sep12',sep12_miles,sep12_gas,'aug12',aug12_miles,aug12_gas,'jul12',jul12_miles,jul12_gas,'jun12',jun12_miles,jun12_gas,'may12',may12_miles,may12_gas,'apr12',apr12_miles,apr12_gas,'mar12',mar12_miles,mar12_gas,'feb12',feb12_miles,feb12_gas,'jan12',jan12_miles,jan12_gas,'dec11',dec11_miles,dec11_gas,'nov11',nov11_miles,nov11_gas,'oct11',oct11_miles,oct11_gas,'sep11',sep11_miles,sep11_gas,'aug11',aug11_miles,aug11_gas,'jul11',jul11_miles,jul11_gas,'jun11',jun11_miles,jun11_gas,'may11',may11_miles,may11_gas,'apr11',apr11_miles,apr11_gas,'mar11',mar11_miles,mar11_gas,'feb11',feb11_miles,feb11_gas,'jan11',jan11_miles,jan11_gas,'dec10',dec10_miles,dec10_gas,'nov10',nov10_miles,nov10_gas,'oct10',oct10_miles,oct10_gas,'sep10',sep10_miles,sep10_gas,'aug10',aug10_miles,aug10_gas,'jul10',jul10_miles,jul10_gas,'jun10',jun10_miles,jun10_gas,'may10',may10_miles,may10_gas,'apr10',apr10_miles,apr10_gas,'mar10',mar10_miles,mar10_gas,'feb10',feb10_miles,feb10_gas,'jan10',jan10_miles,jan10_gas,'dec09',dec09_miles,dec09_gas,'nov09',nov09_miles,nov09_gas,'oct09',oct09_miles,oct09_gas,'sep09',sep09_miles,sep09_gas,'aug09',aug09_miles,aug09_gas,'jul09',jul09_miles,jul09_gas,'jun09',jun09_miles,jun09_gas,'may09',may09_miles,may09_gas,'apr09',apr09_miles,apr09_gas,'mar09',mar09_miles,mar09_gas,'feb09',feb09_miles,feb09_gas,'jan09',jan09_miles,jan09_gas ) dummyalias AS rdate, miles, gas;
~~~


![Lab2_22](/assets/hello-hdp/create_truck_mileage_table_hello_hdp_lab2.png)  


### 2.6.2 Load Sample Data of truck_mileage

To view the data generated by the script, click **Load Sample Data** icon in the Database Explorer next to truck_mileage. After clicking the next button once, you should see a table that _lists each trip made by a truck and driver_:


![Lab2_23](/assets/hello-hdp/Lab2_23.png)


### 2.6.3 Use the Content Assist to build a query

1\.  Create a new **SQL Worksheet**.


2\.  Start typing in the **SELECT SQL command**, but only enter the first two letters:


~~~
SE
~~~

3\.  Press **Ctrl+space** to view the following content assist pop-up dialog window:


![Lab2_24](/assets/hello-hdp/Lab2_24.png)


Notice content assist shows you some options that start with an “SE”. These shortcuts will be great for when you write a lot of custom query code.


4\.  Type in the following query, using **Ctrl+space** throughout your typing so that you can get an idea of what content assist can do and how it works:

~~~
SELECT truckid, avg(mpg) avgmpg FROM truck_mileage GROUP BY truckid;
~~~

![Lab2_28](/assets/hello-hdp/Lab2_28.png)  


5\.  Click the “**Save as …**” button to save the query as “**average mpg**”:  


![Lab2_26](/assets/hello-hdp/Lab2_26.png)


6\.  Notice your query now shows up in the list of “**Saved Queries**”, which is one of the tabs at the top of the Hive User View.


7\.  Execute the “**average mpg**” query and view its results.

### 2.6.4 Explore Explain Features of the Hive Query Editor

1\. Now let's **explore the various explain features** to better _understand the execution of a query_: Text Explain, Visual Explain and Tez Explain. Click on the **Explain** button:


![Lab2_27](/assets/hello-hdp/Lab2_27.png)


2\. Add the `EXPLAIN` command at the beginning of the query:


![Lab2_25](/assets/hello-hdp/Lab2_25.png)


3\. Execute the query. An alternative way to execute explain results is to press the `Explain` button. The results should look like the following:


![Lab2_29](/assets/hello-hdp/query_results_from_explain_hello_hdp_lab2.png)


4\. Click on **STAGE-0:** to view its output, which displays the flow of the resulting Tez job:


![Lab2_30](/assets/hello-hdp/stage_0_explain_command_hello_hdp_lab2.png)


5\. To see the Visual Explain, click on the **Visual Explain icon** on the right tabs. This is a much more readable summary of the explain plan:


![Lab2_31](/assets/hello-hdp/Lab2_311.png)


### 2.6.5 Explore TEZ

1\. If you click on **TEZ View** from Ambari Views on at the top, you can see _DAG details_ associated with the previous hive and pig jobs.

![tez_view](/assets/hello-hdp/tez_view_hello_hdp_lab2.png)


2\. Select the first DAG as it represents the last job that was executed.


![all_dags](/assets/hello-hdp/last_hive_job_dags_hello_hdp_lab2.png)


3\. There are six tabs at the top right please take a few minutes to explore the various tabs and then click on the **Graphical View** tab and hover over one of the nodes with your cursor to get more details on the processing in that node.


![Lab2_35](/assets/hello-hdp/tez_graphical_view_hello_hdp_lab2.png)


5\. Go back to the Hive UV and save the query by

### 2.6.6 Create Table truck avg_mileage From Existing trucks_mileage Data

To **persist these results into a table**, This is a fairly common pattern in Hive and it is called [Create Table As Select](https://cwiki.apache.org/confluence/display/Hive/LanguageManual+DDL#LanguageManualDDL-CreateTableAsSelect(CTAS)) (CTAS ).  Paste the following script into a new Worksheet, then click the **Execute** button:

~~~
CREATE TABLE avg_mileage
STORED AS ORC
AS
SELECT truckid, avg(mpg) avgmpg
FROM truck_mileage
GROUP BY truckid;
~~~

![average_mile_table_query](/assets/hello-hdp/average_mile_table_hello_hdp_lab2.png)

### 2.6.7 Load Sample Data of avg_mileage

To view the data generated by the script, click **Load sample data** icon in the Database Explorer next to avg_mileage. You see our table is now a list of each trip made by a truck.


![results_avg_mileage_table](/assets/hello-hdp/avg_mileage_table_results_hello_hdp_lab2.png)


## Suggested Readings <a id="suggested-readings"></a>

Augment your hive foundation with the following resources:

- [Apache Hive](http://hortonworks.com/hadoop/hive/)
- [Programming Hive](http://www.amazon.com/Programming-Hive-Edward-Capriolo/dp/1449319335/ref=sr_1_3?ie=UTF8&qid=1456009871&sr=8-3&keywords=apache+hive)
- [Hive Language Manual](https://cwiki.apache.org/confluence/display/Hive/LanguageManual+DDL)
