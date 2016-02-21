## How to Process Data with Apache Hive

### Introduction

Hive is a component of Hortonworks Data Platform(HDP). Hive provides a SQL-like interface to data stored in HDP. In the previous tutorial,
we used Pig which is a scripting language with a focus on dataflows. Hive provides a database query interface to Apache Hadoop.

### Hive or Pig?

People often ask why do Pig and Hive exist when they seem to do much of the same thing. Hive because of its SQL like query language is 
often used as the interface to an Apache Hadoop based data warehouse. Hive is considered friendlier and more familiar to users who are 
used to using SQL for querying data. Pig fits in through its data flow strengths where it takes on the tasks of bringing data into Apache 
Hadoop and working with it to get it into the form for querying. A good overview of how this works is in Alan Gates posting on the Yahoo 
Developer blog titled [Pig and Hive at Yahoo!](https://developer.yahoo.com/blogs/hadoop/pig-hive-yahoo-464.html) From a technical point 
of view both Pig and Hive are feature complete so you can do tasks in either tool. However you will find one tool or the other will be 
preferred by the different groups that have to use Apache Hadoop. The good part is they have a choice and both tools work together.

### Our Data Processing Task

We are going to do the same data processing task as we just did with Pig in the previous tutorial. We have several files of baseball 
statistics and we are going to bring them into Hive and do some simple computing with them. We are going to find the player with the 
highest runs for each year. This file has all the statistics from 1871–2011 and contains more that 90,000 rows. Once we have the highest 
runs we will extend the script to translate a player id field into the first and last names of the players.

### Downloading The Data

The data files we are using comes from the site [SeanLahman.com](http://www.seanlahman.com/). You can download the following data file,
[lahman591-csv.zip](http://seanlahman.com/files/database/lahman591-csv.zip). Once you have the file you will need to unzip it into a 
directory. We will be uploading just the `Master.csv` and `Batting.csv` files from the dataset.

### Uploading The Data Files

We start by selecting the HDFS Files view from the Off-canvas menu at the top. The `HDFS Files view` shows you the files in the HDP file
store. In this case the file store resides in the Hortonworks Sandbox VM.

![HDFS File View Icon Image]()

Navigate to `/user/admin` and click on the **Upload** button.

![HDFS Admin Folder Image]()

Clicking on browse will open a dialog box. Navigate to where you stored theBatting.csv file on your local disk and select `Batting.csv.` 
Do the same thing for `Master.csv.` When you are done you will see there are two files in your directory.

![batting and master csv uploaded Image]()
