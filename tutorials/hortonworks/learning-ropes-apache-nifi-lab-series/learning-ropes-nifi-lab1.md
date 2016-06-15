# Lab 1: Build A Simple NiFi DataFlow

## Introduction

In this tutorial, we will build a NiFi DataFlow to fetch vehicle location, speed, and other sensor data from a San Francisco Muni traffic simulator, look for observations of a specific few vehicles, and store the selected observations into a new file. Even though this aspect of the lab is not streaming data, you will see the importance of file I/O in NiFi dataflow application development and how it can be used to simulate streaming data.

In this lab, you will build the following dataflow:

![completed-data-flow-lab1](assets/learning-ropes-nifi-lab-series/lab1-build-nifi-dataflow/completed-data-flow-lab1.png)

**Figure 1:** The completed dataflow contains three sections: ingest data from vehicle location XML Simulator, extract vehicle location detail attributes from FlowFiles and route these detail attributes to a JSON file as long as they are not empty strings. You will learn more in depth about each processors particular responsibility in each section of the dataflow.

Feel free to download the NiFi-DataFlow-Lab1.xml template file.

1\. Click on the template icon located in the management toolbar at the top right corner.

2\. Click Browse, find the template file and hit import.

3\. Hover over the components toolbar, drag the template icon onto the graph and select the NiFi-DataFlow-Lab1.xml template file.

4\. Hit the run button to activate the dataflow. We highly recommend you read through the lab, so you become familiar with the process of building a dataflow.

## Pre-Requisites
- Completed Lab 0: Download, Install and Start NiFi


## Outline
- Step 1: Explore NiFi HTML Interface
- Step 2: Create a NiFi DataFlow
- Step 3: Build XML Simulator DataFlow Section
- Step 4: Build Key Attribute Extraction DataFlow Section
- Step 5: Build Filter and JSON Conversion DataFlow Section
- Step 6: Run the NiFi DataFlow
- Summary
- Further Reading


### Step 1: Explore NiFi HTML Interface

Let’s take a brief tour of NiFi’s HTML interface and explore some of its features that enable users to build data flows.

NiFi’s HTML interface contains 5 main sections: The components toolbar, the actions toolbar, the management toolbar, the search bar and the help button. The canvas is the area in which the data flow is built. View the image below for a visualization of these key areas.

![nifi_dataflow_html_interface](assets/learning-ropes-nifi-lab-series/lab1-build-nifi-dataflow/nifi_dataflow_html_interface.png)

**Figure 2:** NiFi HTML interface contains four toolbars to build a dataflow or multiple dataflows.

### Step 2: Create a NiFi DataFlow

The building blocks of every dataflow consists of processors. These tools perform actions on data that ingest, route, extract, split, aggregate and store it. Our dataflow will contain these processors, each processor includes a high level description of their role in the lab:

- **GetFile** reads vehicle location data from traffic stream zip file
- **UnpackContent** decompresses the zip file
- **ControlRate** controls the rate at which FlowFiles move to the flow
- **EvaluateXPath(x2)** extracts nodes (elements, attributes, etc.) from the XML file
- **SplitXml** splits the XML file into separate FlowFiles, each comprised of children of the parent element
- **UpdateAttribute** assigns each FlowFile a unique name
- **RouteOnAttribute** makes the filtering decisions on the vehicle location data
- **AttributesToJSON** represents the filtered attributes in JSON format
- **MergeContent** merges the FlowFiles into one FlowFile by concatenating their JSON content together
- **PutFile** writes filtered vehicle location data content to a directory on the local file system

### 2.1 Learning Objectives: Overview of DataFlow Build Process
- Add processors onto NiFi canvas
- Configure processors to solve problems
- Establish relationships or connections for each processors
- Troubleshoot problems that may occur
- Run the dataflow

Your dataflow will extract the following XML Attributes from the transit data listed in Table 1. We will learn how to do this extraction with evaluateXPath when we build our dataflow.

**Table 1: Extracted XML Attributes From Transit Data**

| Attribute Name  | Type  | Comment  |
|---|---|---|
| id  | string  | Vehicle ID |
| time  | int64  | Observation timestamp  |
| lat  | float64  | Latitude (degrees)  |
| lon  | float64  | Longitude (degrees)  |
| speedKmHr  | float64  | Vehicle speed (km/h)  |
| dirTag  | float64  | Direction of travel  |

After the filtering and JSON conversion, your new file, which contains transit location data will be stored in the Input Directory listed in Table 2. We will learn how to satisfy the conditions in Table 2 with RouteOnAttribute, AttributesToJSON and PutFile processors.

