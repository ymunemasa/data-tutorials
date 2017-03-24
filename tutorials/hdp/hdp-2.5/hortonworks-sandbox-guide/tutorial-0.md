---
title: Hortonworks Sandbox Guide
tutorial-id: 730
platform: hdp-2.5.0
tags: [sandbox]
---

# Hortonworks Sandbox Guide

## Release Notes

Sept 2016
Md5 **VMware** Virtual Appliance - f1d45e93ab9f2a655db559be5b2f2f43
Md5 **Virtualbox** Virtual Appliance- d42a9bd11f29775cc5b804ce82a72efd
Md5 **Docker** c613fab7ed21e15886ab23d7a28aec8a
HDP Stack and Ambari
The Sandbox uses the following versions of Ambari and HDP stack.  Please use the following release note links provided to view Ambari and HDP stack specific information.

[HDP 2.5 Product Release Notes](https://docs.hortonworks.com/HDPDocuments/HDP2/HDP-2.5.0/bk_release-notes/content/ch_relnotes_v250.html)

[Ambari 2.4 Release Notes](https://docs.hortonworks.com/HDPDocuments/Ambari-2.4.0.0/bk_ambari-release-notes/content/ch_relnotes-ambari-2.4.0.0.html)

## Behavior Changes

- New splash page
- JDK updated to 1.8
- Virtualbox no longer prompts for a new network adapter
- Yum installation module now fixed
- Fixed errors “No such directory or file ATLAS-ENTITIES/000000000000.log
- Port mapping missing for Namenode UI:50070, 8090, 8091,8082, 8086
- Add service error pop up within Ambari

- **RMP-6196** – Using dockerized containers inside the VM’s
- **RMP-6735** – Using Role based access control to log into Ambari, please look at learning ropes tutorial for more information.
- **RMP-7141** – New sample data in databases used for tutorials

## Known Issues

**BUG-65985** - Some files inside the docker container sandbox will show ????? for the file.

## Fixed Issues

**BUG-54706** - HDFS replication set to 3
**BUG-65555** – opened ports for docker
**BUG-64968** - Request to disable "yarn.resourcemanager.recovery.enabled"
**BUG-ATLAS-1147** - UI : column name doesn’t show up in schema tab for hive table

## Limitations

This is a list of common limitations along with their workarounds.

**RMP-3586** - Due to dependency of the underlying OS and Virtual machine application, the following may occur when suspending the virtual machine:
Region Server service for HBase may be stopped when returning back from suspended state.  It will need to be restarted.
Ambari Metrics may be stopped when returning back from suspended state since it now uses an embedded HBase.

**Workaround**: Avoid having to suspend your virtual machine.

## System Information

Operating System and Java versions that the Sandbox has installed.

**OS Version (docker container)**
CentOS release 6.8 (Final)

**Java Version (docker container)**
openjdk version "1.8.0_111"
OpenJDK Runtime Environment (build 1.8.0_111-b15)
OpenJDK 64-Bit Server VM (build 25.111-b15, mixed mode)

Updated from previous version

**OS Version (Hosting Virtual Machine)**
CentOS Linux release 7.2.1511 (Core)

**Image File Sizes**
VMware – 11.1 GB
Virtualbox – 11.7 GB
Docker - 10.2 GB

**Tech Preview Packages**
Ambari Views- hueambarimigration-2.4.0.0.1225.jar
Ambari Views - wfmanager-2.4.0.0.1225.jar
Ambari Views - zeppelin-view-2.4.0.0.1225.jar

**Databases Used**
These are a list of databases used within Sandbox along with the corresponding HDP components that use them.

1\. Ambari: postgres
2\.  Hive Metastore : Mysql
3\.  Ranger: Mysql
4\.  Oozie: derby (embedded)

**HDP Supported Components Not Installed**
These components are offered by the Hortonworks distribution, but not included in the Sandbox.

1\.  Apache Accumulo
2\.  Apache Mahout
3\.  Hue

**Newly Added HDP Supported Packages**

These are packages that have recently been included into the Sandbox for this release.

**Ambari Infra**

**HDP Supported Packages**

**Apache Ambari**
ambari-metrics-grafana-2.4.0.0-1225.x86_64
ambari-agent-2.4.0.0-1225.x86_64
ambari-infra-solr-client-2.4.0.0-1225.x86_64
ambari-infra-solr-2.4.0.0-1225.x86_64
ambari-metrics-collector-2.4.0.0-1225.x86_64
ambari-metrics-hadoop-sink-2.4.0.0-1225.x86_64
ambari-server-2.4.0.0-1225.x86_64
ambari-metrics-monitor-2.4.0.0-1225.x86_64

**Apache Ambari Views**
ambari-admin-2.4.0.0.1225.jar
capacity-scheduler-2.4.0.0.1225.jar
files-2.4.0.0.1225.jar
hive-2.4.0.0.1225.jar
hive-jdbc-2.4.0.0.1225.jar
hueambarimigration-2.4.0.0.1225.jar
pig-2.4.0.0.1225.jar
slider-2.4.0.0.1225.jar
storm-view-2.4.0.0.1225.jar
tez-view-2.4.0.0.1225.jar
wfmanager-2.4.0.0.1225.jar
zeppelin-view-2.4.0.0.1225.jar

**Apache Hadoop (HDFS, YARN, Mapreduce)**
hadoop_2_5_0_0_1245-mapreduce-2.7.3.2.5.0.0-1245.el6.x86_64
hadoop_2_5_0_0_1245-libhdfs-2.7.3.2.5.0.0-1245.el6.x86_64
hadoop-lzo-native-0.6.0-1.x86_64
hadoop_2_5_0_0_1245-yarn-2.7.3.2.5.0.0-1245.el6.x86_64
hadooplzo_2_5_0_0_1245-native-0.6.0.2.5.0.0-1245.el6.x86_64
ambari-metrics-hadoop-sink-2.4.0.0-1225.x86_64
hadoop_2_5_0_0_1245-2.7.3.2.5.0.0-1245.el6.x86_64
hadoop_2_5_0_0_1245-hdfs-2.7.3.2.5.0.0-1245.el6.x86_64
hadoop_2_5_0_0_1245-client-2.7.3.2.5.0.0-1245.el6.x86_64
hadooplzo_2_5_0_0_1245-0.6.0.2.5.0.0-1245.el6.x86_64

**Apache Falcon**
falcon_2_5_0_0_1245-0.10.0.2.5.0.0-1245.el6.noarch

**Apache Hive**
hive_2_5_0_0_1245-1.2.1000.2.5.0.0-1245.el6.noarch
hive2_2_5_0_0_1245-jdbc-2.1.0.2.5.0.0-1245.el6.noarch
atlas-metadata_2_5_0_0_1245-hive-plugin-0.7.0.2.5.0.0-1245.el6.noarch
hive_2_5_0_0_1245-jdbc-1.2.1000.2.5.0.0-1245.el6.noarch
hive_2_5_0_0_1245-hcatalog-1.2.1000.2.5.0.0-1245.el6.noarch
tez_hive2_2_5_0_0_1245-0.8.4.2.5.0.0-1245.el6.noarch
hive_2_5_0_0_1245-webhcat-1.2.1000.2.5.0.0-1245.el6.noarch
hive2_2_5_0_0_1245-2.1.0.2.5.0.0-1245.el6.noarch

**Apache Hbase**
hbase_2_5_0_0_1245-1.1.2.2.5.0.0-1245.el6.noarch

**Apache Flume**
flume_2_5_0_0_1245-1.5.2.2.5.0.0-1245.el6.noarch

**Apache Kafka**
kafka_2_5_0_0_1245-0.10.0.2.5.0.0-1245.el6.noarch

**Apache Knox**
knox_2_5_0_0_1245-0.9.0.2.5.0.0-1245.el6.noarch

**Apache Oozie**
oozie_2_5_0_0_1245-4.2.0.2.5.0.0-1245.el6.noarch
oozie_2_5_0_0_1245-client-4.2.0.2.5.0.0-1245.el6.noarch

**Apache Phoenix**
phoenix_2_5_0_0_1245-4.7.0.2.5.0.0-1245.el6.noarch

**Apache Pig**
pig_2_5_0_0_1245-0.16.0.2.5.0.0-1245.el6.noarch

**Apache Ranger**
ranger_2_5_0_0_1245-kafka-plugin-0.6.0.2.5.0.0-1245.el6.x86_64
ranger_2_5_0_0_1245-usersync-0.6.0.2.5.0.0-1245.el6.x86_64
ranger_2_5_0_0_1245-hdfs-plugin-0.6.0.2.5.0.0-1245.el6.x86_64
ranger_2_5_0_0_1245-atlas-plugin-0.6.0.2.5.0.0-1245.el6.x86_64
ranger_2_5_0_0_1245-hive-plugin-0.6.0.2.5.0.0-1245.el6.x86_64
ranger_2_5_0_0_1245-kms-0.6.0.2.5.0.0-1245.el6.x86_64
ranger_2_5_0_0_1245-admin-0.6.0.2.5.0.0-1245.el6.x86_64
ranger_2_5_0_0_1245-tagsync-0.6.0.2.5.0.0-1245.el6.x86_64
ranger_2_5_0_0_1245-solr-plugin-0.6.0.2.5.0.0-1245.el6.x86_64
ranger_2_5_0_0_1245-yarn-plugin-0.6.0.2.5.0.0-1245.el6.x86_64
ranger_2_5_0_0_1245-storm-plugin-0.6.0.2.5.0.0-1245.el6.x86_64
ranger_2_5_0_0_1245-hbase-plugin-0.6.0.2.5.0.0-1245.el6.x86_64
ranger_2_5_0_0_1245-knox-plugin-0.6.0.2.5.0.0-1245.el6.x86_64

**Apache Solr**  (Included in the Hadoop Search package)
ambari-infra-solr-client-2.4.0.0-1225.x86_64  (embedded used for Ambari)
ambari-infra-solr-2.4.0.0-1225.x86_64   (embedded used for Ambari)

**Apache Slider**
storm_2_5_0_0_1245-slider-client-1.0.1.2.5.0.0-1245.el6.x86_64                                                                     slider_2_5_0_0_1245-0.91.0.2.5.0.0-1245.el6.noarch

**Apache Spark**
spark_2_5_0_0_1245-1.6.2.2.5.0.0-1245.el6.noarch
spark_2_5_0_0_1245-yarn-shuffle-1.6.2.2.5.0.0-1245.el6.noarch
spark_2_5_0_0_1245-python-1.6.2.2.5.0.0-1245.el6.noarch
spark2_2_5_0_0_1245-2.0.0.2.5.0.0-1245.el6.noarch
spark2_2_5_0_0_1245-yarn-shuffle-2.0.0.2.5.0.0-1245.el6.noarch
spark2_2_5_0_0_1245-python-2.0.0.2.5.0.0-1245.el6.noarch

**Apache Sqoop**
sqoop_2_5_0_0_1245-1.4.6.2.5.0.0-1245.el6.noarch

**Apache Storm**
storm_2_5_0_0_1245-1.0.1.2.5.0.0-1245.el6.x86_64
storm_2_5_0_0_1245-slider-client-1.0.1.2.5.0.0-1245.el6.x86_64

**Apache Tez**
tez_hive2_2_5_0_0_1245-0.8.4.2.5.0.0-1245.el6.noarch
tez_2_5_0_0_1245-0.7.0.2.5.0.0-1245.el6.noarch

**Apache Zookeeper**
zookeeper_2_5_0_0_1245-server-3.4.6.2.5.0.0-1245.el6.noarch
zookeeper_2_5_0_0_1245-3.4.6.2.5.0.0-1245.el6.noarch

**Other Packages**
These are some of the installed packages in the Sandbox that the HDP components may depend on.

**Python**
python-lxml-2.2.3-1.1.el6.x86_64
rpm-python-4.8.0-55.el6.x86_64
python-pycurl-7.19.0-9.el6.x86_64
python-iniparse-0.3.1-2.1.el6.noarch
python-argparse-1.2.1-2.1.el6.noarch
python-2.6.6-66.el6_8.x86_64
dbus-python-0.83.0-6.1.el6.x86_64
python-dateutil-1.4.1-6.el6.noarch
python-nose-0.10.4-3.1.el6.noarch
python-beaker-1.3.1-7.el6.noarch
python-mako-0.3.4-1.el6.noarch
python-urlgrabber-3.9.1-11.el6.noarch
python-devel-2.6.6-66.el6_8.x86_64
python-libs-2.6.6-66.el6_8.x86_64
python-setuptools-0.6.10-3.el6.noarch
python-markupsafe-0.9.2-4.el6.x86_64
python-matplotlib-0.99.1.2-1.el6.x86_64

**mysql**
mysql-community-common-5.6.33-2.el6.x86_64
mysql-community-libs-5.6.33-2.el6.x86_64
mysql-connector-java-5.1.17-6.el6.noarch
mysql-community-client-5.6.33-2.el6.x86_64
mysql-community-server-5.6.33-2.el6.x86_64

**Postgres**
postgresql-8.4.20-6.el6.x86_64
postgresql-libs-8.4.20-6.el6.x86_64
postgresql-server-8.4.20-6.el6.x86_64

## HDP Services Started Automatically on Startup
When the virtual machine is booted up, the following services are started. If not specified, assume all are java processes.  The users that launch the process are the corresponding names of the component.  The processes are listed with their main class.

**Ambari**
AmbariServer - org.apache.ambari.server.controller.AmbariServer run as root user
Ambari Agent (non java process)

**Flume**
Application - org.apache.flume.node.Application

**HDFS**
Portmap - org.apache.hadoop.portmap.Portmap
NameNode - org.apache.hadoop.hdfs.server.namenode.NameNode
DataNode - org.apache.hadoop.hdfs.server.datanode.DataNode
Nfs

Portmap - Unlike the other processes that are launched by hdfs user, these are run as root user.
The nfs process doesn’t show up as a name for jps output

**HIVE**
RunJar - webhcat - org.apache.hadoop.util.RunJar Run as hcat user
RunJar - metastore - org.apache.hadoop.util.RunJar
RunJar - hiveserver2 - org.apache.hadoop.util.RunJar

**Mapreduce**
JobHistoryServer - org.apache.hadoop.mapreduce.v2.hs.JobHistoryServer
mapred is the user used to launch this process

**Oozie**
Bootstrap - org.apache.catalina.startup.Bootstrap

**Ranger**
UnixAuthenticationService- org.apache.ranger.authentication.UnixAuthenticationService Run as root user
EmbededServer- org.apache.ranger.server.tomcat.EmbeddedServer

**Spark**
HistoryServer - org.apache.spark.deploy.history.HistoryServer

**YARN**
ApplicationHistoryServer - org.apache.hadoop.yarn.server.applicationhistoryservice.ApplicationHistoryServer
ResourceManager -  org.apache.hadoop.yarn.server.resourcemanager.ResourceManager
NodeManager - org.apache.hadoop.yarn.server.nodemanager.NodeManager

**Zookeeper**
QuorumPeerMain - org.apache.zookeeper.server.quorum.QuorumPeerMain

**Zeppelin**
ZeppelinServer - org.apache.zeppelin.server.ZeppelinServer

## HDP Services NOT Started Automatically on Startup
Because of the limited resources avaialble in the sandbox virtual machine environment, the following services are in maintenance mode and will not automatically start.  To fully use these services, you must allocate more memory to the sandbox virtual machine.  If you want these services to automatically start, turn off maintenance mode.  The processes are listed with their main class.

**Ambari Infra**
**Ambari Metrics**

**Atlas**
Main - org.apache.atlas.Main

**HDFS**
SecondaryNameNode - org.apache.hadoop.hdfs.server.namenode.SecondaryNameNode
Since on a single node, secondary namenode is not needed, it is not started.

**Falcon**
Main - org.apache.falcon.Main

**HBase**
HRegionServer - org.apache.hadoop.hbase.regionserver.HRegionServer
HMaster - org.apache.hadoop.hbase.master.HMaster

**Kafka**
Kafka - kafka.Kafka

**Knox**
gateway.jar - /usr/hdp/current/knox-server/bin/gateway.jar
ldap.jar - /usr/hdp/current/knox-server/bin/ldap.jar This process is a mini ldap server

**Spark**
Livy server run as livy
Thrift Server - org.apache.spark.deploy.SparkSubmit run as hive user

**Spark2**
Livy server run as livy
Thrift server - org.apache.spark.deploy.SparkSubmit run as hive user

**Storm**
supervisor - backtype.storm.daemon.supervisor
nimbus - backtype.storm.daemon.nimbus
logviewer - backtype.storm.daemon.logviewer
core - backtype.storm.ui.core
drpc -  backtype.storm.daemon.drpc
