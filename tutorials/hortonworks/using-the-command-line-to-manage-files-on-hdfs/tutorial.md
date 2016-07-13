---
layout: tutorial
title: Using the Command Line to Manage Files on HDFS
tutorial-id: 120
tutorial-series: Operations
tutorial-version: hdp-2.4.0
intro-page: true
components: [ hdfs ]
---

# Using the Command Line to Manage Files on HDFS

### Introduction

In this tutorial, we will walk through some of the basic Hadoop Distributed File System (HDFS) commands you will need to manage files on HDFS.

## Pre-Requisites
*  Downloaded and Installed latest [Hortonworks Sandbox](http://hortonworks.com/products/hortonworks-sandbox/#install)
*  If you're planning to deploy your sandbox on Azure, refer to this tutorial: [Deploying the Sandbox on Azure](http://hortonworks.com/hadoop-tutorial/deploying-hortonworks-sandbox-on-microsoft-azure/)
*  [Learning the Ropes of the Hortonworks Sandbox](http://hortonworks.com/hadoop-tutorial/learning-the-ropes-of-the-hortonworks-sandbox/)
*  Allow yourself around **1 hour** to complete this tutorial.

Downloaded drivers.csv from iot-truck-streaming repo and save it on your local filesystem of the sandbox.

1\. SSH into the sandbox:

~~~
ssh root@127.0.0.1 -p 2222
~~~

2\. Download the drivers.csv since we will use it as an example while we learn to manage files.

~~~
wget https://raw.githubusercontent.com/james94/iot-truck-streaming/master/drivers.csv
~~~

3\. Download the geolocation.zip file. Unzip the file.

~~~
wget https://app.box.com/HadoopCrashCourseData
unzip
~~~

4\. We will use trucks.csv from the folder.

~~~


3\. Open vim to verify drivers.csv downloaded successfully.

4\. Press `esc` button and `:wq` to save and quit vim.

![local_file_system_path_popularNames_txt](/assets/using-the-command-line-to-manage-hdfs/local_file_system_path_popularNames_txt.png)



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
        hadoop fs -mkdir /user/hadoop/drivers /user/hadoop/dir2 /user/hadoop/geolocation
~~~

![create_3_dir](/assets/using-the-command-line-to-manage-hdfs/step1_createDir_hdfs_commandLineManageFiles_hdfs.png)


#### hadoop fs -put:

*   Copies single src file or multiple src files from local file system to the Hadoop Distributed File System.

~~~
# Usage:
        # hadoop fs -put <local-src> ... <HDFS_dest_path>
# Example:
        hadoop fs -put drivers.csv /user/hadoop/drivers/drivers.csv
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
        hadoop fs -ls /user/hadoop/drivers
        hadoop fs -ls /user/hadoop/drivers/drivers.csv
~~~

![list_contents_directory](/assets/using-the-command-line-to-manage-hdfs/step1_listContentDir_commandLineManageFiles_hdfs.png)


### Step 2: Find Out Space Utilization in a HDFS Directory <a id="find-out-space-utilization-in-a-hdfs-directory"></a>

#### hadoop fs -du:

*   Displays size of files and directories contained in the given directory or the size of a file if its just a file.

~~~
# Usage:  
        # hadoop fs -du URI
# Example:
        hadoop fs -du  /user/hadoop/ /user/hadoop/drivers/drivers.csv
~~~

![display_sizes_dir_files](/assets/using-the-command-line-to-manage-hdfs/step2_displayFileSize_commandLineManageFiles_hdfs.png)


### Step 3: Download File From HDFS to Local File System <a id="download-files-hdfs-to-local-file-system"></a>

#### hadoop fs -get:

*   Copies/Downloads files from HDFS to the local file system

~~~
# Usage:
        # hadoop fs -get <hdfs_src> <localdst>
# Example:
        hadoop fs -get /user/hadoop/drivers/drivers.csv /home/
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
        hadoop fs -getmerge /user/hadoop/drivers/  ./popularNamesV2.txt
~~~

![copy_dir1_to_dir3](/assets/using-the-command-line-to-manage-hdfs/step4_getmerge_to_localDestn_commandLineManageFiles_hdfs.png)

> Copies all files from dir1 and stores them into popularNamesV2.txt


#### hadoop distcp:

*   Copy file or directories recursively
*   It is a tool used for large inter/intra-cluster copying
*   It uses MapReduce to effect its distribution copy, error handling and recovery, and reporting

~~~
# Usage:
        # hadoop distcp <src-url> <dest-url>
# Example:
        hadoop distcp /user/hadoop/dir1/ /user/hadoop/dir3/
~~~

![copy_file_recursively_distcp](/assets/using-the-command-line-to-manage-hdfs/step4_copy_file_recursively_commandLineManageFiles_hdfs.png)

> distcp: copies dir1 and all its contents to dir3


![copy_dir1_to_dir3](/assets/using-the-command-line-to-manage-hdfs/step4_visual_copy_recursively_distcp_commandLineManageFiles_hdfs.png)

> Visual result of distcp operation's aftermath, dir1 gets copied to dir3


### Step 5: Use Help Command to access Hadoop Command Manual <a id="use-help-command-access-hadoop-command-manual"></a>

Help command opens the list of commands supported by Hadoop Data File System (HDFS)

~~~
# Example:  
        hadoop  fs  -help
~~~


![hadoop_help_command_manual](/assets/using-the-command-line-to-manage-hdfs/step5_help_commandLineManageFiles_hdfs.png)

Hope this short tutorial was useful to get the basics of file management.

##Summary <a id="summary">
Congratulations! We just learned to use commands to manage our files in HDFS. We know how to create, upload and list the the contents in our directories. We also acquired the skills to download files from HDFS to our local file system and explored a few advanced features of the command line.

## Further Reading <a id="further-reading"></a>
- [HDFS Overview](http://hortonworks.com/hadoop/hdfs/)
- [Hadoop File System Documentation](https://hadoop.apache.org/docs/current/hadoop-project-dist/hadoop-common/FileSystemShell.html)
