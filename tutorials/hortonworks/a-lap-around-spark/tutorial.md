## A Lap Around Spark with HDP

This Apache Spark with Hortonworks Data Platform (HDP) guide walks you through many of the newer features of Spark 1.6 on YARN.

With YARN, Hadoop can now support many types of data and application workloads; Spark on YARN becomes yet another workload running against the same set of hardware resources.

This guide describes how to:

* Run Spark on YARN and run the canonical Spark examples: SparkPi and Wordcount.
* Run Spark 1.6 on HDP 2.3.
* Use the Spark DataFrame API.
* Read/write data from Hive.
* Use SparkSQL Thrift Server for JDBC/ODBC access.
* Use ORC files with Spark, with examples.
* Use SparkR.
* Use the DataSet API.

When you are ready to go beyond these tasks, checkout the [Apache Spark Machine Learning Library (MLlib) Guide](http://spark.apache.org/docs/latest/mllib-guide.html).

### HDP Cluster Requirement

Spark can be configured on any HDP cluster whether it is a multi node cluster or a single node HDP Sandbox.

The instructions in this guide assume you are using the latest Hortonworks Sandbox.

### Run the Spark Pi Example

To test compute intensive tasks in Spark, the Pi example calculates pi by “throwing darts” at a circle. The example points in the unit square ((0,0) to (1,1)) and sees how many fall in the unit circle. The fraction should be pi/4, which is used to estimate Pi.

To calculate Pi with Spark:

**Change to your Spark directory and become spark OS user:**

``` bash
cd /usr/hdp/current/spark-client  
su spark
```

**Run the Spark Pi example in yarn-client mode:**

``` bash
./bin/spark-submit --class org.apache.spark.examples.SparkPi --master yarn-client --num-executors 3 --driver-memory 512m --executor-memory 512m --executor-cores 1 lib/spark-examples*.jar 10
```

**Note:** The Pi job should complete without any failure messages and produce output similar to below, note the value of Pi in the output message:  
![](/assets/a-lap-around-spark/Screenshot%202015-07-20%2014.48.48.png?dl=1)

### Using WordCount with Spark

#### Copy input file for Spark WordCount Example

Upload the input file you want to use in WordCount to HDFS. You can use any text file as input. In the following example, log4j.properties is used as an example:

As user spark:

``` bash
hadoop fs -copyFromLocal /etc/hadoop/conf/log4j.properties /tmp/data
```

### Run Spark WordCount

To run WordCount:

#### Run the Spark shell:

``` bash
./bin/spark-shell --master yarn-client --driver-memory 512m --executor-memory 512m
```

Output similar to below displays before the Scala REPL prompt, scala>:  
![](/assets/a-lap-around-spark/Screenshot%202015-07-20%2014.50.31.png?dl=1)

#### At the Scala REPL prompt enter:

``` js
val file = sc.textFile("/tmp/data")
val counts = file.flatMap(line => line.split(" ")).map(word => (word, 1)).reduceByKey(_ + _)
```
Save *counts* to a file:

``` js
counts.saveAsTextFile("/tmp/wordcount")
```

##### Viewing the WordCount output with Scala Shell

To view the output in the scala shell:

``` js
counts.count()
```

![](/assets/a-lap-around-spark/Screenshot%202015-07-20%2014.55.13.png?dl=1)

To print the full output of the WordCount job:

``` js
counts.toArray().foreach(println)
```

![](/assets/a-lap-around-spark/Screenshot%202015-07-20%2014.57.10.png?dl=1)

##### Viewing the WordCount output with HDFS

To read the output of WordCount using HDFS command:  
Exit the scala shell.

``` bash
exit
```

View WordCount Results:

``` bash
hadoop fs -ls /tmp/wordcount
```

It should display output similar to:

![](/assets/a-lap-around-spark/Screenshot%202015-07-20%2014.58.22.png?dl=1)

Use the HDFS cat command to see the WordCount output. For example,

``` bash
hadoop fs -cat /tmp/wordcount/part-00000
```

![](/assets/a-lap-around-spark/Screenshot%202015-07-20%2014.59.10.png?dl=1)

##### Using Spark DataFrame API

 DataFrame API provides easier access to data since it looks conceptually like a Table and a lot of developers from Python/R/Pandas are familiar with it.

Let's upload people text file to HDFS


``` bash
cd /usr/hdp/current/spark-client
su spark
hadoop fs -copyFromLocal examples/src/main/resources/people.txt people.txt
hadoop fs -copyFromLocal examples/src/main/resources/people.json people.json
```

![](/assets/a-lap-around-spark/Screenshot%202015-07-20%2015.01.49.png?dl=1)

Then let's launch the Spark Shell.

``` bash
cd /usr/hdp/current/spark-client
su spark
./bin/spark-shell --num-executors 2 --executor-memory 512m --master yarn-client
```

At the Spark Shell type the following:

``` js
val df = sqlContext.jsonFile("people.json")
```

This will produce and output such as

![](/assets/a-lap-around-spark/Screenshot%202015-07-20%2015.04.33.png?dl=1)

**Note:** The highlighted output shows the inferred schema of the underlying *people.json*.

Now print the content of DataFrame with `df.show`:

``` js
df.show
```

![](/assets/a-lap-around-spark/Screenshot%202015-07-20%2015.06.29.png?dl=1)

##### Data Frame API examples

``` js
import org.apache.spark.sql.functions._ 

// Select everybody, but increment the age by 1
df.select(df("name"), df("age") + 1).show()
```

![](/assets/a-lap-around-spark/Screenshot%202015-07-20%2015.13.59.png?dl=1)

``` js
// Select people older than 21
df.filter(df("age") > 21).show()
```

![](/assets/a-lap-around-spark/Screenshot%202015-07-20%2015.14.47.png?dl=1)


``` js
// Count people by age
df.groupBy("age").count().show()
```


![](/assets/a-lap-around-spark/Screenshot%202015-07-20%2015.15.41.png?dl=1)

##### Programmatically Specifying Schema

``` js
import org.apache.spark.sql._ 

val sqlContext = new org.apache.spark.sql.SQLContext(sc)
val people = sc.textFile("people.txt")
val schemaString = "name age"

import org.apache.spark.sql.types.{StructType,StructField,StringType} 
val schema = StructType(schemaString.split(" ").map(fieldName => StructField(fieldName, StringType, true)))
```


![](/assets/a-lap-around-spark/Screenshot%202015-07-20%2015.18.02.png?dl=1)

``` js
val rowRDD = people.map(_.split(",")).map(p => Row(p(0), p(1).trim))
val peopleDataFrame = sqlContext.createDataFrame(rowRDD, schema)
peopleDataFrame.registerTempTable("people")
val results = sqlContext.sql("SELECT name FROM people")
results.map(t => "Name: " + t(0)).collect().foreach(println)
```

This will produce an output like

![](/assets/a-lap-around-spark/Screenshot%202015-07-20%2015.19.49.png?dl=1)

### Running Hive UDF

Hive a built-in UDF collect_list(col) which returns a list of objects with duplicates.  
The below example reads and write to HDFS under Hive directories. In a production environment one needs appropriate HDFS permission. However for evaluation you can run all this section as hdfs user.

Before running Hive examples run the following steps:

#### Launch Spark Shell on YARN cluster

``` bash
su hdfs

# If not already in spark-client directory, change to that directory
cd /usr/hdp/current/spark-client
./bin/spark-shell --num-executors 2 --executor-memory 512m --master yarn-client
```

#### Create Hive Context

``` js
val hiveContext = new org.apache.spark.sql.hive.HiveContext(sc)
```

You should see output similar to the following:

![](/assets/a-lap-around-spark/Screenshot%202015-07-20%2015.24.12.png?dl=1)

#### Create Hive Table

``` js
hiveContext.sql("CREATE TABLE IF NOT EXISTS TestTable (key INT, value STRING)")
```

You should see output similar to the following:

![](/assets/a-lap-around-spark/Screenshot%202015-07-20%2015.25.34.png?dl=1)

#### Load example KV value data into Table

``` js
scala> hiveContext.sql("LOAD DATA LOCAL INPATH 'examples/src/main/resources/kv1.txt' INTO TABLE TestTable")
```

You should see output similar to the following:

![](/assets/a-lap-around-spark/Screenshot%202015-07-20%2015.26.53.png?dl=1)

#### Invoke Hive collect_list UDF

``` js
hiveContext.sql("from TestTable SELECT key, collect_list(value) group by key order by key").collect.foreach(println)
```

You should see output similar to the following:

![](/assets/a-lap-around-spark/Screenshot%202015-07-21%2010.40.04.png?dl=1)

### Read & Write ORC File Example

In this tech preview, we have implemented full support for ORC files with Spark. We will walk through an example that reads and write ORC file and uses ORC structure to infer a table.

### ORC File Support

#### Create a new Hive Table with ORC format

``` js
hiveContext.sql("create table orc_table(key INT, value STRING) stored as orc")
```

#### Load Data into the ORC table

``` js
hiveContext.sql("INSERT INTO table orc_table select * from testtable")
```

#### Verify that Data is loaded into the ORC table

``` js
hiveContext.sql("FROM orc_table SELECT *").collect().foreach(println)
```

![](/assets/a-lap-around-spark/Screenshot%202015-07-21%2010.42.11.png?dl=1)

#### Read ORC Table from HDFS as HadoopRDD**

``` js
val inputRead = sc.hadoopFile("/apps/hive/warehouse/orc_table", classOf[org.apache.hadoop.hive.ql.io.orc.OrcInputFormat],classOf[org.apache.hadoop.io.NullWritable],classOf[org.apache.hadoop.hive.ql.io.orc.OrcStruct])
```

![](/assets/a-lap-around-spark/Screenshot%202015-07-21%2010.45.03.png?dl=1)

#### Verify we can manipulate the ORC record through RDD

``` js
val k = inputRead.map(pair => pair._2.toString)
val c = k.collect
```

You should see output similar to the following:

![](/assets/a-lap-around-spark/Screenshot%202015-07-21%2010.46.20.png?dl=1)

#### **Copy example table into HDFS**

``` bash
cd /usr/hdp/current/spark-client
su spark
hadoop fs -put examples/src/main/resources/people.txt people.txt
```

#### Run Spark-Shell

``` bash
./bin/spark-shell --num-executors 2 --executor-memory 512m --master yarn-client
```

on Scala prompt type the following, except for the comments

``` js
import org.apache.spark.sql.hive.orc._ 
import org.apache.spark.sql._ 
import org.apache.spark.sql.types.{StructType,StructField,StringType} 

val hiveContext = new org.apache.spark.sql.hive.HiveContext(sc)
```

![](/assets/a-lap-around-spark/Screenshot%202015-07-21%2010.54.29.png?dl=1)

Load and register the spark table

``` js
// Create an RDD
val people = sc.textFile("examples/src/main/resources/people.txt")

// The schema is encoded in a string
val schemaString = "name age"

// Import Row.
import org.apache.spark.sql.Row;

// Import Spark SQL data types
import org.apache.spark.sql.types.{StructType,StructField,StringType};

// Generate the schema based on the string of schema
val schema =
  StructType(
    schemaString.split(" ").map(fieldName => StructField(fieldName, StringType, true)))

// Convert records of the RDD (people) to Rows.
val rowRDD = people.map(_.split(",")).map(p => Row(p(0), p(1).trim))

// Apply the schema to the RDD.
val peopleDataFrame = sqlContext.createDataFrame(rowRDD, schema)

// Register the DataFrames as a table.
peopleDataFrame.registerTempTable("people")

// SQL statements can be run by using the sql methods provided by sqlContext.
val results = sqlContext.sql("SELECT name FROM people")

// The results of SQL queries are DataFrames and support all the normal RDD operations.
// The columns of a row in the result can be accessed by field index or by field name.
results.map(t => "Name: " + t(0)).collect().foreach(println)
```

![](/assets/a-lap-around-spark/Screenshot%202015-07-21%2013.43.49.png?dl=1)

Save Table to ORCFile

``` js
peopleDataFrame.write.orc("people.orc")
```

Create Table from ORCFile

``` js
val morePeopleDF = hiveContext.read.orc("people.orc")
morePeopleDF.registerTempTable("morePeople")
```

![](/assets/a-lap-around-spark/Screenshot%202015-07-21%2013.46.51.png?dl=1)

Query from the table

``` js
hiveContext.sql("SELECT * from morePeople").collect.foreach(println)
```

![](/assets/a-lap-around-spark/Screenshot%202015-07-21%2013.47.58.png?dl=1)

### SparkSQL Thrift Server for JDBC/ODBC access

With this release SparkSQL’s thrift server provides JDBC access to SparkSQL.

**Start Thrift Server**  

``` bash
su spark
cd /usr/hdp/current/spark-client
./sbin/start-thriftserver.sh --master yarn-client --executor-memory 512m --hiveconf hive.server2.thrift.port=10015
```

**Connect to Thrift Server over beeline**\
Launch beeline

``` bash
./bin/beeline
```

**Connect to Thrift Server & Issue SQL commands**  
On beeline prompt

``` sql
!connect jdbc:hive2://localhost:10015
```

Note this is example is without security enabled, so any username password should work or simply press enter/return.

Note, the connection may take a few second to be available and try show tables after a wait of 10-15 second in a Sandbox env.

``` sql
show tables;
```


![](/assets/a-lap-around-spark/Screenshot%202015-07-21%2013.53.04.png?dl=1)

type `Ctrl+C` to exit beeline.

*   **Stop Thrift Server**

``` bash
./sbin/stop-thriftserver.sh
```

![](/assets/a-lap-around-spark/Screenshot%202015-07-21%2013.55.40.png?dl=1)

### Spark Job History Server

Spark Job history server is integrated with YARN’s Application Timeline Server(ATS) and publishes job metrics to ATS. This allows job details to be available after the job finishes.

1.  **Start Spark History Server**

``` bash
./sbin/start-history-server.sh
```

You can let the history server run, while you run examples and go to YARN resource manager page at [http://127.0.0.1:8088/cluster/apps](http://127.0.0.1:8088/cluster/apps) and see the logs of finished application with the history server.

1.  **Stop Spark History Server**

``` bash
./sbin/stop-history-server.sh
```

![](/assets/a-lap-around-spark/Screenshot%202015-07-21%2014.00.10.png?dl=1)

Visit [http://hortonworks.com/tutorials](http://hortonworks.com/tutorials) for more tutorials on Apache Spark.
