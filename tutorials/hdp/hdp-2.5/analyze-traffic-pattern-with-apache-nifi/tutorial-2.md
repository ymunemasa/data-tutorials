---
title: Analyze Traffic Pattern with Apache NiFi
tutorial-id: 640
platform: hdp-2.5.0
tags: [nifi]
---

# Tutorial 0: Set-Up NiFi Environment

## Introduction

In this tutorial, you learn about the NiFi environment, how to install NiFi onto Hortonworks Sandbox or on a local machine, and how to start NiFi.

## Prerequisites
-   Completed Learning the Ropes of Apache NiFi-Introduction.
-   Downloaded and installed [Hortonworks Sandbox](https://hortonworks.com/products/sandbox/). (Required for Section 2 and 3 for NiFi installation.)
-   If on mac or linux, add an IP and `sandbox.hortonworks.com` to your `/private/etc/hosts` file
-   If on windows 7, add an IP and `sandbox.hortonworks.com` to your `C://Windows/System32/Drivers/etc/hosts` file
-   For Windows users, download [Git Bash](https://openhatch.org/missions/windows-setup/install-git-bash) to run Linux terminal commands in these tutorials.

The following terminal commands in the tutorial instructions are performed in VirtualBox Sandbox and Mac machine. For windows users, to run the following terminal commands, download [Git Bash](https://openhatch.org/missions/windows-setup/install-git-bash).

If on mac or linux, to add `sandbox.hortonworks.com` to your list of hosts, open the terminal, enter the following command, replace {Host-Name} with the appropriate host for your sandbox:

~~~bash
echo '{Host-Name} sandbox.hortonworks.com' | sudo tee -a /private/etc/hosts
~~~

If on windows 7, to add `sandbox.hortonworks.com` to your list of hosts, open git bash, enter the following command, replace {Host-Name} with the appropriate host for your sandbox:

~~~bash
echo '{Host-Name} sandbox.hortonworks.com' | tee -a /c/Windows/System32/Drivers/etc/hosts
~~~

## Outline
-   [Section 0: Explore NiFi Environment Before NiFi Installation](#explore-nifi-environment)
    -   [0.A Plan to Install HDF 2.0 on Sandbox](#install-hdf-on-sandbox)
    -   [0.B Plan to Install HDF 2.0 on Local Machine](#install-hdf-on-machine)
-   [Section 1: Setup NiFi on Local Machine](#setup-nifi-locally)
    -   [Step 1: Download and Install NiFi Locally](#download-nifi-machine)
    -   [Step 2: Start NiFi](#start-nifi-locally)
-   [Section 2: Setup NiFi on Sandbox by Ambari Wizard](#nifi-ambari-wizard)
    -   [Step 1: Install NiFi By Ambari Wizard](#install-NiFi-ambari)
    -   [Step 2: Start NiFi via Ambari Service](#start-nifi-ambari)
-   [Section 3: Setup NiFi on Sandbox By CLI](#setup-nifi-sandbox)
    -   [Step 1: Install NiFi By Sandbox Shell](#install-NiFi-cli)
    -   [Step 2: Start NiFi via Sandbox Shell](#start-nifi-cli)
    -   [Step 3A: Forward Port with VirtualBox GUI](#forward-port-virtualbox)
    -   [Step 3B: Forward Port with Azure GUI](#forward-port-azure)
-   [Summary](#summary)
-   [Appendix A: Troubleshoot NiFi Installation](#troubleshoot-nifi-installation)

## Section 0: Explore NiFi Environment Before NiFi Installation <a id="explore-nifi-environment"></a>

FOr this tutorial you can run NiFi inside a single virtual machine or on your local computer. This version of the tutorial instructions are based on [Hortonworks DataFlow 2.0 GZipped](https://hortonworks.com/downloads/). There are 2 ways to download and install HDF 2.0: Option 1 on a Hortonworks Sandbox 2.5 Virtual Image (via Ambari Wizard, Sandbox Shell) or Option 2 on your local machine. HDF comes in 2 versions with only **NiFi** or with **NiFi, Kafka, Storm, and Zookeeper**. For this tutorial series, you should download HDF with NiFi only. The necessary components are:
-   HDF 2.0 (NiFi only)
-   Internet Access

### 0.A Plan to Install HDF 2.0 on HDP Sandbox <a id="install-hdf-on-sandbox"></a>

If you plan to install HDF on Hortonworks Sandbox, review the table, and proceed to step 2.

**Table 1: Hortonworks Sandbox VM Information**

| Parameter  | Value (VirtualBox)  | Value(VMware)  | Value(MS Azure)  |
|:---|:---:|:---:|---:|
| Host Name  | 127.0.0.1  | 172.16.110.129  | 23.99.9.233  |
| Port  | 2222  | 2222  | 22  |
| Terminal Username  | root  | root  | {username-of-azure}  |
| Terminal Password  | hadoop  | hadoop  | {password-of-azure}  |

> Note: **Host Name** values are unique for VMware & Azure Sandbox compared to the table. For VMware and VirtualBox, **Host Name** is located on the Sandbox Welcome screen. For Azure, **Host Name** is located under **Public IP Address** on the Sandbox Dashboard. For Azure users, you created the terminal **username** and **password** while deploying the Sandbox on Azure. For VMware and VirtualBox users, you change the terminal password after first login.

If it is your first time using the Sandbox VM, you might be prompted to change the default 'hadoop' password. Run the following command and provide a stronger password:

~~~
ssh -p 2222 root@sandbox.hortonworks.com
root@localhost's password:
You are required to change your password immediately (root enforced)
Last login: Wed Jun 15 19:47:44 2016 from 10.0.2.2
Changing password for root.
(current) UNIX password:
New password:
Retype new password:
[root@sandbox ~]#
~~~

### 0.B Plan to Install HDF 2.0 on Local Machine <a id="install-hdf-on-machine"></a>

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

Version 2 comes with Ambari, Ranger, NiFi, Kafka, Storm and Zookeeper
- This version is available in Hortonworks Documentation

There are 2 ways to install the NiFi Service by local machine, Hortonworks
Sandbox via Ambari Service Wizard or Sandbox Shell.

## Section 1: Setup NiFi on Local Machine <a id="setup-nifi-locally"></a>

### Step 1: Download and Install NiFi Locally <a id="download-nifi-machine"></a>

1\. Open a browser. Download NiFi from [HDF Downloads Page](https://hortonworks.com/downloads/). You will see four HDF download links. We will download the **NiFi only** option. There are two package options: one for HDF TAR.GZ file tailored to Linux and zip file more compatible with Windows. Mac can use either option. In this tutorial section, download the zip on a Mac:

![download_hdf_iot](assets/lab0-download-install-start-nifi/download-hdf-learn-ropes-nifi.png)

2\. After downloading NiFi, it will be in a compressed format. To install NiFi, extract the files from the compressed file to a location in which you want to run the application. For the tutorial, we moved the extracted HDF folder to the `Applications` folder.

The image below shares NiFi downloaded and installed in the Applications folder:

![download_install_nifi](assets/lab0-download-install-start-nifi/download_install_nifi.png)

### Step 2: Start NiFi Locally <a id="start-nifi-locally"></a>

If you downloaded and installed NiFi on your local machine, use this step to start NiFi.

There are 3 methods to start NiFi: launch NiFi in foreground, in the background or as a service. See the [HDF Install and Setup Guide](http://docs.hortonworks.com/HDPDocuments/HDF1/HDF-1.2.0.1/bk_HDF_InstallSetup/content/starting-nifi.html) to learn more.

1\. To start NiFi in the background, open a terminal window or git bash, navigate to NiFi installation directory ,`Applications` folder, and enter:

~~~bash
./HDF-2.0.0.0/nifi/bin/nifi.sh start
~~~

2\. Open NiFi at `http://sandbox.hortonworks.com:8080/nifi/`. Wait 1 to 2 minutes for NiFi to load.

Now that you started NiFi, review the [conclusion](#conclusion-lab0) and then we can move onto the tutorial 1.

## Section 2: Setup NiFi on Sandbox by Ambari Wizard <a id="nifi-ambari-wizard"></a>

### Step 1: Install NiFi By Ambari Wizard <a id="install-NiFi-ambari"></a>

Use the following steps to perform the NiFi installation:

1\. SSH into the Sandbox VM:

~~~bash
ssh root@sandbox.hortonworks.com -p 2222
~~~

> Note: You should receive a success message.

2\. Login into Ambari as admin. In the left sidebar of services, click on the **Actions** button. A drop down menu appears, select the **Add Service** button ![add_service](assets/lab0-download-install-start-nifi/add_service.png). The **Add Service Wizard** window will appear.

![add_service_wizard](assets/lab0-download-install-start-nifi/add_service_wizard.png)

Choose the NiFi service:

![select_nifi_service](assets/lab0-download-install-start-nifi/select_nifi_service.png)

3\. Once NiFi box is checked, select the **Next** button. As the the Ambari Wizard transitions to **Assign Masters**, you will see an **Error** window message ignore it. Click on the **OK** button. You will see an indicator that the **Assign Masters** page is loading, keep it's default settings and click **Next**. As the wizard transitions to **Assign Slaves and Clients**, a **Validation Issues** window will appear, select **Continue Anyway**. The wizard will continue onto the next setup settings called **Customize Services**. Keep it's default settings, click **Next**. A **Consistency Check Failed** window will appear, click **Proceed Anyway** and you will proceed to the **Review** section.

4\. For the **Review** section, you will see a list of repositories, select **Deploy->**.

![review_section_nifi](assets/lab0-download-install-start-nifi/review_section_nifi.png)

> Note: you should see a preparing to deploy message.

5\. The wizard will transition to the **Install, Start and Test** section. Click **Next**.

![install_started_service_success](assets/lab0-download-install-start-nifi/install_started_service_success.png)

6\. At the Summary section, you see an **Important** alert, which states that we should restart services that contain **restart indicators** in the left sidebar of Ambari Services on the Ambari Dashboard. Click **Continue->**.

![summary_section_wizard](assets/lab0-download-install-start-nifi/summary_section_wizard.png)

7\. Upon a successful installation, you should see a new services listed with a **green check symbol** next to the service name. This check symbol also indicates that NiFi is running.

![service_installed_succesfully](assets/lab0-download-install-start-nifi/service_installed_succesfully.png)

> Note: If you run into any issues installing NiFi using the Ambari Wizard, refer to Appendix A.

### Step 2: Start NiFi via Ambari Service <a id="start-nifi-ambari"></a>

If NiFi is not already running, we will use Ambari Service Tool to launch NiFi.

1\. Click on NiFi located in the left sidebar of Ambari Services on the Dashboard.

2\. Select the **Action Services** button, click **Start** to activate NiFi.

![start_nifi_button](assets/lab0-download-install-start-nifi/start_nifi_button.png)

>Note: Once the service successfully started you should see a **green check symbol** next to the name of the service.

3\. Open NiFi at `http://sandbox.hortonworks.com:9090/nifi/`. Wait 1 to 2 minutes for NiFi to load.

![open_nifi_html_interface](assets/lab0-download-install-start-nifi/open_nifi_html_interface.png)

Now that you started NiFi, review the [conclusion](#conclusion-lab0) and then we can move onto the tutorial 1.

## Section 3: Setup NiFi on Sandbox By CLI <a id="setup-nifi-sandbox"></a>

### Step 1: Install NiFi By Sandbox Shell <a id="install-NiFi-cli"></a>

Use the following steps to guide you through the NiFi installation:

1\. Open a terminal window (Mac and Linux) or git bash (Windows) on **sandbox**.

~~~bash
ssh root@sandbox.hortonworks.com -p 2222
~~~

2\. Download the **jdkinstall_nifi.sh** file from the github repo. Copy & paste the following commands:

~~~bash
cd
wget https://raw.githubusercontent.com/hortonworks/data-tutorials/40f2357dc6a6b847e180d50d21f5a858526f81a9/tutorials/hdp/hdp-2.5/analyze-traffic-pattern-with-apache-nifi/assets/jdkinstall_nifi.sh
chmod +x ./jdkinstall_nifi.sh
~~~

3\. Let's navigate back to our local machine. Open a browser. Download NiFi from [HDF Downloads Page](https://hortonworks.com/downloads/). There are two package options: one for HDF TAR.GZ file tailored to Linux and ZIP file more compatible with Windows. Mac can use either option. For the tutorial,  download the latest HDF TAR.GZ:

![download_hdf_iot](assets/lab0-download-install-start-nifi/download-hdf-learn-ropes-nifi.png)

4\. Now we need to send NiFi from our local machine to the sandbox virtual machine.
Open a terminal for your local machine. If your HDF program was downloaded to the
**Downloads** folder, navigate to it. `cd ~/Downloads`, then we can perform
the transport.

~~~bash
scp -P 2222 HDF-2.0.0.0-579.tar.gz root@sandbox.hortonworks.com:/root
~~~

> Note: For VMware and Azure users, the sandbox IP address may be different, so replace 127.0.0.1 with your appropriate IP. Use the ssh-port provided in Table 1. hdf-version is the digits in the tar.gz name you downloaded, for example the numbers in bold HDF-**2.0.0.0-579**.tar.gz. If your HDF version number is different, replace the number in the example with the number you have.

5\. Next, we have to extract the HDF gzipped tar file. Run the following command from the Sandbox terminal:

~~~bash
tar xvf /root/HDF-2.0.0.0-579.tar.gz
~~~

6\. Now the nifi install script we downloaded earlier, comes back. Run the script from your sandbox terminal:

~~~bash
./jdkinstall_nifi.sh
~~~

If you installed NiFi using command line approach, you can move onto **Step 3**.

### Step 2: Start NiFi via Sandbox Shell <a id="start-nifi-cli"></a>

In this tutorial, launch NiFi in the background.

1\. Open a terminal (Mac and Linux) or git bash (Windows). SSH into the Hortonworks Sandbox:

~~~bash
ssh root@127.0.0.1 -p 2222
~~~

2\. Navigate to the `bin` directory using the following command:

~~~bash
cd hdf/HDF-2.0.0.0/nifi/bin
~~~

3\. Run the `nifi.sh` script to start NiFi:

~~~bash
./nifi.sh start
~~~

> Note: To stop NiFi, type `./nifi.sh stop`

Open the NiFi DataFlow at `http://sandbox.hortonworks.com:9090/nifi/` to verify NiFi started. Wait 1 minute for NiFi to load. If NiFi HTML interface does not load, verify the value in the nifi.properties file matches **nifi.web.http.port=9090**.

4\. Navigate to the **conf** folder and open nifi.properties in the vi editor.

~~~bash
cd ../conf
vi nifi.properties
~~~

5\. Type `/nifi.web.http.port` and press enter. Verify `9090` is the value of nifi.web.http.port as below, else change it to this value:

~~~bash
nifi.web.http.port=9090
~~~

To exit the vi editor, press `esc` and then enter `:wq` to save the file.
Now that the configuration in the nifi.properties file is updated, port forward a new NiFi port because the VM is not listening for the port **9090**, so NiFi does not load on the browser. If you are a **VirtualBox Sandbox user, refer to step 3A**. For **Azure Sandbox users, refer to step 3B**.

### Step 3A: Forward Port with VirtualBox GUI <a id="forward-port-virtualbox"></a>

1\. Open VirtualBox Manager

2\. Right-click your running Hortonworks Sandbox, and select **settings**.

3\. Go to the **Network** Tab

Click the button that says **Port Forwarding**. Overwrite NiFi entry with the following values:

| Name  | Protocol  | Host IP  | Host Port  | Guest IP  | Guest Port  |
|:---|:---:|:---:|:---:|:---:|---:|
| NiFi  | TCP  | 127.0.0.1  | 9090  |   | 9090  |

![port_forward_nifi_iot](assets/lab0-download-install-start-nifi/port_forward_nifi_iot.png)

4\. Open NiFi at `http://sandbox.hortonworks.com:9090/nifi/`. Wait 1 to 2 minutes for NiFi to load.

> Note: If you have not configured the `sandbox.hortonworks.com` alias in `/etc/hosts`, try the `http://localhost:9090/nifi` URL as well.

Now that you started NiFi, review the [conclusion](#conclusion-lab0) and then we can move onto the tutorial 1.

### Step 3B: Forward Port with Azure GUI <a id="forward-port-azure"></a>

1\. Open Azure Sandbox.

2\. Click the Sandbox with the **shield icon**.

![shield-icon-security-inbound.png](assets/lab0-download-install-start-nifi/shield-icon-security-inbound.png)

3\. Under **Settings**, in the **General** section, click **Inbound Security Rules**.

![inbound-security-rule.png](assets/lab0-download-install-start-nifi/inbound-security-rule.png)

4\. Scroll to **NiFi**, and click on the row.

![list-nifi-port.png](assets/lab0-download-install-start-nifi/list-nifi-port.png)

5\. Verify the **Destination Port Range** value is 9090, else change it to that.

![change-nifi-port.png](assets/lab0-download-install-start-nifi/change-nifi-port.png)

6\. Open NiFi at `http://sandbox.hortonworks.com:9090/nifi/`. Wait 1 to 2 minutes for NiFi to load.

Now that you started NiFi, review the [conclusion](#conclusion-lab0) and then we can move onto the tutorial 1.

## Summary

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

![service_installed_succesfully](assets/lab0-download-install-start-nifi/service_installed_succesfully.png)
