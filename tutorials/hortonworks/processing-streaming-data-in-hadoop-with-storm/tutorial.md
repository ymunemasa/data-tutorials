### Introduction

In this tutorial, we will review Apache Storm Infrastructure, download a storm jar file and deploy a WordCount Topology. After we run the topology, we will view storm log files because it is helpful for debugging.

## Pre-Requisites
*  Downloaded and Installed latest [Hortonworks Sandbox](http://hortonworks.com/products/hortonworks-sandbox/#install)
*  [Learning the Ropes of the Hortonworks Sandbox](http://hortonworks.com/hadoop-tutorial/learning-the-ropes-of-the-hortonworks-sandbox/)
*  Allow yourself around one hour to complete this tutorial

## Outline
- [What is Apache Storm?](#what-is-apache-storm)
- [Step 1: Check Storm Service is Running](#check-storm-service-running)
- [Step 2: Download the Storm Topology JAR file](#download-storm-topology-jar-file)
- [Step 3: Check Classes Available in jar](#check-classes-available-jar)
- [Step 4: Run Word Count Topology](#run-word-count-topology)
- [Step 5: Open Storm UI](#open-storm-ui)
- [Step 6: Click on WordCount Topology](#click-on-wordcount-topology)
- [Step 7: Navigate to Bolt Section](#navigate-to-bolt-section)
- [Step 8: Navigate to Executor Section](#navigate-to-executor-section)
- [Appendix A: View Storm Log Files](#appendix-a-view-log-files)
- [Appendix B: Install Maven and Get Started Storm Starter Kit](#appendix-b-install-maven-download-storm-kit)
- [Further Reading](#further-reading)

### What is Apache Storm? <a id="what-is-apache-storm"></a>

[Apache Storm](http://hortonworks.com/hadoop/storm) is an open source engine which can process data in realtime using its distributed architecture. Storm is simple and flexible. It can be used with any programming language of your choice.

Let’s look at the various components of a Storm Cluster:

1.  **Nimbus node. **The master node (Similar to JobTracker)
2.  **Supervisor nodes.** Starts/stops workers & communicates with Nimbus through Zookeeper
3.  **ZooKeeper nodes.** Coordinates the Storm cluster


![Storm Architecture](/assets/processing-streaming-data-in-hadoop-with-storm/storm_architecture.png)

> Architechture: Nimbus, Zookeeper, Supervisor


Here are a few terminologies and concepts you should get familiar with before we go hands-on:

*   **Tuples.** An ordered list of elements. For example, a “4-tuple” might be (7, 1, 3, 7)
*   **Streams.** An unbounded sequence of tuples.
*   **Spouts.** Sources of streams in a computation (e.g. a Twitter API)
*   **Bolts.** Process input streams and produce output streams. They can:
    *   Run functions;
    *   Filter, aggregate, or join data;
    *   Talk to databases.
*   **Topologies.** The overall calculation, represented visually as a network of spouts and bolts


![Storm Basic Concepts](/assets/processing-streaming-data-in-hadoop-with-storm/storm_basic_concepts.png)

> Basic Concepts Map: Topologies process data when it comes streaming in from the spout, the bolt processes it and the results are passed into Hadoop.


## Installation and Setup Verification:

### Step 1: Check Storm Service is Running <a id="check-storm-service-running"></a>

Let’s check if the sandbox has storm processes up and running by login into Ambari and look for Storm in the services listed:

![](/assets/processing-streaming-data-in-hadoop-with-storm/check_storm_service_psdh_storm.png)

### Step 2: Download the Storm Topology JAR file <a id="download-storm-topology-jar-file"></a>

Now let’s look at a Streaming use case using Storm’s Spouts and Bolts processes. For this we will be using a simple use case, however it should give you the real life experience of running and operating on Hadoop Streaming data using this topology.

Let’s get the jar file which is available in the Storm Starter kit. This has other examples as well, but let’s use the WordCount operation and see how to turn it ON. We will also track this in Storm UI.

~~~bash
wget http://public-repo-1.hortonworks.com/HDP-LABS/Projects/Storm/0.9.0.1/storm-starter-0.0.1-storm-0.9.0.1.jar
~~~

![enter image description here](/assets/processing-streaming-data-in-hadoop-with-storm/download_storm_starter_kit.png)


### Step 3: Check Classes Available in jar <a id="check-classes-available-jar"></a>

In the Storm example Topology, we will be using three main parts or processes:

1.  Sentence Generator Spout
2.  Sentence Split Bolt
3.  WordCount Bolt

You can check the classes available in the jar as follows:

~~~bash
jar -xvf storm-starter-0.0.1-storm-0.9.0.1.jar | grep Sentence  
jar -xvf storm-starter-0.0.1-storm-0.9.0.1.jar | grep Split  
jar -xvf storm-starter-0.0.1-storm-0.9.0.1.jar | grep WordCount
~~~


![enter image description here](/assets/processing-streaming-data-in-hadoop-with-storm/check_classes_available_jar.png)



### Step 4: Run Word Count Topology <a id="run-word-count-topology"></a>

Let’s run the storm job. It has a Spout job to generate random sentences while the bolt counts the different words. There is a split Bolt Process along with the Wordcount Bolt Class.

Let’s run the Storm Jar file.

~~~bash
[root@sandbox ~]# storm jar storm-starter-0.0.1-storm-0.9.0.1.jar storm.starter.WordCountTopology WordCount -c storm.starter.WordCountTopology WordCount -c nimbus.host=sandbox.hortonworks.com
~~~

> **Note:** For Sandbox versions without Storm preinstalled, navigate to `/usr/lib/storm/bin/` directory to run the command above.

![enter image description here](/assets/processing-streaming-data-in-hadoop-with-storm/run_storm_topology_wordcount.png)



### Step 5: Open Storm UI <a id="open-storm-ui"></a>

Let’s use Storm UI and look at it graphically:  
![enter image description here](/assets/processing-streaming-data-in-hadoop-with-storm/view_storm_topology_stormui.png)

> You should notice the Storm Topology, WordCount in the Topology summary.

### Step 6: Click on WordCount Topology <a id="click-on-wordcount-topology"></a>

The topology is located Under Topology Summary. You will see the following:  

![enter image description here](/assets/processing-streaming-data-in-hadoop-with-storm/click_wordcount_topology.png)

### Step 7: Navigate to Bolt Section <a id="navigate-to-bolt-section"></a>

Click on **count**.

![enter image description here](/assets/processing-streaming-data-in-hadoop-with-storm/click_count_bolt_section.png)


### Step 8: Navigate to Executor Section <a id="navigate-to-executor-section"></a>

Click on any port and you will be able to view the results.


![enter image description here](/assets/processing-streaming-data-in-hadoop-with-storm/count_executor_section_ports.png)


You just processed streaming data using Apache Storm. Congratulations on completing the Tutorial!


## Appendix A: View Storm Log Files <a id="appendix-a-view-log-files"></a>

Lastly but most importantly, you can always look at the log files. These logs are extremely useful for debugging or status finding. Their directory location:

~~~bash
[root@sandbox ~]# cd /var/log/storm

[root@sandbox storm]# ls -ltr
~~~

![enter image description here](/assets/processing-streaming-data-in-hadoop-with-storm/view_log_files_debugging.png)


## Appendix B: Install Maven and Get Started with Storm Starter Kit <a id="appendix-b-install-maven-download-storm-kit"></a>

### Install Maven

Download and install Apache Maven as shown in the commands below

~~~bash
curl -o /etc/yum.repos.d/epel-apache-maven.repo https://repos.fedorapeople.org/repos/dchen/apache-maven/epel-apache-maven.repo
yum -y install apache-maven
mvn -version
~~~

![enter image description here](/assets/processing-streaming-data-in-hadoop-with-storm/maven_install_version_streaming_storm.png)


### Get Started with Storm Starter Kit

Download the Storm Starter Kit and try other topology examples, such as ExclamationTopology and ReachTopology.

~~~bash
git clone git://github.com/apache/storm.git && cd storm/examples/storm-starter
~~~


## Further Reading <a id="further-reading"></a>

- Learn to setup the [Apache Storm-Starter Kit from Github](https://github.com/apache/storm/tree/master/examples/storm-starter) manually with their guide.
- [Apache Storm Talks and Slides](http://storm.apache.org/talksAndVideos.html)
- [Basics of Storm](http://storm.apache.org/documentation.html)
- [Apache Storm](http://hortonworks.com/hadoop/storm/)




