---
layout: tutorial
title: How to Analyze Machine and Sensor Data
tutorial-id: 310
tutorial-series: Real-World End to End Examples
tutorial-version: hdp-2.5.0
intro-page: true
components: [ hive, zeppelin, ambari ]
---


## Analyze Machine and Sensor Data

**Version 1.0 for HDP 2.5 January 25, 2017**

### Introduction

Hortonworks Data Platform (HDP) can be used to to refine and analyze data from heating, ventilation, and air conditioning (HVAC) systems to maintain optimal office building temperatures and minimize expenses.

Demo video [Enable Predictive Analytics with Hadoop](http://www.youtube.com/watch?v=Op_5MmG7hIw) illustrates what you'll be building in this tutorial.

### Sensor Data

A sensor is a device that measures a physical quantity and transforms it into a digital signal. Sensors are always on, capturing data at a low cost, and powering the "Internet of Things."

### Use of Sensor Data

In this tutorial, we will focus on sensor data from building operations. Specifically, we will refine and analyze the data from Heating, Ventilation, Air Conditioning (HVAC) systems in 20 large buildings around the world.

### Prerequisites:

- Installed Hortonworks Sandbox (On Docker, VirtualBox or VMware)
- Preview [Apache Hive Overview](http://hortonworks.com/apache/hive/)
- Preview [Apache Zeppelin Overview](http://hortonworks.com/apache/zeppelin/)

### Tutorial Series Overview

In this tutorial, we work with HVAC sensor data from 20 buildings from different countries. Learn a method to refine and analyze HVAC data:

**Lab1 - Upload and Refine Data with Hive**
- Download and extract the sensor data files to your local machine.
- Upload and cleanse HVAC data with Apache Hive running on HDP sandbox.

**Lab 2 - Visualize HVAC Data Via Zeppelin**
- Access the refined HVAC data.
- Visualize HVAC data to determine buildings that need HVAC units.
