<<<<<<< HEAD
---
layout: tutorial
title: Simulating and Transporting Real Time Event Streams with Apache Kafka
tutorial-id: 170
tutorial-series: Streaming
tutorial-version: hdp-2.4.0
intro-page: false
components: [ kafka ]
---

# Lab 1: Simulating and Transporting Real Time Event Stream with Apache Kafka
=======
# Lab 1: Simulate and Transport Real Time Event Stream with Apache Kafka
>>>>>>> hdp

### Introduction

[Apache Kafka](http://kafka.apache.org/) can be used on the Hortonworks Data Platform to capture real-time events. We will begin with showing you how to configure Apache Kafka and Zookeeper. Next we will show you how to ingest the truckevent data into Kafka. We have also included code highlights at the end of this tutorial for your reference.

## Pre-Requisites
*  Downloaded and Installed latest [Hortonworks Sandbox](http://hortonworks.com/products/hortonworks-sandbox/#install)
*  Since this tutorial requires admin privileges, refer to [Learning the Ropes of the Hortonworks Sandbox](http://hortonworks.com/hadoop-tutorial/learning-the-ropes-of-the-hortonworks-sandbox/) to reset your Ambari admin password
*  Memory must be at least 8GB RAM, preferably 4 processor cores, else errors may occur in third tutorial
*  Allow yourself around one hour to complete this tutorial

## Outline

*   [Apache Kafka](#apache-kafka-lab1)
*   [Step 1: Navigate to Ambari User Views](#navigate-ambari-user-views-lab1)
*   [Step 2: Start Apache Kafka](#start-kafka-lab1)
*   [Step 3: Configure Kafka with Zookeeper](#configure-kafka-with-zookeeper-lab1)
*   [Step 4: Create Kafka Producer](#define-kafka-topic-lab1)
*   [Step 5: Load the data](#download-data-lab1)
*   [Step 6: Run Kafka Producer](#run-kafka-producer-lab1)
*   [Step 7: Code Review](#code-review-lab1)
*   [Appendix A: Install Kafka](#install-kafka-lab1)
*   [Appendix B: Install Maven and Compile](#install-maven-compile-lab1)
*   [Further Reading](#further-reading-lab1)

## Apache Kafka <a id="apache-kafka-lab1"></a>

[Apache Kafka](http://kafka.apache.org/) is an open source messaging system designed for:

*   Persistent messaging
*   High throughput
*   Distributed
*   Multi-client support
*   Real time

![Kafka Producer-Broker-Consumer](/assets/realtime-event-processing/t1-update/image13.png)

Kafka Producer-Broker-Consumer

### Tutorial Overview

1.  Install and Start Kafka on latest [Hortonworks Sandbox](http://hortonworks.com/products/hortonworks-sandbox/).
2.  Review Kafka and ZooKeeper Configs
3.  Create Kafka topics for Truck events.
4.  Write Kafka Producers for Truck events.

### Step 1: Navigate to Ambari <a id="navigate-ambari-user-views-lab1"></a>

#### 1.1 Start the Hortonworks Sandbox

After downloading the Sandbox and running the VM, login to the Sandbox using the URL displayed in the console. For example, the URL in the screenshot below is `http://127.0.0.1:8888/`

![](/assets/realtime-event-processing/t1-update/sandbox_virtualbox_vm_iot.png)

#### 1.2 Login to Ambari

After resetting your Ambari admin password with assistance from [Learning the Ropes of the Hortonworks Sandbox](http://hortonworks.com/hadoop-tutorial/learning-the-ropes-of-the-hortonworks-sandbox/), Go to port 8080 of your Sandbox’s IP address to view the Ambari login page. For example, `http://127.0.0.1:8080:`

![](/assets/realtime-event-processing/t1-update/image21.png)


### Step 2: Start Apache Kafka <a id="start-kafka-lab1"></a>

#### 2.1  View the Kafka Services page

From the Dashboard page of Ambari, click on Kafka from the list of installed services. (If Kafka is not installed, perform the steps in [Appendix A](#appendix-a) first.):

![](/assets/realtime-event-processing/t1-update/image03.png)

#### 2.2 Enable Kafka

From the Kafka page, click on Service Actions -> Start:

![](/assets/realtime-event-processing/t1-update/image06.png)

Check the box and click on Confirm Start:

![Screen Shot 2015-06-04 at 3.06.10 PM.png](/assets/realtime-event-processing/t1-update/image11.png)

Wait for Kafka to start.

### Step 3: Configure Kafka with ZooKeeper <a id="configure-kafka-with-zookeeper-lab1"></a>

ZooKeeper serves as the coordination interface between the Kafka broker and consumers:

![Single Broker based Kakfa cluster](/assets/realtime-event-processing/t1-update/image02.png)

The important Zookeeper properties can be checked in Ambari.

#### 3.1  Configure ZooKeeper

Click on **ZooKeeper** in the list of services, then click on the Configs tab. Verify ZooKeeper is running on port 2181:

![](/assets/realtime-event-processing/t1-update/zookeeper_config_iot.png)

If this port 2181 is busy or is consumed by other processes, then you could change the default port number of ZooKeeper to any other valid port number. If ZooKeeper is not running, you can start the Zookeeper service from Ambari:

![](/assets/realtime-event-processing/t1-update/start_zookeeper_service_iot.png)

#### 3.2 Configure Kafka

From the Kafka page, click on the **Configs** tab. Verify the `zookeeper.connect` property points to your ZooKeeper server name and port:

![](/assets/realtime-event-processing/t1-update/kafka_configs_zookeeper_connect_iot.png)

### Step 4: Define a Kafka Topic <a id="define-kafka-topic-lab1"></a>

#### 4.1 SSH into the Sandbox

We will SSH into the Sandbox to the perform the remaining tasks of this tutorial. To SSH in to the Sandbox on Windows, press **Alt+F5** in the VM window. On a Mac, press **Fn+Alt+F5**.

![](/assets/realtime-event-processing/t1-update/sandbox_virtualbox_vm_iot.png)

> NOTE: You can also SSH using a program like Putty for Windows or the Terminal application on a Mac. The command to login is `ssh root@127.0.0.1 -p 2222`.

You will be prompted for a login:

![](/assets/realtime-event-processing/t1-update/prompt_login_iot.png)

Type in `root` as the login, and the password is `hadoop`.

**TIP**: After typing in the VM, press the Ctrl key on Windows (or Command+Ctrl on Mac) to regain control of the cursor.

#### 4.2 Create a new Topic

Using the `kafka-topics.sh` script (which should be in your PATH), create a new topic named `truckevent`:

~~~bash
[root@sandbox ~]# kafka-topics.sh --create --zookeeper localhost:2181 --replication-factor 1 --partitions 1 --topic truckevent  
~~~

If the `kafka-topics.sh` script is not in your PATH and you get a command not found error, then change directories to where the Kafka scripts are installed:

~~~bash
[root@sandbox ~]# cd /usr/hdp/current/kafka-broker/bin/
~~~

You will need to **add a dot and a slash (./)** to the beginning of the commands:

~~~bash
[root@sandbox bin]# ./kafka-topics.sh --create --zookeeper localhost:2181 --replication-factor 1 --partitions 1 --topic truckevent 
~~~
    
Also note that sometimes ZooKeeper does not listen on `localhost`, so you may need to use the Sandbox’s IP address instead.


The output should look like:

![](/assets/realtime-event-processing/t1-update/create_topic_kafka_iot.png)


#### 4.3 Verify the topic was created successfully

Check if topic `truckevent` was created successfully with the following command:

~~~bash
[root@sandbox ~]# ./kafka-topics.sh --list --zookeeper localhost:2181
~~~

You should see `truckevent` in the list of topics (and probably your only topic):

![](/assets/realtime-event-processing/t1-update/verify_kafka_topic_created_iot.png)

### Overview of Producing Messages  

Producers are applications that create Messages and publish them to the Kafka broker for further consumption:

![Kafka Producers for truck events](/assets/realtime-event-processing/t1-update/image24.png)


In this tutorial, we shall use a Java API to produce Truck events. The Java code in `TruckEventsProducer.java` will generate data with following columns:


~~~
    `driver_name` string,    
    `driver_id` string,    
    `route_name` string,    
    `route_id` string,    
    `truck_id` string,    
    `timestamp` string,    
    `longitude` string,    
    `latitude` string,    
    `violation` string,    
    `total_violations` string
~~~
  


This Java Truck events producer code uses [New York City Truck Routes (kml)](http://www.nyc.gov/html/dot/downloads/misc/all_truck_routes_nyc.kml) file which defines road paths with Latitude and Longitude information.



### Step 5: Download the Data <a id="download-data-lab1"></a>

1.  Download the New York City Truck Routes

Run the following commands to download the TruckEventsProducer Java code and the NYC Truck routes kml file. This may take a minute or two to download depending on the internet connection


~~~bash
[root@sandbox ~]# mkdir /opt/TruckEvents   
[root@sandbox ~]# cd /opt/TruckEvents   
[root@sandbox TruckEvents]# wget https://www.dropbox.com/s/rv43a05czfaqjlj/Tutorials-master-2.3.zip  
[root@sandbox TruckEvents]# unzip Tutorials-master-2.3.zip
[root@sandbox TruckEvents]# cd /opt/TruckEvents/Tutorials-master  
~~~


Note: The source code for all the tutorials is located in "src" subdirectory and the pre-compiled binaries for all the tutorials are in the "target" subdirectory. If you would like to modify/run the code, refer to Appendix B for the steps to install and run maven.


### Step 6: Run Kafka Producer <a id="run-kafka-producer-lab1"></a>

To start the Kafka Producer we execute the following command to see the output as shown in the screenshot below.

~~~bash
java -cp target/Tutorial-1.0-SNAPSHOT.jar com.hortonworks.tutorials.tutorial1.TruckEventsProducer sandbox.hortonworks.com:6667 sandbox.hortonworks.com:2181
~~~


![Screen Shot 2015-06-06 at 5.46.22 PM.png](/assets/realtime-event-processing/t1-update/run_kafka_producer_iot.png)

After a few seconds, press Control-C to stop the producer.

We have now successfully compiled and had the Kafka producer publish some messages to the Kafka cluster.

To verify, execute the following command to start a consumer to see the produced events:

~~~bash
[root@sandbox Tutorials-master]# /usr/hdp/current/kafka-broker/bin/kafka-console-consumer.sh --zookeeper sandbox.hortonworks.com:2181 --topic truckevent --from-beginning
~~~
   
![Screen Shot 2015-06-06 at 5.50.53 PM.png](/assets/realtime-event-processing/t1-update/verify_kafka_producer_sent_messages_iot.png)  

You can press Control-C to stop the console consumer (i.e keep Control key pressed and then press C)

## Code description <a id="code-review-lab1"></a>

## Producer:

We use the TruckEventsProducer.java file under the src/main/java/tutorial1/ directory to generate the Kafka TruckEvents. This uses the all_truck_routes_nyc.kml data file available from [NYC DOT](http://www.nyc.gov/html/dot/html/motorist/trucks.shtml). We use Java API’s to produce Truck Events.

~~~bash
[root@sandbox ~]# ls /opt/TruckEvents/Tutorials-master/src/main/java/com/hortonworks/tutorials/tutorial1/TruckEventsProducer.java

[root@sandbox ~]# ls /opt/TruckEvents/Tutorials-master/src/main/resources/all_truck_routes_nyc.kml  
~~~

The java file contains 3 functions

~~~java
    `public class TruckEventsProducer`
~~~
We configure the Kafka producer in this function to serialize and send the data to Kafka Topic ‘truckevent’ created in the tutorial. The code below shows the Producer class used to generate messages.

~~~java
    String TOPIC = "truckevent";    
    ProducerConfig config = new ProducerConfig(props);    
    Producer<String, String> producer = new Producer<String, String>(config);  
~~~

The properties of the producer are defined in the ‘props’ variable. The events, truckIds and the driverIds data is selected with random function from the array variables.

~~~java
    Properties props = new Properties();    
    props.put("metadata.broker.list", args[0]);    
    props.put("zk.connect", args[1]);    
    props.put("serializer.class", "kafka.serializer.StringEncoder");    
    props.put("request.required.acks", "1");  




    String[] events = {"Normal", "Normal", "Normal", "Normal", "Normal", "Normal", "Lane Departure","Overspeed", "Normal", "Normal", "Normal", "Normal", "Lane Departure","Normal","Normal", "Normal", "Normal",  "Unsafe tail distance", "Normal", "Normal","Unsafe following distance", "Normal", "Normal", "Normal","Normal","Normal","Normal","Normal","Normal","Normal","Normal","Normal","Normal","Normal", "Normal", "Overspeed","Normal", "Normal","Normal","Normal","Normal","Normal","Normal" };

    String[] truckIds = {"1", "2", "3","4"};

    String[] routeName = {"route17", "route17k", "route208", "route27"};

    String[] driverIds = {"11", "12", "13", "14"};
~~~


`KeyedMessage` class takes the topic name, partition key, and the message value that needs to be passed from the producer as follows:



#### class KeyedMessage(K, V)

~~~java
    KeyedMessage<String, String> data = new KeyedMessage<String, String>(TOPIC, finalEvent);  
~~~

The Kafka producer events with timestamps are created by selecting the data from above arrays and geo location from the all_truck_routes_nyc.kml file.

~~~java
    KeyedMessage<String, String> data = new KeyedMessage<String, String>(TOPIC, finalEvent);    
    LOG.info("Sending Messge #:" + i +", msg:" + finalEvent);    
    producer.send(data);    
    Thread.sleep(1000);'  
~~~

To transmit the data, we now build an array using the GetKmlLangList() and getLatLong() function.

~~~java
    private static String getLatLong
~~~


This function returns coordinates in Latitude and Longitude format.

~~~java
    if (latLong.length == -1)    
    {  
       return latLong[1].trim() + "|" + latLong[0].trim();    
    }  
~~~

Function used to build an array:

~~~java
    public static String[] GetKmlLanLangList
~~~

This method is reading KML file which is an XML file. This xml file is loaded in File fXmlFile variable.

~~~java
    File fXmlFile = new File(urlString);  
~~~

Which will parse this file by running through each node (Node.ELEMENT_NODE) in loop. The XML element "coordinates" has array of two items lat, long. The function reads the lat, long and returns the values in array.





## Conclusion

This tutorial gave you brief glimpse of how to use Apache Kafka to transport real-time events data. In our next tutorial, you will see how to capture data from Kafka Producer into Storm for processing


## Appendix A: Install Kafka <a id="install-kafka-lab1"></a>

Follow these steps if your version of the Sandbox does not have Kafka installed:


1\.  From the Ambari Dashboard, select Actions -> Add Service:

![](/assets/realtime-event-processing/t1-update/add_service_kafka_iot.png)

2\.  Select Kafka from the list of Services and click Next:

![](/assets/realtime-event-processing/t1-update/select_kafka_iot.png)

3\.  Keep clicking Next with the selected defaults until you reach the following screen:

![](/assets/realtime-event-processing/t1-update/kafka_log_dirs_iot.png)

4\.  Set the value of logs.dir to  /tmp/kafka-logs


5\.  Click the Deploy button:

![](/assets/realtime-event-processing/t1-update/deploy_kafka_service_iot.png)

6\.  Wait for Kafka to install:

![](/assets/realtime-event-processing/t1-update/install_start_test_kafka_iot.png)


7\.  After Kafka is installed, you may be asked to restart some dependent Services. Please select the appropriate Services and click Restart.


## Appendix B: Install Maven and compile <a id="install-maven-compile-lab1"></a>

Download and install Apache Maven as shown in the commands below

~~~bash
    curl -o /etc/yum.repos.d/epel-apache-maven.repo https://repos.fedorapeople.org/repos/dchen/apache-maven/epel-apache-maven.repo
    yum -y install apache-maven
    mvn -version  
~~~

![Maven Version](/assets/realtime-event-processing/t1-update/maven_version_iot.png)
Maven Version


Now lets compile and execute the code to generate Truck Events. (This may run for a 5-6 minutes, depending on your internet connection)

~~~bash
    cd /opt/TruckEvents/Tutorials-master    
    mvn clean package  
~~~

![mvn clean package](/assets/realtime-event-processing/t1-update/maven_clean_package_iot.png)

![mvn clean package](/assets/realtime-event-processing/t1-update/build_success_maven_iot.png)

~~~bash
    ls
~~~

Once the code is successfully compiled we shall see a new target directory created in the current folder. The binaries for all the Tutorials are in this target directory and the source code in src.

![](/assets/realtime-event-processing/t1-update/new_dir_maven_package_iot.png)


## Further Reading <a id="further-reading-lab1"></a>
- [Apache Kafka](http://kafka.apache.org/)
- [Kafka Overview](http://hortonworks.com/hadoop/kafka/)
