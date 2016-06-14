# Lab 1: Build A Simple NiFi DataFlow

## Introduction

In this tutorial, we will build a NiFi DataFlow to fetch vehicle location, speed, and other sensor data from a San Francisco Muni traffic simulator, look for observations of a specific few vehicles, and store the selected observations into a new file. Even though this aspect of the lab is not streaming data, you will see the importance of file I/O in NiFi dataflow application development and how it can be used to simulate streaming data.

In this lab, you will build the following dataflow:

![completed-data-flow-lab1]()

Figure 1: The completed dataflow contains three sections: ingest data from vehicle location XML Simulator, extract vehicle location detail attributes from FlowFiles and route these detail attributes to a JSON file as long as they are not empty strings. You will learn more in depth about each processors particular responsibility in each section of the dataflow.

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


### Step 1: Explore NiFi HTML Interface

Let’s take a brief tour of NiFi’s HTML interface and explore some of its features that enable users to build data flows.

NiFi’s HTML interface contains 5 main sections: The components toolbar, the actions toolbar, the management toolbar, the search bar and the help button. The canvas is the area in which the data flow is built. View the image below for a visualization of these key areas.

![nifi_web_interface_toolbar]()

**Figure 3:** NiFi HTML interface contains four toolbars to build a dataflow or multiple dataflows.

### Step 2: Create a NiFi DataFlow

The building blocks of every dataflow consists of processors. These tools perform actions on data that ingest, route, extract, split, aggregate and store it. Our dataflow will contain these processors, each processor includes a high level description of their role in the lab:

- **GetFile** reads vehicle location data from traffic stream zip file
- **UnpackContent** decompresses the zip file
- **ControlRate** controls the rate at which FlowFiles move to the flow
- **EvaluateXPath(x2)** extracts nodes (elements, attributes, etc.) from the XML file
- **SplitXml** splits the XML file into separate FlowFiles, each comprised of children of the parent element
- **UpdateAttribute** assigns each FlowFile a unique name
- **RouteOnAttribute** makes the filtering decisions on the vehicle location data
- **AttributesToJSON** represents the attributes in JSON format
- **MergeContent** merges the FlowFiles into one FlowFile by concatenating their JSON content together
- **PutFile** writes filtered vehicle location data content to a directory on the local file system

### 2.1 Learning Objectives: Overview of DataFlow Build Process
- Add processors onto NiFi canvas
- Configure processors to solve problems
- Establish relationships or connections for each processors
- Troubleshoot problems that may occur
- Run the dataflow

Your dataflow will extract the following XML Attributes from the transit data listed in Table 1.

**Table 1: Extracted XML Attributes From Transit Data**

| Attribute Name  | Type  | Comment  |
|---|---|---|
| id  | string  | Vehicle ID |
| time  | int64  | Observation timestamp  |
| lat  | float64  | Latitude (degrees)  |
| lon  | float64  | Longitude (degrees)  |
| speedKmHr  | float64  | Vehicle speed (km/h)  |
| dirTag  | float64  | Direction of travel  |

**Table 2: Filtered and Converted Transit Location Data**

| Attribute Name  | Type  |
