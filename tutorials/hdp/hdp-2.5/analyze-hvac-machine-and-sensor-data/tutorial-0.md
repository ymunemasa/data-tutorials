---
title: Analyze HVAC Machine and Sensor Data
tutorial-id: 310
platform: hdp-2.5.0
tags: [hive, zeppelin, ambari]
---

# Analyze HVAC Machine and Sensor Data

## Introduction

Hortonworks Data Platform (HDP) can be used to to refine and analyze data from heating, ventilation, and air conditioning (HVAC) systems to maintain optimal office building temperatures and minimize expenses.

Demo video [Enable Predictive Analytics with Hadoop](http://www.youtube.com/watch?v=Op_5MmG7hIw) illustrates what you'll be building in this tutorial.

### Sensor Data

A sensor is a device that measures a physical quantity and transforms it into a digital signal. Sensors are always on, capturing data at a low cost, and powering the "Internet of Things."

### Use of Sensor Data

In this tutorial, we will focus on sensor data from building operations. Specifically, we will refine and analyze the data from Heating, Ventilation, Air Conditioning (HVAC) systems in 20 large buildings around the world.

## Prerequisites

-   Installed Hortonworks Sandbox (On Docker, VirtualBox or VMware)
-   Preview [Apache Hive Overview](https://hortonworks.com/apache/hive/)
-   Preview [Apache Zeppelin Overview](https://hortonworks.com/apache/zeppelin/)

## Outline

In this tutorial, we work with HVAC sensor data from 20 buildings from different countries. Learn a method to refine and analyze HVAC data:

1.  **Lab 1** Upload and Refine Data with Hive
2.  **Lab 2** Visualize HVAC Data Via Zeppelin
