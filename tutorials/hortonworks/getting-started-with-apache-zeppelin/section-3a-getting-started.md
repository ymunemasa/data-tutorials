---
layout: tutorial
title: Getting Started with Apache Zeppelin
tutorial-id: 368
tutorial-series: Zeppelin
tutorial-version: hdp-2.5.0
intro-page: true
components: [ Zeppelin, Spark, Hive, LDAP, Livy ]
---

### **Creating a Notebook**

To create a notebook:

1. Under the “Notebook” tab, choose **+Create new note**.

2.  You will see the following window. Type a name for the new note (or accept the default): <br><br>![Screen Shot 2016-03-07 at 4.43.20 PM](http://hortonworks.com/wp-content/uploads/2016/03/Screen-Shot-2016-03-07-at-4.43.20-PM-300x112.png)

3.  You will see the note that you just created, with one blank cell in the note. Click on the settings icon at the upper right. (Hovering over the icon will display the words "interpreter-binding.")<br><br>![zepp-settings-button](http://hortonworks.com/wp-content/uploads/2016/03/zepp-settings-button-1.png)<br><br>

4.  Drag the spark-yarn-client interpreter to the top of the list, and save it:<br><br>![Screen Shot 2016-03-03 at 11.14.58 PM](http://hortonworks.com/wp-content/uploads/2016/03/Screen-Shot-2016-03-03-at-11.14.58-PM-258x300.png)<br><br>

5.  Type sc.version into a paragraph in the note, and click the “Play” button (blue triangle): <br><br>![Screen Shot 2016-03-07 at 4.51.46 PM](http://hortonworks.com/wp-content/uploads/2016/03/Screen-Shot-2016-03-07-at-4.51.46-PM-300x21.png)<br>
SparkContext, SQLContext, ZeppelinContext will be created automatically. They will be exposed as variable names ‘sc’, ‘sqlContext’ and ‘z’, respectively, in scala and python environments.<br><br>
**Note:** The first run will take some time, because it is launching a new Spark job to run against YARN. Subsequent paragraphs will run much faster.<br><br>

6.  When finished, the status indicator on the right will say "FINISHED". The output should list the version of Spark in your cluster: <br><br>![Screen Shot 2016-03-07 at 4.55.48 PM](http://hortonworks.com/wp-content/uploads/2016/03/Screen-Shot-2016-03-07-at-4.55.48-PM-1.png)

### **Importing External Libraries**

As you explore Zeppelin you will probably want to use one or more external libraries. For example, to run [Magellan](http://hortonworks.com/blog/magellan-geospatial-analytics-in-spark/) you need to import its dependencies; you will need to include the Magellan library in your environment. There are three ways to include an external dependency in a Zeppelin notebook: **Using the %dep interpreter** (**Note**: This will only work for libraries that are published to Maven.)

<pre>%dep
z.load("group:artifact:version")
%spark
import ...</pre>

Here is an example that imports the dependency for Magellan:

<pre>%dep
z.addRepo("Spark Packages Repo").url("http://dl.bintray.com/spark-packages/maven")
z.load("com.esri.geometry:esri-geometry-api:1.2.1")
z.load("harsha2010:magellan:1.0.3-s_2.10")</pre>

For more information, see [https://zeppelin.incubator.apache.org/docs/interpreter/spark.html#dependencyloading](https://zeppelin.incubator.apache.org/docs/interpreter/spark.html#dependencyloading).
