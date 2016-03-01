# Using the Command Line to Manage Files on HDFS

### Introduction

In this tutorial, we will walk through some of the basic Hadoop Distributed File System (HDFS) commands you will need to manage files on HDFS.

## Pre-Requisites
*  Downloaded and Installed latest [Hortonworks Sandbox](http://hortonworks.com/products/hortonworks-sandbox/#install)
*  [Learning the Ropes of the Hortonworks Sandbox](http://hortonworks.com/hadoop-tutorial/learning-the-ropes-of-the-hortonworks-sandbox/)
*  Create popularNames.txt file and save it on your local file system

1. Open your vi editor with the following command:

~~~
vi popularNames.txt
~~~

2. In vi, press `i` to insert text. Copy and paste the following data into the text file:

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

3. Press `esc` button and `:wq` to save and quit the vi.

![local_file_system_path_popularNames_txt](/assets/using-the-command-line-to-manage-hdfs/)

> popularNames.txt in the example above is located in `~` directory.

## Outline
- [Step 1: Create a directory in HDFS, Upload a file and List Contents](#create-a-directory-in-hdfs-upload-a-file-and-list-contents)
- 

Let’s get started.

### Step 1: Create a directory in HDFS, Upload a file and List Contents <a id="create-a-directory-in-hdfs-upload-a-file-and-list-contents"></a>

Learn the syntax:

#### hadoop fs -mkdir:

*   Takes the path uri's as an argument and creates a directory or multiple directories.

~~~
Usage: 
        hadoop fs -mkdir <paths> 
Example:
        hadoop fs -mkdir /user/hadoop
        hadoop fs -mkdir /user/hadoop/dir1 /user/hadoop/dir2 /user/hadoop/dir3
~~~

#### hadoop fs -put:

*   Copies single src file or multiple src files from local file system to the Hadoop Distributed File System.
  
~~~
Usage: 
        hadoop fs -put <local-src> ... <HDFS_dest_path>
Example:
        hadoop fs -put popularNames.txt /user/hadoop/dir1/popularNames.txt
~~~

#### hadoop fs -ls:

*   Lists the contents of a directory
*   For a file returns stats of a file



        Usage:  
            hadoop  fs  -ls  <args>  
        Example:
            hadoop  fs  -ls  /user/hadoop/dir1  /user/hadoop/dir2  
            hadoop  fs  -ls  /user/hadoop/dir1/filename.txt
            hadoop  fs  -ls  hdfs://<hostname>:9000/user/hadoop/dir1/




Let’s use the following commands as follows and execute. You can ssh to the sandbox using Tools like Putty. You could download putty.exe from the internet.

![enter image description here](/assetsusing-the-command-line-to-manage-hdfs/HDFS_HW_step_1-1.jpg)

Let’s touch a file locally.

    $ touch filename.txt

![enter image description here](/assetsusing-the-command-line-to-manage-hdfs/HDFS_HW_step_1-2.jpg)

#### [](#step-2-now-lets-check-how-to-find-out-space-utilization-in-a-hdfs-dir)Step 2: Now, let’s check how to find out space utilization in a HDFS dir.

##### [](#hadoop-fs--du)hadoop fs -du:

*   Displays sizes of files and directories contained in the given directory or the size of a file if its just a file.

        Usage:  
                hadoop fs -du URI
        Example:
                hadoop fs -du  /user/hadoop/ /user/hadoop/dir1/Sample.txt

![enter image description here](/assetsusing-the-command-line-to-manage-hdfs/HDFS_HW_DU_step2.1.jpg)

#### [](#step-4)Step 4:

Now let’s see how to upload and download files from and to Hadoop Data File System(HDFS)  
Upload: ( we have already tried this earlier)

##### [](#hadoop-fs--put)hadoop fs -put:

*   Copy single src file, or multiple src files from local file system to the Hadoop data file system

        Usage: 
                hadoop fs -put <localsrc> ... <HDFS_dest_Path>
        Example:
                hadoop fs -put /home/ec2-user/Samplefile.txt ./ambari.repo /user/hadoop/dir3/

Download:  
hadoop fs -get:

*   Copies/Downloads files to the local file system

        Usage: 
                hadoop fs -get <hdfs_src> <localdst> 
        Example:
                hadoop fs -get /user/hadoop/dir3/Samplefile.txt /home/

![enter image description here](/assetsusing-the-command-line-to-manage-hdfs/HDFS_HW_get_step2.1.jpg)

#### [](#step-5-lets-look-at-quickly-two-advanced-features)Step 5: Let’s look at quickly two advanced features.

##### [](#hadoop-fs--getmerge)hadoop fs -getmerge

*   Takes a source directory files as input and concatenates files in src into the destination local file.

        Usage: 
                hadoop fs -getmerge <src> <localdst> [addnl]
        Example:
                hadoop fs -getmerge /user/hadoop/dir1/  ./Samplefile2.txt
        Option:
                addnl: can be set to enable adding a newline on end of each file

##### [](#hadoop-distcp)hadoop distcp:

*   Copy file or directories recursively
*   It is a tool used for large inter/intra-cluster copying
*   It uses MapReduce to effect its distribution copy, error handling and recovery, and reporting

        Usage: 
                hadoop distcp <srcurl> <desturl>
        Example:
                hadoop distcp hdfs://<NameNode1>:8020/user/hadoop/dir1/ \ 
                        hdfs://<NameNode2>:8020/user/hadoop/dir2/

You could use the following steps to perform getmerge and discp.  
Let’s upload two files for this exercise first:



#  touch  txt1  txt2  #  hadoop  fs  -put  txt1  txt2  /user/hadoop/dir2/  #  hadoop  fs  -ls  /user/hadoop/dir2/




![enter image description here](/assetsusing-the-command-line-to-manage-hdfs/HDFS_HW_getmerge_distcp_step2.1.png)


#### [](#step-6getting-help)Step 6:Getting help

You can use Help command to get list of commands supported by Hadoop Data File System(HDFS)



  Example:  hadoop  fs  -help




![enter image description here](/assetsusing-the-command-line-to-manage-hdfs/HDFS_HW_step3.png)

Hope this short tutorial was useful to get the basics of file management.
