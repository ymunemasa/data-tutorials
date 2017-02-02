## Lab 1 - Protect Web Server Logs from Deletion using HDFS Snapshot

### Introduction

Web Server logs are being loaded into HDFS on a daily basis for processing and long term storage. The logs are loaded a few times a day, and the dataset is organized into directories that hold log files per day in HDFS. Since the Web Server logs are stored only in HDFS, it’s imperative that they are protected from deletion. You’ve been tasked to learn to use HDFS Snapshot to protect these Web Server Logs:
/data/weblogs
/data/weblogs/20130901
/data/weblogs/20130902
/data/weblogs/20130903

### Prerequisites
Read through Introduction

### Outline
- Step 1. Enable Snapshots
- Step 2. Take Point In Time Snapshots
- Step 3. View Snapshot Directory State
- Summary
- Further Reading

### Step 1. Enable Snapshots
In order to provide data protection and recovery for the Web Server log data, we must enable snapshots for the parent directory:
hdfs dfsadmin -allowSnapshot /data/weblogs
Snapshots must be explicitly enabled for directories. This dfsadmin configuration provides system administrators with the level of granular control they need to manage data in HDP.

### Step 2. Take Point In Time Snapshots

We must creates a snapshot, so we can take a point in time snapshot of the /data/weblogs/directory and its subtree:
hdfs dfs -createSnapshot /data/weblogs
This will create a snapshot, and give it a default name which matches the timestamp at which the snapshot was created. Users can provide an optional snapshot name instead of the default. With the default name, the created snapshot path will be: /data/weblogs/.snapshot/s20130903-000941.091. Users can schedule a CRON job to create snapshots at regular intervals. Example, when you run CRON job: 30 18 * * * rm /home/someuser/tmp/*, the comand tells your file system to run the content from the tmp folder at 18:30 every day. For instance, to integrate CRON jobs with HDFS snapshots, run the command: 30 18 * * * hdfs dfs -createSnapshot /data/weblogs/* to schedule Snapshots to be created each day at 6:30.

### Step 3. View Snapshot Directory State

To view the state of the directory at the recently created snapshot for verification that it is protected, write command:
hdfs dfs -ls /data/weblogs/.snapshot/s20130903-000941.091
Found 3 items
drwxr-xr-x   - web hadoop  	     0 2013-09-01 23:59/data/weblogs/.snapshot/s20130903-000941.091/20130901
drwxr-xr-x   - web hadoop  	     0 2013-09-02 00:55/data/weblogs/.snapshot/s20130903-000941.091/20130902
drwxr-xr-x   - web hadoop  	     0 2013-09-03 23:57/data/weblogs/.snapshot/s20130903-000941.091/20130903
Summary

Congratulations you just learned 3 important objectives when protecting web server logs from deletion. You now are able to enable snapshots, take point in time snapshots and view snapshot directory states. All these tasks come together to make it possible to protect data in HDFS.

Further Reading
Snapshot Operations: Administrator Operations (-allowSnapshot)
Snapshot Operations: User Operations (-createSnapshot)
Snapshot Overview: Snapshot Paths (-ls)
