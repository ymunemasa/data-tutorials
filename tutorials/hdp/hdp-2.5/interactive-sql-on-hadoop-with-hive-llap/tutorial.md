---
title: Interactive SQL on Hadoop with Hive LLAP
tutorial-id: 720
platform: hdp-2.5.0
tags: [hive, ambari, tableau]
---

# Interactive SQL on Hadoop with Hive LLAP

## Introduction

**Hive LLAP** combines persistent query servers and intelligent in-memory caching to deliver blazing-fast SQL queries without sacrificing the scalability Hive and Hadoop are known for. This tutorial will show you how to try LLAP on your HDP 2.5 Sandbox and experience its interactive performance firsthand using a BI tool of your choice (`Tableau` will be show in the demo but others will work as well).

![hive_llap_architecture](assets/hive_llap_architecture.png)

### Benefits of Hive LLAP include:

1. LLAP uses persistent query servers to avoid long startup times and deliver fast SQL.
2. LLAP shares its in-memory cache among all SQL users, maximizing the use of this scarce resource.
3. LLAP has fine-grained resource management and preemption, making it great for highly concurrent access across many users.
4. LLAP is 100% compatible with existing Hive SQL and Hive tools.

## Goals and Objectives

The goal of this tutorial is to learn how to enable interactive SQL query performance on the HDP Sandbox using `LLAP`, then to connect a BI tool to LLAP and run interactive SQL analytics.

## Prerequisites

