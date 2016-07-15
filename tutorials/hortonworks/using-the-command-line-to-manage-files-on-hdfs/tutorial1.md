---
layout: tutorial
title: Using the Command Line to Manage Files on HDFS
tutorial-id: 120
tutorial-series: Operations
tutorial-version: hdp-2.5.0
intro-page: true
components: [ hdfs ]
---

# Manage Files on HDFS with the Command Line

### Introduction

In this tutorial, we will walk through many of the common of the basic Hadoop Distributed File System (HDFS) commands you will need to manage files on HDFS. The particular datasets we will utilize to learn HDFS file management are San Francisco salaries from 2011-2014.

## Pre-Requisites
*  Downloaded and Installed latest [Hortonworks Sandbox](http://hortonworks.com/products/hortonworks-sandbox/#install)
*  If you're planning to deploy your sandbox on Azure, refer to this tutorial: [Deploying the Sandbox on Azure](http://hortonworks.com/hadoop-tutorial/deploying-hortonworks-sandbox-on-microsoft-azure/)
*  [Learning the Ropes of the Hortonworks Sandbox](http://hortonworks.com/hadoop-tutorial/learning-the-ropes-of-the-hortonworks-sandbox/)
*  Allow yourself around **1 hour** to complete this tutorial.

### Download Vehicle Related Datasets

We will download sf-salaries-2011-2013.csv and sf-salaries-2014.csv data onto our local filesystems of the sandbox. The commands are tailored for mac and linux users.

1\. SSH into the sandbox:

~~~
ssh root@127.0.0.1 -p 2222
~~~

2\. Copy and paste the commands to download the sf-salaries-2011-2013.csv and sf-salaries-2014.csv files. We will use them while we learn file management operations.

~~~
# download sf-salaries-2011-2013
wget https://raw.githubusercontent.com/hortonworks/tutorials/hdp-2.5/assets/using-the-command-line-to-manage-hdfs/sf-salary-datasets/sf-salaries-2011-2013.csv
# download sf-salaries-2014
wget https://raw.githubusercontent.com/hortonworks/tutorials/hdp-2.5/assets/using-the-command-line-to-manage-hdfs/sf-salary-datasets/sf-salaries-2014.csv
~~~

![list_geolocation_contents](/assets/using-the-command-line-to-manage-hdfs/list_geolocation_contents.png)



## Outline
- [Step 1: Create a directory in HDFS, Upload a file and List Contents](#create-a-directory-in-hdfs-upload-a-file-and-list-contents)
- [Step 2: Find Out Space Utilization in a HDFS Directory](#find-out-space-utilization-in-a-hdfs-directory)
- [Step 3: Download Files From HDFS to Local File System](#download-files-hdfs-to-local-file-system)
- [Step 4: Explore Two Advanced Features](#explore-two-advanced-features)
- [Step 5: Use Help Command to access Hadoop Command Manual](#use-help-command-access-hadoop-command-manual)
- [Summary](#summary)
- [Further Reading](#further-reading)

### Step 1: Create a directory in HDFS, Upload a file and List Contents <a id="create-a-directory-in-hdfs-upload-a-file-and-list-contents"></a>

Let's learn by writing the syntax. You will be able to copy and paste the following example commands into your terminal:

#### hadoop fs -mkdir:

*   Takes the path uri's as an argument and creates a directory or multiple directories.

~~~
# Usage:
        # hadoop fs -mkdir <paths>
# Example:
        hadoop fs -mkdir /user/hadoop
        hadoop fs -mkdir /user/hadoop/sf-salaries-2011-2013 /user/hadoop/sf-salaries /user/hadoop/sf-salaries-2014
~~~

![create_3_dir](/assets/using-the-command-line-to-manage-hdfs/step1_createDir_hdfs_commandLineManageFiles_hdfs.png)


#### hadoop fs -put:

*   Copies single src file or multiple src files from local file system to the Hadoop Distributed File System.

~~~
# Usage:
        # hadoop fs -put <local-src> ... <HDFS_dest_path>
# Example:
        hadoop fs -put drivers.csv /user/hadoop/sf-salaries-2011-2013/sf-salaries-2011-2013.csv
        hadoop fs -put Geolocation/trucks.csv /user/hadoop/sf-salaries-2014/sf-salaries-2014.csv
~~~

![upload_file_local_file_system](/assets/using-the-command-line-to-manage-hdfs/step1_createDir_hdfs_commandLineManageFiles_hdfs.png)


#### hadoop fs -ls:

*   Lists the contents of a directory
*   For a file, returns stats of a file

~~~
# Usage:  
        # hadoop  fs  -ls  <args>  
# Example:
        hadoop fs -ls /user/hadoop
        hadoop fs -ls /user/hadoop/sf-salaries-2011-2013
        hadoop fs -ls /user/hadoop/sf-salaries-2011-2013/sf-salaries-2011-2013.csv
~~~

![list_contents_directory](/assets/using-the-command-line-to-manage-hdfs/step1_listContentDir_commandLineManageFiles_hdfs.png)


### Step 2: Find Out Space Utilization in a HDFS Directory <a id="find-out-space-utilization-in-a-hdfs-directory"></a>

#### hadoop fs -du:

*   Displays size of files and directories contained in the given directory or the size of a file if its just a file.

~~~
# Usage:  
        # hadoop fs -du URI
# Example:
        hadoop fs -du  /user/hadoop/ /user/hadoop/sf-salaries-2011-2013/sf-salaries-2011-2013.csv
~~~

![display_sizes_dir_files](/assets/using-the-command-line-to-manage-hdfs/step2_displayFileSize_commandLineManageFiles_hdfs.png)


### Step 3: Download File From HDFS to Local File System <a id="download-files-hdfs-to-local-file-system"></a>

#### hadoop fs -get:

*   Copies/Downloads files from HDFS to the local file system

~~~
# Usage:
        # hadoop fs -get <hdfs_src> <localdst>
# Example:
        hadoop fs -get /user/hadoop/sf-salaries-2011-2013/sf-salaries-2011-2013.csv /home/
~~~

![enter image description here](/assets/using-the-command-line-to-manage-hdfs/step3_download_hdfs_file_to_localsystem_commandLineManageFiles_hdfs.png)


### Step 4: Explore Two Advanced Features <a id="explore-two-advanced-features"></a>

#### hadoop fs -getmerge

*   Takes a source directory file or files as input and concatenates files in src into the local destination file.

~~~
# Usage:
        # hadoop fs -getmerge <src> <localdst> [addnl]
# Option:
        # addnl: can be set to enable adding a newline on end of each file
# Example:
        hadoop fs -getmerge /user/hadoop/sf-salaries-2011-2013/  /user/hadoop/sf-salaries-2014/sf-salaries-2014.csv
~~~

![copy_dir1_to_dir3](/assets/using-the-command-line-to-manage-hdfs/step4_getmerge_to_localDestn_commandLineManageFiles_hdfs.png)

> Copies all files from dir1 and stores them into popularNamesV2.txt


#### hadoop distcp:

*   Copy file or directories recursively, all the directory's files and subdirectories to the bottom of the directory tree are copied.
*   It is a tool used for large inter/intra-cluster copying
*   It uses MapReduce to effect its distribution copy, error handling and recovery, and reporting

~~~
# Usage:
        # hadoop distcp <src-url> <dest-url>
# Example:
        hadoop distcp /user/hadoop/sf-salaries-2011-2013/ /user/hadoop/sf-salaries
~~~

![copy_file_recursively_distcp](/assets/using-the-command-line-to-manage-hdfs/step4_copy_file_recursively_commandLineManageFiles_hdfs.png)

> distcp: copies drivers and all its contents to trucks


![copy_dir1_to_dir3](/assets/using-the-command-line-to-manage-hdfs/step4_visual_copy_recursively_distcp_commandLineManageFiles_hdfs.png)

> Visual result of distcp operation's aftermath, drivers gets copied to trucks


### Step 5: Use Help Command to access Hadoop Command Manual <a id="use-help-command-access-hadoop-command-manual"></a>

Help command opens the list of commands supported by Hadoop Data File System (HDFS)

~~~
# Example:  
        hadoop  fs  -help
~~~


![hadoop_help_command_manual](/assets/using-the-command-line-to-manage-hdfs/step5_help_commandLineManageFiles_hdfs.png)

Hope this short tutorial was useful to get the basics of file management.

##Summary <a id="summary">
Congratulations! We just learned to use commands to manage our drivers.csv and trucks.csv dataset files in HDFS. We learned to create, upload and list the the contents in our directories. We also acquired the skills to download files from HDFS to our local file system and explored a few advanced features of HDFS file management using the command line.

## Further Reading <a id="further-reading"></a>
- [HDFS Overview](http://hortonworks.com/hadoop/hdfs/)
- [Hadoop File System Documentation](https://hadoop.apache.org/docs/current/hadoop-project-dist/hadoop-common/FileSystemShell.html)
