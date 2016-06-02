---
layout: tutorial
title: Create Falcon Cluster
tutorial-id: 640
tutorial-series: Governance
tutorial-version: hdp-2.4.0
intro-page: true
components: [ falcon, ambari ]
---

## Introduction

Apache Falcon is a framework to simplify data pipeline processing and management on Hadoop clusters.

It makes it much simpler to onboard new workflows/pipelines, with support for late data handling and retry policies. It allows you to easily define relationship between various data and processing elements and integrate with metastore/catalog such as Hive/HCatalog. Finally it also lets you capture lineage information for feeds and processes. In this tutorial, we are going to create a Falcon cluster by :

*   Preparing up HDFS directories
*   Creating two cluster entities (primaryCluster and backupCluster)

## Prerequisite

- [Download Hortonworks Sandbox](http://hortonworks.com/products/hortonworks-sandbox/#install)
- Complete the [Learning the Ropes of the Hortonworks Sandbox tutorial,](http://hortonworks.com/hadoop-tutorial/learning-the-ropes-of-the-hortonworks-sandbox/) you will need it for logging into Ambari as an administrator user.

Once you have downloaded the Hortonworks Sandbox and run the VM, navigate to the Ambari interface on the port `8080` of the IP address of your Sandbox VM. Login with the username of `admin` and the password that you set for the Ambari admin user. You should have a similar image as below:

![ambariHomePage](/assets/create-falcon-cluster/ambariHomePage.png)

## Outline
- [1: Starting Falcon](#starting-falcon)
- [2: Preparing HDFS Directories](#preparing-hdfs-directories)
- [3: Creating Cluster Entities](#creating-cluster-entities)
      - [3.1: Creating primaryCluster Entity using Wizard](#creating-primaryCluster-wizard)
      - [3.2: Creating primaryCluster Entity using XML](#creating-primaryCluster-XML)
      - [3.3: Creating backupCluster Entity using Wizard](#creating-backupCluster-wizard)
      - [3.4: Creating backupCluster Entity using XML](#creating-backupCluster-XML)
- [4: Summary](#summary)
- [5: Where do I go next?](#where-do-I-go-next)

## 1. Starting Falcon <a id="starting-falcon"></a>

By default, Falcon is not started on the Sandbox. You can start the Falcon service from Ambari by clicking on the Falcon icon in the left hand pane:

![falconHomePage](/assets/create-falcon-cluster/falconHomePage.png)


Then click on the `Service  Actions` button on the top right:

![falconStart](/assets/create-falcon-cluster/falconStart.png)


Then click on `Start`:

![falconStartProgress](/assets/create-falcon-cluster/falconStartProgress.png)


Once Falcon starts, Ambari should clearly indicate as below that the service has started:

![falconStarted](/assets/create-falcon-cluster/falconStarted.png)

## 2. Preparing HDFS Directories <a id="preparing-hdfs-directories"></a>

First SSH into the Hortonworks Sandbox with the command:

~~~bash
ssh root@127.0.0.1 -p 2222
~~~

![sshTerminal](/assets/create-falcon-cluster/sshTerminal.png)

The default password is `hadoop`. If you have changed it earlier, then enter the new one.

We need to create the directories on HDFS representing the two clusters that we are going to define, namely `primaryCluster` and `backupCluster`.

First, from the command line, check whether the Falcon server is running or not.
Switch the user to Falcon using:

~~~bash
su - falcon
~~~

Change the directory to your HDP version:

~~~bash
cd /usr/hdp/2.4.2.0.0-258/falcon
~~~

And run the below script to find the status of Falcon server:

~~~bash
./bin/falcon-status
~~~

 Next, use `hadoop fs -mkdir` commands to create the directories `/apps/falcon/primaryCluster` and `/apps/falcon/backupCluster` on HDFS.

 ~~~bash
 hadoop fs -mkdir /apps/falcon/primaryCluster
 hadoop fs -mkdir /apps/falcon/backupCluster
 ~~~

 ![creatingDirectories](/assets/create-falcon-cluster/creatingDirectories.png)

 Further create directories called `staging` inside each of the directories we created above:

 ~~~bash
 hadoop fs -mkdir /apps/falcon/primaryCluster/staging
 hadoop fs -mkdir /apps/falcon/backupCluster/staging
 ~~~

 ![creatingStagingDirectories](/assets/create-falcon-cluster/creatingStagingDirectories.png)

 Next, create the `working` directories for `primaryCluster` and `backupCluster`:

 ~~~bash
 hadoop fs -mkdir /apps/falcon/primaryCluster/working
 hadoop fs -mkdir /apps/falcon/backupCluster/working
 ~~~

![creatingWorkingDirectories](/assets/create-falcon-cluster/creatingWorkingDirectories.png)

Finally you need to set the proper permissions on the staging/working directories:

~~~bash
hadoop fs -chmod 777 /apps/falcon/primaryCluster/staging
hadoop fs -chmod 755 /apps/falcon/primaryCluster/working
hadoop fs -chmod 777 /apps/falcon/backupCluster/staging
hadoop fs -chmod 755 /apps/falcon/backupCluster/working
~~~

## 3. Creating Cluster Entities <a id="creating-cluster-entities"></a>

Let’s open the Falcon Web UI. You can easily launch the Falcon Web UI from Ambari:
Navigate to the Falcon Summary page and click `Quick Links>Falcon Web UI`.

![quickLinksFalconUI](/assets/create-falcon-cluster/quickLinksFalconUI.png)

You can also navigate to the Falcon Web UI directly on the browser. The Falcon UI is by default at port 15000. The default username is `ambari-qa` and the password is `admin`.

![loginFalconPage](/assets/create-falcon-cluster/loginFalconPage.png)

This UI allows us to create and manage the various entities like Cluster, Feed, Process and Mirror. Each of these entities are represented by an XML file that you either directly upload or generate by filling out the various fields.
You can also search for existing entities and then edit, change state, etc.

![falconUI](/assets/create-falcon-cluster/falconUI.png)

Let’s first create a couple of cluster entities. To create a cluster entity click on the `Cluster` button on the top.

**NOTE : If you want to create it from XML, skip the wizard section, and move on to the next one.**

### 3.1 Creating primaryCluster Entity using Wizard <a id="creating-primaryCluster-wizard"></a>

A cluster entity defines the default access points for various resources on the cluster as well as default working directories to be used by Falcon jobs.

To define a cluster entity, we must specify a unique name by which we can identify the cluster. In this tutorial, we use:

~~~
primaryCluster
~~~

Next enter a data center name or location of the cluster and a description for the cluster. The data center name can be used by Falcon to improve performance of jobs that run locally or across data centers. Mention `primaryColo` in Colo and `this is primary cluster` in description.

All entities defined in Falcon can be grouped and located using tags. To clearly identify and locate entities, we assign the tag:

~~~
EntityType
~~~

With the value

~~~
Cluster
~~~

We then need to specify the owner and permissions for the cluster.
So we enter:

~~~
Owner:  ambari-qa
Group: users
Permissions: 755
~~~

Next, we enter the URI for the various resources Falcon requires to manage data on the clusters. These include the NameNode dfs.http.address, the NameNode IPC address used for file system metadata operations, the Yarn client IPC address used for executing jobs on Yarn, the Oozie address used for running Falcon Feeds and Processes, and the Falcon messaging address. The values we will use are the defaults for the Hortonworks Sandbox; if you run this tutorial on your own test cluster, modify the addresses to match those defined in Ambari:

~~~
Readonly hftp://sandbox.hortonworks.com:50070
Write hdfs://sandbox.hortonworks.com:8020
Execute sandbox.hortonworks.com:8050         
Workflow http://sandbox.hortonworks.com:11000/oozie/
Messaging tcp://sandbox.hortonworks.com:61616?daemon=true
~~~

The versions are not used and will be removed in the next version of the Falcon UI.

You can also override cluster properties for a specific cluster. This can be useful for test or backup clusters which may have different physical configurations. In this tutorial, we’ll just use the properties defined in Ambari.

After the resources are defined, you must define default staging, temporary, and working directories for use by Falcon jobs based on the HDFS directories you created earlier in the tutorial. These can be overridden by specific jobs, but will be used in the event no directories are defined at the job level. In the current version of the UI, these directories must exist, be owned by Falcon, and have the proper permissions.

~~~
Staging  /apps/falcon/primaryCluster/staging
Temp /tmp         
Working /apps/falcon/primaryCluster/working
~~~

If you want to view the XML preview of whatever values you are entering, you can click on XML preview. Click Next to view the summary.

![cluster1](/assets/create-falcon-cluster/cluster1.png)

![cluster2](/assets/create-falcon-cluster/cluster2.png)

Click `Save` to persist the entity.

![cluster3](/assets/create-falcon-cluster/cluster3.png)

### 3.2 Creating primaryCluster Entity using XML <a id="creating-primaryCluster-XML"></a>

After clicking on the `Cluster` button at the top, click on the `Edit XML` button over XML Preview area. Replace the XML content with the XML document below:

~~~
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<cluster name="primaryCluster" description="this is primary cluster" colo="primaryColo" xmlns="uri:falcon:cluster:0.1">
    <tags>primaryKey=primaryValue</tags>
    <interfaces>
        <interface type="readonly" endpoint="hftp://sandbox.hortonworks.com:50070" version="2.2.0"/>
        <interface type="write" endpoint="hdfs://sandbox.hortonworks.com:8020" version="2.2.0"/>
        <interface type="execute" endpoint="sandbox.hortonworks.com:8050" version="2.2.0"/>
        <interface type="workflow" endpoint="http://sandbox.hortonworks.com:11000/oozie/" version="4.0.0"/>
        <interface type="messaging" endpoint="tcp://sandbox.hortonworks.com:61616?daemon=true" version="5.1.6"/>
    </interfaces>
    <locations>
        <location name="staging" path="/apps/falcon/primaryCluster/staging"/>
        <location name="temp" path="/tmp"/>
        <location name="working" path="/apps/falcon/primaryCluster/working"/>
    </locations>
    <ACL owner="ambari-qa" group="users" permission="0x755"/>
    <properties>
        <property name="test" value="value1"/>
    </properties>
</cluster>
~~~

Click `Finish` on top of the XML Preview area to save the XML.

![clusterXML1](/assets/create-falcon-cluster/clusterXML1.png)

Falcon UI should have automatically parsed out the values from the XML and populated in the right fields. Once you have verified that these are the correct values press `Next`.

![clusterXML2](/assets/create-falcon-cluster/clusterXML2.png)

Click `Save` to persist the entity.

![clusterXML3](/assets/create-falcon-cluster/clusterXML3.png)

You should receive a notification that the operation was successful.

Falcon jobs require a source cluster and a destination, or target, cluster. For some jobs, this may be the same cluster, for others, such as Mirroring and Disaster Recovery, the source and target clusters will be different.

**NOTE : If you want to create it from XML, skip the wizard section, and move on to the next one.**

### 3.3 Creating backupCluster Entity using Wizard <a id="creating-backupCluster-wizard"></a>

Let’s go ahead and create a second cluster by creating a cluster with the name:

~~~
backupCluster
~~~

Reenter the same information you used above except for the directory information. For the directories, use the backupCluster directories created earlier in the tutorial.

~~~
Staging  /apps/falcon/backupCluster/staging
Temp /tmp         
Working /apps/falcon/backupCluster/working
~~~

![cluster4](/assets/create-falcon-cluster/cluster4.png)

![cluster5](/assets/create-falcon-cluster/cluster5.png)

Click `Save` to persist the `backupCluster` entity.

![cluster6](/assets/create-falcon-cluster/cluster6.png)

### 3.4 Creating backupCluster Entity using XML <a id="creating-backupCluster-XML"></a>

Click on `Cluster` button on the top to open up the form to create the cluster entity.

After clicking on the `Cluster` button at the top, click on the `Edit XML` button over XML Preview area. Replace the XML content with the XML document below:

~~~
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<cluster name="backupCluster" description="this is backup colo" colo="backupColo" xmlns="uri:falcon:cluster:0.1">
    <tags>backupKey=backupValue</tags>
    <interfaces>
        <interface type="readonly" endpoint="hftp://sandbox.hortonworks.com:50070" version="2.2.0"/>
        <interface type="write" endpoint="hdfs://sandbox.hortonworks.com:8020" version="2.2.0"/>
        <interface type="execute" endpoint="sandbox.hortonworks.com:8050" version="2.2.0"/>
        <interface type="workflow" endpoint="http://sandbox.hortonworks.com:11000/oozie/" version="4.0.0"/>
        <interface type="messaging" endpoint="tcp://sandbox.hortonworks.com:61616?daemon=true" version="5.1.6"/>
    </interfaces>
    <locations>
        <location name="staging" path="/apps/falcon/backupCluster/staging"/>
        <location name="temp" path="/tmp"/>
        <location name="working" path="/apps/falcon/backupCluster/working"/>
    </locations>
    <ACL owner="ambari-qa" group="users" permission="0x755"/>
    <properties>
        <property name="test2" value="value2"/>
    </properties>
</cluster>
~~~

Click `Finish` on top of the XML Preview area to save the XML and then the Next button to verify the values.

![clusterXML4](/assets/create-falcon-cluster/clusterXML4.png)

Once you have verified that these are the correct values press `Next`.

![clusterXML5](/assets/create-falcon-cluster/clusterXML5.png)

Click `Save` to persist the `backupCluster` entity.

![clusterXML6](/assets/create-falcon-cluster/clusterXML6.png)

## 4. Summary <a id="summary"></a>

In this tutorial we learned how to create cluster entities in Apache Falcon using the Falcon UI. Now go ahead and start creating feeds and processes by exploring more Falcon tutorials.

## 5. Where do I go next? <a id="where-do-I-go-next"></a>

You can go to following links to explore other Falcon tutorials:

1. [Define and Process Data Pipelines in Hadoop with Apache Falcon](http://hortonworks.com/hadoop-tutorial/defining-processing-data-end-end-data-pipeline-apache-falcon/)
2. [Incremental Backup of data from HDP to Azure using Falcon for Disaster Recovery and Burst Capacity](http://hortonworks.com/hadoop-tutorial/incremental-backup-data-hdp-azure-disaster-recovery-burst-capacity/)
3. [Mirroring Datasets between Hadoop Clusters with Apache Falcon](http://hortonworks.com/hadoop-tutorial/mirroring-datasets-between-hadoop-clusters-with-apache-falcon/)
4. [Processing Data Pipeline using Apache Falcon](http://hortonworks.com/hadoop-tutorial/defining-processing-data-end-end-data-pipeline-apache-falcon/)