**Table 2: Other DataFlow Requirements**

| Parameter  | Value  |
|---|---|
| Input Directory  | /home/nifi/input  |
| Output Directory  | /home/nifi/output/filtered_transitLoc_data  |
| File Format  | JSON  |
| Filter For  | id, time, lat, lon, speedKmHr, dirTag  |

Let's build our dataflow to fetch, filter and store transit sensor data from San Francisco Muni, M-Ocean View route. Here is a visulization, courtesy of nextbus and google, of the data NiFi generates using our traffic XML simulator:

![sf_ocean_view_route_nifi_streaming](assets/learning-ropes-nifi-lab-series/lab1-build-nifi-dataflow/live_stream_sf_muni_nifi_learning_ropes.png)

### 2.2 Add processors

1\. Go to the **components** toolbar, drag and drop the processor icon ![processor_nifi_iot](assets/learning-ropes-nifi-lab-series/lab1-build-nifi-dataflow/processor_nifi_iot.png) onto the graph.


An **Add Processor** window will appear with 3 ways to find our desired processor: **processor list**, **tag cloud**, or **filter bar**

- processor list: contains almost 160 processors
- tag cloud: reduces list by category
- filter bar: search for desired processor

![add_processor_window](assets/learning-ropes-nifi-lab-series/lab1-build-nifi-dataflow/add_processor_window.png)


2\. Select the **GetFile** processor and a short description of the processor's function will appear.

- **GetFile** fetches the vehicle location simulator data fro files in a directory.

Click the **Add** button to the processor to the graph.

![add_processor_getfile_nifi-learn-ropes](assets/learning-ropes-nifi-lab-series/lab1-build-nifi-dataflow/add_processor_getfile_nifi-learn-ropes.png)

3\. Add the **UnpackContent, ControlRate, EvaluateXPath, SplitXML, UpdateAttribute, EvaluateXPath, RouteOnAttribute, AttributesToJSON, MergeContent** and **PutFile** processors using the processor icon.

Overview of Each Processor's Role in our DataFlow:

- **UnpackContent** decompresses the contents of FlowFiles from the traffic simulator zip file.

- **ControlRate** controls the rate at which FlowFiles are transferred to follow-on processors enabling traffic simulation.

- **EvaluateXPath** extracts the timestamp of the last update for vehicle location data returned from each FlowFile.

- **SplitXML** splits the parent's child elements into separate FlowFiles. Since vehicle is a child element in our xml file, each new vehicle element is stored separately.

- **UpdateAttribute** updates the attribute name for each FlowFile.

- **EvaluateXPath** extracts attributes: vehicle id, direction latitude, longitude and speed from vehicle element in each FlowFile.

- **RouteOnAttribute** transfers FlowFiles to follow-on processors only if vehicle ID, speed, latitude, longitude, timestamp and direction match the filter conditions.

- **AttributesToJSON** generates a JSON representation of the attributes extracted from the FlowFiles and converts XML to JSON format this less attributes.

- **MergeContent** merges a group of JSON FlowFiles together based on a number of FlowFiles and packages them into a single FlowFile.

Follow the step above to add these processors. You should obtain the image below:

![added_processors_nifi_part1](assets/learning-ropes-nifi-lab-series/lab1-build-nifi-dataflow/added_processors_nifi_part1.png)

> Note: To find more information on the processor, right click ExecuteProcess and click **usage**. An in app window will appear with that processor’s documentation.

### 2.3 Troubleshoot Common Processor Issues

Notice the nine processors in the image above have warning symbols ![warning_symbol_nifi_iot](/assets/learning-ropes-nifi-lab-series/lab1-build-nifi-dataflow/warning_symbol_nifi_iot.png) in the upper left corner of the processor face. These warning symbols indicate the processors are invalid.

1\. To troubleshoot, hover over one of the processors, for instance the **GetFile** processor, and a warning symbol will appear. This message informs us of the requirements needed, so we can run this processor.

![error_getFile_processor_nifi_lab1](/assets/learning-ropes-nifi-lab-series/lab1-build-nifi-dataflow/warning_getFile_processor_nifi_lab1.png)

The warning message indicates: we need to specify a directory path to tell the processor where to pull data and a connection for the processor to establish a relationship.
Each Processor will have its own alert message. Let’s configure and connect each processor to remove all the warning messages, so we can have a live data flow.


### 2.4 Configure processors

