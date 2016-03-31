---
layout: tutorial
title: Learning Spark with Zeppelin
tutorial-id: 365
tutorial-series: Spark
tutorial-version: hdp-2.4.0
intro-page: true
components: [ spark, zeppelin ]
---


### Introduction

In this tutorial, we will introduce the basic concepts of Apache Spark RDDs, DataFrames, and Spark Streaming in a hands-on lab in Apache Zeppelin notebook.

We will also introduce the first necessary steps to get up and running with Zeppelin on a Hortonworks Data Platform (HDP) Sandbox.

### Prerequisites

This tutorial is a part of series of hands-on tutorials to get you started with HDP using Hortonworks Sandbox. Please ensure you complete the prerequisites before proceeding with this tutorial.

*   Downloaded and Installed latest [Hortonworks Sandbox](http://hortonworks.com/products/hortonworks-sandbox/#install)

**Note**: if you are attending a Meetup/Crash Course your speaker/instructor might have additional instructions regarding the Sandbox VM image.

*   [Learning the Ropes of the Hortonworks Sandbox](http://hortonworks.com/hadoop-tutorial/learning-the-ropes-of-the-hortonworks-sandbox/)

### Concepts

The core concepts on RDDs, DataFrames, and Spark Streaming are introduced in the lab itself. In this tutorial we will focus instead on how to get you started with Sandbox and explore basics of Apache Ambari and Apache Zeppelin to get you quickly up and running with the lab.

### Setup

#### 1. Start your Sandbox

First, start your Sandbox Virtual Machine (VM) in either a VirtualBox/VMware environment and note your VM IP address.

We will refer to your VM IP address as `<HOST IP>` throughout this tutorial.

If you need help finding your `<HOST IP>` checkout [Learning the Ropes](http://hortonworks.com/hadoop-tutorial/learning-the-ropes-of-the-hortonworks-sandbox/#learn-host-address-environment).

#### 2. Launch "Shell in a Box"

Now that your Sandbox is running, open a web browser and go to: `http://<HOST IP>:4200`

Where `<HOST IP>` is the IP address of your Sandbox machine.

For example, the default address for **VirtualBox** is http://127.0.0.1:4200

Next, log into "Shell in a Box" using the following *default* credentials: <br>
**User**: `root`<br>
**Pass**: `hadoop`

**Note**: if you’re logging for the first time you will be required to change your password.

#### 3. Download Latest Zeppelin Notebooks

Now that you are logged into the "Shell in a Box", copy and paste the following script and hit `Enter`:

~~~
curl -sSL https://raw.githubusercontent.com/hortonworks-gallery/zeppelin-notebooks/master/update_all_notebooks.sh | sudo -u zeppelin -E sh
~~~

This will download the latest Zeppelin notebooks from the [Hortonworks Zeppelin Notebook Gallery](https://github.com/hortonworks-gallery/zeppelin-notebooks).

#### 4. Launch Zeppelin

In your web browser, open another tab and go to: `http://<HOST IP>:9995`

Where `<HOST IP>` is the IP address of your Sandbox machine.

For example, the default address for **VirtualBox** is http://127.0.0.1:9995

#### 5. Open a Zeppelin Lab Notebook

At this point you should see the following Zeppelin interface:

TODO: Add Zeppelin Main List Screenshot

Click on the "Lab 102: Apache Spark with Zeppelin (Scala)" to open the notebook.

Once the notebook is open you are ready to proceed with the lab.
