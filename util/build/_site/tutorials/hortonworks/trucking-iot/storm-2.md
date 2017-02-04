# Storm - Architecture

## Introduction
This tutorial will cover the core concepts of Storm, and walk through setting up Storm on the sandbox.  We will also run a small Storm application, which we'll take a closer look at in the next tutorial.

## Pre-Requisites
-   [Learning the Ropes of the Hortonworks Sandbox](https://hortonworks.com/hadoop-tutorial/learning-the-ropes-of-the-hortonworks-sandbox)
-   [Storm - 0](#)

## Outline
-   Our use case
-   Download the project
-   Next up: Something (either pushing out to Kafka or reading/writing NiFi)


## Our use case

Remember that trucking company we talked about in the [previous section](# "Storm - 0")?  Let's discuss what they need and how we're going to make that happen.

The company has two streams of data coming in.  One stream is coming from all of the trucks' onboard computer.  This stream has information on events going on ..

The second stream has information about the level of traffic congestion on each route that trucks are driving on.

The company wants to unify these two streams of data into a single one, by finding out what traffic data matches with each bit of truck data.  Additionally, because traffic data is not coming in as often as truck data, we need to capture and correlate data in **windows**.

## Download the project

From here on out, we'll be writing code using the Scala programming language.  If you would rather not code, then you can download the finished version and simply follow along.

To download the bare project and write code from scratch, clone this repository:
```
git clone https://github.com/orendain/
```

To download the finished project but still follow along, clone this repository:
```
git clone https://github.com/orendain/
```

## Let's talk Spouts



## Creating FileReaderSpouts




## Next up: Something
