---
layout: tutorial
title: Introduce Apache Hadoop to Developers
tutorial-id: 130
tutorial-series: Introduction
tutorial-version: hdp-2.5.0
intro-page: false
components: [ hadoop ]
---

## Introduction

- MapReduce Programming Model influenced by functional programming constructs, demonstrate its power through examples
- Discuss MapReduce and its relationship to HDFS, Streaming API, Repositories, SBT Setup, Gradle Setup
- Performance Apache MapReduce Implementation
- Exploits data locality to reduce network overhead
- Failure recovery features ensure job completion in environment

## Pre-Requisite
*  Downloaded and Installed latest [Hortonworks Sandbox](http://hortonworks.com/products/hortonworks-sandbox/#install)
*  [Learning the Ropes of the Hortonworks Sandbox](http://hortonworks.com/hadoop-tutorial/learning-the-ropes-of-the-hortonworks-sandbox/)
*  Allow yourself around 1 to 2 hours to complete this tutorial

## Outline

*   [Write a MapReduce program](#write-a-mapreduce-program)
*   [Step 1: Examine The MapReduce Example](#examine-the-mapreduce-example)
*   [Step 2: Mapper reading data from HDFS](#mapper-reading-data-hdfs)
*   [Step 3: Streaming API](#streaming-api)
*   [Step 4: Repositories](#repositories-hortonworks)
*   [Step 5: Source & Javadoc](#source-javadoc)
*   [Step 6: SBT Setup](#sbt-setup)
*   [Step 7: Gradle Setup](#gradle-setup)
*   [Appendix A: Hive and Pig: Motivation](#hive-and-pig-motivation)
*   [Further Reading](#further-reading-java-dev)


## Write a MapReduce Program <a id="write-a-mapreduce-program"></a>

In this section, you will learn how to use the Hadoop API to write a MapReduce program in Java.

Each of the portions (**RecordReader, Mapper, Partitioner, Reducer, etc.**) can be created by the developer. The developer is expected to at least write the Mapper, Reducer, and driver code.

### Step 1: Examine The MapReduce Example <a id="examine-the-mapreduce-example"></a>

### MapReduce WordCount Descrption

**WordCount** example reads text files and counts how often words occur. The input is text files and the output is text files. Each line contains a word and as the program counts how often words appear, it separates each word by a tab.

Each mapper takes a line as input and breaks it into words. It then emits a key/value pair of the word and 1\. Each reducer sums the counts for each word and emits a single key/value with the word and sum.

As an optimization, the reducer is also used as a combiner on the map outputs. This reduces the amount of data sent across the network by combining each word into a single record.

To run the example, copy and paste the command

~~~bash
hadoop jar hadoop-*-examples.jar wordcount [-m <#maps>] [-r <#reducers>] <in-dir> <out-dir>
~~~

All of the files in the input directory are read and the number of words in the input are written to the output directory. It is assumed that both inputs and outputs are stored in HDFS. If your input is not already in HDFS, but rather in a local file system somewhere, you need to copy the data into HDFS using a command like this:

~~~bash
hadoop dfs -copyFromLocal <local-dir> <hdfs-dir>
~~~

### WordCount Java Code

Below is the standard wordcount example implemented in Java:

~~~java
        package org.myorg;

        import java.io.IOException;
        import java.util.*;

        import org.apache.hadoop.fs.Path;
        import org.apache.hadoop.conf.*;
        import org.apache.hadoop.io.*;
        import org.apache.hadoop.mapreduce.*;
        import org.apache.hadoop.mapreduce.lib.input.FileInputFormat;
        import org.apache.hadoop.mapreduce.lib.input.TextInputFormat;
        import org.apache.hadoop.mapreduce.lib.output.FileOutputFormat;
        import org.apache.hadoop.mapreduce.lib.output.TextOutputFormat;

        public class WordCount {

         public static class Map extends Mapper<LongWritable, Text, Text, IntWritable> {
            private final static IntWritable one = new IntWritable(1);
            private Text word = new Text();

            public void map(LongWritable key, Text value, Context context) throws IOException, InterruptedException {
                String line = value.toString();
                StringTokenizer tokenizer = new StringTokenizer(line);
                while (tokenizer.hasMoreTokens()) {
                    word.set(tokenizer.nextToken());
                    context.write(word, one);
                }
            }
         } 

         public static class Reduce extends Reducer<Text, IntWritable, Text, IntWritable> {

            public void reduce(Text key, Iterable<IntWritable> values, Context context) 
              throws IOException, InterruptedException {
                int sum = 0;
                for (IntWritable val : values) {
                    sum += val.get();
                }
                context.write(key, new IntWritable(sum));
            }
         }

         public static void main(String[] args) throws Exception {
            Configuration conf = new Configuration();

                Job job = new Job(conf, "wordcount");

            job.setOutputKeyClass(Text.class);
            job.setOutputValueClass(IntWritable.class);

            job.setMapperClass(Map.class);
            job.setReducerClass(Reduce.class);

            job.setInputFormatClass(TextInputFormat.class);
            job.setOutputFormatClass(TextOutputFormat.class);

            FileInputFormat.addInputPath(job, new Path(args[0]));
            FileOutputFormat.setOutputPath(job, new Path(args[1]));

            job.waitForCompletion(true);
         }

        }
~~~

### MapReduce jobs consist of three portions

*   The driver code
     *   Code that runs on the client to configure and submit the job
*   The Mapper
*   The Reducer

Before we dive into the code, let's cover basic **Hadoop API concepts.**

### Step 2: Mapper reading data from HDFS <a id="mapper-reading-data-hdfs"></a>

The data passed to the Mapper is specified by an InputFormat. The InputFormat is specified in the driver code. It defines the location of the input data like a file or directory on HDFS. It also determines how to split the input data into input splits.

Each Mapper deals with a single input split. InputFormat is a factory for RecordReader objects to extract (key, value) records from the input source.

FilelnputFormat is the base class used for all file-based InputFormats. TextlnputFormat is the default FilelnputFormat. It treats each \n-terminated line of a file as a value. The Key is the byte offset within the file of that line. KeyValueTextlnputFormat maps \n-terminated lines as ‘key SEP value’. By default, separator is a tab. SequenceFilelnputFormat is a binary file of (key, value) pairs with some additional metadata. SequenceFileAsTextlnputFormat is similar, but maps (key.toString( ), value.toString( )).

Keys and values in Hadoop are objects. Values are objects which implement the writable interface. Keys are objects which implement writableComparable.

### Writable

Hadoop defines its own ‘box classes’ for strings, integers and so on:

*   IntWritable for ints
*   LongWritable for longs
*   FloatWritable for floats
*   DoubleWritable for doubles
*   Text for strings
*   Etc.

The writable interface makes serialization quick and easy for Hadoop. Any value’s type must implement the writable interface.

### WritableComparable

A WritableComparable is a Writable, which is also Comparable. Two writableComparables can be compared against each other to determine their ‘order’. Keys must be WritableComparables because they are passed to the Reducer in sorted order.

Note that despite their names, all Hadoop box classes implement both Writable and WritableComparable, for example, intwritable is actually a WritableComparable

### Driver

The driver code runs on the client machine. It configures the job, then submits it to the cluster.

### Step 3: Streaming API <a id="streaming-api"></a>

Many organizations have developers skilled in languages other than Java, such as

*   C#
*   Ruby
*   Python
*   Perl

The Streaming API allows developers to use any language they wish to write Mappers and Reducers as long as the language can read from standard input and write to standard output.

The advantages of the Streaming API are that there is no need for non-Java coders to learn Java. So it results in faster development time and the ability to use existing code libraries.

### How Streaming Works

To implement streaming, write separate Mapper and Reducer programs in the language of your choice. They will receive input via stdin. They should write their output to stdout.

If TextinputFormat (the default) is used, the streaming Mapper just receives each line from the file on stdin where no key is passed. Streaming Mapper and streaming Reducer’s output should be sent to stdout as key (tab) value (newline) and the Separators other than tab can be specified.

In Java, all the values associated with a key are passed to the Reducer as an iterator. Using Hadoop Streaming, the Reducer receives its input as (key, value) pairs, one per line of standard input.

Your code will have to keep track of the key so that it can detect when values from a new key start appearing launching a Streaming Job .To launch a Streaming job, use e.g.,:

~~~bash
hadoop jar $HADOOP_HOME/contrib/streaming/hadoop-streaming*.jar \
-input mylnputDirs \ -output myOutputDir \
-mapper myMap.py \
-reducer myReduce.py \ -file myMap.py \ -file myReduce.py
~~~

### Step 4: Repositories <a id="repositories-hortonworks"></a>

At Hortonworks, we store all of our artifacts in a public Sonatype Nexus repository. That repository can be easily accessed and searched for commonly used library, source code, and javadoc archives simply by navigating to [http://repo.hortonworks.com](http://repo.hortonworks.com).

### Step 5: Artifacts

Jar files containing compiled classes, source, and javadocs are all available in our public repository, and finding the right artifact with right version is as easy as searching the repository for classes you need to resolve.

For example, If creating a solution that requires the use of a class such as org.apache.hadoop.fs.FileSystem, you can simply search our public repository for the artifact that contains that class using the search capabilities available through [http://repo.hortonworks.com](http://repo.hortonworks.com). Searching for that class will locate the hadoop-common artifact that is part of the org.apache.hadoop group. There will be multiple artifacts each with a different version.

Artifacts in our repository use a 7 digit version scheme. So if we’re looking at the 2.7.1.2.4.0.0-169 version of this artifact:

*   The first three digits (2.7.1) signify the Apache Hadoop base version
*   The next four digits (2.4.0.0) signify our Hortonworks Data Platform release
*   The final numbers after the hyphen (169) signifies the build number

As you’re looking for the right artifact, it’s important to use the artifact version that corresponds to the HDP version you plan to deploy to. You can determine this by using `hdp-select versions` from the command line, or using Ambari by navigating to `Admin > Stack and Versions`. If neither of these are available in your version of HDP or Ambari, you can use yum, zypper, or dpkg to query the RPM or Debian packages installed for HDP and note their versions.

Once the right artifact has been found with the version that corresponds to your target HDP environment, it’s time to configure your build tool to both resolve our repository and include the artifact as a dependency. The following section outlines how to do both with commonly used with build tools such as Maven, SBT, and Gradle.

### Maven Setup

Apache Maven, is an incredibly flexible build tool used by many Hadoop ecosystem projects. In this section, we will outline what updates to your project’s pom.xml file are required to start resolving HDP artifacts.

### Repository Configuration

The pom.xml file enables flexible definition of project dependencies and build procedures. To add the Hortonworks repository to your project, allowing HDP artifacts to be resolved, edit the section and add a entry as illustrated below:

~~~html
      <repositories>

       <repository>

         <id>HDP</id>

         <name>HDP Releases</name>

         <url>http://repo.hortonworks.com/content/repositories/releases/</url>

       </repository>    

      </repositories>
~~~


### Artifact Configuration

Dependencies are added to Maven using the tag within the section of the pom.xml. To add a dependency such as hadoop-common, add this fragment:

~~~html
    <dependency>
       <groupId>org.apache.hadoop</groupId>
       <artifactId>hadoop-common</artifactId>
       <version>2.7.1.2.4.0.0-169</version>
    </dependency>
~~~

Once both the repository has been added to the repositories section, and the artifacts have been added to the dependencies section, a simple `mvn compile` can be issued from the base directory of your project to ensure that proper syntax has been used and the appropriate dependencies are downloaded.

### Step 5: Source & Javadoc <a id="source-javadoc"></a>

When using Maven with an IDE, it is often helpful to have the accompanying JavaDoc and source code. To obtain both from our repository for the artifacts that you have defined in your pom.xml, run the following commands from the base directory of your project:

~~~bash
mvn dependency:sources

mvn dependency:resolve -Dclassifier=javadoc
~~~

### Step 6: SBT Setup <a id="sbt-setup"></a>

The Scala Build Tool is commonly used with Scala based projects, and provide simple configuration, and many flexible options for dependency and build management.

Repository Configuration

In order for SBT projects to resolve Hortonworks Data Platform dependencies, an additional resolvers entry must be added to your build.sbt file, or equivalent, as illustrated below:

~~~bash
resolvers += "Hortonworks Releases" at "[http://repo.hortonworks.com/content/repositories/releases/](http://repo.hortonworks.com/content/repositories/releases/)"
~~~


### Artifact Configuration

Dependencies can be added to SBT’s libraryDependencies as illustrated below:

    libraryDependencies += “org.apache.hadoop” % “hadoop-common” % “2.7.1.2.4.0.0-169”

To explicitly ask SBT to also download source code and JavaDocs an alternate notation can be used:

    libraryDependencies += “org.apache.hadoop” % “hadoop-common” % “2.7.1.2.4.0.0-169” withSources() withJavadoc()

Once both the repository has been added to resolvers, and the artifacts have been added to dependencies, a simple sbt compile can be issued from the base directory of your project to ensure that proper syntax has been used and the appropriate dependencies are downloaded.

### Step 7: Gradle Setup <a id="gradle-setup"></a>

The Gradle build management tool is used frequently in Open Source java projects, and provides a simple Groovy-based DSL for project dependency and build definition.

Plugin Configuration

Gradle uses plugins add functionality to add new task, domain objects and conventions to your gradle build. Add the following plugins to your build.gradle file, or equivalent, as illustrated below:

~~~
    apply plugin: ‘java’

    apply plugin: ‘maven’

    apply plugin: ‘idea’  // Pick IDE appropriate for you

    apply plugin: ‘eclipse’ // Pick IDE appropriate for you
~~~



Repository Configuration

In order for Gradle projects to resolve Hortonworks Data Platform dependencies, an additional entry must be added to your build.gradle file, or equivalent, as illustrated below:

~~~
    repositories {



      maven { url “http://repo.hortonworks.com/content/repositories/releases/” }



    }
~~~ 

### Artifact Configuration

Dependencies can be added to Gradle’s dependencies section as illustrated below:

~~~
      dependencies {

         compile group: “org.apache.hadoop”, name: “hadoop-common”, version: “2.7.1.2.3.2.0-2650”

      }

      idea {  // Pick IDE appropriate for you

        module {

            downloadJavadoc = true

            downloadSources = true

        }

      }



      eclipse {  // Pick IDE appropriate for you



        classpath {

            downloadSources = true

            downloadJavadoc = true

        }

      }

~~~
Once both the repositories and the dependencies have been added to build file, a simple gradle clean build can be issued from the base directory of your project to ensure that proper syntax has been used and the appropriate dependencies are downloaded.

### Appendix A: Hive and Pig: Motivation <a id="hive-and-pig-motivation"></a>

MapReduce code is typically written in Java. Although it can be written in other languages using Hadoop

Streaming Requires a programmer who understands how to think in terms of MapReduce, who understands the problem they’re trying to solve and who has enough time to write and test the code.

Many organizations have only a few developers who can write good MapReduce code

Meanwhile, many other people want to analyze data

*   Data analysts
*   Business analysts
*   Data scientists
*   Statisticians

So we needed a higher-level abstraction on top of MapReduce providing the ability to query the data without needing to know MapReduce intimately. Hive and Pig address these needs.

## Further Reading <a id="further-reading-java-dev"></a>

See the following tutorial for more on Hive and Pig:

*   Explore [MapReduce Tutorial](https://hadoop.apache.org/docs/current/hadoop-mapreduce-client/hadoop-mapreduce-client-core/MapReduceTutorial.html#MapReduce_Tutorial)
*   [Process Data with Apache Hive](http://hortonworks.com/hadoop-tutorial/how-to-process-data-with-apache-hive/)
*   [Process Data with Apache Pig](http://hortonworks.com/hadoop-tutorial/how-to-process-data-with-apache-pig/)
*   [Get Started with Cascading on Hortonworks Data Platform](http://hortonworks.com/hadoop-tutorial/cascading-log-parsing/)
*   [Interactive Query for Hadoop with Apache Hive on Apache Tez](http://hortonworks.com/hadoop-tutorial/supercharging-interactive-queries-hive-tez/)
*   [Exploring Data with Apache Pig from the Grunt shell](http://hortonworks.com/hadoop-tutorial/exploring-data-apache-pig-grunt-shell/)

*   We have many [tutorials](http://hortonworks.com/tutorials) which you can use with the Hortonworks Sandbox to learn about a rich and diverse set of components of the Hadoop platform.
