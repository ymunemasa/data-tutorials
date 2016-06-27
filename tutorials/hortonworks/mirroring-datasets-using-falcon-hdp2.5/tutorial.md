---
layout: tutorial
title: Mirroring Datasets Between Hadoop Clusters with Apache Falcon
tutorial-id: 680
tutorial-series: Governance
tutorial-version: hdp-2.5.0
intro-page: true
components: [ falcon, ambari ]
---

## Introduction

Apache Falcon is a framework to simplify data pipeline processing and management on Hadoop clusters.

It provides data management services such as retention, replications across clusters, archival etc. It makes it much simpler to onboard new workflows/pipelines, with support for late data handling and retry policies. It allows you to easily define relationship between various data and processing elements and integrate with metastore/catalog such as Hive/HCatalog. Finally it also lets you capture lineage information for feeds and processes.

In this tutorial we are going walk the process of mirroring the datasets between Hadoop clusters.

## Prerequisites

- [Download Hortonworks Sandbox 2.5 Technical Preview](http://hortonworks.com/tech-preview-hdp-2-5/)
- Complete the [Learning the Ropes of the Hortonworks Sandbox tutorial,](http://hortonworks.com/hadoop-tutorial/learning-the-ropes-of-the-hortonworks-sandbox/) you will need it for logging into Ambari as an administrator user.
- Complete the [Leveraging Apache Falcon with Your Hadoop Clusters](https://github.com/hortonworks/tutorials/blob/hdp-2.5/tutorials/hortonworks/create-falcon-cluster-hdp2.5/tutorial.md) tutorial to start the falcon service, prepare HDFS directories for Falcon cluster and to create Falcon cluster entities.

## Outline
- [1: Preparing HDFS Directories](#preparing-hdfs-directories)
- [2: Setting up the Mirroring Job](#setting-up-mirroring-job)
- [3: Running the Job](#running-job)
- [4: Summary](#summary)

## 1. Preparing HDFS Directories <a id="preparing-hdfs-directories"></a>

After creating cluster entities, let’s go back to the SSH terminal, switch the user to `root` and then to `ambari-qa`:  

~~~
hadoop fs -mkdir /user/ambari-qa/falcon
hadoop fs -mkdir /user/ambari-qa/falcon/mirrorSrc
hadoop fs -mkdir /user/ambari-qa/falcon/mirrorTgt
~~~

![creatingMirrorDirectories](/assets/mirroring-datasets-using-falcon-hdp2.5/creatingMirrorDirectories.png)

Now we need to set permissions to allow access. You must be logged in as the owner of the directory `/user/ambari-qa/falcon/`

~~~bash
hadoop fs -chmod -R 777 /user/ambari-qa/falcon
~~~

![givingPermission](/assets/mirroring-datasets-using-falcon-hdp2.5/givingPermission.png)

## 2. Setting up the Mirroring Job <a id="setting-up-mirroring-job"></a>

To create the mirroring job, go back to the Falcon UI on your browser and click on the `Create` drop down.

![select_mirror](/assets/mirroring-datasets-using-falcon-hdp2.5/select_mirror.png)

Click `Mirror` from the drop down menu, you will see a page like this:

![mirror_home_page](/assets/mirroring-datasets-using-falcon-hdp2.5/mirror_home_page.png)

Provide a name of your choice. The name must be unique to the system. We named the Mirror Job `MirrorTest`.

Ensure the File System mirror type is selected, then select the appropriate Source and Target and type in the appropriate paths. In our case the source cluster is `primaryCluster` and that HDFS path on the cluster is `/user/ambari-qa/falcon/mirrorSrc`.

The target cluster is `backupCluster` and that HDFS path on the cluster is `/user/ambari-qa/falcon/mirrorTgt`.
Also set the validity of the job to your current time, so that when you attempt to run the job in a few minutes, the job is still within the validity period. Keep default values in Advanced Options and then Click `Next`.

![mirror1](/assets/mirroring-datasets-using-falcon-hdp2.5/mirror1.png)

![mirror2](/assets/mirroring-datasets-using-falcon-hdp2.5/mirror2.png)

Verify the summary information, then click `Save`:

![mirror_summary1](/assets/mirroring-datasets-using-falcon-hdp2.5/mirror_summary1.png)

![mirror_summary2](/assets/mirroring-datasets-using-falcon-hdp2.5/mirror_summary2.png)

## 3. Running the Job <a id="running-job"></a>

Before we can run the job we need some data to test on HDFS. Let’s give us permission to upload some data using the HDFS View in Ambari.

~~~
su - root

su hdfs

hadoop fs -chmod -R 775 /user/ambari-qa
~~~

Open Ambari from your browser at port 8080.
Then launch the HDFS view from the top right hand corner.
From the view on the Ambari console navigate to the directory `/user/ambari-qa/falcon/mirrorSrc`.

![hdfs_directory_filesview](/assets/mirroring-datasets-using-falcon-hdp2.5/hdfs_directory_filesview.png)

Click `Upload` button and upload any file you want to use.

![local_file_path](/assets/mirroring-datasets-using-falcon-hdp2.5/local_file_path.png)

Once uploaded the file should appear in the directory.

![local_file_uploaded](/assets/mirroring-datasets-using-falcon-hdp2.5/local_file_uploaded.png)

Now navigate to the Falcon UI and search for the job we created. The name of the Mirror job we had created was `MirrorTest`.

![search_mirror_test](/assets/mirroring-datasets-using-falcon-hdp2.5/search_mirror_test.png)

Select the `MirrorTest` job by clicking the checkbox and then click on `Schedule`.

![schedule_mirror_test](/assets/mirroring-datasets-using-falcon-hdp2.5/schedule_mirror_test.png)

The state of the job should change from `SUBMITTED` to `RUNNING`.

![running_mirror_test](/assets/mirroring-datasets-using-falcon-hdp2.5/running_mirror_test.png)

After a few minutes, use the HDFS View in the Ambari console to check the `/user/ambari-qa/falcon/mirrorTgt` directory and you should see that  your data is mirrored.

![test_file_copied](/assets/mirroring-datasets-using-falcon-hdp2.5/test_file_copied.png)

## 4. Summary <a id="summary"></a>

In this tutorial we walked through the process of mirroring the datasets between two cluster entities.
