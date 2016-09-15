---
layout: tutorial
title: Hello HDP An Introduction to Hadoop with Hive and Pig
tutorial-id: 100
tutorial-series: Basic Development
tutorial-version: hdp-2.5.0
intro-page: true
components: [ ambari, hive, pig, spark, zeppelin, technical-preview ]
---

# Hadoop Tutorial – Getting Started with HDP

## Introduction

Hello World is often used by developers to familiarize themselves with new concepts by building a simple program. This tutorial aims to achieve a similar purpose by getting practitioners started with Hadoop and HDP. We will use an Internet of Things (IoT) use case to build your first HDP application.

This tutorial describes how to refine data for a Trucking IoT  [Data Discovery](http://hortonworks.com/solutions/advanced-analytic-apps/#data-discovery) (aka IoT Discovery) use case using the Hortonworks Data Platform. The IoT Discovery use cases involves vehicles, devices and people moving across a map or similar surface. Your analysis is targeted to linking location information with your analytic data.

For our tutorial we are looking at a use case where we have a truck fleet. Each truck has been equipped to log location and event data. These events are streamed back to a datacenter where we will be processing the data.  The company wants to use this data to better understand risk.

Here is the video of [Analyzing Geolocation Data](http://youtu.be/n8fdYHoEEAM) to show you what you’ll be doing in this tutorial.

## Pre-Requisites:

*  Downloaded and Installed [Hortonworks Sandbox](http://hortonworks.com/downloads/#sandbox)
*  Before entering hello HDP labs, we **highly recommend** you go through [Learning the Ropes of the Hortonworks Sandbox](http://hortonworks.com/hadoop-tutorial/learning-the-ropes-of-the-hortonworks-sandbox/) to become familiar with the Sandbox in a VM and the Ambari Interface.

*   Data Set Used: [**Geolocation.zip**](https://app.box.com/HadoopCrashCourseData)
*   ***Optional***: Hortonworks ODBC driver installed and configured – see the tutorial on installing the ODBC driver for Windows or OS X. Refer to
    *   [Installing and Configuring the Hortonworks ODBC driver on Windows 7](http://hortonworks.com/hadoop-tutorial/how-to-install-and-configure-the-hortonworks-odbc-driver-on-windows-7/)
    *   [Installing and Configuring the Hortonworks ODBC driver on Mac OS X](http://hortonworks.com/hadoop-tutorial/how-to-install-and-configure-the-hortonworks-odbc-driver-on-mac-os-x/)
    <!-- *   Microsoft Excel 2013 Professional Plus is required for the Windows 7 or later installation to be able to construct the maps.
-->

*  In this tutorial, the Hortonworks Sandbox is installed on an Oracle VirtualBox virtual machine (VM) – your screens may be different.

<!---
- Install the ODBC driver that matches the version of Excel you are using (32-bit or 64-bit).

- We will use the Power View feature in Microsoft Excel 2013 to visualize the sensor data. Power View is currently only available in Microsoft Office Professional Plus and Microsoft Office 365 Professional Plus.

- Note, other versions of Excel will work, but the visualizations will be limited to charts or graphs. You can also use other visualization tool, such as Zeppelin and Zoomdata.
-->
## Tutorial Overview

In this tutorial, we will provide the collected geolocation and truck data. We will import this data into HDFS and build derived tables in Hive. Then we will process the data using Pig, Hive and Spark. The processed data is then visualized using Apache Zeppelin.

<!---The processed data is then imported into Microsoft Excel where it can be visualized.-->

To refine and analyze Geolocation data, we will:

*   Review some Hadoop Fundamentals
*   Download and extract the Geolocation data files.
*   Load the captured data into the Hortonworks Sandbox.
*   Run Hive, Pig and Spark scripts that compute truck mileage and driver risk factor.
<!--- *   Access the refined sensor data with Microsoft Excel.-->
*   Visualize the geolocation data using Zeppelin.

## Goals of the Tutorial

The goal of this tutorial is that you get familiar with the basics of following:

*   Hadoop and HDP
*   Ambari File User Views and HDFS
*   Ambari Hive User Views and Apache Hive
*   Ambari Pig User Views and Apache Pig
*   Apache Spark
*   Data Visualization with Zeppelin (Optional)
<!---*   Data Visualization with Excel (Optional)-->

<!---*   Data Visualization with Zoomdata (Optional)-->

## Outline

1.  Introduction
2.  Pre-Requisites
    1.  Data Set Used: [**Geolocation.zip**](https://app.box.com/HadoopCrashCourseData)
    2.  Latest Hortonworks Sandbox Version
    3.  Learning the Ropes of the Hortonworks Sandbox - Become familiar with your Sandbox and Ambari.
3.  Tutorial Overview
4.  Goals of the Tutorial (outcomes)
5.  Hadoop Data Platform Concepts (New to Hadoop or HDP- Refer following)
    1.  [Apache Hadoop and HDP](https://github.com/hortonworks/tutorials/blob/hdp-2.5/tutorials/hortonworks/hello-hdp-an-introduction-to-hadoop/hello-hdp-section-2.md) (5 Pillars)
    2.  [Apache Hadoop Distributed File System (HDFS)](http://hortonworks.com/hadoop/hdfs/)
    3.  [Apache YARN](http://hortonworks.com/hadoop/yarn/)
    4.  [Apache MapReduce](http://hortonworks.com/hadoop/mapreduce/)
    5.  [Apache Hive](http://hortonworks.com/hadoop/hive/)
    6.  [Apache Pig](http://hortonworks.com/hadoop/pig/)
6.  **Get Started with HDP Labs**

    1.  [Lab 1: Loading Sensor Data into HDFS](https://github.com/hortonworks/tutorials/blob/hdp-2.5/tutorials/hortonworks/hello-hdp-an-introduction-to-hadoop/hello-hdp-section-3.md)
    2.  [Lab 2: Data Manipulation with Hive](https://github.com/hortonworks/tutorials/blob/hdp-2.5/tutorials/hortonworks/hello-hdp-an-introduction-to-hadoop/hello-hdp-section-4.md) (Ambari User Views)
    3.  [Lab 3: Use Pig to compute Driver Risk Factor](https://github.com/hortonworks/tutorials/blob/hdp-2.5/tutorials/hortonworks/hello-hdp-an-introduction-to-hadoop/hello-hdp-section-5.md)
    4.  [Lab 4: Use Apache Spark to compute Driver Risk Factor](https://github.com/hortonworks/tutorials/blob/hdp-2.5/tutorials/hortonworks/hello-hdp-an-introduction-to-hadoop/hello-hdp-section-6.md)
    <!---5.  [Lab 5: Optional Visualization and Reporting with Excel](https://github.com/hortonworks/tutorials/blob/hdp-2.5/tutorials/hortonworks/hello-hdp-an-introduction-to-hadoop/hello-hdp-section-7.md)
        1.  [Configuring ODBC driver](http://hortonworks.com/hadoop-tutorial/how-to-install-and-configure-the-hortonworks-odbc-driver-on-mac-os-x/)  (Mac and Windows)-->
    5.  [Lab 5: Optional Visualization and Reporting with Zeppelin](https://github.com/hortonworks/tutorials/blob/hdp-2.5/tutorials/hortonworks/hello-hdp-an-introduction-to-hadoop/hello-hdp-section-8.md)  
    <!---7.  [Lab 7: Optional Visualization and Reporting with Zoomdata](https://github.com/hortonworks/tutorials/blob/hdp-2.5/tutorials/hortonworks/hello-hdp-an-introduction-to-hadoop/hello-hdp-section-9.md)-->
7.  **Next Steps/Try These**
    1.  Practitioner Journey-  As a Hadoop Practitioner you can adopt following learning paths
        *   Hadoop Developer - [Click Here!](http://hortonworks.com/products/hortonworks-sandbox/#tuts-developers)
        *   Hadoop Administrator -[Click Here!](http://hortonworks.com/products/hortonworks-sandbox/#tuts-admins)
        *   Data Scientist - [Click Here!](http://hortonworks.com/products/hortonworks-sandbox/#tuts-analysts)
    2.  [Case Studies](http://hortonworks.com/industry/) – Learn how Hadoop is being used by various industries.
8.  **References and Resources**
    1.  [Hadoop - The Definitive Guide by O`Reilly](http://www.amazon.com/Hadoop-Definitive-Guide-Tom-White/dp/1491901632/ref=dp_ob_image_bk)
    2.  [Hadoop for Dummies](http://www.amazon.com/Hadoop-Dummies-Dirk-deRoos/dp/1118607554/ref=sr_1_1?s=books&ie=UTF8&qid=1456105405&sr=1-1&keywords=hadoop+dummies)
    3.  [Hadoop Crash Course slides-Hadoop Summit 2015](http://www.slideshare.net/Hadoop_Summit/hadoop-crash-course-workshop-at-hadoop-summit)
    4.  [Hadoop Crash Course Workshop- Hadoop Summit 2015](https://www.youtube.com/watch?v=R-va7pZg7HM)
