---
layout: tutorial
title: Introduce Apache Hadoop to Developers
tutorial-id: 130
tutorial-series: Introduction
tutorial-version: hdp-2.5.0
intro-page: false
components: [ hadoop ]
---

## Introduction

In this concepts overview, we will explore the core concepts of Apache Hadoop and examine the 
Mapper and Reducer at a high level perspective.

## Pre-Requisite
*  Downloaded and Installed latest [Hortonworks Sandbox](http://hortonworks.com/products/hortonworks-sandbox/#install)
*  [Learning the Ropes of the Hortonworks Sandbox](http://hortonworks.com/hadoop-tutorial/learning-the-ropes-of-the-hortonworks-sandbox/)
*  Allow yourself around 1 to 2 hours to complete this tutorial

## Outline

*   [Hadoop](#hadoop-concept)
*   [Explore the Core Concepts of Apache Hadoop](#core-apache-hadoop)
*   [Step 1: What is MapReduce?](#what-is-mapreduce)
*   [Step 2: The MapReduce Concepts and Terminology](#mapreduce-concepts-terminology)
*   [Step 3: MapReduce: The Mapper](#mapreduce-the-mapper)
*   [Step 4: MapReduce: The Reducer](#mapreduce-the-reducer)

## Hadoop <a id="hadoop-concept"></a>

Apache Hadoop is a community driven open-source project goverened by the [Apache Software Foundation](http://apache.org).

It was originally implemented at Yahoo based on papers published by Google in 2003 and 2004\. Hadoop committers today work 
at several different organizations like Hortonworks, Microsoft, Facebook, Cloudera and many others around the world.

Since then Apache Hadoop has matured and developed to become a data platform for not just processing humongous amount of 
data in batch but with the advent of [YARN](http://hortonworks.com/hadoop/yarn/) it now supports many diverse workloads 
such as Interactive queries over large data with [Hive on Tez](http://hortonworks.com/labs/stinger/), Realtime data processing 
with [Apache Storm](http://hortonworks.com/labs/storm/), super scalable NoSQL datastore like [HBase](http://hortonworks.com/hadoop/hbase/),
in-memory datastore like [Spark](http://hortonworks.com/hadoop/spark/) and the list goes on.

![](/assets/introducing-hadoop-to-java-developers/5-boxes.png)

> Hortonworks Data Platform


### Explore the Core Concepts of Apache Hadoop <a id="core-apache-hadoop"></a>

*   The Hadoop Distributed File System (HDFS)
*   MapReduce

A Hadoop Cluster is a set of machines that run HDFS and MapReduce. Nodes are individual machines. A cluster can have as few as 
one node to several thousands of nodes. For most application scenarios, Hadoop is linearly scalable, which means you can expect 
better performance by simply adding more nodes.

### Step 1: What is MapReduce? <a id="what-is-mapreduce"></a>

MapReduce is a method for distributing a task across multiple nodes. Each node processes data stored on that node to the extent possible.

A running Map Reduce job consists of various phases such as `Map  ->  Sort  ->  Shuffle  ->  Reduce`

The primary advantages of abstracting your jobs as MapReduce, which run over a distributed infrastructure like CPU and Storage are:

*   Automatic parallelization and distribution of data in blocks across a distributed, scale-out infrastructure.
*   Fault-tolerance against failure of storage, compute and network infrastructure
*   Deployment, monitoring and security capability
*   A clean abstraction for programmers

Most MapReduce programs are written in Java. It can also be written in any scripting language using the Streaming API of Hadoop. 
MapReduce abstracts all the low level plumbing away from the developer such that developers can concentrate on writing the Map and 
Reduce functions.

### Step 2: The MapReduce Concepts and Terminology <a id="mapreduce-concepts-terminology"></a>

MapReduce jobs are controlled by a software daemon known as the `JobTracker`. The JobTracker resides on a ‘master node’. Clients 
submit MapReduce jobs to the JobTracker. The JobTracker assigns Map and Reduce tasks to other nodes on the cluster.

These nodes each run a software daemon known as the `TaskTracker`. The TaskTracker is responsible for actually instantiating the Map 
or Reduce task, and reporting progress back to the JobTracker

A `job` is a program with the ability to execute Mappers and Reducers over a dataset. A `task` is the execution of a single Mapper 
or Reducer over a slice of data.

There will be at least as many task attempts as there are tasks. If a task attempt fails, another will be started by the JobTracker. 
Speculative execution can also result in more task attempts than completed tasks.

### Step 3: MapReduce: The Mapper <a id="mapreduce-the-mapper"></a>

Hadoop attempts to ensure that Mappers run on nodes, which hold their portion of the data locally, to minimize network traffic. 
Multiple Mappers run in parallel, each processing a portion of the input data.

The Mapper reads data in the form of key/value pairs. It outputs zero or more key/value pairs

~~~
map(in_key, in_value) -> (inter_key, inter_value) list
~~~

The Mapper may use or completely ignore the input key. For example, a standard pattern is to read a file one line at a time. 
The key is the byte offset into the file at which the line starts. The value is the contents of the line itself. Typically the 
key is considered irrelevant. If the Mapper writes anything out, the output must be in the form of key/value pairs.

### Step 4: MapReduce: The Reducer <a id="mapreduce-the-reducer"></a>

After the Map phase is over, all the intermediate values for a given intermediate key are combined together into a list. This list 
is given to a Reducer. There may be a single Reducer, or multiple Reducers, this is specified as part of the job configuration. 
All values associated with a particular intermediate key are guaranteed to go to the same Reducer.

The intermediate keys and their value lists are passed to the Reducer in sorted key order. This step is known as the 
***shuffle and sort***. The Reducer outputs zero or more final key/value pairs. These are written to HDFS. In practice, the Reducer 
usually emits a single key/value pair for each input key.

It is possible for some Map tasks to take more time to complete than the others, often due to faulty hardware, or underpowered machines. 
This execution time may cause a bottleneck since all mappers need to finish before any reducers can kick-off. Hadoop uses speculative 
execution to mitigate against such situations. If a Mapper appears to be running more sluggishly than the others, a new instance of the 
Mapper will be started on another machine, operating on the same data. The results of the first Mapper to finish will be used. Hadoop 
will kill off the Mapper which is still running.