Now that we added some processors, we will configure our processors in the **Configure Processor** window, which contains 4 tabs: **Settings**, **Scheduling**, **Properties** and **Comments**. We will spend most of our time in the properties tab since it is the main place to configure specific information that the processor needs to run properly. The properties that are in bold are required for the processor to be valid. If you want more information on a particular property, hover over the help icon ![question_mark_symbol_properties_config_iot.png](/assets/learning-ropes-nifi-lab-series/lab1-build-nifi-dataflow/question_mark_symbol_properties_config_iot.png) located next to the Property Name with the mouse to read a description of the property.

### Step 3: Build XML Simulator DataFlow Section

### 3.1 Configure GetFile Processor

1\. Download [Traffic Simulator Data XML zip file](/assets/learning-ropes-nifi-lab-series/trafficLocs_data_for_simulator.zip).

If NiFi is on Sandbox, send the zip file to the sandbox with the command:

~~~bash
scp -P 2222 ~/Downloads/trafficLocs_data_for_simulator.zip root@localhost:/home/nifi/input
~~~

If NiFi is on local machine, create a new folder named `/home/nifi/input` in the `/` directory with the command:

~~~bash
mkdir /home/nifi/input
mv ~/Downloads/trafficLocs_data_for_simulator.zip /home/nifi/input
~~~  

Right click on the **GetFile** processor and click **configure** from dropown menu

![configure_processor_nifi_iot](/assets/learning-ropes-nifi-lab-series/lab1-build-nifi-dataflow/configure_processor_nifi_iot.png)

2\. Click on the **Properties** tab.

3\. In the **value** field next to property **Input Directory**, insert `/home/nifi/input`. Click the **OK** button.

4\. In the **value** field next to property **Keep Source File**, change false to `true`. Click **OK** and then leave other configurations as default and click **Apply**.

![getFile_config_property_tab_window](/assets/learning-ropes-nifi-lab-series/lab1-build-nifi-dataflow/getFile_config_property_tab_window.png)

**Figure 3:** GetFile Configuration Property Tab Window



### 3.2 Configure UnpackContent Processor

1\. Open the processor configuration **properties** tab. Change the **value** field next to property **Packaging Format** from use mime.type attribute to `zip`. Click **OK** and then **Apply**.

![unpackContent_config_property_tab_window](/assets/learning-ropes-nifi-lab-series/lab1-build-nifi-dataflow/unpackContent_config_property_tab_window.png)

**Figure 4:** UnpackContent Configuration Property Tab Window

### 3.3 Configure ControlRate Processor

1\. Open the processor configuration **properties** tab. Change the **value** next to property **Rate Control Criteria** from data rate to `flowfile count`.

2\. In the **value** next to property **Maximum Rate**, enter `1`. Insert `6 second` for the **Time Duration** value field. This configuration makes it so only 1 flowfile will transfer through this processor every 6 seconds.

![controlRate_config_property_tab_window](/assets/learning-ropes-nifi-lab-series/lab1-build-nifi-dataflow/controlRate_config_property_tab_window.png)

**Figure 5:** ControlRate Configuration Property Tab Window


### Step 4: Build Key Attribute Extraction DataFlow Section

### 4.1 Configure EvaluateXPath Processor

1\. Open the processor configuration **properties** tab. Change the **value** next to property **Destination** from flowfile-content to `flowfile-attribute`.

2\. Add a new dynamic property for XPath expression, select the **New property** button. Insert the following property name and value into your properties tab as shown in the table below:

| Property  | Value  |
|---|---|
| Last_Time  | //body/lastTime/@time  |

![evaluateXPath_config_property_tab_window](/assets/learning-ropes-nifi-lab-series/lab1-build-nifi-dataflow/evaluateXPath_config_property_tab_window.png)

**Figure 6:** EvaluateXPath Configuration Property Tab Window

### 4.2 Configure SplitXML Processor

1\. Keep SplitXML configuration **properties** as default.

### 4.3 Configure UpdateAttribute Processor

1\. Add a new dynamic property for NiFi expression, select the new property button. Insert the following property name and value into your properties tab as shown in the table below:

| Property  | Value  |
|---|---|
| filename  | ${UUID()}  |

![updateAttribute_config_property_tab_window](/assets/learning-ropes-nifi-lab-series/lab1-build-nifi-dataflow/updateAttribute_config_property_tab_window.png)

**Figure 7:** UpdateAttribute Configuration Property Tab Window

### 4.4 Configure EvaluateXPath Processor

1\. Open the processor configuration **properties** tab. Change the **value** next to property **Destination** from flowfile-content to `flowfile-attribute`.

