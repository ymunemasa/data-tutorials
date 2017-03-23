---
title: Learning Spark SQL with Zeppelin
tutorial-id: 365
platform: hdp-2.6.0
tags: [spark, zeppelin]
---

# Learning Spark SQL with Zeppelin

## Introduction

In this tutorial, we will introduce you to Apache Spark SQL. Spark SQL is a higher-level module that allows you to operate on DataFrames and Datasets, which we will cover in more detail later.

In the second part of the lab, we will explore an airline dataset using higher-level SQL API. We will visualize the dataset and write SQL queries to find insights on when and where we can expect highest delays in flight arrivals and departures.

## Prerequisites

-   This tutorial is a part of series of hands-on tutorials using the [Hortonworks Data Platform (HDP)](https://hortonworks.com/products/data-center/hdp/) via either the [Hortonworks Data Cloud (HDCloud)](https://hortonworks.com/products/cloud/aws/) or a pre-configured downloadable [HDP Sandbox](https://hortonworks.com/products/sandbox/).
-   The Zeppelin notebook uses basic [Scala](http://www.dhgarrette.com/nlpclass/scala/basics.html) syntax. A Python version is coming soon.
-   (Optional) If you are new to Zeppelin, review the following tutorial: [Getting Started with Apache Zeppelin](https://hortonworks.com/hadoop-tutorial/getting-started-apache-zeppelin/)

## Outline
-   [Tutorial Details](#tutorial-details)
-   [Environment Setup](#environment-setup)
    -   [Option 1: Setup Hortonworks Data Cloud (HDCloud) on AWS](#option-1-setup-hortonworks-data-cloud-hdcloud-on-aws)
    -   [Option 2: Download and Setup Hortonworks Data Platform (HDP) Sandbox](#option-2-download-and-setup-hortonworks-data-platform-hdp-sandbox)
-   [Notebook Preview](#notebook-preview)
-   [Start the Tutorial](#start-the-tutorial)
-   [Final Words](#final-words)

## Tutorial Details

TODO:

## Environment Setup

### Option 1: Setup Hortonworks Data Cloud (HDCloud) on AWS

1a. Create an [Amazon Web Services (AWS) Account](https://aws.amazon.com/) if you don't have one

1b. Follow this step-by-step doc to [Setup and Launch a Controller on HDCloud](https://hortonworks.github.io/hdp-aws/launch/index.html)

1c. Create a *Data Science* [Cluster](https://hortonworks.github.io/hdp-aws/create/index.html) (use settings listed below)

Select/specify the following for your cluster:

-   HDP Version: HDP 2.6 or later
-   Cluster Type: "Data Science: Apache Spark 2.1+, Apache Zeppelin 0.6.2+" or later
-   Worker instance count: one or more
-   Remote Access: 0.0.0.0/0

Here's a screenshot with sample settings:

![setting-up-hd-cloud](assets/spinning-up-hdcloud-cluster.jpg)

### Option 2: Download and Setup Hortonworks Data Platform (HDP) Sandbox

This option is optimal if you prefer to run everything in local environment (laptop/PC).

Keep in mind, that you will need **8GB** of memory dedicated for the virtual machine, meaning that you should have at least **12GB** of memory on your system.

2a. Download and Install [HDP Sandbox 2.6](https://hortonworks.com/products/sandbox/)

2b. Review [Learning the Ropes of HDP Sandbox](https://hortonworks.com/hadoop-tutorial/learning-the-ropes-of-the-hortonworks-sandbox/)

#### Review Zeppelin Tutorial (optional)

If you are new to Zeppelin, review the following tutorial [Getting Started with Apache Zeppelin](https://github.com/hortonworks/tutorials/blob/hdp-2.5/tutorials/hortonworks/getting-started-with-apache-zeppelin/tutorial.md)

## Notebook Preview

Before you start, here's a preview of the notebook.

![Notebook Preview](assets/large-notebook-preview.jpg)

A dynamic preview (allowing code copy) can be found [here](https://www.zeppelinhub.com/viewer/notebooks/aHR0cHM6Ly9yYXcuZ2l0aHVidXNlcmNvbnRlbnQuY29tL2hvcnRvbndvcmtzLWdhbGxlcnkvemVwcGVsaW4tbm90ZWJvb2tzL2hkcC0yLjYvMkNBNTg3Szc3L25vdGUuanNvbg).

## Start Tutorial

TODO:

- Download Notebook Link: https://raw.githubusercontent.com/hortonworks-gallery/zeppelin-notebooks/hdp-2.6/2CA587K77/note.json

## Final Words

TODO:
