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

In this tutorial, we will introduce the basic concepts of Apache Spark DataFrames in a hands-on lab.

We will also introduce the necessary steps to get up and running with Apache Zeppelin on a Hortonworks Data Platform (HDP) Sandbox.

### Prerequisites

This tutorial is a part of series of hands-on tutorials to get you started with HDP using Hortonworks Sandbox. Please ensure you complete the prerequisites before proceeding with this tutorial.

*   Downloaded and Installed latest [Hortonworks Sandbox](http://hortonworks.com/products/hortonworks-sandbox/#install)

**Note**: if you are attending a Meetup/Crash Course your speaker/instructor may have additional instructions regarding the Sandbox VM image.

*   [Learning the Ropes of the Hortonworks Sandbox](http://hortonworks.com/hadoop-tutorial/learning-the-ropes-of-the-hortonworks-sandbox/)

### Concepts

The core concepts of Spark DataFrames will be introduced in the lab itself. In this tutorial we will focus instead on how to get you started with Sandbox and explore basics of Apache Zeppelin to get you quickly up and running with the lab.

### Setup

#### 1. Start your Sandbox

First, start your Sandbox Virtual Machine (VM) in either a VirtualBox or VMware environment and note your VM IP address.

We will refer to your VM IP address as `<HOST IP>` throughout this tutorial.

If you need help finding your `<HOST IP>` checkout [Learning the Ropes](http://hortonworks.com/hadoop-tutorial/learning-the-ropes-of-the-hortonworks-sandbox/#learn-host-address-environment).

#### 2. Launch a "Shell in a Box"

Now that your Sandbox is running, open a web browser and go to: `http://<HOST IP>:4200`

Where `<HOST IP>` is the IP address of your Sandbox machine.

For example, the default address for **VirtualBox** is [http://127.0.0.1:4200](http://127.0.0.1:4200)

Next, log into the "Shell in a Box" using the following *default* credentials:

~~~
User: root
Pass: hadoop
~~~

If you’re logging for the first time you will be required to change your password.

#### 3. Download Latest Zeppelin Notebooks

Now that you are logged into the "Shell in a Box", copy and paste the following script and hit `Enter`:

~~~
curl -sSL https://raw.githubusercontent.com/hortonworks-gallery/zeppelin-notebooks/master/update_all_notebooks.sh | sudo -u zeppelin -E sh
~~~

This will download the latest Zeppelin notebooks from the [Hortonworks Zeppelin Notebook Gallery](https://github.com/hortonworks-gallery/zeppelin-notebooks).

#### 4. Launch Zeppelin

In your web browser, open another tab and go to: `http://<HOST IP>:9995`

Where `<HOST IP>` is the IP address of your Sandbox machine.

For example, the default address for **VirtualBox** is [http://127.0.0.1:9995](http://127.0.0.1:9995)

#### 5. Open Zeppelin Lab Notebook

At this point you should see the following Zeppelin interface:

![](/assets/learning-spark-with-zeppelin/1-main-zeppelin-screen.png)

Click on "Lab 102: Intro to Spark with Scala" to open the notebook.

![](/assets/learning-spark-with-zeppelin/2-selecting-notebook.png)

Once the notebook is open, follow the step-by-step instructions within the notebook to complete the lab.

### Further Resources

Once you're done with the lab, make sure to checkout other Zeppelin Labs and [Spark Tutorials](http://hortonworks.com/hadoop/spark/#tutorials).
