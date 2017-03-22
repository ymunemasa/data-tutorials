# Hortonworks HDP 2.5 Technical Preview Tutorials

Tutorials below in Section 1 are working and the ones in Section 2 don't work.

## Outline

- Getting Started with HDP
- Apache Atlas & Apache Ranger Integration
- Apache Spark & Apache Zeppelin
- Apache HBase & Apache Phoenix
- Data Pipelining with Apache Falcon


## Getting Started with HDP

**Description**

Begin your Apache Hadoop journey with this tutorial aimed for users with limited experience in using the Sandbox.
Explore Sandbox on virtual machine and cloud environments and learn to navigate the Apache Ambari user interface.

This tutorial provides a section that describes the key concepts and series of tutorials where you move data into HDFS,
explore the data with SQL in Apache Hive, do transformations with Apache Pig or Apache Spark and at the end generate a
report with Apache Zeppelin.

[View Hello HDP Tutorial](https://github.com/hortonworks/tutorials/tree/hdp-2.5/tutorials/hortonworks/hello-hdp-an-introduction-to-hadoop)

![tez_vertex_swimlane]({{page.path}}/assets/tez_vertex_swimlane_map1_lab2.png)

Coverage: Ambari, Ambari Views(Hive, Pig), Hive, Pig, Spark, Zeppelin


## Apache Atlas & Apache Ranger Integration

**Description**

Hortonworks has recently announced the integration of Apache Atlas and Apache Ranger, and introduced the concept of tag or classification based policies. Enterprises can classify data in Apache Atlas and use the classification to build security policies in Apache Ranger.

This tutorial walks through an example of tagging data in Atlas and building a security policy in Ranger.

[View Atlas & Ranger Integration Tutorial](https://github.com/hortonworks/tutorials/blob/hdp-2.5/tutorials/hortonworks/tag-based-policies-atlas-ranger/tutorial.md)

![Tag Based Policies]({{page.path}}/assets/deny_conditions.png)

Coverage: Atlas, Ranger

## Apache Spark & Apache Zeppelin

**Description**

Apache Spark is a fast, in-memory data processing engine with elegant and expressive development APIs to allow data workers to efficiently execute streaming, machine learning or SQL workloads that require fast iterative access to datasets.

These tutorials will provide you an introduction to using Apache Spark in Apache Zeppelin notebooks.  You will also learn to use the new Apache Spark HBase connector inside an Apache Zeppelin notebook.

![zeppelin_login_lab4]({{page.path}}/assets/zeppelin_login_lab4.png)

There are 6 tutorials (2 new)

- (**New!**) [Spark HBase - A DataFrame Based Connector](https://github.com/hortonworks/tutorials/blob/hdp-2.5/tutorials/hortonworks/spark-hbase-a-dataframe-based-hbase-connector/tutorial.md)
Coverage: Spark with Hortonworks HBase Connector in Zeppelin


- (**New!**) [Getting Started with Apache Zeppelin](https://github.com/hortonworks/tutorials/tree/hdp-2.5/tutorials/hortonworks/getting-started-with-apache-zeppelin)
Coverage: Zeppelin

-  [Hands-on Tour of Apache Spark in 5 Minutes](https://github.com/hortonworks/tutorials/blob/hdp-2.5/tutorials/hortonworks/hands-on-tour-of-spark-5-minutes/tutorial.md)
Coverage: Spark w Python, Zeppelin

-  [A Lap Around Apache Spark](https://github.com/hortonworks/tutorials/blob/hdp-2.5/tutorials/hortonworks/a-lap-around-spark/tutorial.md)
Coverage: Uses a lot of Spark features but no Zeppelin

-  [Interacting with Data on HDP using Apache Zeppelin and Apache Spark](https://github.com/hortonworks/tutorials/blob/hdp-2.5/tutorials/hortonworks/interacting-with-data-using-zeppelin-and-spark/tutorial.md)
Coverage: Spark w Scala, Zeppelin

-  [Using Hive with ORC from Apache Spark](https://github.com/hortonworks/tutorials/blob/hdp-2.5/tutorials/hortonworks/orc-with-spark/tutorial.md)
Coverage: Spark RDD, ORC

## Apache HBase & Apache Phoenix

**Description**

Apache HBase is an open source NoSQL database that provides real-time read/write access to those large datasets.  Learn how to use the new Apache HBase backup and restore features.

[View HBase & Phoenix Tutorial](https://github.com/hortonworks/tutorials/blob/hdp-2.5/tutorials/hortonworks/introducing-hbase-phoenix/tutorial.md)

The new "Introduction to Hbase Concepts and Apache Phoenix" tutorial where some parts are still pending.  This will be leveraging the same Hbase tables from the IOT tutorial and will break it out into its own series.   This will also add the Backup and Restore labs (new feature in HDP 2.5) and the Spark Hbase Connector(new feature HDP 2.5).

## Data Pipelining with Apache Falcon

**Description**

Apache Falcon centrally manages the data lifecycle, facilitate quick data replication for business continuity and disaster recovery and provides a foundation for audit and compliance by tracking entity lineage and collection of audit logs.
Learn how to use the update Apache Falcon to create data pipelines and mirror data sets.

![falcon_new_ui]({{page.path}}/assets/tutorial_image.png)

These tutorials work with HDP 2.4 but given the major Falcon UI change these will need a lot updates.

[Create a Falcon Cluster](https://github.com/hortonworks/tutorials/blob/hdp-2.5/tutorials/hortonworks/create-falcon-cluster-hdp2.5/tutorial.md)

[Mirroring datasets between Hadoop Clusters via Apache Falcon](https://github.com/hortonworks/tutorials/blob/hdp-2.5/tutorials/hortonworks/mirroring-datasets-using-falcon-hdp2.5/tutorial.md)
