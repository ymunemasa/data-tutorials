---
layout: tutorial
title: Mirroring Datasets Between Hadoop Clusters with Apache Falcon
tutorial-id: 650
tutorial-series: Governance
tutorial-version: hdp-2.4.0
intro-page: true
components: [ falcon, ambari ]
---

##Introduction

Apache Falcon is a framework to simplify data pipeline processing and management on Hadoop clusters.

It provides data management services such as retention, replications across clusters, archival etc. It makes it much simpler to onboard new workflows/pipelines, with support for late data handling and retry policies. It allows you to easily define relationship between various data and processing elements and integrate with metastore/catalog such as Hive/HCatalog. Finally it also lets you capture lineage information for feeds and processes.

In this tutorial we are going walk the process of mirroring the datasets between Hadoop clusters.

## Prerequisite

- [Download Hortonworks Sandbox](http://hortonworks.com/products/hortonworks-sandbox/#install)
- Complete the [Learning the Ropes of the Hortonworks Sandbox tutorial,](http://hortonworks.com/hadoop-tutorial/learning-the-ropes-of-the-hortonworks-sandbox/) you will need it for logging into Ambari as an administrator user.
- Complete the [Creating Falcon Cluster tutorial](http://hortonworks.com/hadoop-tutorial/create-falcon-cluster/) to start the falcon service, prepare HDFS directories for Falcon cluster and to create Falcon cluster entities.

## Outline
- [1: Preparing HDFS Directories](#preparing-hdfs-directories)
- [2: Setting up the Mirroring Job](#setting-up-mirroring-job)
- [3: Running the Job](#running-job)
- [4: Summary](#summary)

## 1. Preparing HDFS Directories <a id="preparing-hdfs-directories"></a>

After creating cluster entities, let’s go back to the SSH terminal, switch the user to `root` and then to `ambari-qa`:  

~~~bash
su - root
su - ambari-qa
~~~

Now create the directory `/user/ambari-qa/falcon` on HDFS, and then create the directories `mirrorSrc` and `mirrorTgt` as the source and target of the mirroring job we are about to create.

~~~bash
hadoop fs -mkdir /user/ambari-qa/falcon
hadoop fs -mkdir /user/ambari-qa/falcon/mirrorSrc
hadoop fs -mkdir /user/ambari-qa/falcon/mirrorTgt
~~~

![creatingMirrorDirectories](/assets/mirroring-datasets-using-falcon/creatingMirrorDirectories.png)

Now we need to set permissions to allow access. You must be logged in as the owner of the directory `/user/ambari-qa/falcon/`

~~~bash
hadoop fs -chmod -R 777 /user/ambari-qa/falcon
~~~

![givingPermission](/assets/mirroring-datasets-using-falcon/givingPermission.png)

## 2. Setting up the Mirroring Job <a id="setting-up-mirroring-job"></a>

To create the mirroring job, go back to the Falcon UI on your browser and click on the `Mirror` button on the top.

![mirrorHomePage](/assets/mirroring-datasets-using-falcon/mirrorHomePage.png)

Provide a name of your choice. The name must be unique to the system. We named the Mirror Job `MirrorTest`.

Ensure the File System mirror type is selected, then select the appropriate Source and Target and type in the appropriate paths. In our case the source cluster is `primaryCluster` and that HDFS path on the cluster is `/user/ambari-qa/falcon/mirrorSrc`.

The target cluster is `backupCluster` and that HDFS path on the cluster is `/user/ambari-qa/falcon/mirrorTgt`.
Also set the validity of the job to your current time, so that when you attempt to run the job in a few minutes, the job is still within the validity period. Click `Next`.

![mirror1](/assets/mirroring-datasets-using-falcon/mirror1.png)

Verify the summary information, then click `Save`

![mirror2](/assets/mirroring-datasets-using-falcon/mirror2.png)

![mirror3](/assets/mirroring-datasets-using-falcon/mirror3.png)

## 3. Running the Job <a id="running-job"></a>

Before we can run the job we need some data to test on HDFS. Let’s give us permission to upload some data using the HDFS View in Ambari.

~~~bash
hadoop fs -chmod -R 775 /user/ambari-qa
~~~

![givingPermissionToAmbariQa](/assets/mirroring-datasets-using-falcon/givingPermissionToAmbariQa.png)

Open Ambari from your browser at port 8080.
Then launch the HDFS view from the top right hand corner.
From the view on the Ambari console navigate to the directory:

~~~
/user/ambari-qa/falcon/mirrorSrc
~~~

![mirrorSrcDirectory](/assets/mirroring-datasets-using-falcon/mirrorSrcDirectory.png)

Click `Upload` button and upload any file you want to use.

![uploadingFile](/assets/mirroring-datasets-using-falcon/uploadingFile.png)

Once uploaded the file should appear in the directory.

![uploadedFile](/assets/mirroring-datasets-using-falcon/uploadedFile.png)

Now navigate to the Falcon UI and search for the job we created. The name of the Mirror job we had created was `MirrorTest`.

![searchMirror](/assets/mirroring-datasets-using-falcon/searchMirror.png)

Select the `MirrorTest` job by clicking the checkbox and then click on `Schedule`.

![scheduleMirror](/assets/mirroring-datasets-using-falcon/scheduleMirror.png)

The state of the job should change from `SUBMITTED` to `RUNNING`.

![runningMirror](/assets/mirroring-datasets-using-falcon/runningMirror.png)

After a few minutes, use the HDFS View in the Ambari console to check the `/user/ambari-qa/falcon/mirrorTgt` directory and you should see that  your data is mirrored.

![targetDirectory](/assets/mirroring-datasets-using-falcon/targetDirectory.png)

## 4. Summary <a id="summary"></a>

In this tutorial we walked through the process of mirroring the datasets between two cluster entities. In the next tutorial we will work through defining various data feeds and processing them to refine the data.
