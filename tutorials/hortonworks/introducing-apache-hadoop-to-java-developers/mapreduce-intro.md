---
layout: tutorial
title: Introduce Apache Hadoop to Developers
tutorial-id: 130
tutorial-series: Introduction
tutorial-version: hdp-2.5.0
intro-page: true
components: [ hadoop ]
---

# Introduction to Apache Hadoop MapReduce

Version 1 for HDP 2.5 updated on August 20, 2016

## Introduction

MapReduce is a Programming Model influenced by functional programming constructs. MapReduce processes large datasets with a parallel distributed algorithm. Therefore, data processing occurs at extreme speeds compared to sequential processing. We will discuss MapReduce's implementation on the way it processes data. While MapReduce processes data, we will explore the software's failure recovery features that ensure jobs complete. We will learn to use the MapReduce API in an IDE(Eclipse, Intellij) on the Sandbox and discuss MapReduce's relationship to HDFS, Streaming API, Repositories, SBT Setup and Gradle Setup.

Progressive, our employer of 1 year, wants to implement a new approach for monitoring drivers' behavior that uses the MapReduce API. Therefore, once results are collected, drivers will be offered insurance at a rate based on how well they drive. We have been assigned the software project which involves using MapReduce to track the number of miles logged per driver (In the tutorial, we will go through interactive step by step instructions for building this new program). 

## Prerequisites
*  Downloaded and Installed [Hortonworks Sandbox](http://hortonworks.com/products/hortonworks-sandbox/#install)
*  If you are not familiar with the Sandbox in a VM and the Ambari Interface, refer to 
[Learning the Ropes of the Hortonworks Sandbox](http://hortonworks.com/hadoop-tutorial/learning-the-ropes-of-the-hortonworks-sandbox/)
*  If you are not familiar with Java concepts, we highly recommend you search for a brief video on Youtube
*  If you want to learn Java programming before proceeding with the tutorial, we highly recommend you take a free course online
*  Allow yourself around 1 to 2 hours to complete this tutorial

## How is this tutorial different?
- User is presented with a Real World Scenario in which they find purpose in using MapReduce to solve a problem 
- Interactive step by step instructions on how to create a MapReduce program in an IDE on the Sandbox

## About this tutorial
- Edited collaboratively on [Github](https://github.com/hortonworks/tutorials-future/new/master/tutorials/hortonworks/introducing-apache-hadoop-to-java-developers) 
to give the community access to free learning

## Goals and Learning Objectives

The goal of this tutorial is to provide you with an opportunity to build a MapReduce DataFlow by writing MapReduce code. You do not need programming experience or functional programming syntax. However, we do recommend you have some knowledge of Java syntax and concepts to obtain the best experience.

**Learning Objectives from this tutorial are:**

- Understand Apache Hadoop MapReduce Fundamentals
- Understand MapReduce's Role in the Hadoop Ecosystem
- Introduce MapReduce API's: Mapper, Partitioner, Shuffle, Reducer
- Setup IDE on Sandbox for MapReduce Development
- Create MapReduce DataFlows in Java
- Learn about MapReduce Pipes API to write Jobs in C++
- Learn about Hadoop Streaming API to write Jobs in any Language

## Tutorial Overview
- MapReduce Core Concepts
  - Brief intro to MapReduce
    - MapReduce and HDFS
  - Dealing with failures
  - Performance & Scalability 
  - Use of MapReduce inside Hortonworks Data Platform
  - MapReduce programming Examples
  - MapReduce, Tez and LLAP
- Setup Programming Environment
  - Sandbox
  - Eclipse IDE (Option1)
  - Intellij IDE (Option2)
  - Maven
- Implementation of Apache Hadoop MapReduce
  - Write MapReduce API code
    - Track Miles Logged Per Driver
    - Store Data Into HDFS
  - Present results in terminal
