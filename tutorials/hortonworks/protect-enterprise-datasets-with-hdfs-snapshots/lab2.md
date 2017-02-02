## Lab 2 - Backup Web Server Logs via Snapshot Disaster Recovery

### Introduction

Now that we solved the problem from the first scenario, we need to account for new data loaded into the web logs dataset, there could be an erroneous deletion of a file or directory. For example, an application could delete the set of logs pertaining to Sept 2nd, 2013 stored in the /data/weblogs/20130902 directory.

Since /data/weblogs has a snapshot, the snapshot will protect from the file blocks being removed from the file system. A deletion will only modify the metadata to remove /data/weblogs/20130902 from the working directory. You’ve been tasked to set up HDFS snapshots’ disaster recovery feature.

### Prerequisites

### Outline
- Step 1. Recover Lost Data
- Step 2. Verify Recovery from Deletion was Successful
- Step 3. Verify HDFS protects Snapshot Data from User or Application - Deletion
- Summary
- Further Reading

### Step 1. Recover Lost Data

To recover from this deletion, we can data is restoreed data by copying the needed data from the snapshot path:
hdfs dfs -cp /data/weblogs/.snapshot/s20130903-000941.091/20130902/data/weblogs/

### Step 2. Verify Recovery from Deletion was Successful

This will restore the lost set of files to the working data set:
hdfs dfs -ls /data/weblogs

Found 3 items
drwxr-xr-x   - web hadoop  	     0 2013-09-01 23:59 /data/weblogs/20130901
drwxr-xr-x   - web hadoop  	     0 2013-09-04 12:10 /data/weblogs/20130902
drwxr-xr-x   - web hadoop  	     0 2013-09-03 23:57 /data/weblogs/20130903

### Step 3. Verify HDFS protects Snapshot Data from User or Application Deletion
Since snapshots are read-only, HDFS will also protect against user or application deletion of the snapshot data itself. The following operation will fail:
hdfs dfs -rmdir /data/weblogs/.snapshot/s20130903-000941.091/20130902

### Summary

Congratulations, you learned how to use HDFS Snapshots to backup your web server logs data. Now you can recover lost data by using hdfs dfs -cp to make a replica from the data saved in the snapshot path. You now know how to use hdfs dfs -cp to double check the lost data is now present in HDFS. You have seen that HDFS snapshots protects data from being deleted by a user or application since snapshot data is read-only. Experiment further with HDFS snapshots to protect your data.

### Further Reading
User Guide - HDFS Snapshots
