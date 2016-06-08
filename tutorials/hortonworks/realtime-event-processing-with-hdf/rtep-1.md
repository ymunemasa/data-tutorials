# Lab0: Ingest, Route and Land Real Time Events with Apache NiFi

## Introduction

Apache NiFi can collect and transport data from numerous sources and provide interactive command and control of live flows with full and automated data provenance. We will install NiFi onto our Hortonworks Sandbox and become familiar with the NiFi Web Interface. We will create a flow of data using Hortonworks DataFlow to activate the truck stream simulator to generate truck data, remove the log data, extract the live truck events data and store the events into a file. We will use a file to verify that the correct data is being inserted into the file.

## Pre-Requisites
- Downloaded and Installed latest [Hortonworks Sandbox](http://hortonworks.com/products/hortonworks-sandbox/#install)
- If you are new to the sandbox shell, refer to [Learning the Ropes of the Hortonworks Sandbox](http://hortonworks.com/hadoop-tutorial/learning-the-ropes-of-the-hortonworks-sandbox/)
- Memory must be at least 8GB RAM, preferably 4 processor cores, else errors may occur in third tutorial
- For windows users, to run linux terminal commands in these tutorials, download [Git Bash](https://openhatch.org/missions/windows-setup/install-git-bash).
- Read Table 1 to figure out some basic details about your sandbox

**Table 1: Virtual Machine Information** <a id="table1-virtual-machine-information"></a>

| Parameter  | Value (VirtualBox)  | Value(VMware)  | Value(MS Azure)  |
|---|---|---|---|
| Host Name  | 127.0.0.1  | 172.16.110.129  | 23.99.9.233  |
| Port  | 2222  | 2222  | 22  |
| Terminal Username  | root  | root  | {username-of-azure}  |
| Terminal Password  | hadoop  | hadoop  | {password-of-azure}  |

> Note: **Host Name** values are unique for VMware & Azure Sandbox compared to the table. For VMware and VirtualBox, **Host Name** is located on welcome screen. For Azure, **Host Name** is located under **Public IP Address** on Sandbox Dashboard. For Azure users, the terminal **username** and **password** is one you created while deploying the sandbox on azure. For VMware and VirtualBox users, terminal password changes after first login.

- Added `sandbox.hortonworks.com` to your `/private/etc/hosts` file (mac and linux users)
- Added `sandbox.hortonworks.com` to your `/c/Windows/System32/Drivers/etc/hosts` file (windows 7 users)

The following terminal commands in the tutorial instructions are performed in VirtualBox Sandbox and Mac machine. For windows users, to run the following terminal commands, download [Git Bash](https://openhatch.org/missions/windows-setup/install-git-bash).

If on mac or linux, to add `sandbox.hortonworks.com` to your list of hosts, open the terminal, enter the following command:

~~~bash
echo '{Host-Name} sandbox.hortonworks.com' | sudo tee -a /private/etc/hosts
~~~

If on windows 7, to add `sandbox.hortonworks.com` to your list of hosts, open git bash, enter the following command:

~~~bash
echo '{Host-Name} sandbox.hortonworks.com' | sudo tee -a /c/Windows/System32/Drivers/etc/hosts
~~~

![changing-hosts-file.png](/assets/realtime-event-processing-with-hdf/lab0-nifi/changing-hosts-file.png)


## Outline
- [Stream simulator](#stream-simulator-lab0)
- [Step 1: Run Simulator By shell](#step1-run-simulator-shell-lab0)
- [Apache NiFi](#apache-nifi-lab0)
- [Step 2: Install NiFi](#step2-install-nifi-lab0)
- [Step 3: Start NiFi](#step3-start-nifi)
- [Step 4: Explore NiFi Web Interface](#step4-explore-nifi-interface-lab0)
- [Step 5: Create a NiFi Data Flow](#step5-create-nifi-dataflow-lab0)
- [Summary](#summary-lab0)
- [Further Reading](#further-reading-lab0)

## Tutorial Overview
- Understand the Stream Simulator
- Run Stream Simulator From Terminal
- Install and Start NiFi
- Create NiFi DataFlow to Generate and Store Truck events

## Stream Simulator <a id="stream-simulator-lab0"></a>

The stream simulator is a lightweight framework that generates truck event data. The simulator uses [New York City Truck Routes (kml)](http://www.nyc.gov/html/dot/downloads/misc/all_truck_routes_nyc.kml) which defines driver road paths with Latitude and Longitude information.

The simulator uses **[Akka](http://akka.io/)** to simplify concurrency, messaging and inheritance. It has two **[Plain Old Java Objects (POJOS)](https://en.wikipedia.org/wiki/Plain_Old_Java_Object)**, one for Trucks and another for Drivers that generate the events. Consequently, the **AbstractEventEmitter** class becomes extended while the **onReceive** method generates events, creates new **[Actors](http://doc.akka.io/docs/akka/snapshot/java/untyped-actors.html)**, sends messages to Actors and delivers those events to an **EventCollector** class. This class’s purpose is to collect events generated from the domain objects and print them to standard output. Let’s run the simulator through the terminal and see the events that are generated.

### Step 1: Run the Simulator By shell <a id="step1-run-simulator-shell-lab0"></a>

Before we run the simulator, we need to perform some shell operations to install and download the stream simulator. The following terminal commands were performed in VirtualBox Sandbox and Mac machine. For VMware and Azure users, refer to [Table 1](#table1-virtual-machine-information) in the pre-requisites section to run ssh command. For windows users, to run the following terminal commands, download [Git Bash](https://openhatch.org/missions/windows-setup/install-git-bash). The other terminal commands should be the same for VirtualBox, VMware and Azure.

### 1.1 Download & Setup The Simulator

1\. Open the terminal, if using VirtualBox copy & paste the following command to access the sandbox through the shell.

~~~
ssh root@127.0.0.1 -p 2222
~~~

For VMware and Azure users, insert the appropriate values for username, hostname and port into the SSH Definition:

~~~
ssh <username>@<hostname> -p <port>
~~~

> Note: For VMware and Azure users, the hostname is different than VirtualBox and the **hostname** can be found on the welcome screen. Refer to Table 1 for **port** number. Username for VMware and Azure is same as VirtualBox. If you need help, refer to [Learning the Ropes of the Hortonworks Sandbox](http://hortonworks.com/hadoop-tutorial/learning-the-ropes-of-the-hortonworks-sandbox/).

2\. Clone the github repo to download the truck event simulator.

~~~
cd ~
git clone https://github.com/james94/iot-truck-streaming
~~~

3\. Install Apache Maven, so we can compile the stream simulator code and run the simulator. Run the following commands:

~~~
wget http://repos.fedorapeople.org/repos/dchen/apache-maven/epel-apache-maven.repo -O /etc/yum.repos.d/epel-apache-maven.repo

yum install apache-maven
~~~

> Note: You will be prompted to allow maven to install, type 'y' for yes

After your maven package installs, you should obtain the message: Complete!

4\. Navigate to iot-truck-streaming directory.

~~~
cd iot-truck-streaming
~~~

5\. Since we are at the base of our project, let’s export our demo configurations:

~~~
sudo mkdir /etc/storm_demo
sudo cp config.properties /etc/storm_demo
sudo cp -R storm-demo-webapp/routes/ /etc/storm_demo
~~~

6\. For maven to run, it needs to detect the pom.xml file. Rename pom24.xml to pom.xml, copy/paste the commands:

~~~
mv -f storm-streaming/pom24.xml storm-streaming/pom.xml

mvn clean package
~~~

Apache Maven command: mvn clean deletes everying in the target folder. The storm-streaming contains a target folder that is impacted. The package phase of the command compiles the code and packages it into jar files according to the pom file.

> Note: packaging may take around 9 minutes.

### 1.2 Run The Simulator

1\. To test the simulator, run `generate.sh` script. Use the commands:

~~~
cd stream-simulator
chmod 750 *.sh
./generate.sh
~~~

> Note: press **ctrl+c** stop the simulator

You should see message data generated as in the image. The data includes logs as can be seen in the top portion and truck events bottom portion. We will use NiFi to separate this data.

![generate_sh_data](/assets/realtime-event-processing-with-hdf/lab0-nifi/generateSH_data_logs_truckevents_iot.png)

> Note: generate.sh runs java source code located at `iot-truck-streaming/stream-simulator/src/main/java/com/hortonworks/streaming/impl/collectors/StdOutEventCollector.java`. If you would like to see modify/run the code.

## Apache NiFi <a id="apache-nifi-lab0"></a>

[Apache NiFi](https://nifi.apache.org/docs/nifi-docs/html/overview.html#what-is-apache-nifi) is an open source tool for automating and managing the flow of data between systems. To create an effective dataflow, users must understand the various types of processors ![nifi_processor_mini](/assets/realtime-event-processing-with-hdf/lab0-nifi/processor_grey_background_iot.png). This tool is the most important building block available to NiFi because it enables NiFi to perform:

- Data Transformation
- Routing and Mediation
- Database Access
- Attribute Extraction
- System Interaction
- Data Ingestion
- Data Egress/Sending Data
- Splitting and Aggregation
- HTTP
- Amazon Web Services

NiFi is designed to help tackle modern dataflow challenges, such as system failure, data access exceeds capacity to consume, boundary conditions are mere suggestions, systems evolve at different rates, compliance and security.

### Step 2: Install NiFi <a id="step2-install-nifi-lab0"></a>

NiFi will be installed on the Hortonworks Sandbox VirtualBox image because the sandbox does not come with NiFi preinstalled.

The following instructions will guide you through the NiFi installation process. All the steps throughout the tutorial will be done using the latest Hortonworks Sandbox 2.4 on VirtualBox.

1\. Make sure to exit from sandbox shell. Type `exit`. Open a terminal on **local machine**. Download the **install-nifi.sh** file from the github repo. Copy & paste the following commands:

~~~
cd ~
curl -o install-nifi.sh https://raw.githubusercontent.com/hortonworks/tutorials/hdp/assets/realtime-event-processing/install-nifi.sh
~~~

2\. Open a browser. Navigate to `http://hortonworks.com/downloads/`, click the DataFlow next Sandbox tab and download HDF(™) 1.2.0.1: Hortonworks DataFlow tar.gz:

![download_hdf_iot](/assets/realtime-event-processing-with-hdf/lab0-nifi/download_hdf_iot.png)

3\. Run the install-nifi.sh script. Below is a definition of how the install nifi command works:

~~~
install-nifi.sh {location-of-HDF-download} {sandbox-host} {ssh-port} {hdf-version}
~~~

> Note: For VMware and Azure users, sandbox-host can be found at the welcome screen after starting your sandbox and ssh-port can be found in Table 1. hdf-version is the digits in the tar.gz name you downloaded, for example the numbers in bold HDF-**1.2.0.1-1**.tar.gz.

After you provide the file path location to HDF Gzip file, sandbox hostname, ssh port number and HDF version, your command should look similar as follows:

~~~
bash install-nifi.sh ~/Downloads/HDF-1.2.0.1-1.tar.gz localhost 2222 1.2.0.1-1
~~~

> Note: You will be asked if you want to continue the download, type `yes`. You will also be asked twice for your ssh password to install NiFi on your Hortonworks Sandbox.

The script automatically installs NiFi onto your virtual machine. After successful completion, NiFi is transported onto the Hortonworks Sandbox and the HDF folder will be located at `~` folder.

### Step 3: Start NiFi <a id="step3-start-nifi"></a>

It is time to start Apache NiFi.

1\. SSH into the Hortonworks Sandbox

~~~
ssh root@127.0.0.1 -p 2222
~~~

2\. Navigate to the `bin` directory using the following command:

~~~
cd hdf/HDF-1.2.0.1-1/nifi/bin
~~~

3\. Run the `nifi.sh` script to start NiFi:

~~~
./nifi.sh start
~~~

> Note: to stop NiFi, type `./nifi.sh stop`

Open the NiFi DataFlow at `http://sandbox.hortonworks.com:6434/nifi/` to verify NiFi started. Wait 1 minute for NiFi to load. If NiFi HTML interface doesn't load, verify the value in the nifi.properties file matches **nifi.web.http.port=6434**.

4\. Navigate to the **conf** folder and open nifi.properties in the vi editor.

~~~
cd ../conf
vi nifi.properties
~~~

5\. Type `/nifi.web.http.port` and press enter. Verify `6434` is the value of nifi.web.http.port as below, else change it to this value:

~~~
nifi.web.http.port=6434
~~~

To exit the vi editor, press `esc` and then enter `:wq` to save the file.
Now that the configuration in the nifi.properties file has been updated, we need to port forward a new port for NiFi through the Port Forward GUI because the virtual machine is not listening for the port **6434**, so NiFi will not load on the browser. If your using VirtualBox Sandbox, refer to section 3.1. For Azure Sandbox users, refer to section 3.2.

### 3.1 Forward Port with VirtualBox GUI

1\. Open VirtualBox Manager

2\. Right click your running Hortonworks Sandbox, click **settings**

3\. Go to the **Network** Tab

Click the button that says **Port Forwarding**. Overwrite NiFi entry with the following values:

| Name  | Protocol  | Host IP  | Host Port  | Guest IP  | Guest Port  |
|---|---|---|---|---|---|
| NiFi  | TCP  | 127.0.0.1  | 6434  |   | 6434  |

![port_forward_nifi_iot](/assets/realtime-event-processing-with-hdf/lab0-nifi/port_forward_nifi_iot.png)


4\. Open NiFi at `http://sandbox.hortonworks.com:6434/nifi/`. You should be able to access it now. Wait 1 to 2 minutes for NiFi to load.


### 3.2 Forward Port with Azure GUI

1\. Open Azure Sandbox.

2\. Click the sandbox with the **shield icon**.

![shield-icon-security-inbound.png](/assets/realtime-event-processing-with-hdf/lab0-nifi/shield-icon-security-inbound.png)

3\. Under **Settings**, in the **General** section, click **Inbound Security Rules**.

![inbound-security-rule.png](/assets/realtime-event-processing-with-hdf/lab0-nifi/inbound-security-rule.png)

4\. Scroll to **NiFi**, click on the row.

![list-nifi-port.png](/assets/realtime-event-processing-with-hdf/lab0-nifi/list-nifi-port.png)

5\. Change the **Destination Port Range** value from 9090 to 6434.

![change-nifi-port.png](/assets/realtime-event-processing-with-hdf/lab0-nifi/change-nifi-port.png)

6\. Open NiFi at `http://sandbox.hortonworks.com:6434/nifi/`. You should be able to access it now. Wait 1 to 2 minutes for NiFi to load.

### Step 4: Explore NiFi Web Interface <a id="step4-explore-nifi-interface-lab0"></a>

NiFi’s web interface consists of 5 components to build data flows: The **components** toolbar, the **actions** toolbar, the **management** toolbar, the **search** bar and the **help** button. View the image below for a visualization of the user interface for orchestrating a dataflow. Near the top of the UI are multiple toolbars essential for building dataflows.

![nifi_dataflow_html_interface](/assets/realtime-event-processing-with-hdf/lab0-nifi/nifi_dataflow_html_interface.png)

### Step 5: Create a NiFi DataFlow <a id="step5-create-nifi-dataflow-lab0"></a>

We can begin to build a data flow by adding, configuring and connecting the processors. We will also troubleshoot common problems that occur when creating data flows.
By the end of the IoT Lab Series, you will have built the following dataflow:

![dataflow_withKafka_running_iot](/assets/realtime-event-processing-with-hdf/lab1-kafka/dataflow_withKafka_running_iot.png)

**Figure 1:** This [IoT_Lab_Series_DataFlow.xml](https://raw.githubusercontent.com/james94/tutorials/hdp/assets/realtime-event-processing-with-hdf/IoT_Lab_Series_DataFlow.xml) dataflow performs System Interaction, Splitting and Aggregation, Attribute Extraction, Routing and Mediation and Data Egress/Sending Data.

To open the template xml in NiFi, hover over to the management toolbar and click on the template icon ![template_icon_nifi_iot](/assets/realtime-event-processing-with-hdf/lab0-nifi/template_icon_nifi_iot.png). Click on the Browse button and find the dataflow xml file that you downloaded and click open. The template should appear in your NiFi Flow Templates spreadsheet.

To display your dataflow template xml onto the screen, drag the template icon from the components toolbar onto the graph. The dataflow should appear as in the dataflow image above, except this dataflow will be missing the PutKafka processor. We will add it in the next lab.

### 5.1 Add Processors

1\. To add a processor, we will go to the components toolbar, drag and drop the processor ![processor_nifi_iot](/assets/realtime-event-processing-with-hdf/lab0-nifi/processor_nifi_iot.png) onto the graph.

An **Add Processor** window will open. There are 3 options to find our desired processor. We can scroll through the **processor list**, use the **tag cloud** to reduce the processor list by category or utilize the **filter bar** to search for our processor.

![add_processor_window](/assets/realtime-event-processing-with-hdf/lab0-nifi/add_processor_window.png)

2\. Let’s select the [ExecuteProcess](https://nifi.apache.org/docs/nifi-docs/components/org.apache.nifi.processors.standard.ExecuteProcess/index.html) processor. A short description of that processor’s function will appear.

  Runs the operating system command to activate the stream simulator and the StdOut is redirected such that the content is written to StdOut becomes the content of the outbound FlowFile.

Click the **add** button to add the processor to the graph.

![processor_description_iot](/assets/realtime-event-processing-with-hdf/lab0-nifi/processor_description_iot.png)

3\. Add the **SplitText**, **UpdateAttribute**, **RouteOnContent**, **MergeContent** and **PutFile** processors using the processor icon.

  [SplitText](https://nifi.apache.org/docs/nifi-docs/components/org.apache.nifi.processors.standard.SplitText/index.html) takes in one FlowFile whose content is textual and splits it into 1 or more FlowFiles based on the configured number of lines. Each FlowFile is 1 line.

  [UpdateAttribute](https://nifi.apache.org/docs/nifi-docs/components/org.apache.nifi.processors.attributes.UpdateAttribute/index.html) updates each FlowFile with a unique attribute name. ${UUID()}.

  [RouteOnContent](https://nifi.apache.org/docs/nifi-docs/components/org.apache.nifi.processors.standard.RouteOnContent/index.html) search content of the FlowFile to see if it matches the regex regular expression, such as (Normal), (Overspeed), (“Lane Departure”). The expressions are driving event keywords. If so, the Flowfile is routed to the processor with the configured relationship.

  [MergeContent](https://nifi.apache.org/docs/nifi-docs/components/org.apache.nifi.processors.standard.MergeContent/index.html) merges many FlowFiles into a single FlowFile. In the tutorial, each FlowFile is merged by concatenating their content together. There will be two processors: one of them will merge all the truck events into a single FlowFile while the other merges all the log data together.

  [PutFile](https://nifi.apache.org/docs/nifi-docs/components/org.apache.nifi.processors.standard.PutFile/index.html) writes the contents of a FlowFile to a directory on a local file system. There will be two processors: one that writes the filtered logs data to log_data folder. The other that writes the filtered truck event data to truck_events folder.

Follow the step above to add these processors. You should obtain a similar image as below.

![dataflow_nifi_iot](/assets/realtime-event-processing-with-hdf/lab0-nifi/dataflow_nifi_iot.png)

> Note: We will add one more MergeContent and PutFile processor into our dataflow. Continue following the steps to build the complete dataflow.

### 5.2 Troubleshoot Common Processor Issues

Notice the nine processors in the image above have warning symbols ![warning_symbol_nifi_iot](/assets/realtime-event-processing-with-hdf/lab0-nifi/warning_symbol_nifi_iot.png) in the upper left corner of the processor face. These warning symbols indicate the processors are invalid.

1\. To troubleshoot, hover over one of the processors, for instance the ExecuteProcess processor and a warning symbol will appear. This message informs us of the requirements to make this processor valid.

![warning_message_executeprocess_nifi_iot](/assets/realtime-event-processing-with-hdf/lab0-nifi/warning_message_executeprocess_nifi_iot.png)

The warning message indicates: we need to enter a command into the value field of the **property** command since it is empty and connect this processor to another component to establish a relationship.
Each Processor will have its own alert message. Let’s configure and connect each processor to remove all the warning messages, so we can have a live data flow.

### 5.3 Configure Processors

Now that we added some processors, we will configure our processors in the **Configure Processor** window, which contains 4 tabs: **Settings**, **Scheduling**, **Properties** and **Comments**. We will spend most of our time in the properties tab since it is the main place to configure specific information that the processor needs to run properly. The properties that are in bold are required for the processor to be valid. If you want more information on a particular property, hover over the help icon ![question_mark_symbol_properties_config_iot.png](/assets/realtime-event-processing-with-hdf/lab0-nifi/question_mark_symbol_properties_config_iot.png) located next to the Property Name with the mouse to read a description of the property.

### 5.3.1 Configure ExecuteProcess Processor

1\. Right click on the **ExecuteProcess** processor and click **configure** from dropown menu ![configure_processor_nifi_iot](/assets/realtime-event-processing-with-hdf/lab0-nifi/configure_processor_nifi_iot.png)

2\. Click on the **Properties** tab.

3\. In the **value** field located next to property **command**, write `sh`.

4\. In the **value** field next to **command arguments**, enter the directory path of your scripts location /root/iot-truck-streaming/stream-simulator/generate.sh.

> Note: if your sh file is located in a different path, enter that path.

5\. Set the Batch Direction **value** to `10 sec`.

![executeProcess_properties_config](/assets/realtime-event-processing-with-hdf/lab0-nifi/executeProcess_properties_config.png)

> Note: Configure ExecuteProcess processor Attributes. The properties in bold indicate they are required and must have a value to run. Optional: click the comments tab and enter a brief description: runs the stream simulator and reads the live truck event data feed

6\. Let’s navigate to the **Scheduling** tab. We will modify the **Run Schedule** field and insert `1 sec`, so the processor runs every 1 second. Let’s click the **Apply** button.

![executeprocess_scheduling_nifi_iot](/assets/realtime-event-processing-with-hdf/lab0-nifi/executeprocess_scheduling_nifi_iot.png)

### 5.3.2 Configure SplitText Processor

1\. Right click on the **SplitText** processor and click **configure** from dropown menu ![configure_processor_nifi_iot](/assets/realtime-event-processing-with-hdf/lab0-nifi/configure_processor_nifi_iot.png)

2\. Click on the **Properties** tab.

3\. Insert `1` into the value field for **Line Split Count** Property. 1 line will be added to each split FlowFile. Keep the default values unchanged.

4\. For **Remove Trailing Newlines** property, set the value field as **false**. This configuration does not remove newlines at the end of each split file, so when the FlowFiles are merged into a single FlowFile, each FlowFile will be on its own line.

![splittext_property_config_nifi_iot](/assets/realtime-event-processing-with-hdf/lab0-nifi/splittext_property_config_nifi_iot.png)

5\. Navigate to the **Settings** tab. Check the **failure** and **original** checkbox under **Auto terminate relationships**. Click the **Apply** button.

![splitText_configuration_nifi_iot](/assets/realtime-event-processing-with-hdf/lab0-nifi/splitText_configuration_nifi_iot.png)

> Note: The Auto Terminate Relationships tell NiFi the relationship that the files in our flow will be labeled as when we’re done working on them.

The SplitText Processor will still have a warning symbol ![warning_symbol_nifi_iot](/assets/realtime-event-processing-with-hdf/lab0-nifi/warning_symbol_nifi_iot.png) because we need to connect it to another component. Before we start connecting the processors, let’s configure our **UpdateAttribute** processor.

### 5.3.3 Configure UpdateAttribute Processor

1\. Right click on the **UpdateAttribute** processor and click **configure** from dropown menu ![configure_processor_nifi_iot](/assets/realtime-event-processing-with-hdf/lab0-nifi/configure_processor_nifi_iot.png)

2\. Click on the **Properties** tab.

3\. Add ![add_new_property_config_nifi_iot](/assets/realtime-event-processing-with-hdf/lab0-nifi/add_new_property_config_nifi_iot.png) and name it `filename`. Insert NiFi Expression Language `${UUID()}` to give each FlowFile that transfers through this processor a unique name. Click **OK** and then **Apply**.

### 5.3.4 Configure RouteOnContent Processor

1\. Right click on the **RouteOnContent** processor and click **configure** from dropown menu ![configure_processor_nifi_iot](/assets/realtime-event-processing-with-hdf/lab0-nifi/configure_processor_nifi_iot.png)

2\. Click on the **Properties** tab.

3\. Change **Match Requirement** property value to `content must contain match`.

4\. Add ![add_new_property_config_nifi_iot](/assets/realtime-event-processing-with-hdf/lab0-nifi/add_new_property_config_nifi_iot.png) and name it `search_for_truck_event_data`. Insert Regex Expression Language:

~~~
(Normal)|(Overspeed)|(Lane Departure)|(Unsafe tail distance)|(Unsafe following distance)
~~~

to search the content of each FlowFile to see if it contains any of these driving event keywords; if so, we found truck_event data. Click **OK** and then **Apply**.

![routeOnContent_filter_nifi_iot](/assets/realtime-event-processing-with-hdf/lab0-nifi/routeOnContent_filter_nifi_iot.png)

### 5.3.5 Configure MergeContent(truck_events) Processor

1\. Right click on the **MergeContent** processor and click **configure** from dropown menu ![configure_processor_nifi_iot](/assets/realtime-event-processing-with-hdf/lab0-nifi/configure_processor_nifi_iot.png)

2\. Click on the **Properties** tab.

3\. Add `50` to the value field for the **Minimum Number of Entries** property. Add `70` to the value field for **Maximum Number of Entries property**. This min and max value will instruct the processor to merge the FlowFiles together once at least 50 FlowFiles are loaded into the queue, but will not merge more than 70. Feel free to change the min and max values.

![mergeContent_property_configs](/assets/realtime-event-processing-with-hdf/lab0-nifi/mergeContent_property_configs.png)

4\. Navigate to the **Settings** tab.

5\. Rename the processor: `MergeContent(truck_events)`. Check the **failure** and **original** checkbox under **Auto terminate relationships**.

### 5.3.6 Configure MergeContent(logs) Processor

1\. Right click the MergeContent processor created in the previous step and copy it ![copy_processor_nifi_iot](/assets/realtime-event-processing-with-hdf/lab0-nifi/copy_processor_nifi_iot.png). Move the mouse slightly to the right of MergeContent(truck_events) processor and paste it ![paste_processor_nifi_iot](/assets/realtime-event-processing-with-hdf/lab0-nifi/paste_processor_nifi_iot.png)

2\. Open configure **settings** tab, and rename the processor `MergeContent(logs)`.

### 5.3.7 Configure PutFile(truck_events) Processor

1\. Right click on the **PutFile** processor below MergeContent(truck_events) and click **configure** from dropown menu ![configure_processor_nifi_iot](/assets/realtime-event-processing-with-hdf/lab0-nifi/configure_processor_nifi_iot.png)

2\. Click on the **Properties** tab.

3\. The warning message tells us that the directory is invalid and that it is required. So, let’s add a value for the **directory** property: `/root/nifi_output/truck_events` as in the image. We will keep the other values default.

![putfile_properties_truck_events_config_nifi_iot](/assets/realtime-event-processing-with-hdf/lab0-nifi/putfile_properties_truck_events_config_nifi_iot.png)

4\. Navigate to the **Settings** tab.

5\. Rename the processor: `PutFile(truck_events)`.

6\. The warning message informs us that the processor’s relationship is invalid since it is not auto-terminated as `success`. So, let’s check the **failure** and **success** checkbox below the **Auto terminated relationships**. Click the **Apply** button.

![putfile_truck_events_nifi_iot](/assets/realtime-event-processing-with-hdf/lab0-nifi/putfile_truck_events_nifi_iot.png)

### 5.3.8 Configure PutFile(logs) Processor

1\. Right click the PutFile(truck_events) processor created in the previous step and copy it ![copy_processor_nifi_iot](/assets/realtime-event-processing-with-hdf/lab0-nifi/copy_processor_nifi_iot.png). Move the mouse slightly above MergeContent(logs) processor and paste it ![paste_processor_nifi_iot](/assets/realtime-event-processing-with-hdf/lab0-nifi/paste_processor_nifi_iot.png).

2\.Right click on the **PutFile** processor located above MergeContent(logs) and click **configure** from dropown menu ![configure_processor_nifi_iot](/assets/realtime-event-processing-with-hdf/lab0-nifi/configure_processor_nifi_iot.png).

3\. Click on the **Properties** tab.

4\. Change a value for the **directory** property: `/root/nifi_output/log_data` as in the image. We will keep the other values default.

![putfile_properties_config_logs_nifi_iot](/assets/realtime-event-processing-with-hdf/lab0-nifi/putfile_properties_config_logs_nifi_iot.png)

5\. Navigate to the **Settings** tab.

6\. Rename the processor: `PutFile(logs)`. Click the **Apply** button.

![putfile_logs_nifi_iot](/assets/realtime-event-processing-with-hdf/lab0-nifi/putfile_logs_nifi_iot.png)

### 5.4 Connect All Processors

A common warning message among all processors is that there needs to be a relationship or connection between each processor. The relationship tells NiFi what to do with the data that the processor transferred. For instance, you will see these two common relationships: success and failure. These two relationship affect the way data is routed through the flow. Once we connect all processors and establish their appropriate relationship, the warnings will disappear.

### 5.4.1 Connect ExecuteProcess to SplitText

1\. Connect the **ExecuteProcess** processor to the **SplitText** processor by hovering over the center of it and dragging the **circle** to the SplitText. Then we will repeat the same process to connect the all the processors to our flow of data.

![connect_processors_execute_splittext_nifi_iot](/assets/realtime-event-processing-with-hdf/lab0-nifi/connect_processors_execute_splittext_nifi_iot.png)

> Note: Make sure in the Create Connection window both relationships for the processor are set to success.

### 5.4.2 Connect SplitText to UpdateAttribute

1\. Connect the SplitText processor to Update Attribute. A Create Connection window will appear, check the **splits** checkbox to establish their relationship.

### 5.4.3 Connect UpdateAttribute to RouteOnContent

1\. Connect the UpdateAttribute processor to RouteOnContent. In the Create Connection window, check the **success** checkbox for the relationship.

### 5.4.4 Connect RouteOnContent to MergeContent(truck_events)

1\. Connect the RouteOnContent processor to MergeContent(truck_events). In the Create Connection window, check the **search_for_truck_event_data** checkbox  for the relationship. All the FlowFiles sent to this processor are truck events.

### 5.4.5 Connect RouteOnContent to MergeContent(logs)
1\. Connect the RouteOnContent processor to MergeContent(logs). In the Create Connection window, check the **unmatched** checkbox for the relationship. All the FlowFiles sent to this processor are logs and data we don’t want kafka to receive.

### 5.4.6 Connect MergeContent(logs) to PutFile(logs)
1\. Connect the MergeContent(logs) to Putfile(logs). In the Create Connection window, check the **merged** checkbox for the relationship. All the FlowFiles sent to this processor are logs and data we don’t want kafka to receive.

### 5.4.7 Connect MergeContent(truck_events) to PutFile(truck_events)

1\. Connect the MergeContent(truck_events) to Putfile(truck_events). In the Create Connection window, check the **merged** checkbox for the relationship. All the FlowFiles sent to this processor are truck event data we do want kafka to receive.

Once all processors are connected, your dataflow should look as below:

![dataflow_lab0_complete_nifi_iot](/assets/realtime-event-processing-with-hdf/lab0-nifi/dataflow_lab0_complete_nifi_iot.png)

### 5.5 Run NiFi DataFlow

1\. The processors are valid since the warning symbols disappeared. Notice that the processors have a red stop symbol ![stop_symbol_nifi_iot](/assets/realtime-event-processing-with-hdf/lab0-nifi/stop_symbol_nifi_iot.png) in the upper left corner and are ready to run. To select all processors, hold down the shift-key and drag your mouse across the entire data flow.

![dataflow_selected_nifi_iot](/assets/realtime-event-processing-with-hdf/lab0-nifi/dataflow_selected_nifi_iot.png)

2\. Now that all processors are selected, go to the actions toolbar and click the start button ![start_button_nifi_iot](/assets/realtime-event-processing-with-hdf/lab0-nifi/start_button_nifi_iot.png). Your screen should look like the following:

![run_dataflow_nifi_iot](/assets/realtime-event-processing-with-hdf/lab0-nifi/run_dataflow_nifi_iot.png)

Note: To run the DataFlow again, you will need to copy & paste the ExecuteProcess processor onto the graph, then delete the old one, and connect the new one to the splittext procesor. You will need to repeat this process each time you want to run the DataFlow. This step will ensure dataflow flows through each processor. Currently,the ExecuteProcess processor is getting a patch to fix this problem. 

3\. To quickly see what the processors are doing and the information on their faces, right click on the graph, click the **refresh status** button ![refresh_nifi_iot](/assets/realtime-event-processing-with-hdf/lab0-nifi/refresh_nifi_iot.png)

![refresh_dataflow_data_increase_nifi_iot](/assets/realtime-event-processing-with-hdf/lab0-nifi/refresh_dataflow_data_increase_nifi_iot.png)

> Note: On each processor face, the In, Read/Write and Out all have data increasing.

### 5.6 Check Data Stored In Correct Directory

To check that the log and truck event data were written to the correct directory, wait 20 seconds, then open your terminal and navigate to their appropriate directories. Make sure to SSH into your sandbox.

### 5.7 Verify Logs Stored In log_data Directory

1\. Let’s check the logs, navigate to through directory path: `/root/nifi_output/log_data`.

~~~
cd /root/nifi_output/nifi_output/log_data
~~~

2\. To see new files that were created, type the command:

~~~
ls
~~~

3\. Let’s open one of the files to see the log data that was generated. Choose a file of your choice and type the following command `vi {file_of_your_choice}`.

~~~
vi 28863080789498
~~~

Once the file is opened, you should obtain similar output as below:

![logs_stream_simulator_nifi_output](/assets/realtime-event-processing-with-hdf/lab0-nifi/logs_stream_simulator_nifi_output.png)

> Note: to exit the vi editor, press `esc` and then type `:q`.

### 5.8 Verify Events Stored In truck_events Directory

1\. Navigate to truck events directory: `/root/nifi_output/truck_events` and view the files in the directory. Open two random file to verify only event data is being sent to this directory.

~~~
cd /root/nifi_output/truck_events
ls
vi 28918091050702
~~~

Once the file is opened, you should obtain similar output as below:

![truck_events_file_nifi_iot](/assets/realtime-event-processing-with-hdf/lab0-nifi/truck_events_file_nifi_iot.png)

> Note: to exit the vi editor, press `esc` and then type `:q`.

## Summary <a id="summary-lab0"></a>

Congratulations! You made it to the end of the tutorial and built a NiFi DataFlow that reads in a simulated stream of data, filters truck events from log data, stores the truck event data into a specific directory and writes that data to a file. You also learned how to use Apache Maven to package and compile code in order to run the simulator through the shell or by NiFi. You even explored troubleshooting common issues that occur when creating a flow of data. If you are interested in learning to integrate NiFi with other technologies, such as Kafka continue onto our next lab in the IoT tutorial series.

## Further Reading <a id="further-reading-lab0"></a>

- [Apache NiFi Documentation](https://nifi.apache.org/docs.html)
- [Hortonworks DataFlow Documentation](http://docs.hortonworks.com/HDPDocuments/HDF1/HDF-1.2/bk_UserGuide/content/index.html)
- [Apache NiFi Video Tutorials](https://nifi.apache.org/videos.html)
- [Apache Maven Documentation](https://maven.apache.org/)
- [Regex Expression Language](http://regexr.com/)
