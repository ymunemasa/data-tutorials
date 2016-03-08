---
layout: tutorial
title: How to Analyze Machine and Sensor Data
tutorial-id: 310
tutorial-series: Real-World End to End Examples
tutorial-version: hdp-2.4.0
intro-page: true
components: [ hive, zeppelin, ambari ]
---


## How to Analyze Machine and Sensor Data

**This tutorial is for HDP version 2.4 of the [Hortonworks Sandbox](http://hortonworks.com/products/sandbox) - a single-node Hadoop cluster running in a virtual machine. [Download](http://hortonworks.com/products/sandbox) the Hortonworks Sandbox to run this and other tutorials in the series.**

### Introduction

This tutorial describes how to refine data from heating, ventilation,
and air conditioning (HVAC) systems using the Hortonworks Data Platform,
and how to analyze the refined sensor data to maintain optimal building
temperatures.

Demo: Here is the video of [Enable Predictive Analytics with Hadoop](http://www.youtube.com/watch?v=Op_5MmG7hIw) as a demo of what you'll be doing in this tutorial.

### Sensor Data

A sensor is a device that measures a physical quantity and transforms it into a digital signal. Sensors are always on, capturing data at a low cost, and powering the "Internet of Things."

### Potential Uses of Sensor Data

Sensors can be used to collect data from many sources, such as:

-   To monitor machines or infrastructure such as ventilation equipment, bridges, energy meters, or airplane engines. This data can be used for predictive analytics, to repair or replace these items before they break.
-   To monitor natural phenomena such as meteorological patterns, underground pressure during oil extraction, or patient vital statistics during recovery from a medical procedure.

In this tutorial, we will focus on sensor data from building operations. Specifically, we will refine and analyze the data from Heating, Ventilation, Air Conditioning (HVAC) systems in 20 large buildings around the world.

### Prerequisites:

- Hortonworks Sandbox (installed and running)
- Hortonworks ODBC driver installed and configured (if using Microsoft Excel for reporting analysis)

Refer to

-   [Installing and Configuring the Hortonworks ODBC driver on Windows 7](http://hortonworks.com/hadoop-tutorial/how-to-install-and-configure-the-hortonworks-odbc-driver-on-windows-7/)
-   [Installing and Configuring the Hortonworks ODBC driver on Mac OS X](http://hortonworks.com/hadoop-tutorial/how-to-install-and-configure-the-hortonworks-odbc-driver-on-mac-os-x/)
-   Microsoft Excel 2013 Professional Plus (optional)

**Notes:**

-   In this tutorial, the Hortonworks Sandbox is installed on an Oracle VirtualBox virtual machine (VM) – your screens may be different.
-   If you plan on using the Microsoft Excel for the analysis and reporting section install the ODBC driver that matches the version of Excel you are using (32-bit or 64-bit).
-   If choosing to use Excelm you will use the Power View feature in Microsoft Excel 2013 to visualize the sensor data. Power View is currently only available in Microsoft Office Professional Plus and Microsoft Office 365 Professional Plus.
-   Note, other versions of Excel will work, but the visualizations will be limited to charts. You can connect to any other visualization tool you like.
-	If not using Excel, you will be able to use Apache Zeppelin to analyze and report on the data from this tutorial.

### Overview

To refine and analyze HVAC sensor data, we will:

-   Download and extract the sensor data files.
-   Load the sensor data into the Hortonworks Sandbox.
-   Run two Hive scripts to refine the sensor data.
-   Access the refined sensor data with Microsoft Excel or Apache Zeppelin.
-   Visualize the sensor data using Excel Power View or Apache Zeppelin.


### Download and Extract the Sensor Data Files

-   You can download the sample sensor data contained in a compressed (.zip) folder here:
  - [SensorFiles.zip](http://s3.amazonaws.com/hw-sandbox/tutorial14/SensorFiles.zip)   

-   Save the `SensorFiles.zip` file to your computer, then extract the files. You should see a SensorFiles folder that contains the following files:

-   `HVAC.csv` – contains the targeted building temperatures, along with the actual (measured) building temperatures. The building temperature data was obtained using Apache Flume. Flume can be usedas a log aggregator, collecting log data from many diverse sources and moving it to a centralized data store. In this case, Flume was used to capture the sensor log data, which we can now load into the Hadoop Distributed File System (HFDS).  For more details on Flume, refer to Tutorial 13: Refining and Visualizing Sentiment Data

-   `building.csv` – contains the "building" database table. Apache Sqoop can be used to transfer this type of data from a structured database into HFDS.

## Outline 

1. [Lab 1 - Load Data Into Hive](#lab-1)
2. [Lab 2 - Reporting](#lab-2)
  - [Reporting with Excel](#report-with-excel)
  - [Reporting with Zeppelin](#report-with-zeppelin)