2\. Add a new dynamic property for XPath expression, select the new property button. Insert the following property name and value into your properties tab as shown in the table below:

| Property  | Value  |
|---|---|
| Direction_of_Travel  | //vehicle/@dirTag  |
| Latitude  | //vehicle/@lat  |
| Longitude  | //vehicle/@lon  |
| Vehicle ID  | //vehicle/@id  |
| Vehicle_Speed  | //vehicle/@speedKmHr  |

![evaluateXPath_extract_splitFlowFiles_config_property_tab](/assets/learning-ropes-nifi-lab-series/lab1-build-nifi-dataflow/evaluateXPath_extract_splitFlowFiles_config_property_tab.png)

**Figure 8:** EvaluateXPath Configuration Property Tab Window

### Step 5: Build Filter and JSON Conversion DataFlow Section

### 5.1 Configure RouteOnAttribute

1\. Open the processor configuration **properties** tab. Add a new dynamic property for NiFi expression, select the new property button. Insert the following property name and value into your properties tab as shown in the table below:

| Property  | Value  |
|---|---|
| Filter_VehicleLoc_Details  | `${Direction_of_Travel:isEmpty():not():and(${Last_Time:isEmpty()not()}):and(${Latitude:isEmpty():not()}):and(${Longitude:isEmpty():not()}):and(${Vehicle_ID:isEmpty():not()}):and(${Vehicle_Speed:equals('0'):not()})}`  |

![routeOnAttribute_config_property_tab_window](/assets/learning-ropes-nifi-lab-series/lab1-build-nifi-dataflow/routeOnAttribute_config_property_tab_window.png)

**Figure 9:** RouteOnAttribute Configuration Property Tab Window

### 5.2 Configure AttributesToJSON

1\. Open the processor configuration **properties** tab. In the **value** field next property **Attributes List**, enter `Vehicle_ID, Direction_of_Travel, Latitude, Longitude, Vehicle_Speed, Last_Time`.

2\. Change the **value** next to property **Destination** from flowfile-attribute to `flowfile-content`.

![attributesToJSON_config_property_tab_window](/assets/learning-ropes-nifi-lab-series/lab1-build-nifi-dataflow/attributesToJSON_config_property_tab_window.png)

**Figure 10:** AttributesToJSON Configuration Property Tab Window

### 5.3 Configure MergeContent

1\. Open the processor configuration **properties** tab. Insert `10` records into the **value** for the property **Minimum Number of Entries**. Insert `15` records into the **Maximum Number of Entries** value.

![mergeContent_firstHalf_config_property_tab_window](/assets/learning-ropes-nifi-lab-series/lab1-build-nifi-dataflow/mergeContent_firstHalf_config_property_tab_window.png)

2\. Scroll down, change the value for Delimiter Strategy from Filename to `Text`. Insert `[` into Header value. Insert `]` into the Footer value. Type, then press `, shift+enter` into the Demarcator value.

![mergeContent_secondHalf_config_property_tab_window](/assets/learning-ropes-nifi-lab-series/lab1-build-nifi-dataflow/mergeContent_secondHalf_config_property_tab_window.png)

### 5.4 Configure PutFile

1\. Open the processor configuration **properties** tab. Insert `/home/nifi/output/filtered_transitLoc_data` into the **Directory** value field.

![putFile_config_property_tab_window](assets/learning-ropes-nifi-lab-series/lab1-build-nifi-dataflow/putFile_config_property_tab_window.png)

### Connect All processors

A common warning message among all processors is that there needs to be a relationship or connection between each processor. The relationship tells NiFi what to do with the data that the processor transferred. For instance, you will see these two common relationships: success and failure. These two relationship affect the way data is routed through the flow. Once we connect all processors and establish their appropriate relationship, the warnings will disappear.

### Connect Processors from Vehicle Location XML Simulator Section

1\. Connect the **GetFile** processor to the **UnpackContent** processor by hovering over the center of GetFile and dragging the **circle** to the UnpackContent. Let's repeat the same process to connect all processors. Pay attention to each processor's relationship some may not have the usual **success** or **failure**.

2\. Connect UnpackContent to ControlRate processor. When the Create Connection window appears, check **success** checkbox to establish their relationship.

3\. Connect ControlRate to EvaluateXPath processor. When the Create Connection window appears, check **success** checkbox to establish their relationship.

### Connect Processors from Extract Key Attributes in FlowFiles Section

1\. Connect EvaluateXPath to SplitXML processor. When the Create Connection window appears, check **matched** checkbox to establish their relationship.

