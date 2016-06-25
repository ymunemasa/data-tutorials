---
layout: tutorial
title: Getting Started with Apache Zeppelin
tutorial-id: 368
tutorial-series: Zeppelin
tutorial-version: hdp-2.5.0
intro-page: true
components: [ Zeppelin, Spark, Hive, LDAP, Livy ]
---

Apache Zeppelin is a web-based notebook that enables interactive data analytics. With Zeppelin, you can make beautiful data-driven, interactive and collaborative documents with a rich set of pre-built language backends (or interpreters) such as Scala (with Apache Spark), Python (with Apache Spark), SparkSQL, Hive, Markdown, Angular, and Shell.

With a focus on Enterprise, Zeppelin has the following important features:

* Ambari-managed installation
* Zeppelin Livy integration
* Security:
  * Execute jobs as authenticated user
  * Zeppelin authentication against LDAP
  * Notebook authorization

### **Prerequisites**

*   HDP 2.5 TP
*   Spark 1.6.1

### **Overview**

This tutorial of Apache Zeppelin covers:

*   Instructions for setting up Zeppelin on HDP 2.5 TP with Spark 1.6.1 using Ambari
*   Configuration for running Zeppelin against Spark on YARN and Hive
*   Configuration for running Zeppelin against Spark on YARN with Livy interpreter
*   Access Control on Notebooks
*   Configuration for Zeppelin to authenticate users against LDAP
