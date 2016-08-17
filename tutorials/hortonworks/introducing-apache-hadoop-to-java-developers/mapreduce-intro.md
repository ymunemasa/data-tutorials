---
layout: tutorial
title: Introduce Apache Hadoop to Developers
tutorial-id: 130
tutorial-series: Introduction
tutorial-version: hdp-2.5.0
intro-page: false
components: [ hadoop ]
---

# Introduction to Apache Hadoop MapReduce

Version 1 for HDP 2.5 updated on August 17, 2016

## Introduction

- MapReduce Programming Model influenced by functional programming constructs, demonstrate its power through examples
- Discuss MapReduce and its relationship to HDFS, Streaming API, Repositories, SBT Setup, Gradle Setup
- Performance Apache MapReduce Implementation
- Exploits data locality to reduce network overhead
- Failure recovery features ensure job completion in environment

In this concepts overview, we will explore the core concepts of Apache Hadoop and examine the 
Mapper and Reducer at a high level perspective.

## Pre-Requisites
*  Downloaded and Installed [Hortonworks Sandbox](http://hortonworks.com/products/hortonworks-sandbox/#install)
*  If you are not familiar with the Sandbox in a VM and the Ambari Interface, refer to 
[Learning the Ropes of the Hortonworks Sandbox](http://hortonworks.com/hadoop-tutorial/learning-the-ropes-of-the-hortonworks-sandbox/)
*  Allow yourself around 1 to 2 hours to complete this tutorial

## How is this tutorial different?
- Brief overview of trade-offs between alternatives
- Apache MapReduce implementation internals, tuning tips

## About this tutorial
- Edited collaboratively on [Github](https://github.com/hortonworks/tutorials-future/new/master/tutorials/hortonworks/introducing-apache-hadoop-to-java-developers) 
to give the community access to free learning

## Tutorial Overview
- MapReduce Core Concepts
  - Brief intro to MapReduce
  - Use of MapReduce inside Hortonworks Data Platform
  - MapReduce programming Examples
  - MapReduce, similar and alternatives (Need to check)
- Implementation of Apache Hadoop MapReduce
  - Dealing with failures
  - Performance & Scalability 
  - Usability 
