---
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
*  [Learning the Ropes of the Hortonworks Sandbox](http://hortonworks.com/hadoop-tutorial/learning-the-ropes-of-the-hortonworks-sandbox/)
*  Create popularNames.txt file and save it on your local file system

1.) Open your vi editor with the following command:

~~~
vi popularNames.txt
~~~

> **Note:** You can create any text file with data you want or you can follow the example. You could also download text file.

2.) In vi, press `i` to insert text. Copy and paste the following data into the text file:

~~~
Rank    Male            Female
1	Noah	        Emma
2	Liam	        Olivia
3	Mason	        Sophia
4	Jacob	        Isabella
5	William	        Ava
6	Ethan	        Mia
7	Michael	        Emily
8	Alexander	Abigail
9	James	        Madison
10	Daniel	        Charlotte
~~~

3.) Press `esc` button and `:wq` to save and quit the vi.

![local_file_system_path_popularNames_txt](/assets/using-the-command-line-to-manage-hdfs/local_file_system_path_popularNames_txt.png)

> popularNames.txt in the example above is located in `~` directory.

## Outline
- [Step 1: Create a directory in HDFS, Upload a file and List Contents](#create-a-directory-in-hdfs-upload-a-file-and-list-contents)
- [Step 2: Find Out Space Utilization in a HDFS Directory](#find-out-space-utilization-in-a-hdfs-directory)
- [Step 3: Download Files From HDFS to Local File System](#download-files-hdfs-to-local-file-system)
- [Step 4: Explore Two Advanced Features](#explore-two-advanced-features)
- [Step 5: Use Help Command to access Hadoop Command Manual](#use-help-command-access-hadoop-command-manual)
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
        hadoop fs -mkdir /user/hadoop/dir1 /user/hadoop/dir2 /user/hadoop/dir3
~~~

![create_3_dir](/assets/using-the-command-line-to-manage-hdfs/step1_createDir_hdfs_commandLineManageFiles_hdfs.png)


#### hadoop fs -put:

*   Copies single src file or multiple src files from local file system to the Hadoop Distributed File System.
  
~~~
# Usage: 
        # hadoop fs -put <local-src> ... <HDFS_dest_path>
# Example:
        hadoop fs -put popularNames.txt /user/hadoop/dir1/popularNames.txt
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
        hadoop fs -ls /user/hadoop/dir1
        hadoop fs -ls /user/hadoop/dir1/popularNames.txt
~~~

![list_contents_directory](/assets/using-the-command-line-to-manage-hdfs/step1_listContentDir_commandLineManageFiles_hdfs.png)


### Step 2: Find Out Space Utilization in a HDFS Directory <a id="find-out-space-utilization-in-a-hdfs-directory"></a>

#### hadoop fs -du:

*   Displays size of files and directories contained in the given directory or the size of a file if its just a file.

~~~
# Usage:  
        # hadoop fs -du URI
# Example:
        hadoop fs -du  /user/hadoop/ /user/hadoop/dir1/popularNames.txt
~~~

![display_sizes_dir_files](/assets/using-the-command-line-to-manage-hdfs/step2_displayFileSize_commandLineManageFiles_hdfs.png)


### Step 3: Download File From HDFS to Local File System <a id="download-files-hdfs-to-local-file-system"></a>

#### hadoop fs -get:

*   Copies/Downloads files from HDFS to the local file system

~~~
# Usage: 
        # hadoop fs -get <hdfs_src> <localdst> 
# Example:
        hadoop fs -get /user/hadoop/dir1/popularNames.txt /home/
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
        hadoop fs -getmerge /user/hadoop/dir1/  ./popularNamesV2.txt
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

## Further Reading <a id="further-reading"></a>
- [HDFS Overview](http://hortonworks.com/hadoop/hdfs/)
- [Hadoop File System Documentation](https://hadoop.apache.org/docs/current/hadoop-project-dist/hadoop-common/FileSystemShell.html)
