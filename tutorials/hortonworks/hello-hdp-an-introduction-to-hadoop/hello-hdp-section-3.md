---
title: Hello HDP An Introduction to Hadoop with Hive and Pig
tutorial-id: 100
tutorial-series: Basic Development
tutorial-version: hdp-2.4.0
intro-page: false
components: [ ambari, hive, pig, spark, zeppelin ]
---

# Lab 1: HDFS - Loading Data

## Loading Sensor Data into HDFS

### Introduction

In this section you will download the sensor data and load that into HDFS using Ambari User Views. You will get introduced to the Ambari Files User View to manage files. You can perform tasks like create directories, navigate file systems and upload files to HDFS.  In addition you’ll perform a few other file-related tasks as well.  Once you get the basics, you will create two directories and then load two files into HDFS using the Ambari Files User View.

## Pre-Requisites

The tutorial is a part of series of hands on tutorial to get you started on HDP using Hortonworks sandbox. Please ensure you complete the prerequisites before proceeding with this tutorial.

*   Downloaded and Installed latest [Hortonworks Sandbox](http://hortonworks.com/products/hortonworks-sandbox/#install)
*   [Learning the Ropes of the Hortonworks Sandbox](http://hortonworks.com/hadoop-tutorial/learning-the-ropes-of-the-hortonworks-sandbox/)

## Outline

*   [HDFS backdrop](#hdfs-backdrop)
*   [Step 1.1: Download data](#step1.1) – [**Geolocation.zip**](https://app.box.com/HadoopCrashCourseData)
*   [Step 1.2: Load Data into HDFS](#step1.2)
*   [Suggested Reading](#suggested-reading)

## HDFS backdrop <a id="hdfs-backdrop"></a>

A single physical machine gets saturated with its storage capacity as the data grows. Thereby comes impending need to partition your data across separate machines. This type of File system that manages storage of data across a network of machines is called Distributed File Systems. [HDFS](http://hortonworks.com/blog/thinking-about-the-hdfs-vs-other-storage-technologies/) is a core component of Apache Hadoop and is designed to store large files with streaming data access patterns, running on clusters of commodity hardware. With Hortonworks Data Platform HDP 2.2, HDFS is now expanded to support [heterogeneous storage](http://hortonworks.com/blog/heterogeneous-storage-policies-hdp-2-2/)  media within the HDFS cluster.

### Step 1.1: Download and Extract the Sensor Data Files <a id="step1.1"></a>

*   You can download the sample sensor data contained in a compressed (.zip) folder here:  [**Geolocation.zip**](https://app.box.com/HadoopCrashCourseData)
*   Save the Geolocation.zip file to your computer, then extract the files. You should see a Geolocation folder that contains the following files:
    *   geolocation.csv – This is the collected geolocation data from the trucks. it contains records showing truck location, date, time, type of event, speed, etc.
    *   trucks.csv – This is data was exported from a relational database and it shows info on truck model, driverid, truckid, and aggregated mileage info.

### Step 1.2: Load the Sensor Data into HDFS <a id="step1.2"></a>

*   Go to the Ambari Dashboard and open the HDFS User View by click on the User Views icon and selecting the HDFS Files menu item.


![Screen Shot 2015-07-21 at 10.17.21 AM](/assets/hello-hdp/hdfs_files_view_hello_hdp_lab1.png)


*   Starting from the top root of the HDFS file system, you will see all the files the logged in user (maria_dev in this case) has access to see:


![Lab2_2](/assets/hello-hdp/hdfs_files_user_view_maria_dev_hello_hdp.png)


*   Click tmp. Then click  ![Lab2_3](/assets/hello-hdp/Lab2_3.png) button to create the `/tmp/maria_dev` directory and then create the `/tmp/maria_dev/data` directory.


![Screen Shot 2015-07-27 at 9.42.07 PM](/assets/hello-hdp/maria_dev_create_new_dir_data_hello_hdp_lab1.png)


*   Now traverse to the `/tmp/admin/data` directory and upload the corresponding geolocation.csv and trucks.csv files into it.


![Screen Shot 2015-07-27 at 9.43.28 PM](/assets/hello-hdp/uploaded_geolocation_files_data_hello_hdp_lab1.png)


You can also perform the following operations on a file by right clicking on the file: **Download**, **Move**, **Permissions**, **Rename** and **Delete**.

**IMPORTANT**

- Right click on the folder `data` which is contained within `/tmp/maria_dev`. Click **Permissions**. Make sure that the background of all the **write** boxes are checked (blue).


![Lab2_5](/assets/hello-hdp/edit_permissions_data_folder_hello_hdp_lab1.png)


## Suggested Reading <a id="suggested-reading"></a>
- [HDFS](http://hortonworks.com/hadoop/hdfs/)
- [HDFS User Guide](https://hadoop.apache.org/docs/stable/hadoop-project-dist/hadoop-hdfs/HdfsUserGuide.html)
