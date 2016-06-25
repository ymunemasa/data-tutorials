---
layout: tutorial
title: Getting Started with Apache Zeppelin
tutorial-id: 368
tutorial-series: Zeppelin
tutorial-version: hdp-2.5.0
intro-page: true
components: [ Zeppelin, Spark, Hive, LDAP, Livy ]
---

Apache Zeppelin requires the following software:

*   HDP 2.5 TP
*   Spark 1.6.1
*   Git installed on the node that is running Ambari Server. (If you need to install git, run sudo yum install git.)
*   Java 8 installed on the node where Zeppelin is installed

**Note:** If you're running an **HDP 2.5 TP Sandbox**, then you already have the latest Apache Zeppelin pre-installed with most of the features pre-configured. The features, however, may have to be enabled.

**HDP Cluster Requirements**

Zeppelin can be installed on any HDP 2.5 TP cluster. The following instructions assume that Spark version 1.6.1 is already installed on the HDP cluster.

### **Installing Zeppelin on an Ambari-Managed Cluster**

To install Zeppelin using Ambari, complete the following steps:

1\.  Download the Zeppelin Ambari Stack Definition. On the node running Ambari server, run the following:

~~~
VERSION=`hdp-select status hadoop-client | sed 's/hadoop-client - \([0-9]\.[0-9]\).*/\1/'`

sudo git clone https://github.com/hortonworks-gallery/ambari-zeppelin-service.git /var/lib/ambari-server/resources/stacks/HDP/$VERSION/services/ZEPPELIN
~~~

2\.  Restart the Ambari Server:

~~~
sudo service ambari-server restart
~~~

3\.  After Ambari restarts and service indicators turn green, add the Zeppelin service.

Important: Make sure that you install the Zeppelin service on a node where Spark clients are installed.

At the bottom left of the Ambari dashboard, choose **Actions** -> **Add Service**:

![zepp-add-service](http://hortonworks.com/wp-content/uploads/2016/05/zepp-add-service-280x300.png)

On the Add Service screen select the Zeppelin service. Step through the rest of the installation process, accepting all default values. On the Review screen, make a note of the node selected to run Zeppelin service; call this ZEPPELIN_HOST.

![add-service-review](http://hortonworks.com/wp-content/uploads/2016/05/add-service-review-300x157.png)

Click **Deploy** to complete the installation process.

4\. Launch Zeppelin in your browser: [http://ZEPPELIN_HOST:9995](http://zeppelin_host:9995)

Zeppelin includes a few sample notebooks, including a Zeppelin tutorial. There are also quite a few notebooks available at the [Hortonworks Zeppelin Gallery](https://github.com/hortonworks-gallery/zeppelin-notebooks), including sentiment analysis, geospatial mapping,IoT demos, and multiple labs.