-   This tutorial requires the HDP 2.5 Sandbox. The HDP 2.5 Sandbox can be downloaded at https://hortonworks.com/products/sandbox/
-   If you are not familiar HDP 2.5 Sandbox, the following tutorial provides an introduction:
[Learning the Ropes of the Hortonworks Sandbox](https://hortonworks.com/hadoop-tutorial/learning-the-ropes-of-the-hortonworks-sandbox/)
-   This tutorial assumes you have a **16GB** (or more) laptop and does its best to maximize available resources. Since this is relatively limited, if you’re looking to try Hive LLAP at big data scales, check out the LLAP template on the cloud.
-   `Hive LLAP` is a Technical Preview feature in the HDP 2.5 Sandbox. This tutorial requires making some configurations to the Sandbox and allocating additional resources. In order to run this tutorial you will need to be able to allocate **12 GB RAM** to the Sandbox VM.
-   This tutorial also requires **Tableau version 9.X** or later.

## Outline

- [1. Hive LLAP Sandbox Setup](#hive_llap_sandbox_setup)
- [2. Connect with a BI Tool and Run Queries](#connect_with_bi_tool)
- [3. Connect LLAP to the Large Dataset (Optional, Advanced)](#connect_llap)
- [4. Enhanced Monitoring for Hive and LLAP](#enhanced_monitoring)
- [Further Reading](#further-reading)

## 1. Hive LLAP Sandbox Setup <a id="hive_llap_sandbox_setup"></a>

### Increase Sandbox Memory Size

To benefit from Hive LLAP’s in-memory processing we need a bit more memory and processing power than the Sandbox offers by default. In this tutorial we’ll use a `12 GB` sandbox and increase available `CPU power` as well.

When you import the Sandbox in VirtualBox, change the Appliance settings to increase RAM from 8192 to 12288 MB. When you first select the appliance to import you will see a screen similar to this one:

![import_appliance](assets/import_appliance.png)

When you press `Continue` you have the opportunity to change the amount of VM RAM. Double-click the amount of RAM and change it to `12288 MB`.

![change_ram](assets/change_ram.png)

This assumes you have a `16 GB` system. If your system has more than 16 GB total memory, feel free to increase RAM even further for better performance. When the import is done, boot the Sandbox and wait for the welcome screen to appear.

### Enable Ambari Admin Login

We need to change the Sandbox configuration using Ambari to enable LLAP. This requires us to first reset the Ambari admin password and then log in. To do this, follow
https://hortonworks.com/hadoop-tutorial/learning-the-ropes-of-the-hortonworks-sandbox/#setup-ambari-admin-password

Confirm you can log in to the Ambari UI as the admin user before continuing.

### Generate a Larger Dataset to Analyze (Optional)

The Sandbox ships with a few small tables, but to get a more substantial feel of LLAP we can generate a larger dataset. This part is optional and if you’re in a hurry you can skip it. For this demo we will generate 2 GB of data based on the standard TPC-H benchmark. To simplify things, all data generation and loading are handled by a single bundle you can download and run on your Sandbox.

To get started, log into the console by navigating your browser to http://127.0.0.1:4200/, then follow these steps:

1\. Log in to the console as root.

2\. Become the hive user:

~~~
su - hive
~~~

3\. Download the data generator bundle:

~~~
wget  https://github.com/cartershanklin/sandbox-datagen/blob/master/datagen.tgz?raw=true
~~~

4\. Extract the bundle:

~~~
tar -zxf datagen.tgz?raw=true
~~~

5\. Enter the datagen directory:

~~~
cd datagen
~~~

6\. Generate the data:

~~~
sh datagen.sh 2
~~~

This step will take up to a few minutes.

### Stop Services We Don’t Need

Ambari enables a number of HDP services we don’t need to try Hive LLAP. Since LLAP relies heavily on caching and in-memory processing we will stop these to free memory to improve performance.

When you first login you will see these services. If the services show up as yellow rather than green, wait a moment until you see green checkmarks next to these services.

![initial_services](assets/initial_services.png)

To free up a bit more resources we can stop stop Oozie, Flume and Zeppelin Notebook. For each service go to `Service Actions`:

![service_actions](assets/service_actions.png)

Then press `Stop`. After the service is stopped, select `Turn On Maintenance Mode` from Service Actions.

![final_services](assets/final_services.png)

### Increase YARN Memory in Ambari

Out of the box the Sandbox ships with a minimal YARN allocation of `2.25 GB`. We need to increase this to take advantage of Hive LLAP in-memory processing.

First select `YARN`:

![select_yarn](assets/select_yarn.png)

Then Configs -> Settings. We will increase YARN Memory to `8GB (8192MB)`

![yarn_memory](assets/yarn_memory.png)

> NOTE: If you see a maximum value of 256 TB, reload your tab until you see a smaller value.

After that, set the Minimum Container Size to `512MB`.

![minimum_container](assets/minimum_container.png)

Increase Percentage of physical CPU allocated for all containers on a node to `100%` and Number of virtual cores to `4`.

![percentage_cpu](assets/percentage_cpu.png)

Now press `Save`.

**Important: Restart YARN before continuing using Restart All Affected.**

Next switch to the Tez configuration and change tez.task.launch.cmd-opts to `-Xmx819m`.

![tez_config](assets/tez_config.png)

And press `Save`.

### Enable and Configure Interactive Query (Hive LLAP)

Now we actually enable Hive LLAP. Go to the Hive Settings tab and enable `Interactive Query` on the Settings tab:

![enable_interactive_query](assets/enable_interactive_query.png)

Accept the default location to install HiveServer2 Interactive. After you select a host you will be able to change the resources dedicated to Interactive Query. Set % of Cluster Capacity to `80%`, and Maximum Total Concurrent Queries to `1`.

You should see these settings before you save:

![cluster_capacity](assets/cluster_capacity.png)

Next, confirm your HiveServer2 Heap Size and Metastore Heap Size are both set to 1024 MB. If they are set to something larger, reset them to 1024 MB.

![cbo](assets/cbo.png)

Next, increase the per Map memory threshold to about `350 MB` (doesn’t need to be exact):

![memory_map_join](assets/memory_map_join.png)

Next switch to the Advanced configuration tab and set hive.tez.java.opts to `-server -Xmx819m -Djava.net.preferIPv4Stack=true` :

![hive_tez_java_opts](assets/hive_tez_java_opts.png)

Finallty press Save, Hive LLAP will automatically start, wait until Ambari has zero active operations before continuing.

Note that to connect to Hive LLAP you use a dedicated HiveServer2 instance which, by default, runs on port 10500. You can also use Zookeeper-based service discovery to connect beeline to Hive LLAP. The connection information is listed on the Hive Summary tab, under HiveServer2 Interactive JDBC URL.

![hive_llap_io_memory_mode](assets/hive_llap_io_memory_mode.png)

Finally, press `Save`. Now restart YARN, MapReduce2, Tez and Hive.

## 2. Connect with a BI Tool and Run Queries <a id="connect_with_bi_tool"></a>

Now we’re ready to connect a BI Tool to LLAP and try things out. This demo will use Tableau. If you prefer another tool you should adapt these instructions to your choice.

### Download and Install the ODBC driver

First we need to install the Hive ODBC driver. If you are querying the large dataset generated earlier, it is strongly recommended to use the latest ODBC driver, since it can help BI tools take advantage of the new primary / foreign key support to run queries much faster.

Start by downloading the `ODBC driver` from the Add-Ons section in https://hortonworks.com/downloads/

If you are on Windows: Create a DSN using the ODBC Driver Manager and point it to host `127.0.0.1`, port 10500, use Username/Password authentication with the credentials `hive/hive`.

![odbc_driver_setup](assets/odbc_driver_setup.png)

> **If you are on Mac**: Note that connecting using Tableau does not require the use of an ODBC Driver Manager, the driver will be loaded automatically. Other BI tools may require the use of an ODBC Driver Manager.

### Connect Tableau to LLAP and a Small Dataset

Start Tableau, connect “To a server” -> More Servers -> Hortonworks Hadoop Hive

![connect_tableau](assets/connect_tableau.png)

When prompted, connect to `127.0.0.1` port `10500`, type `HiveServer2`, Authentication `User Name and Password`, Username `hive`, Password `hive`.

![hortonworks_hive_connection](assets/hortonworks_hive_connection.png)

Next click `Select Schema` and click the magnifying glass to show available schema.

![select_schema](assets/select_schema.png)

Select `default` and click the magnifying glass to reveal all tables.

![select_default](assets/select_default.png)

Drag `sample_08` to the workspace.

![sample_08](assets/sample_08.png)

Click on `Sheet` 1 to go to the worksheet.

This table has data on professions, numbers of people within those professions and average salaries for these professions. We can now easily explore this data interactively. For example let’s create a packed bubble chart that shows the relative numbers of people in different professions as in this chart.

![bubble_chart](assets/bubble_chart.png)

To reproduce this chart:

1\. Drag the `Total Emp` measure to the bottom right section of the main pallette:

![measures](assets/measures.png)

You should see a value of 405,555,870.

2\. Drag the Description Dimension to the Rows shelf. The result should look like:

![description_dimension](assets/description_dimension.png)

3\. Select the packed bubble visualization:

![packed_bubble_visualization](assets/packed_bubble_visualization.png)

This will give a visualization that makes it very easy to spot ratios. Unfortunately the All Occupations value is included, so let’s filter it out.

4\. Drag the Description Dimensions to the Filters section. Unselect “All Occupations” from the Filter and press Ok.

![filter_description](assets/filter_description.png)

Your visualization should now look like the diagram above. You can continue to explore this dataset interactively if you want. For example, see if you can recreate this visualization, which sorts job categories by average salary and mentions how many individuals belong to each profession.

## 3. Connect LLAP to the Large Dataset (Optional, Advanced) <a id="connect_llap"></a>

If you generated the large dataset above, here’s how to load it into Tableau and explore it. The data schema has a total of 8 tables and it’s important to relate them correctly. Each BI tool will have its own way of doing that, and here we’ll talk about how to do that in Tableau.

First we optimize the dataset for analytics. This means 2 things:

1\. We convert the data to ORCFile format.
2\. We create primary and foreign keys for the dataset. This allows BI tools to do what’s called “join elimination” to greatly improve performance.

To load the data, navigate back to `http://127.0.0.1:4200/` and run:

~~~
su - hive
cd datagen
sh load_data.sh
~~~

This process will take a couple of minutes. After it’s complete, connect Tableau to the llap schema and show all tables.

![llap_schema](assets/llap_schema.png)

There are 8 total tables here and for a realistic experience we should load all of them with the appropriate associations. Here’s the load order and associations you should make:

| Load Order     |      Table      |  Join Condition  |
|:--------------:|:---------------:|:----------------:|
| 1 |  lineitem | N/A |
| 2 |    orders   |   Join L_Orderkey to O_Orderkey |
| 3 | customer |    Join O_Custkey to C_Custkey |
| 4 |  nation | Join C_Nationkey to N_Nationkey |
| 5 |    region   |   Join N_Regionkey to R_Regionkey |
| 6 | partsupp |    Join L_Suppkey to Ps_Suppkey AND Join L_Partkey to Ps_Partkey |
| 7 |  part | Join Ps_Partkey to P_Partkey |
| 8 |    supplier   |   Join Ps_Suppkey to S_Suppkey |

It is important to ensure these join conditions are established properly. If they aren’t, queries will run very slow. When you’re done, the table associations should look like this:

![table_association](assets/table_association.png)

At this point it’s a good idea to save your workbook to avoid having to do this again. Here’s an example visualization you can do with this data. First drag the L_Extendedprice measure to the bottom right of the workspace. Next, drag the L_Shipinstruct Dimension to the Columns shelf and the L_Shipmode Dimension to the Rows shelf. When you’re done you should see a table like this:

![shipinstruct_shipmode](assets/shipinstruct_shipmode.png)

As you’re interacting, these queries should take no longer than about 5 seconds on a system with adequate resources. If queries are taking longer, ensure the join conditions are set up properly, ensure you are using the latest ODBC driver and ensure the settings given above have all been applied. You can also use the Tez UI (covered below) to further diagnose queries.

## 4. Enhanced Monitoring for Hive and LLAP <a id="enhanced_monitoring"></a>

HDP 2.5 includes some nice new ways to debug and diagnose Hive and Tez jobs. First let’s look at the Tez View. In Ambari hover over the “more items” icon in the top right and click `Tez View`.

![click_tez_view](assets/click_tez_view.png)

Here you’ll see a screen that includes all the queries that have been run through Hive:

![tez_all_dags](assets/tez_all_dags.png)

If we drill into a particular query we can see the exact query text that Tableau generates:

![tableau_generated_query](assets/tableau_generated_query.png)

This Tez View also includes a new Vertex Swimlane view for critical path analysis:

![tez_all_dags_vertex_swimlane](assets/tez_all_dags_vertex_swimlane.png)

## Further Reading

If you’re just getting started with Hive and want to learn about its SQL capabilities or data access options, see [Getting Started with Apache Hive](https://cwiki.apache.org/confluence/display/Hive/GettingStarted) on the wiki.

For a high-level overview of Hive 2, watch [Apache Hive 2.0: SQL Speed Scale](http://www.slideshare.net/HadoopSummit/apache-hive-20-sql-speed-scale).
