---
title: Visualize Website Clickstream Data
tutorial-id: 250
platform: hdp-2.5.0
tags: [ambari, hive, hdfs, zeppelin]
---

# Visualize Website Clickstream Data

## Introduction

Your home page looks great. But how do you move customers on to bigger things—like submitting a form or completing a purchase? Get more granular with customer segmentation. Hadoop makes it easier to analyze, visualize and ultimately change how visitors behave on your website.

In this demo, we demonstrate how an online retailer can optimize buying paths to reduce bounce rate and improve conversion.

<iframe width="700" height="394" src="https://www.youtube.com/embed/weJI6Lp9Vw0?feature=oembed&amp;enablejsapi=1" frameborder="0" allowfullscreen="" id="player0"></iframe>

### In this tutorial, learn how to:

-   Upload twitter feeds into [HDFS](https://hortonworks.com/hadoop/hdfs)
-   Use [HCatalog](https://hortonworks.com/apache/hive/#section_4) to build a relational view of the data
-   Use [Hive](https://hortonworks.com/hadoop/hive) to query and refine the data
-   Import the data into Microsoft Excel with the [ODBC Driver for Apache Hive (v2.1.5)](https://hortonworks.com/downloads/#data-platform)
-   Visualize Data with Powerview
-   Visualize Data with Apache Zeppelin

This demo can be completed with the [Hortonworks Sandbox](https://hortonworks.com/products/sandbox) – a single-node Hadoop cluster running in a virtual machine. Download to run this and other tutorials in the series.

The Hortonworks sandbox is a fully contained Hortonworks Data Platform (HDP) environment. The sandbox includes the core Hadoop components (HDFS and MapReduce), as well as all the tools needed for data ingestion and processing. You can access and analyze sandbox data with many Business Intelligence (BI) applications.

In this tutorial, we will load and review data for a fictitious web retail store in what has become an established use case for Hadoop: deriving insights from large data sources such as web logs. By combining web logs with more traditional customer data, we can better understand our customers, and also understand how to optimize future promotions and advertising.

### Clickstream Data

Clickstream data is an information trail a user leaves behind while visiting a website. It is typically captured in semi-structured website log files.

These website log files contain data elements such as a date and time stamp, the visitor’s IP address, the destination URLs of the pages visited, and a user ID that uniquely identifies the website visitor.

### Potential Uses of Clickstream Data

One of the original uses of Hadoop at Yahoo was to store and process their massive volume of clickstream data. Now enterprises of all types can use Hadoop and the Hortonworks Data Platform (HDP) to refine and analyze clickstream data. They can then answer business questions such as:

-   What is the most efficient path for a site visitor to research a product, and then buy it?
-   What products do visitors tend to buy together, and what are they most likely to buy in the future?
-   Where should I spend resources on fixing or enhancing the user experience on my website?

In this tutorial, we will focus on the “path optimization” use case. Specifically: how can we improve our website to reduce bounce rates and improve conversion?

## Prerequisites

-   Hortonworks ODBC driver (64-bit) installed and configured
-   Hortonworks sample data files uploaded and refined as described in “Loading Data into the Hortonworks Sandbox”
    -   If you haven't loaded this data yet, please [download it here](https://s3.amazonaws.com/hw-sandbox/tutorial8/RefineDemoData.zip)  and import it by following this tutorial: [https://hortonworks.com/hadoop-tutorial/loading-data-into-the-hortonworks-sandbox/](https://hortonworks.com/hadoop-tutorial/loading-data-into-the-hortonworks-sandbox/)
-   Microsoft Excel 2013 Professional Plus 64-bit
-   Windows 7 or later(Optional - to run Microsoft Excel 2013 Professional Plus edition)
    -   Note this tutorial can still be run with any version of Excel, but your visualizaitons will be limited to the built in charts. You may wish to attempt this with another visualization tool that can accept data via an ODBC connection, like Tableau, Lumira, etc.

There are two options for setting up the Hortonworks Sandbox:

1.  **Download & Install [Hortonworks Sandbox](https://hortonworks.com/sandbox)** on your local machine (recommended 8GB of dedicated RAM for the Virtual Machine)
2.  **Deploy [Hortonworks Sandbox on Microsoft Azure](https://hortonworks.com/hadoop-tutorial/deploying-hortonworks-sandbox-on-microsoft-azure/)**


## Outline

1.  **Lab 1** - Perform Web Log Analysis with Hive introduction
2.  **Lab 2** - Visualize Clickstream Logs with Excel
