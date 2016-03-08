---
layout: tutorial
title: Using HCatalog, Pig, and Hive Commands
tutorial-id: 260
tutorial-series: Basic Development
tutorial-version: hdp-2.4.0
intro-page: true
components: [ hcatalog, hive, pig, ambari ]
---

# HCatalog, Basic Pig & Hive Commands

### Introduction
In this tutorial, we will learn to use Hive and Pig along with other tools to process, analyze and filter large datasets.
>>>>>>> hdp

## Pre-Requisites

*  [Apache HCatalog (running time: about 9 minutes)](http://www.youtube.com/watch?v=_dVlNu4lqpE)
*  Downloaded and Installed latest [Hortonworks Sandbox](http://hortonworks.com/products/hortonworks-sandbox/#install)
*  [Learning the Ropes of the Hortonworks Sandbox](http://hortonworks.com/hadoop-tutorial/learning-the-ropes-of-the-hortonworks-sandbox/)

## Outline
- [Step 1: Download Example Data](#download-example-data)
- [Step 2: Upload the data files Into HDFS](#upload-data-files)
- [Step 3: Create tables for the Data With Hive and HCatalog](#create-tables-data-hive-hcatalog)
- [Step 4: Explore Hive Queries to View and Structure that Table Data](#explore-hive-queries-view-structure-data)
- [Step 5: Explore Pig Latin Data Transformation](#explore-pig-latin-data-transformation)
- HDFS [Further Reading](#further-reading-hdfs)
- HCatalog vs. Hive [Further Reading](#further-reading-hcatalog-hive)
- Hive [Further Reading](#further-reading-hive-query)
- Pig [Further Reading](#further-reading-pig-latin)

### Step 1: Download Example Data <a id="download-example-data"></a>

We will use a baseball statistics file. This file has
all the statistics for each American player by year from 1871-2011. The
data set is fairly large (over 95,000 records), but to learn Big Data
you don't need to use a massive dataset. You need only use tools that
scale to massive datasets.

The data files we are using in this tutorial come from Sean Lahman's
extensive historical baseball database
([http://seanlahman.com/](http://seanlahman.com/)), and are being used
under a Creative Commons Attribution-ShareAlike license:
[http://creativecommons.org/licenses/by-sa/3.0/](http://creativecommons.org/licenses/by-sa/3.0/)

Download and unzip the data file below:

[lahman591-csv.zip](http://seanlahman.com/files/database/lahman591-csv.zip)

If the above link doesn't work you can get the file from [this link](/assets/hcat-pig-and-hive-commands/assets/lahman591-csv.zip) as well.

The zip archive includes many statistics files. We will only use the
following two files:

-   Master.csv
-   Batting.csv

### Step 2: Upload the data files Into HDFS <a id="upload-data-files"></a>

Start by using the **HDFS Files** view from the views dropdown menu in Ambari

![hdfs files view icon](/assets/hello-hdp/hdfs_files_view_hello_hdp_lab1.png)

Navigate to the folder `/tmp` and create a new folder called **data**.

![](/assets/hcat-pig-and-hive-commands/02_create_data_directory.png)

Then use the menus to upload to upload the `master.csv` file and `batting.csv` file.

![](/assets/hcat-pig-and-hive-commands/tmp_data_baseball_files_hcatalog_hive_pig.png)

After uploading both files head back to the `data` folder we created. Right click on it's row and select **Permissions**. Make sure all boxes are checked (blue).

![](/assets/hcat-pig-and-hive-commands/04_1_permissions_dropdown.png)
![](/assets/hcat-pig-and-hive-commands/04_2_permissions_dialog.png)

Look at the top bar above the files. Look for **Upload**. Then click the **Browse** to search for the files that we unzipped earlier.

When you are done, you will see the two files in your directory.

![](/assets/hcat-pig-and-hive-commands/2_files_directory_hcatalog_hive_pig.png)


## Further Reading <a id="further-reading-hdfs"></a>
- [HDFS Tutorials](http://hortonworks.com/hadoop/hdfs/#tutorials)
- [HDFS and Apache Hadoop](http://hortonworks.com/hadoop/hdfs/)
- [HDFS Architecture Guide](https://hadoop.apache.org/docs/r1.2.1/hdfs_design.html)

### Step 3: Create tables for the Data With Hive and HCatalog <a id="create-tables-data-hive-hcatalog"></a>

HCatalog has been merged with Hive project. This means that your Hive queries will utilize HCatalog when using commands like `create table` and `drop table`.

We are now going to utilize the _Hive_ view to create tables with our data. Use the same dropdown menu that you used to select the _HDFS Files_ view, and instead click **Hive**.

![](/assets/hello-hdp/hive_user_view_hello_hdp_concepts.png)

Notice some of the basic items in the Hive view which are outlined in the image below.

![](/assets/hello-hdp/ambari_hive_user_view_interface_hello_hdp_concepts.png)

We're now going to create a table from our CSV using a Hive query. Copy and paste the following query and click **Execute** to run the command and create the table.

~~~
CREATE TABLE IF NOT EXISTS batting_data 
(playerid string, yearid string, stint string, 
 teamid string, lgid string, g string, g_batting string,
 ab string, runs int, h string)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
STORED AS TEXTFILE
TBLPROPERTIES("skip.header.line.count"="1")
~~~

![](/assets/hcat-pig-and-hive-commands/batting_table_hcatalog_hive_pig.png)

You'll now need to load the data file into the table. Use the following command to do so.

~~~
LOAD DATA INPATH '/tmp/data/Batting.csv' OVERWRITE INTO TABLE batting_data
~~~

![](/assets/hcat-pig-and-hive-commands/load_batting_data_hcatalog_hive_pig.png)

You will see a new table "batting_data" has been created and has all of the data contained within it.

![](/assets/hcat-pig-and-hive-commands/batting_data_filled_hcatalog_hive_pig.png)


Repeat above steps for the second data set (**master.csv**) using the following queries to create the `master_data` table.

~~~
CREATE TABLE IF NOT EXISTS master_data 
(lahmanID string,playerID string,managerID string ,hofID string, 
 birthYear string,birthMonth string,birthDay string, 
 birthCountry string,birthState string,birthCity string, 
 deathYear string,deathMonth string ,deathDay string, 
 deathCountry string,deathState string ,deathCity string, 
 nameFirst string, nameLast string, nameNote string,  
 nameGiven string, nameNick string, weight string,  
 height string, bats string, throws string, debut string,  
 finalGame string, college string, lahman40ID string,  
 lahman45ID string, retroID string, holtzID string, bbrefID string)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
STORED AS TEXTFILE
TBLPROPERTIES("skip.header.line.count"="1")
~~~

~~~
LOAD DATA INPATH '/tmp/data/Master.csv' OVERWRITE INTO TABLE master_data
~~~

You should now have two different tables inside the database explorer:

![](/assets/hcat-pig-and-hive-commands/10_db_explorer.png)


## Further Reading <a id="further-reading-hcatalog-hive"></a>
- [Hive vs. HCatalog](http://hortonworks.com/blog/hivehcatalog-data-geeks-big-data-glue/)


### Step 4: Explore Hive Queries to View and Structure that Table Data <a id="explore-hive-queries-view-structure-data"></a>

In the previous sections you:

-   Uploaded your data file into HDFS
-   Used the Ambari Hive view to create tables

Apache Hive™ provides a data warehouse function to the Hadoop cluster.
Through the use of HiveQL you can view your data as a table and create
queries just as you would in a database.

To make it easy to interact with Hive, you can we can use Ambari's built in views to run queries on this data. 

In the latest versions of the Hortonworks sandbox we can [execute our Hive queries using Tez](http://hortonworks.com/blog/evaluating-hive-with-tez-as-a-fast-query-engine/), a fast execution engine. It improves on MapReduce in many areas and allows us near-realtime querying on our datasets in Hive.

Notice the query window and **Execute**. Type your queries in the
Query window. When you are done with a query, click the **Execute**.

To see tables that Hive knows about, in Query Editor type the query:

~~~
show tables
~~~

and click on **Execute**.

![](/assets/hcat-pig-and-hive-commands/11_show_tables.png)

Notice the tables that you previously created are in the list ("batting_data" and "master_data").

To see the records type:

~~~
select * from batting_data
~~~

in Query Editor and click **Execute**.

![](/assets/hcat-pig-and-hive-commands/12_select_batting_data.png)

You can see the columns in the table by executing:

~~~
describe batting_data
~~~

![](/assets/hcat-pig-and-hive-commands/13_describe_batting_data.png)

You can make a join with other tables in Hive the same way you do with
other database queries.

Let's make a join between batting_data and master_data tables:

Enter the following into the query editor:

~~~
select a.playerid, a.namefirst, a.namelast, b.yearid, b.runs 
from master_data a join batting_data b ON (b.playerid = a.playerid);
~~~

This job is more complex so it might take longer than previous queries. You can
watch the job running in the log.

When the job completes, you can see the results.

![](/assets/hcat-pig-and-hive-commands/14_advanced_join_query.png)

## Further Reading <a id="further-reading-hive-query"></a>
- [Hive Tutorials](http://hortonworks.com/hadoop/hive/#tutorials)
- [Apache Hive and Hadoop](http://hortonworks.com/hadoop/hive/)
- [Getting Started with Hive](https://cwiki.apache.org/confluence/display/Hive/GettingStarted)


### Step 5: Explore Pig Latin Data Transformation <a id="explore-pig-latin-data-transformation"></a>
-------------------

In this tutorial, you will create and execute a Pig script.

To access the Pig interface, use the dropdown menu for views in Ambari. Select **Pig**.

![](/assets/hello-hdp/pig_user_view_icon_hello_hdp_lab3.png)

A special feature of the interface is the Pig helper. The Pig helper
provides templates for the statements, functions, I/O statements,
HCatLoader() and Python user defined functions. Another feature is the
**Pig arguments** which provides pre-formatted command line arguments
used during execution.

Click **New Script** and create a name for it.

![](/assets/hcat-pig-and-hive-commands/16_create_pig_script.png)

In this section, you will load the data from the table that is stored in
HCatalog/Hive. Then you will make a join between two data sets on the Player
ID field in the same way that you did in the Hive section.

#### 5.1 Prepare to load the data

The data is already in HDFS through HCatalog. HCatalog stores schema and
location information, so we can use the HCatLoader() function within the
Pig script to read data from HCatalog-managed tables. In Pig, you now
only need to give the table a name or alias so that Pig can process the
table.

Follow this procedure to load the data using HCatLoader:

-   Use the right-hand pane to start adding your code at Line 1
-   Open the Pig helper drop-down menu at the bottom of the screen to
    give you a template for the line.

Choose **PIG helper -> HCatalog -> LOAD...**template. This action
pastes the Load template into the script area.

**IMPORTANT**! Note that the statement should be `org.apache.hive.hcatalog.pig.HCatLoader();`. Note the addition of the **hive** component.

![](/assets/hcat-pig-and-hive-commands/17_pig_helper_dropdown.png)

-   The entry **%TABLE%** is highlighted in red. Type the name of the
    table ('**batting_data**') in place of **%TABLE%**(single quotes
    are required).
-   Remember to add the "a = " before the template. This saves the
    results into "a".
-   Make sure the statement ends with a semi-colon (;)

Repeat this sequence for "master_data" and add " b = "

The completed lines of code will be:

~~~
a = LOAD 'batting_data' using org.apache.hive.hcatalog.pig.HCatLoader();
b = LOAD 'master_data' using org.apache.hive.hcatalog.pig.HCatLoader();
~~~

![](/assets/hcat-pig-and-hive-commands/18_pig_script_1.png)

It is important to note that at this point, we have merely defined the
aliases for our tables to hold the data (alias "a" for batting data and
alias "b" for master data). Data is not loaded or transformed until we
execute an operational command such as DUMP or STORE

#### 5.2 Join both the tables on Player ID

Next, you will use the **JOIN** operator to join both tables on the Player
ID. Master.data has the player's first name and last name and player ID
(among other fields). Batting.data has the player's run record and
player ID (among other fields). You will create a new data set using the
Pig Join function that will match the player ID field and include all of
the data from both tables.

Complete these steps:

-   Choose **PIG helper->Data processing functions->JOIN template**
-   Replace %VAR% with "a". Repeat this step on the same line for "b".
-   Again, add the trailing semi-colon to the code.

So, the final code will be:

~~~
a = LOAD 'batting_data' using org.apache.hive.hcatalog.pig.HCatLoader();
b = LOAD 'master_data' using org.apache.hive.hcatalog.pig.HCatLoader();
c = join a by playerid, b by playerid;
~~~

![](/assets/hcat-pig-and-hive-commands/19_pig_script_2.png)

Now you have joined all the records in both of the tables on Player ID.

#### 5.3 Execute the script and generate output

To complete the Join operation, use the DUMP command to execute the
results. This will show all of the records that have a common PlayerID.
The data from both tables will be merged into one row. Complete this
steps:

-   Add the last line with **PIG helper->I/O->DUMP** template and
    replace %VAR% with "c".

The full script should be:

~~~
a = LOAD 'batting_data' using org.apache.hive.hcatalog.pig.HCatLoader();
b = LOAD 'master_data' using org.apache.hive.hcatalog.pig.HCatLoader();
c = join a by playerid, b by playerid;
dump c;
~~~

![](/assets/hcat-pig-and-hive-commands/20_pig_script_3.png)

#### 5.4 Save the script and execute it

First you need to add the `-useHCatalog` (Case Sensitive) argument using the box box in the bottom right hand corner

![](/assets/hcat-pig-and-hive-commands/21_use_hcat_arg.png)

At the top of the screen, make sure the box "Execute on Tez" is checked. Then click **Execute** to run the script. This action creates one or more Tez jobs.

Below the **Execute** is a progress bar that shows the job's status.
The progress bar can be blue (indicating job is in process), red (job
has a problem), or green (job is complete).

![](/assets/hcat-pig-and-hive-commands/22_pig_job_status.png)

When the job completes, you will see the results show up in one of the dropdown menus. The result is that each line that starts with an open parenthesis "(" has
data from both tables for each unique player ID.

![](/assets/hcat-pig-and-hive-commands/23_pig_result.png)

Click the **Logs** dropdown menu if you want to see what happened when your
script ran, including any error messages. (You might need to scroll down
to view the entire log.)

![](/assets/hcat-pig-and-hive-commands/24_pig_result_logs.png)

Congratulations! You have successfully completed HCatalog, Basic Pig &
Hive Commands.

## Further Reading <a id="further-reading-pig-latin"></a>
- [Pig Tutorials](http://hortonworks.com/hadoop/pig/#tutorials)
- [Getting Started with Pig](http://pig.apache.org/#Getting+Started)
