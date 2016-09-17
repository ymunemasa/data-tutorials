---
layout: tutorial
title: Tutorial 0 Download, Install and Start NiFi
tutorial-id: 640
tutorial-series: Basic Development
tutorial-version: hdf-2.0
intro-page: false
components: [ nifi ]
---

# Tutorial 0: Download, Install, and Start NiFi

## Introduction

In this tutorial, you learn about the NiFi environment, how to install NiFi onto Hortonworks Sandbox or on a local machine, and how to start NiFi.

## Pre-Requisites
- Completed Learning the Ropes of Apache NiFi-Introduction.
- Downloaded and installed [Hortonworks Sandbox](http://hortonworks.com/products/sandbox/). (Required for Step 2, Option 1 for NiFi installation.)
- For Windows users, download [Git Bash](https://openhatch.org/missions/windows-setup/install-git-bash) to run Linux terminal commands in these tutorials.
- If on mac or linux, added `sandbox.hortonworks.com` to your `/private/etc/hosts` file
- If on windows 7, added `sandbox.hortonworks.com` to your `/c/Windows/System32/Drivers/etc/hosts` file

The following terminal commands in the tutorial instructions are performed in VirtualBox Sandbox and Mac machine. For windows users, to run the following terminal commands, download [Git Bash](https://openhatch.org/missions/windows-setup/install-git-bash).

If on mac or linux, to add `sandbox.hortonworks.com` to your list of hosts, open the terminal, enter the following command, replace {Host-Name} with the appropriate host for your sandbox:

~~~bash
echo '{Host-Name} sandbox.hortonworks.com' | sudo tee -a /private/etc/hosts
~~~

If on windows 7, to add `sandbox.hortonworks.com` to your list of hosts, open git bash, enter the following command, replace {Host-Name} with the appropriate host for your sandbox:

~~~bash
echo '{Host-Name} sandbox.hortonworks.com' | tee -a /c/Windows/System32/Drivers/etc/hosts
~~~

![changing-hosts-file.png](/assets/realtime-event-processing-with-hdf/lab0-nifi/changing-hosts-file.png)

## Outline
- [Step 1: Explore NiFi Environment Before NiFi Installation](#explore-nifi-environment)
  - [1.1 Plan to Install HDF 2.0 on Sandbox](#install-hdf-on-sandbox)
  - [1.2 Plan to Install HDF 2.0 on Local Machine](#install-hdf-on-machine)
- [Step 2: Download and Install NiFi on Sandbox (Option 1)](#download-nifi-sandbox)
- [Step 3: Download and Install NiFi on Local Machine (Option 2)](#download-nifi-machine)
- [Step 4: Start NiFi on Sandbox](#start-nifi-sandbox)
  - [4.1 Forward Port with VirtualBox GUI](#forward-port-virtualbox)
  - [4.2 Forward Port with Azure GUI](#forward-port-azure)
- [Step 5: Start NiFi on Local Machine](#start-nifi-locally)
- [Conclusion](#conclusion-lab0)
- [Appendix A: Troubleshoot NiFi Installation](#troubleshoot-nifi-installation)

### Step 1: Explore NiFi Environment Before NiFi Installation <a id="explore-nifi-environment"></a>

You can run NiFi inside a single virtual machine or on your local computer. This version of the tutorial instructions are based on [Hortonworks DataFlow 2.0 GZipped](http://hortonworks.com/downloads/). There are 2 ways to download and install HDF 2.0: Option 1 on a Hortonworks Sandbox 2.4 Virtual Image or Option 2 on your local machine. HDF comes in 2 versions with only NiFi or with NiFi, Kafka, Storm, and Zookeeper. For this tutorial series, you should download HDF with NiFi only. The necessary components are:
- HDF 2.0 (NiFi only)
- Internet Access

### 1.1 Plan to Install HDF 2.0 on Sandbox <a id="install-hdf-on-sandbox"></a>

If you plan to install HDF on Hortonworks Sandbox, review the table, and proceed to step 2.

**Table 1: Hortonworks Sandbox VM Information**

| Parameter  | Value (VirtualBox)  | Value(VMware)  | Value(MS Azure)  |
|:---|:---:|:---:|---:|
| Host Name  | 127.0.0.1  | 172.16.110.129  | 23.99.9.233  |
| Port  | 2222  | 2222  | 22  |
| Terminal Username  | root  | root  | {username-of-azure}  |
| Terminal Password  | hadoop  | hadoop  | {password-of-azure}  |


> Note: **Host Name** values are unique for VMware & Azure Sandbox compared to the table. For VMware and VirtualBox, **Host Name** is located on the Welcome screen. For Azure, **Host Name** is located under **Public IP Address** on the Sandbox Dashboard. For Azure users, you created the terminal **username** and **password** while deploying the Sandbox on Azure. For VMware and VirtualBox users, you change the terminal password after first login.

If it is your first time using the Sandbox VM, you might be prompted to change the default 'hadoop' password. Run the following command and provide a stronger password:

~~~
ssh -p 2222 root@localhost
root@localhost's password:
You are required to change your password immediately (root enforced)
Last login: Wed Jun 15 19:47:44 2016 from 10.0.2.2
Changing password for root.
(current) UNIX password:
New password:
Retype new password:
[root@sandbox ~]#
~~~

### 1.2 Plan to Install HDF 2.0 on Local Machine <a id="install-hdf-on-machine"></a>

You should read this section if you plan to install NiFi on your local machine. Once you have verified that your machine meets system requirements, proceed to Step 3.

Does your system meet HDF's installation requirements?

Supported OS for HDF Installation:
- Linux Red Hat/Cent OS 6 or 7) 64-bit
- Ubuntu 12.04 or 14.04 64-bit
- Debian 6 or 7
- SUSE Enterprise 11-SP3
- MAC OS X
- Windows OS

Supported Browsers:
- Mozilla Firefox latest
- Google Chrome latest
- MS Edge
- Safari 8

Supported JDKS:
- Open JDK7 or JDK8
- Oracle JDK 7 or JDK 8

Supported HDP Versions that Interoperate with HDF:
- HDP 2.3.x
- HDP 2.4.x
- HDP 2.5.x

Two Versions of HDF

Version 1 only comes with NiFi.
- On the Hortonworks HDF downloads page, version 1 is available.

Version 2 comes with NiFi, Kafka, Storm and Zookeeper
- This version is available in Hortonworks Documentation

### Step 2: Download and Install NiFi on Hortonworks Sandbox (Option 1) <a id="download-nifi-sandbox"></a>
This tutorial uses Hortonworks Sandbox 2.5.

NiFi is installed on the Hortonworks Sandbox VirtualBox image because the Sandbox does not come with NiFi preinstalled.

Use the following steps to perform the NiFi installation:

1\. SSH into the Sandbox VM:

~~~bash
ssh root@127.0.0.1 -p 2222
~~~

2\. Run the following commands in Sandbox terminal to download the latest version of NiFi into the Ambari Stack.

~~~bash
cd /var/lib/ambari-server/resources/stacks/HDP/2.5/services/NIFI
git fetch --all
git reset --hard origin/master
service ambari-server restart
~~~

> Note: You should receive a success message.

3\. Open Ambari. In the left sidebar of services, click on the **Actions** button. A drop down menu appears, select the **Add Service** button ![add_service](/assets/learning-ropes-nifi-lab-series/lab0-download-install-start-nifi/add_service.png). The **Add Service Wizard** window will appear.

![add_service_wizard](/assets/learning-ropes-nifi-lab-series/lab0-download-install-start-nifi/add_service_wizard.png)

Choose the NiFi service:

![select_nifi_service](/assets/learning-ropes-nifi-lab-series/lab0-download-install-start-nifi/select_nifi_service.png)

4\. Once NiFi box is checked, select the **Next** button. As the the Ambari Wizard transitions to **Assign Masters**, you will see an **Error** window message ignore it. Click on the **OK** button. You will see an indicator that the **Assign Masters** page is loading, keep it's default settings and click **Next**. As the wizard transitions to **Assign Slaves and Clients**, a **Validation Issues** window will appear, select **Continue Anyway**. The wizard will continue onto the next setup settings called **Customize Services**. Keep it's default settings, click **Next**. A **Consistency Check Failed** window will appear, click **Proceed Anyway** and you will proceed to the **Review** section.

5\. For the **Review** section, you will see a list of repositories, select **Deploy->**.

![review_section_nifi](/assets/learning-ropes-nifi-lab-series/lab0-download-install-start-nifi/review_section_nifi.png)

> Note: you should see a preparing to deploy message.

6\. The wizard will transition to the **Install, Start and Test** section. Click **Next**.

![install_started_service_success](/assets/learning-ropes-nifi-lab-series/lab0-download-install-start-nifi/install_started_service_success.png)

7\. At the Summary section, you see an **Important** alert, which states that we should restart services that contain **restart indicators** in the left sidebar of Ambari Services on the Ambari Dashboard. Click **Continue->**.

![summary_section_wizard](/assets/learning-ropes-nifi-lab-series/lab0-download-install-start-nifi/summary_section_wizard.png)

8\. Upon a successful installation, you should see a **green check symbol** next to the service name. This check symbol also indicates that NiFi is running.

![service_installed_succesfully](/assets/learning-ropes-nifi-lab-series/lab0-download-install-start-nifi/service_installed_succesfully.png)

> Note: If you run into any issues installing NiFi using the Ambari Wizard, refer to Appendix A.

### Step 3: Download and Install NiFi on Local Machine (Option 2) <a id="download-nifi-machine"></a>

1\. Open a browser. Download NiFi from [HDF Downloads Page](http://hortonworks.com/downloads/). You will see four HDF download links. We will download the **NiFi only** option. There are two package options: one for HDF TAR.GZ file tailored to Linux and zip file more compatible with Windows. Mac can use either option. In this tutorial section, download the zip on a Mac:

![download_hdf_iot](/assets/learning-ropes-nifi-lab-series/lab0-download-install-start-nifi/download-hdf-learn-ropes-nifi.png)

2\. After downloading NiFi, it will be in a compressed format. To install NiFi, extract the files from the compressed file to a location in which you want to run the application. For the tutorial, we moved the extracted HDF folder to the `Applications` folder.

The image below shares NiFi downloaded and installed in the Applications folder:

![download_install_nifi](/assets/learning-ropes-nifi-lab-series/lab0-download-install-start-nifi/download_install_nifi.png)

### Step 4: Start NiFi on Sandbox <a id="start-nifi-sandbox"></a>

Use the following steps to start NiFi if you downloaded and installed it on Hortonworks Sandbox. For information about how to start NiFi on your local machine, go to step 5.

If NiFi is not already running, we will use Ambari Service Tool to launch NiFi.

1\. Click on NiFi located in the left sidebar of Ambari Services on the Dashboard.

2\. Select the **Action Services** button, click **Start** to activate NiFi.

![start_nifi_button](/assets/learning-ropes-nifi-lab-series/lab0-download-install-start-nifi/start_nifi_button.png)

>Note: Once the service successfully started you should see a **green check symbol** next to the name of the service.

3\. Open NiFi at `http://sandbox.hortonworks.com:9090/nifi/`. Wait 1 to 2 minutes for NiFi to load.

![open_nifi_html_interface](/assets/learning-ropes-nifi-lab-series/lab0-download-install-start-nifi/open_nifi_html_interface.png)

### 4.1 Forward Port with VirtualBox GUI <a id="forward-port-virtualbox"></a>

1\. Open VirtualBox Manager

2\. Right-click your running Hortonworks Sandbox, and select **settings**.

3\. Go to the **Network** Tab

Click the button that says **Port Forwarding**. Overwrite NiFi entry with the following values:

| Name  | Protocol  | Host IP  | Host Port  | Guest IP  | Guest Port  |
|:---|:---:|:---:|:---:|:---:|---:|
| NiFi  | TCP  | 127.0.0.1  | 9090  |   | 9090  |

![port_forward_nifi_iot](/assets/learning-ropes-nifi-lab-series/lab0-download-install-start-nifi/port_forward_nifi_iot.png)


4\. Open NiFi at `http://sandbox.hortonworks.com:9090/nifi/`. Wait 1 to 2 minutes for NiFi to load.

> Note: If you have not configured the `sandbox.hortonworks.com` alias in `/etc/hosts`, try the `http://localhost:9090/nifi` URL as well.

### 4.2 Forward Port with Azure GUI <a id="forward-port-azure"></a>

1\. Open Azure Sandbox.

2\. Click the Sandbox with the **shield icon**.

![shield-icon-security-inbound.png](/assets/learning-ropes-nifi-lab-series/lab0-download-install-start-nifi/shield-icon-security-inbound.png)

3\. Under **Settings**, in the **General** section, click **Inbound Security Rules**.

![inbound-security-rule.png](/assets/learning-ropes-nifi-lab-series/lab0-download-install-start-nifi/inbound-security-rule.png)

4\. Scroll to **NiFi**, and click on the row.

![list-nifi-port.png](/assets/learning-ropes-nifi-lab-series/lab0-download-install-start-nifi/list-nifi-port.png)

5\. Verify the **Destination Port Range** value is 9090, else change it to that.

![change-nifi-port.png](/assets/learning-ropes-nifi-lab-series/lab0-download-install-start-nifi/change-nifi-port.png)

6\. Open NiFi at `http://sandbox.hortonworks.com:9090/nifi/`. Wait 1 to 2 minutes for NiFi to load.


### Step 5: Start NiFi on Local Machine <a id="start-nifi-locally"></a>

If you downloaded and installed NiFi on your local machine, use this step to start NiFi.

There are 3 methods to start NiFi: launch NiFi in foreground, in the background or as a service. See the [HDF Install and Setup Guide](http://docs.hortonworks.com/HDPDocuments/HDF1/HDF-1.2.0.1/bk_HDF_InstallSetup/content/starting-nifi.html) to learn more.

1\. To start NiFi in the background, open a terminal window or git bash, navigate to NiFi installation directory ,`Applications` folder, and enter:

~~~bash
./HDF-2.0.0.0/nifi/bin/nifi.sh start
~~~

2\. Open NiFi at `http://sandbox.hortonworks.com:8080/nifi/`. Wait 1 to 2 minutes for NiFi to load.

## Conclusion <a id="conclusion-lab0"></a>

Congratulations! You learned that NiFi can be installed on a VM or directly on your computer. You also learned to download, install, and start NiFi. Now that you have NiFi is up and running, you are ready to build a dataflow.

## Appendix A: Troubleshoot NiFi Installation <a id="troubleshoot-nifi-installation"></a>

There are multiple reasons why NiFi installation could have failed. Let's check a few variables to determine a solution.

1\. In the left side-bar of Ambari Services on the Ambari Dashboard, you may see that the NiFi service has a **yellow question mark** next to its name. Click on NiFi service. Then click **Action Services** button, select **Delete Service**.

2\. Restart Ambari from the command line. Run:

~~~bash
ambari-server restart
~~~

3\. When you enter the Ambari Dashboard after the server restarted, you'll notice NiFi service is gone. Let's try to repeat the steps from **Step 2** to reinstall the NiFi.

4\. Once the service is reinstalled, if there is a **green check symbol** next to the name, then the reinstallation was successful.

![service_installed_succesfully](/assets/learning-ropes-nifi-lab-series/lab0-download-install-start-nifi/service_installed_succesfully.png)

## Further Reading
For more information on NiFi Configuration, see the [System Administrator's Guide](http://docs.hortonworks.com/HDPDocuments/HDF1/HDF-1.2.0.1/bk_AdminGuide/content/index.html).
