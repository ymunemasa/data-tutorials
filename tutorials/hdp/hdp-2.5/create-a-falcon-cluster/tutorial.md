---
title: Create a Falcon Cluster
tutorial-id: 670
platform: hdp-2.5.0
tags: [falcon, ambari]
---

# Create a Falcon Cluster

## Introduction

Apache Falcon is a framework to simplify data pipeline processing and management on Hadoop clusters.

It makes it much simpler to onboard new workflows/pipelines, with support for late data handling and retry policies. It allows you to easily define relationship between various data and processing elements and integrate with metastore/catalog such as Hive/HCatalog. Finally it also lets you capture lineage information for feeds and processes. In this tutorial, we are going to create a Falcon cluster by :

-   Preparing up HDFS directories
-   Creating two cluster entities (primaryCluster and backupCluster)

## Prerequisite

- [Download Hortonworks Sandbox 2.5](https://hortonworks.com/downloads/#sandbox)
- Complete the [Learning the Ropes of the Hortonworks Sandbox tutorial,](https://hortonworks.com/hadoop-tutorial/learning-the-ropes-of-the-hortonworks-sandbox/) you will need it for logging into Ambari as an administrator user.

Once you have downloaded the Hortonworks Sandbox and run the VM, navigate to the Ambari interface on the port `8080` of the IP address of your Sandbox VM. Login with the username of `admin` and the password that you set for the Ambari admin user. You should have a similar image as below:

![ambariHomePage](assets/ambariHomePage.png)

## Outline
- [1. Scenario](#scenario)
- [2. Starting Falcon](#starting-falcon)
- [3. Create a Ambari Falcon user](#create-ambari-falcon-user)
- [4. Preparing HDFS Directories](#preparing-hdfs-directories)
- [5. Creating Cluster Entities](#creating-cluster-entities)
    - [5.1 Creating primaryCluster Entity using Wizard](#creating-primaryCluster-wizard)
    - [5.2 Creating primaryCluster Entity using XML](#creating-primaryCluster-XML)
    - [5.3 Creating backupCluster Entity using Wizard](#creating-backupCluster-wizard)
    - [5.4 Creating backupCluster Entity using XML](#creating-backupCluster-XML)
- [Summary](#summary)
- [Further Reading](#further-reading)

## 1. Scenario <a id="scenario"></a>

In this tutorial, we are going to create a Falcon cluster so that we can configure data pipelines and then perform the feed management services such as feed retention, data replication across clusters and archival. This tutorial is the starting point of all Falcon tutorials where we create two cluster entities which define where the data and the processes for your data pipeline are stored. Allow yourself 1 quality hour to complete this tutorial.

## 2. Starting Falcon <a id="starting-falcon"></a>

By default, Falcon is not started on the Sandbox. You can start the Falcon service from Ambari by clicking on the Falcon icon in the left hand pane:

![falconHomePage](assets/falconHomePage.png)

Then click on the `Service  Actions` button on the top right:

![falconStart](assets/falconStart.png)

Then click on `Start`:

![falconStartProgress](assets/falconStartProgress.png)

Once Falcon starts, Ambari should clearly indicate as below that the service has started:

![falconStarted](assets/falconStarted.png)

## 3. Create a Ambari falcon user <a id="create-ambari-falcon-user"></a>

Click the button at the top of the Ambari screen with admin menu drop down and click `Manage Ambari`.

![manage_ambari](assets/manage_ambari.png)

Click the blue `Users` button in the bottom box as given below:

![manage_users](assets/manage_users.png)

Click the `Create Local User` button at the top of the page.

![create_local_user](assets/create_local_user.png)

Enter `falcon` as the user name and then set the password for it. Enter it again for confirmation and `Save` the user.

![save_local_user](assets/save_local_user.png)

You can see the newly added `falcon` user. Click on it to assign it a group so that it can access Ambari views.
Write `“views”` and select it in `Local Group Membership` box and then click on `tick` mark to add a falcon user in the `“views”` group.

![local_group_permission](assets/local_group_permission.png)

Now logout of Ambari from the admin user and login to Ambari as falcon user.

## 4. Preparing HDFS Directories <a id="preparing-hdfs-directories"></a>

Select the Files View like given below:

![select_files_view](assets/select_files_view.png)

The Files View Interface will appear with the following default folders.

![files_view_home_page](assets/files_view_home_page.png)

We need to create the directories on HDFS representing the two clusters that we are going to define, namely `primaryCluster` and `backupCluster`.
Navigate to `/apps/falcon` folder, click the `New Folder` button ![new_folder_button](assets/new_folder_button.png), an add new folder window appears and name the folder primaryCluster. Press enter or `Add`

![add_new_folder_primary](assets/add_new_folder_primary.png)

Similarly, create another folder called `backupCluster`, you will see your new directories created successfully:

![primary_backup_folders_created](assets/primary_backup_folders_created.png)

Click on the row of `primaryCluster` directory and then click on `Permissions` button:

![click_permissions](assets/click_permissions.png)

Add `Write` permission for both Group and Others and then click `Save`.

![edit_permissions](assets/edit_permissions.png)

Do the same for `backupCluster` directory. Now navigate down into the `primaryCluster` directory and create two new directories: `staging` and `working`. Click on the row for the `staging` directory and add `Write` permission for both Group and Others. Refresh the page and then navigate to `/apps/falcon/primaryCluster` to see the changes:

![staging_working_folders](assets/staging_working_folders.png)

Repeat the same steps for `backupCluster`. Create two directories- `staging` and `working` and then assign `Write` permission in `staging` directory for Group and Others.

![staging_working_folders_backup](assets/staging_working_folders_backup.png)
<!---
First SSH into the Hortonworks Sandbox with the command:

~~~
ssh root@127.0.0.1 -p 2222
~~~

![sshTerminal](assets/sshTerminal.png)

The default password is `hadoop`. If you have changed it earlier, then enter the new one.

We need to create the directories on HDFS representing the two clusters that we are going to define, namely `primaryCluster` and `backupCluster`.

First, from the command line, check whether the Falcon server is running or not.
Switch the user to Falcon using:

~~~
su - falcon
~~~

Change the directory to your HDP version:

~~~
cd /usr/hdp/current/falcon-server
~~~

And run the below script to find the status of Falcon server:

~~~
./bin/falcon-status
~~~

 Next, use `hdfs dfs -mkdir` commands to create the directories `/apps/falcon/primaryCluster` and `/apps/falcon/backupCluster` on HDFS.

 ~~~
 hdfs dfs -mkdir /apps/falcon/primaryCluster
 hdfs dfs -mkdir /apps/falcon/backupCluster
 ~~~

 ![create_hdfs_directory](assets/create_hdfs_directory.png)

 Further create directories called `staging` inside each of the directories we created above:

 ~~~
 hdfs dfs -mkdir /apps/falcon/primaryCluster/staging
 hdfs dfs -mkdir /apps/falcon/backupCluster/staging
 ~~~

 ![create_staging_directory](assets/create_staging_directory.png)

 Next, create the `working` directories for `primaryCluster` and `backupCluster`:

 ~~~
 hdfs dfs -mkdir /apps/falcon/primaryCluster/working
 hdfs dfs -mkdir /apps/falcon/backupCluster/working
 ~~~

![create_working_directory](assets/create_working_directory.png)

Finally you need to set the proper permissions on the staging/working directories:

~~~
hdfs dfs -chmod 777 /apps/falcon/primaryCluster/staging
hdfs dfs -chmod 755 /apps/falcon/primaryCluster/working
hdfs dfs -chmod 777 /apps/falcon/backupCluster/staging
hdfs dfs -chmod 755 /apps/falcon/backupCluster/working
~~~
-->

## 5. Creating Cluster Entities <a id="creating-cluster-entities"></a>

Let’s open the Falcon Web UI. You can navigate to the Falcon Web UI directly on the browser. Type `127.0.0.1:15000`. The Falcon UI is by default at port 15000. The default username is `ambari-qa`.
<!---
You can easily launch the Falcon Web UI from Ambari:
Navigate to the Falcon Summary page and click `Quick Links>Falcon Web UI`.

![quickLinksFalconUI](assets/quickLinksFalconUI.png)
-->

![falcon_login_page](assets/falcon_login_page.png)

This UI allows us to create and manage the various entities like Cluster, Feed, Process and Mirror. Each of these entities are represented by an XML file that you either directly upload or generate by filling out the various fields.
You can also search for existing entities and then edit, change state, etc.

![falcon_front_page](assets/falcon_front_page.png)

Let’s first create a couple of cluster entities. To create a cluster entity click on the `Create` dropdown,

![select_cluster](assets/select_cluster.png)

 Click `Cluster` on the top.

**NOTE : If you want to create it from XML, skip the wizard section, and move on to the next one.**

### 5.1 Creating primaryCluster Entity using Wizard <a id="creating-primaryCluster-wizard"></a>

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

Next, we enter the URI for the various resources Falcon requires to manage data on the clusters. These include the NameNode dfs.http.address, the NameNode IPC address used for file system metadata operations, the Yarn client IPC address used for executing jobs on Yarn, the Oozie address used for running Falcon Feeds and Processes, and the Falcon messaging address. The values we will use are the defaults for the Hortonworks Sandbox; if you run this tutorial on your own test cluster, modify the addresses to match those defined in Ambari:

~~~
Namenode DFS Address - hftp://sandbox.hortonworks.com:50070
File System Default Address - hdfs://sandbox.hortonworks.com:8020
YARN Resource Manager Address - sandbox.hortonworks.com:8050
Workflow Address - http://sandbox.hortonworks.com:11000/oozie/
Message Broker Address - tcp://sandbox.hortonworks.com:61616?daemon=true
~~~

You can also override cluster properties for a specific cluster. This can be useful for test or backup clusters which may have different physical configurations. In this tutorial, we’ll just use the properties defined in Ambari.
After the resources are defined, you must define default staging, temporary, and working directories for use by Falcon jobs based on the HDFS directories you created earlier in the tutorial. These can be overridden by specific jobs, but will be used in the event no directories are defined at the job level. In the current version of the UI, these directories must exist, be owned by Falcon, and have the proper permissions.

~~~
Staging*  - /apps/falcon/primaryCluster/staging
Temp* - /tmp
Working* - /apps/falcon/primaryCluster/working
~~~

We then need to specify the owner and permissions for the cluster. Click on Advanced Options drop down menu

So we enter:

~~~
Owner:  ambari-qa
Group: users
Permissions: 755
Owner - Check box Read, Write and Execute
Group - Check box Read and Execute
Others - Check box Read and Execute
~~~

If you want to view the XML preview of whatever values you are entering, you can click on XML preview. Click Next to view the summary.

![cluster1](assets/cluster1.png)

![cluster2](assets/cluster2.png)

Click `Save` to persist the entity.

![cluster_save](assets/cluster_save.png)

### 5.2 Creating primaryCluster Entity using XML <a id="creating-primaryCluster-XML"></a>

After clicking on the `Create` drop down menu, select `Cluster` button and click on the `Edit XML` button over XML Preview area. Replace the XML content with the XML document below:

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

![cluster_xml_1](assets/cluster_xml_1.png)

Falcon UI should have automatically parsed out the values from the XML and populated in the right fields. Once you have verified that these are the correct values press `Next`.

![cluster_xml_2](assets/cluster_xml_2.png)

Click `Save` to persist the entity.

![cluster_xml_save](assets/cluster_xml_save.png)

You should receive a notification that the operation was successful.

Falcon jobs require a source cluster and a destination, or target, cluster. For some jobs, this may be the same cluster, for others, such as Mirroring and Disaster Recovery, the source and target clusters will be different.

**NOTE : If you want to create it from XML, skip the wizard section, and move on to the next one.**

### 5.3 Creating backupCluster Entity using Wizard <a id="creating-backupCluster-wizard"></a>

Let’s go ahead and create a second cluster by creating a cluster with the name:

~~~
backupCluster
~~~

Mention `backupColo` in Colo and `this is backup cluster` in description.

Reenter the same information you used above except for the directory information. For the directories, use the backupCluster directories created earlier in the tutorial.

~~~
Staging* - /apps/falcon/backupCluster/staging
Temp* - /tmp
Working* - /apps/falcon/backupCluster/working
~~~

![backup_cluster1](assets/backup_cluster1.png)

![backup_cluster2](assets/backup_cluster2.png)

Click `Save` to persist the `backupCluster` entity.

![backup_cluster_save](assets/backup_cluster_save.png)

### 5.4 Creating backupCluster Entity using XML <a id="creating-backupCluster-XML"></a>

Click on `Create` drop down menu and click `Cluster` button to open up the form to create the cluster entity.
Click on the `Edit XML` button over XML Preview area. Replace the XML content with the XML document below:

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

![backup_cluster_xml_1](assets/backup_cluster_xml_1.png)

Once you have verified that these are the correct values press `Next`.

![backup_cluster_xml_2](assets/backup_cluster_xml_2.png)

Click `Save` to persist the `backupCluster` entity.

![backup_cluster_xml_save](assets/backup_cluster_xml_save.png)

## Summary <a id="summary"></a>

In this tutorial we learned how to create cluster entities in Apache Falcon using the Falcon UI. Now go ahead and start creating feeds and processes by exploring more Falcon tutorials.

## Further Reading

You can go to following links to explore other Falcon tutorials:

1. [Mirroring Datasets between Hadoop Clusters with Apache Falcon](https://hortonworks.com/hadoop-tutorial/mirroring-datasets-between-hadoop-clusters-with-apache-falcon/)
2. [Define and Process Data Pipelines in Hadoop with Apache Falcon](https://hortonworks.com/hadoop-tutorial/defining-processing-data-end-end-data-pipeline-apache-falcon/)
3. [Incremental Backup of data from HDP to Azure using Falcon for Disaster Recovery and Burst Capacity](https://hortonworks.com/hadoop-tutorial/incremental-backup-data-hdp-azure-disaster-recovery-burst-capacity/)
4. [Processing Data Pipeline using Apache Falcon](https://hortonworks.com/hadoop-tutorial/defining-processing-data-end-end-data-pipeline-apache-falcon/)