2\. Connect SplitXML to UpdateAttribute processor. When the Create Connection window appears, check **split** checkbox to establish their relationship.

3\. Connect UpdateAttribute to EvaluateXPath processor. When the Create Connection window appears, check **success** checkbox to establish their relationship.

4\. Connect EvaluateXPath to RouteOnAttribute processor. When the Create Connection window appears, check **matched** checkbox to establish their relationship.

### Connect Processors from Filter Key Attributes to JSON File Section

 1\. Connect RouteOnAttribute to AttributesToJSON processor. When the Create Connection window appears, check **Filter_Attributes** checkbox to establish their relationship.

2\. Connect AttributesToJSON to MergeContent processor. When the Create Connection window appears, check **success** checkbox to establish their relationship.

3\. Connect MergeContent to PutFile processor. When the Create Connection window appears, check **merged** checkbox to establish their relationship.

### Step 6: Run the NiFi DataFlow

1\. The processors are valid since the warning symbols disappeared. Notice that the processors have a red stop symbol ![stop_symbol_nifi_iot](/assets/realtime-event-processing-with-hdf/lab0-nifi/stop_symbol_nifi_iot.png) in the upper left corner and are ready to run. To select all processors, hold down the **shift-key** and drag your mouse across the entire data flow.

2\. Now that all processors are selected, go to the actions toolbar and click the start button ![start_button_nifi_iot](/assets/learning-ropes-nifi-lab-series/lab1-build-nifi-dataflow/start_button_nifi_iot.png). Your screen should look like the following:

![run_dataflow_lab1_nifi_learn_ropes](/assets/learning-ropes-nifi-lab-series/lab1-build-nifi-dataflow/run_dataflow_lab1_nifi_learn_ropes.png)

3\. To quickly see what the processors are doing and the information on their faces, right click on the graph, click the **refresh status** button ![refresh_nifi_iot](/assets/learning-ropes-nifi-lab-series/lab1-build-nifi-dataflow/refresh_nifi_iot.png)

4\. To check that the data was written to a file, open your terminal. Make sure to SSH into your sandbox. Navigate to the directory you wrote for the PutFile processor. List the files and open one of the newly created files to view filtered transit output. In the tutorial our directory path is: `/home/nifi/output/filtered_transitLoc_data`.

~~~
cd /home/nifi/output/filtered_transitLoc_data
ls
vi 171228778202845
~~~

![commands_enter_sandbox_shell_lab1](/assets/learning-ropes-nifi-lab-series/lab1-build-nifi-dataflow/commands_enter_sandbox_shell_lab1.png)


![filtered_vehicle_locations_data_nifi_learn_ropes](/assets/learning-ropes-nifi-lab-series/lab1-build-nifi-dataflow/filtered_vehicle_locations_data_nifi_learn_ropes.png)

> Note: to exit the vi editor, press `esc` and then type `:q`.

Did you receive the data you expected?

## Summary

Congratulations! You made it to the end of the tutorial and built a NiFi DataFlow that reads in a live stream simulation from NextBus.com, splits the parent’s children elements from the XML file into separate FlowFiles, extracts nodes from the XML file, makes a filtering decision on the attributes and stores that newly modified data into a file. If you are interested in learning more about NiFi, view the following further reading section.

If you want a more in depth review of the dataflow we just built, read the information below, else continue onto the next lab.

Vehicle Location XML Simulation Section:
streams the contents of a file from local disk into NiFi, unpacks the zip file and transfers each file as a single FlowFile, controls the rate at which the data flows to the remaining part of the flow.

Extract Attributes From FlowFiles Section:
Splits XML message into many FlowFiles, updates each FlowFile filename attribute with unique name and User Defined XPath Expressions are evaluated against the XML Content to extract the values into user-named Attribute.

Filter Key Attributes to JSON File Section:
Routes FlowFile based on whether it contains all XPath Expressions (attributes) from the evaluation, writes JSON representation of input attributes to FlowFile as content, merges the FlowFiles by concatenating their content together into a single FlowFile and writes the contents of a FlowFile to a directory on the local filesystem.


## Further Reading

- [Hortonworks DataFlow Documentation](http://docs.hortonworks.com/HDPDocuments/HDF1/HDF-1.2/bk_UserGuide/content/index.html)
- [NiFi Expression Language Guide](https://nifi.apache.org/docs/nifi-docs/html/expression-language-guide.html)
- [Apache NiFi](https://nifi.apache.org/videos.html)
