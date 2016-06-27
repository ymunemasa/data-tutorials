---
layout: tutorial
title: Hello HDP An Introduction to Hadoop with Hive and Pig
tutorial-id: 100
tutorial-series: Basic Development
tutorial-version: hdp-2.4.0
intro-page: false
components: [ ambari, hive, pig, spark, zeppelin ]
---

# Lab 1: HDFS - Loading Data

## Loading Sensor Data into HDFS

## Introduction

In this section, you will download the sensor data and load that into HDFS using Ambari User Views. You will get introduced to the Ambari Files User View to manage files. You can perform tasks like create directories, navigate file systems and upload files to HDFS.  In addition, you’ll perform a few other file-related tasks as well.  Once you get the basics, you will create two directories and then load two files into HDFS using the Ambari Files User View.

## Pre-Requisites

The tutorial is a part of series of hands on tutorial to get you started on HDP using Hortonworks sandbox. Please ensure you complete the prerequisites before proceeding with this tutorial.

*   Downloaded and Installed latest [Hortonworks Sandbox](http://hortonworks.com/products/hortonworks-sandbox/#install)
*   [Learning the Ropes of the Hortonworks Sandbox](http://hortonworks.com/hadoop-tutorial/learning-the-ropes-of-the-hortonworks-sandbox/)
*   Allow yourself around **20 minutes** to complete this tutorial.

## Outline

*   [HDFS backdrop](#hdfs-backdrop)
*   [Step 1.1: Download data](#step1.1) – [**Geolocation.zip**](https://app.box.com/HadoopCrashCourseData)
*   [Step 1.2: Load Data into HDFS](#step1.2)
*   [Summary](#summary-lab1)
*   [Suggested Reading](#suggested-reading)


## HDFS backdrop <a id="hdfs-backdrop"></a>

A single physical machine gets saturated with its storage capacity as the data grows. This growth drives the need to partition your data across separate machines. This type of File system that manages storage of data across a network of machines is called Distributed File Systems. [HDFS](http://hortonworks.com/blog/thinking-about-the-hdfs-vs-other-storage-technologies/) is a core component of Apache Hadoop and is designed to store large files with streaming data access patterns, running on clusters of commodity hardware. With Hortonworks Data Platform HDP 2.2, HDFS is now expanded to support [heterogeneous storage](http://hortonworks.com/blog/heterogeneous-storage-policies-hdp-2-2/)  media within the HDFS cluster.

## Step 1.1: Download and Extract the Sensor Data Files <a id="step1.1"></a>

*   You can download the sample sensor data contained in a compressed (.zip) folder here:  [**Geolocation.zip**](https://app.box.com/HadoopCrashCourseData)
*   Save the Geolocation.zip file to your computer, then extract the files. You should see a Geolocation folder that contains the following files:
    *   geolocation.csv – This is the collected geolocation data from the trucks. It contains **records** showing _truck location, date, time, type of event, speed, etc_.
    *   trucks.csv – This is data was exported from a relational database and it shows **info** on _truck models, driverid, truckid, and aggregated mileage info_.

## Step 1.2: Load the Sensor Data into HDFS <a id="step1.2"></a>

*   Go to the Ambari Dashboard and open the **HDFS Files** view. Click on the 9 square Ambari User Views icon next to the username button and select the **HDFS Files** menu item.


![Screen Shot 2015-07-21 at 10.17.21 AM](/assets/hello-hdp/files_view_lab1.png)


*   Start from the top root of the HDFS file system, you will see all the files the logged in user (_maria_dev_ in this case) has access to see:


![Lab2_2](/assets/hello-hdp/root_files_view_folder_lab1.png)


*   Click `tmp` folder. Then click  ![Lab2_3](/assets/hello-hdp/new_folder_icon_lab1.png) button to create the `maria_dev` directory inside the `tmp` folder. Then create the `data` directory inside `maria_dev` folder. Now navigate into the `data` folder.


![Screen Shot 2015-07-27 at 9.42.07 PM](/assets/hello-hdp/new_folder_maria_data_lab1.png)


*   If your not already in your newly created directory path `/tmp/maria_dev/data`, go to the **data** folder. Then  click on the ![upload_icon_lab1](/assets/hello-hdp/upload_icon_lab1) button to upload the corresponding **geolocation.csv** and **trucks.csv** files into it.


![Screen Shot 2015-07-27 at 9.43.28 PM](/assets/hello-hdp/uploaded_geo_files_lab1.png)


You can also perform the following operations on a file or folder by clicking on the entity's row: **Open**, **Rename**, **Permissions**, **Delete**, **Copy**, **Move**, **Download** and **concatenate**.

**IMPORTANT**

- click on the `data` folder's row, which is contained within the directory path `/tmp/maria_dev`. Click **Permissions**. Make sure that the background of all the **write** boxes are checked (**blue**). Refer to image for a visual explanation.


![Lab2_5](/assets/hello-hdp/edit_permissions_data_folder_lab1.png)


## Summary <a id="summary-lab1"></a>
Congratulations! Let’s summarize the skills and knowledge we acquired from this tutorial. We learned **Hadoop Distributed File System (HDFS)** was built to manage storing data across multiple machines. Now we can upload data into the HDFS using Ambari’s HDFS **Files view**.


## Suggested Reading <a id="suggested-reading"></a>
- [HDFS](http://hortonworks.com/hadoop/hdfs/)
- [Manage Files on HDFS with Command Line](http://hortonworks.com/hadoop-tutorial/using-commandline-manage-files-hdfs/)
- [HDFS User Guide](https://hadoop.apache.org/docs/stable/hadoop-project-dist/hadoop-hdfs/HdfsUserGuide.html)
- Build your HDFS Architecture Knowledge [HDFS Architecture Guide](https://hadoop.apache.org/docs/r1.0.4/hdfs_design.html)
- [HDP OPERATIONS: HADOOP ADMINISTRATION](http://hortonworks.com/training/class/hdp-operations-hadoop-administration-fundamentals/)
