---
layout: tutorial
title: Learning the Ropes of the Hortonworks Sandbox
tutorial-id: 160
tutorial-series: Introduction
tutorial-version: hdp-2.4.0
intro-page: true
components: [ ambari ]
---

# Learning the Ropes of the Hortonworks Sandbox

### Introduction

This tutorial is aimed for users who do not have much experience in using the Sandbox. 
We will install and explore the Sandbox on virtual machine and cloud environments. We will also navigate the Ambari user interface.
Let's begin our Hadoop journey.

## Pre-Requisites
- Downloaded and Installed [Hortonworks Sandbox](http://hortonworks.com/products/hortonworks-sandbox/#install)

## Outline
- [What is the Sandbox?](#what-is-the-sandbox)
- [Step 1: Explore the Sandbox in a VM](#explore-sandbox-vm)
      - [1.1 Install the Sandbox](#install-sandbox)
      - [1.2 Learn the Host Address of Your Environment](#learn-host-address-environment)
      - [1.3 Connect to the Welcome Screen](#connect-to-welcome-screen)
      - [1.4 Multiple Ways to Execute Terminal Commands(SSH, Web Shell, VM Shell)](#ways-execute-terminal-command)
- [Step 2: Explore Ambari](#explore-ambari)
      - [2.1 Use Terminal to Find the Host IP Sandbox Runs On](#find-host-ip-sandbox-runs-on)
      - [Services Provided By the Sandbox](#services-provided-by-sandbox)
      - [2.2 Setup Ambari admin Password Manually](#setup-ambari-admin-password)
      - [2.3 Explore Ambari Welcome Screen 5 Key Capabilities](#explore-ambari-welcome-screen)
      - [2.4 Explore Ambari Dashboard Links](#explore-ambari-dashboard)
- [Step 3: Troubleshoot Problems](#troubleshoot-problems)
      - [3.1 Technique for Finding Answers in HCC](#technique-for-finding-answers-hcc)
- [Further Reading](#further-reading)

## What is the Sandbox? <a id="what-is-the-sandbox"></a>

The Sandbox is a straightforward, pre-configured, learning environment that contains the latest developments from Apache Hadoop Enterprise, specifically Hortonworks Data Platform (HDP) Distribution. The Sandbox comes packaged in a virtual environment that can run in the cloud or on your personal machine. The Sandbox allows you to learn and explore HDP on your own.

### Step 1: Explore the Sandbox in a VM <a id="explore-sandbox-vm"></a>

#### 1.1 Install the Sandbox <a id="install-sandbox"></a>

Start the HDP Sandbox following the [Installation Steps](http://hortonworks.com/products/hortonworks-sandbox/#install) to start the VM.

![Lab0_1](/assets/learning-the-ropes-of-the-hortonworks-sandbox/install_hortonworks_sandbox_learning_ropes.png)

> **Note:** The Sandbox [system requirements](http://hortonworks.com/products/hortonworks-sandbox/#install) include that you have a 64 bit OS with at least 8 GB of RAM and enabled BIOS for virtualization. Find out about the newest features, known and resolved issues along with other updates on HDP 2.4 from the [release notes](http://hortonworks.com/wp-content/uploads/2015/10/ReleaseNotes_10_27_2015.pdf). The Sandbox on Azure is under construction and will update to HDP2.4 soon.

#### 1.2 Learn the Host Address of Your Environment <a id="learn-host-address-environment"></a>

Once you have installed the Sandbox VM, it resolves to the host on your environment, the address of which varies depending upon the Virtual Machine you are using(Vmware, VirtualBox etc). As, a general thumb rule, wait for the installation to complete and confirmation screen will tell you the host your sandbox resolves to. For example:

In case of VirtualBox: `host` would be `127.0.0.1`

![Host Address of Sandbox Environment](/assets/learning-the-ropes-of-the-hortonworks-sandbox/learn_host_address_learning_the_ropes_sandbox.png)

> **Note:** In case of Azure, your **host** can be found under **Public IP Address** on the dashboard. For further clarification, check out our guide for [Deploying Hortonworks Sandbox on Azure](http://hortonworks.com/hadoop-tutorial/deploying-hortonworks-sandbox-on-microsoft-azure/).

If you are using a private cluster or a cloud to run sandbox. Please find the host your sandbox resolves to.

#### 1.3 Connect to the Welcome Screen <a id="connect-to-welcome-screen"></a>

Append the port number :8888 to your host address, open your browser, and access Sandbox Welcome page at `http://_host_:8888/.`

![Sandbox Welcome Screen](/assets/learning-the-ropes-of-the-hortonworks-sandbox/sandbox_welcome_page_learning_the_ropes_sandbox.png)

#### 1.4 Multiple Ways to Execute Terminal Commands <a id="ways-execute-terminal-command"></a>

> **Note:** For all methods below, the login credential instructions will be the same to access the Sandbox through the terminal.
- Login using username as **root** and password as **hadoop**. 
- After first time login, you will be prompted to retype your current password, then change your password. 

##### Secure Shell (SSH) Method:

Open your terminal (mac and linux) or putty (windows). Type the following command to access the Sandbox through SSH:

~~~
# Usage:
      ssh <username>@<hostname> -p <port>;
# Example:
      ssh root@127.0.0.1 -p 2222;
~~~

![Mac Terminal SSH](/assets/learning-the-ropes-of-the-hortonworks-sandbox/secure_shell_sandbox_learning_the_ropes_sandbox.png)

> Mac OS Terminal

##### Shell Web Client Method: 

Open your web browser. Type the following text into your browser to access the Sandbox through the shell:

~~~
# Usage:
    #  _host_:4200
Example:
      127.0.0.1:4200
~~~

![Shell in the Browser Sandbox](/assets/learning-the-ropes-of-the-hortonworks-sandbox/browser_shell_learning_ropes_sandbox.png)

> Appearance of Web Shell

##### VM Terminal Method: 

Open the Sandbox through Virtualbox or VMware. The Sandbox VM Welcome Screen will appear. For Linux/Windows users, press `Alt+F5` and for Mac, press `Fn+Alt+F5` to login into the Sandbox VM Terminal.

![Shell VM Terminal Sandbox](/assets/learning-the-ropes-of-the-hortonworks-sandbox/vm_terminal_sandbox_learning_ropes_sandbox.png)

> VirtualBox VM Terminal

### Step 2: Explore Ambari <a id="explore-ambari"></a>

Navigate to Ambari welcome page using the **url** given on Sandbox welcome page.

> **Note:** Both the username and password to login are **maria_dev**.

#### 2.1 Use Terminal to Find the Host IP Sandbox Runs On <a id="find-host-ip-sandbox-runs-on"></a>

If you want to search for the host address your sandbox is running on, ssh into the sandbox terminal upon successful installation and follow subsequent steps:

1.  login using username as **root** and password as **hadoop**.
2.  Type `ifconfig` and look for **inet addr:** under eth0.
3.  Use the inet addr, append **:8080** and open it into a browser. It shall direct you to Ambari login page.
4.  This inet address is randomly generated for every session and therefore differs from session to session.

![Host_Address_Sandbox_Runs_On](/assets/learning-the-ropes-of-the-hortonworks-sandbox/find_host_sandbox_runs_on_learning_the_ropes_sandbox.png)


##### Services Provided By the Sandbox <a id="services-provided-by-sandbox"></a>

| Service | URL | 
|---------|-----|
| Sandbox Welcome Page | [http://_host_:8888]()|
| Ambari Dashboard | [http://_host_:8080]()|
| Ambari Welcome | [http://_host_:8080/views/ADMIN_VIEW/2.2.1.0/INSTANCE/#/]()|
| Hive User View | [http://_host_/#/main/views/HIVE/1.0.0/AUTO_HIVE_INSTANCE]()|
| Pig User View | [http://_host_:8080/#/main/views/PIG/1.0.0/Pig]()|
| File User View | [http://_host_:8080/#/main/views/FILES/1.0.0/Files]()|
| SSH Web Client | [http://_host_:4200]()|
| Hadoop Configuration | [http://_host_:50070/dfshealth.html]()   [http://_host_:50070/explorer.html]() |


##### The following Table Contains Login Credentials:


| Service | User | Password |
|---------|------|----------|
| Ambari | maria_dev | maria_dev |
| Ambari | admin | refer to [section 2.2](#setup-ambari-admin-password) |
| Linux OS | root | hadoop |

#### 2.2 Setup Ambari admin Password Manually <a id="setup-ambari-admin-password"></a>

1. Start your sandbox and open a terminal (mac or linux) or putty (windows)
2. SSH into the sandbox as root using `ssh root@127.0.0.1 -p 2222`. For Azure and VMware users, your `_host_` and `_port_` will be different.
3. Type the following commands:

~~~
# Updates password
ambari-admin-password-reset
# If Ambari doesn't restart automatically, restart ambari service
ambari-agent restart
~~~

> **Note:** Now you can login to ambari as an admin user to perform operations, such as starting and stopping services.

![Terminal Update Ambari admin password](/assets/learning-the-ropes-of-the-hortonworks-sandbox/terminal_update_ambari_password_learning_the_ropes_sandbox.png)

#### 2.3 Explore Ambari Welcome Screen 5 Key Capabilities <a id="explore-ambari-welcome-screen"></a>

Enter the **Ambari Welcome URL** and then you should see a similar screen:

![Lab0_3](/assets/learning-the-ropes-of-the-hortonworks-sandbox/ambari_welcome_learning_the_ropes_sandbox.png)

1.  “**Operate Your Cluster**” will take you to the Ambari Dashboard which is the primary UI for Hadoop Operators
2.  “**Manage Users + Groups**” allows you to add & remove Ambari users and groups
3.  “**Clusters**” allows you to grant permission to Ambari users and groups
4.  “**Ambari User Views**” list the set of Ambari Users views that are part of the cluster
5.  “**Deploy Views**” provides administration for adding and removing Ambari User Views

#### 2.4 Explore Ambari Dashboard Links <a id="explore-ambari-dashboard"></a>

Enter the **Ambari Dashboard URL** and you should see a similar screen:

![Lab0_4](/assets/hello-hdp/Lab0_4.png)


Click on

1.  **Metrics**, **Heatmap** and **Configuration**

and then the

2.  **Dashboard**, **Services**, **Hosts**, **Alerts**, **Admin** and User Views icon (represented by 3×3 matrix ) to become familiar with the Ambari resources available to you.

### Step 3: Troubleshoot Problems <a id="troubleshoot-problems"></a>

Check [Hortonworks Community Connection](http://hortonworks.com/community/forums/)(HCC) for answers to problems you may come across during your hadoop journey.

![Hortonworks Community Connection Main Page](/assets/learning-the-ropes-of-the-hortonworks-sandbox/hcc_page_learning_the_ropes_sandbox.png)

#### 3.1 Technique for Finding Answers in HCC <a id="technique-for-finding-answers-hcc"></a>
- Insert quotes around your tutorial related problem
- Be specific by including keywords (error, tutorial name, etc.)

## Further Reading <a id="further-reading"></a>

- To learn more about Hadoop please explore the [HDP Getting Started documentation](http://docs.hortonworks.com/HDPDocuments/HDP2/HDP-2.2.4/bk_getting-started-guide/content/ch_about-hortonworks-data-platform.html).
- To get started with Hortonworks Data Platform, explore [Hadoop Tutorial-Getting Started with HDP](http://hortonworks.com/hadoop-tutorial/hello-world-an-introduction-to-hadoop-hcatalog-hive-and-pig/)
- If you have questions, feedback or need help getting your environment ready visit  [developer.hortonworks.com](http://hortonworks.com/developer/).
- Please also explore the [HDP documentation](http://docs.hortonworks.com/).
