---
title: Hello HDP An Introduction to Hadoop with Hive and Pig
tutorial-id: 100
tutorial-series: Basic Development
tutorial-version: hdp-2.4.0
intro-page: false
components: [ ambari, hive, pig, spark, zeppelin ]
---

# Lab 6: Data Reporting With Zeppelin

## Data Visualization using Apache Zeppelin

### Introduction

In this tutorial you will be introduced to Apache Zeppelin. In the earlier section of lab, you learned how to perform data visualization 
using Excel. This section will teach you to visualize data using Zeppelin.

## Pre-Requisites

The tutorial is a part of series of hands on tutorial to get you started on HDP using Hortonworks sandbox. Please ensure you complete the prerequisites before proceeding with this tutorial.

*   Downloaded and Installed latest [Hortonworks Sandbox](http://hortonworks.com/products/hortonworks-sandbox/#install)
*   [Learning the Ropes of the Hortonworks Sandbox](http://hortonworks.com/hadoop-tutorial/learning-the-ropes-of-the-hortonworks-sandbox/)
*   Lab 1: Loading sensor data into HDFS
*   Lab 2: Data Manipulation with Apache Hive
*   Lab 3: Use Pig to compute Driver Risk Factor/ Lab 4: Use Spark to compute Driver Risk Factor
*   Working Zeppelin installation
*   Please configure ODBC drivers on your system with the help of following tutorial:
*   Allow yourself around half an hour to complete this tutorial.

## Outline

*   [Apache Zeppelin](#apache-zeppelin)
*   [Step 6.1: Create a Zeppelin Notebook](#step6.1)
*   [Step 6.2: Execute a Hive Query](#step6.2)
*   [Step 6.3: Build Charts Using Zeppelin](#step6.3)
*   [Outro](#outro)
*   [Suggested Readings](#suggested-readings)

## Apache Zeppelin <a id="apache-zeppelin"></a>

Apache Zeppelin provides a powerful web-based notebook platform for data analysis and discovery.  
Behind the scenes it supports Spark distributed contexts as well as other language bindings on top of Spark.

In this tutorial we will be using Apache Zeppelin to run SQL queries on our geolocation, trucks, and 
riskfactor data that we've collected earlier and visualize the result through graphs and charts.

NOTE: We can also run queries via various interpreters for the following (but not limited to) spark, hawq and postgresql.

### Step 6.1: Create a Zeppelin Notebook <a id="step6.1"></a>

##### 6.1.1 Navigate to Zeppelin Notebook

1) Navigate to http://sandbox.hortonworks.com:9995 directly to open the Zeppelin interface.


![Zeppelin Dashboard](/assets/hello-hdp/zeppelin_welcome_page_hello_hdp_lab4.png)


2) Click on create note, name the notebook **Driver Risk Factor** and a new notebook shall get started.


![Zeppelin Create New Notebook](/assets/hello-hdp/zeppelin_create_new_notebook.png)


### Step 6.2: Execute a Hive Query <a id="step6.2"></a>

##### 6.2.1 Visualize finalresults Data in Tabular Format

In the previous Spark and Pig tutorials you already created a table finalresults which gives the risk factor 
associated with every driver. We will use the data we generated in this table to visualize which drivers have the highest risk factor.

1) Copy and paste the code below into your Zeppelin note.

~~~
%hive

SELECT * FROM finalresults
~~~

2) Click the play button next to "ready" or "finished" to run the query in the Zeppelin notebook. 
Alternative way to run query is "shift+enter."


![play_button_zeppelin_workbook](/assets/hello-hdp/play_button_lab6.png)


Initially, the query will produce the data in tabular format as shown in the screenshot.


![finalresults_data_tabular](/assets/hello-hdp/finalresults_data_tabular_lab6.png)


### Step 6.3: Build Charts using Zeppelin <a id="step6.3"></a>

##### 6.3.1 Visualize finalresults Data in Chart Format

1) Iterate through each of the tabs that appear underneath the query. 
Each one will display a different type of chart depending on the data that is returned in the query.


![charts_tab_under_query_lab6](/assets/hello-hdp/charts_tab_under_query_lab6.png)


2) After clicking on a chart, we can view extra advanced settings to tailor the view of the data we want


![Chart Advanced Settings](/assets/hello-hdp/advanced_settings_chart_lab6.png)


3) Click settings to open the advanced chart features.

4) To make the same chart as the one above, drag the table relations into the boxes as shown in the image below.


![Advanced Settings Boxes](/assets/hello-hdp/advanced_settings_boxes_lab6.png)


5) You should now see an image like the one below.


![Bar Graph Example Image](/assets/hello-hdp/bar_graph_chart_ex_lab6.png)


6) If you hover on the peaks, each will give the driverid and riskfactor.


![driverid_riskfactor_peak](/assets/hello-hdp/driverid_riskfactor_peak_lab6.png)


7) Try experimenting with the different types of charts as well as dragging and 
dropping the different table fields to see what kind of results you can obtain.

8) Let' try a different query to find which cities and states contain the drivers with the highest riskfactors.

~~~
%hive

SELECT a.driverid, a.riskfactor, b.city, b.state 
FROM finalresults a, geolocation b where a.driverid=b.driverid
~~~

9) Run the query above using the keyboard shortcut Shift+Enter. 
You should eventually end up with the results in a table below.


![Filter City and States](/assets/hello-hdp/filter_city_states_lab6.png)


10) After changing a few of the settings we can figure out which of the cities has the high risk factors. 
Try changing the chart settings by clicking the scatterplot icon. Then make sure that they keys a.driverid 
is within the xAxis field, a.riskfactor is in the yAxis field, and b.city is in the group field. 
The chart should look similar to the following.


![Scatter Plot Graph](/assets/hello-hdp/scatter_plot_lab6.png)


The graph shows that driver id number A39 has a high risk factor of 652417 and drives in Santa Maria.  

### Outro <a id="outro"></a>

Now that we know how to use Apache Zeppelin to obtain and visualize our data, we can use the skills 
we've learned from our Hive, Pig, and Spark labs, as well and apply them to new kinds of data to 
try to make better sense and meaning from the numbers!

## Suggested Readings <a id="suggested-readings"></a>

- [Zeppelin on HDP](http://hortonworks.com/hadoop/zeppelin/)
- [Apache Zeppelin Docs](https://zeppelin.incubator.apache.org/docs/)
- [Zeppelin Homepage](https://zeppelin.incubator.apache.org/)

