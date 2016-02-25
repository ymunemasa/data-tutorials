### Introduction

[Apache Spark](http://hortonworks.com/hadoop/spark/) is a fast, in-memory data processing engine with elegant and expressive development APIs in Scala, Java, Python, and R that allow data workers to efficiently execute machine learning algorithms that require fast iterative access to datasets (see [Spark API Documentation](http://spark.apache.org/docs/latest/api.html) for more info). Spark on [Apache Hadoop YARN](http://hortonworks.com/hadoop/YARN "Apache Hadoop YARN") enables deep integration with Hadoop and other YARN enabled workloads in the enterprise.

In this tutorial, we will introduce the basic concepts of Apache Spark and the first few necessary steps to get started with Spark using an Apache Zeppelin Notebook on a Hortonworks Data Platform (HDP) Sandbox.

### Prerequisite

There are two options for setting up the Hortonworks Sandbox:

1.  **Download & Install [Hortonworks Sandbox on Local Machine](http://hortonworks.com/sandbox)**  
or
2.  **Deploy [Hortonworks Sandbox on Microsoft Azure](http://hortonworks.com/hadoop-tutorial/deploying-hortonworks-sandbox-on-microsoft-azure/)**

### Concepts

At the core of Spark is the notion of a **Resilient Distributed Dataset** (RDD), which is an immutable collection of objects that is partitioned and distributed across multiple physical nodes of a YARN cluster and that can be operated in parallel.

Typically, RDDs are instantiated by loading data from a shared filesystem, HDFS, HBase, or any data source offering a Hadoop InputFormat on a YARN cluster.

Once an RDD is instantiated, you can apply a [series of operations](https://spark.apache.org/docs/latest/programming-guide.html#rdd-operations). All operations fall into one of two types: [transformations](https://spark.apache.org/docs/latest/programming-guide.html#transformations) or [actions](https://spark.apache.org/docs/latest/programming-guide.html#actions). **Transformation** operations, as the name suggests, create new datasets from an existing RDD and build out the processing Directed Acyclic Graph (DAG) that can then be applied on the partitioned dataset across the YARN cluster. An **Action** operation, on the other hand, executes DAG and returns a value.

Let’s try it out.

### A Hands-On Example

 From an Ambari view select **Zeppelin**

![](/assets/a-tour-of-spark-in-5-minutes/4-apache-spark-tour-in-5-minutes.png)

Once Zeppelin launches, select **Create new note** from **Notebook** dropdown menu

![](/assets/a-tour-of-spark-in-5-minutes/2-apache-spark-tour-in-5-minutes.png)

Give your notebook a name. I named my notebook *Apache Spark in 5 Minutes*

![](/assets/a-tour-of-spark-in-5-minutes/3-apache-spark-tour-in-5-minutes.png)

Zeppelin comes with several interpreters pre-configured on Sandbox. In this tutorial we will use a shell interpreter `%sh` and a pyspark interpreter `%pyspark`.

Let's start with a shell interpreter `%sh` and bring in some Hortonworks related Wikipedia data.

Type the following in your Zeppelin Notebook and hit **shift + enter** to execute the code:

    %sh

    wget http://en.wikipedia.org/wiki/Hortonworks

You should see an output similar to this

![](/assets/a-tour-of-spark-in-5-minutes/5-apache-spark-tour-in-5-minutes.png)

Next, let's copy the data over to HDFS. Type and execute the following:

    %sh

    hadoop fs -put ~/Hortonworks /tmp

Now we are ready to run a simple Python program with Spark. This time we will use the python interpreter `%pyspark`. Copy and execute this code:

    %pyspark

    myLines = sc.textFile('hdfs://sandbox.hortonworks.com/tmp/Hortonworks')

    myLinesFiltered = myLines.filter( lambda x: len(x) > 0 )

    count = myLinesFiltered.count()

    print count

When you execute the above you should get only a number as an output. I got `311` but it may vary depending on the Wikipedia entry.

![](/assets/a-tour-of-spark-in-5-minutes/6-apache-spark-tour-in-5-minutes.png)

Let's go over what's actually going on. After the python interpreter `%pyspark` is initialized we instantiate an RDD using a Spark Context `sc` with a `Hortonworks` file on HDFS:

    myLines = sc.textFile('hdfs://sandbox.hortonworks.com/tmp/Hortonworks')

After we instantiate the RDD, we apply a transformation operation on the RDD. In this case, a simple transformation operation using a Python lambda expression to filter out all the empty lines:

    myLinesFiltered = myLines.filter( lambda x: len(x) > 0 )

At this point, the transformation operation above did not touch the data in any way. It has only modified the processing graph.

We finally execute an action operation using the aggregate function `count()`, which then executes all the transformation operations:

    count = myLinesFiltered.count()

Lastly, with `print count` we display the final count value, which returns `311`.

That's it! Your complete notebook should look like this after you run your code in all paragraphs:

![](/assets/a-tour-of-spark-in-5-minutes/1-apache-spark-tour-in-5-minutes.png)

We hope that this little example wets your appetite for more ambitious data science projects on the Hortonworks Data Platform (HDP) Sandbox.

For more information checkout [Apache Spark & Hadoop](http://hortonworks.com/spark).
