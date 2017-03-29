---
title: Spark on HBase A DataFrame Based HBase Connector
tutorial-id: 369
platform: hdp-2.5.0
tags: [spark, hbase]
---

# Spark on HBase: A DataFrame Based HBase Connector

## Introduction
The technical preview of the [Spark-HBase connector](https://github.com/hortonworks/shc) was developed by Hortonworks along with Bloomberg. The connector leverages Spark SQL Data Sources API introduced in Spark-1.2.0. It bridges the gap between the simple HBase Key Value store and complex relational SQL queries and enables users to perform complex data analytics on top of HBase using Spark. An HBase DataFrame is a standard Spark DataFrame, and is able to interact with any other data sources such as Hive, ORC, Parquet, JSON, etc.

## Prerequisites

*   Download and Install [Hortonworks Sandbox 2.5](https://hortonworks.com/products/sandbox/)
*   Review [Learning the Ropes of the Hortonworks Sandbox](https://hortonworks.com/hadoop-tutorial/learning-the-ropes-of-the-hortonworks-sandbox/)
*   Review [Getting Started with Apache Zeppelin](https://hortonworks.com/hadoop-tutorial/getting-started-apache-zeppelin/)

## Outline

-   [Concepts](#concepts)
-   [Usage](#usage)
-   [Import and run Apache Zeppelin Notebook](#import-and-run-apache-zeppelin-notebook)
-   [Non-Zeppelin Spark Package HBase Configuration](#non-zeppelin-spark-package-hbase-configuration)

## Concepts

There are several open source Spark HBase connectors available either as Spark packages, as independent projects or in HBase trunk. Spark has moved to the Dataset/DataFrame APIs, which provides built-in query plan optimization. Now, end users prefer to use DataFrames/Datasets based interface. The HBase connector in the HBase trunk has a rich support at the RDD level, e.g. BulkPut, etc, but its DataFrame support is not as rich. HBase trunk connector relies on the standard HadoopRDD with HBase built-in TableInputFormat has some performance limitations. In addition, BulkGet performed in the the driver may be a single point of failure. There are some other alternative implementations. Take [**Spark-SQL-on-HBase**](https://github.com/Huawei-Spark/Spark-SQL-on-HBase) as an example. It applies very advanced custom optimization techniques by embedding its own query optimization plan inside the standard Spark Catalyst engine, ships the RDD to HBase and performs complicated tasks, such as partial aggregation, inside the HBase coprocessor. This approach is able to achieve high performance, but it difficult to maintain due to its complexity and the rapid evolution of Spark. Also allowing arbitrary code to run inside a coprocessor may pose security risks. The Spark-on-HBase Connector (SHC) has been developed to overcome these potential bottlenecks and weaknesses. It implements the standard Spark Datasource API, and leverages the Spark Catalyst engine for query optimization. In parallel, the RDD is constructed from scratch instead of using TableInputFormat in order to achieve high performance. With this customized RDD, all critical techniques can be applied and fully implemented, such as partition pruning, column pruning, predicate pushdown and data locality. The design makes the maintenance very easy, while achieving a good tradeoff between performance and simplicity.

## Usage

The following illustrates the basic procedure on how to use the connector. For more details and advanced use case, such as Avro and composite key support, please refer to the [examples](https://github.com/hortonworks/shc/tree/master/src/main/scala/org/apache/spark/sql/execution/datasources/hbase/examples) in the repository.

## Import and run Apache Zeppelin Notebook

For this example, we have prepared and written a fully functional Zeppelin notebook example: "Spark HBase - A DataFrame Based Connector."

If you're new to Zeppelin make sure to checkout the [Getting Started Guide](https://hortonworks.com/hadoop-tutorial/getting-started-apache-zeppelin/).

You can preview the completed notebook [here](https://www.zeppelinhub.com/viewer/notebooks/aHR0cHM6Ly9yYXcuZ2l0aHVidXNlcmNvbnRlbnQuY29tL2hvcnRvbndvcmtzLWdhbGxlcnkvemVwcGVsaW4tbm90ZWJvb2tzL2hkcC0yLjUvMkJSWkNBTTRFL25vdGUuanNvbg).

And you can import the notebook using the following url [https://raw.githubusercontent.com/hortonworks-gallery/zeppelin-notebooks/hdp-2.5/2BRZCAM4E/note.json](https://raw.githubusercontent.com/hortonworks-gallery/zeppelin-notebooks/hdp-2.5/2BRZCAM4E/note.json)

## Non-Zeppelin Spark Package HBase Configuration

Users can also use the Spark-on-HBase connector as a standard Spark package. To include the package in your Spark application use: spark-shell, pyspark, or spark-submit

`$SPARK_HOME/bin/spark-shell --packages zhzhan:shc:0.0.11-1.6.1-s_2.10`

Users can include the package as the dependency in your SBT file as well. The format is the spark-package-name:version

`spDependencies += "zhzhan:shc:0.0.11-1.6.1-s_2.10"`
