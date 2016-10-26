---
layout: tutorial
title: Introduction to DataFlow Automation with Apache NiFi Concepts
tutorial-id: 640
tutorial-series: Basic Development
tutorial-version: hdf-2.0.0
intro-page: false
components: [ nifi ]
---

# Introduction to DataFlow Automation with Apache NiFi Concepts

## Introduction

The concepts section is tailored toward enriching your hands-on experience in the tutorials. By the end of this section, you will be able to define NiFi, know how to create dataflows for specific use cases, acquire knowledge on how to build a NiFi DataFlow and become familiar with the core concepts of NiFi. The goal of this section is to help NiFi practitioners know how to use the NiFi documentation for their advantage.

## Outline
- 1\. What is Apache NiFi?
- 2\. Who Uses NiFi, and for what?
- 3\. Understand NiFi DataFlow Build Process
- 4\. The Core Concepts of NiFi
- 5\. A Brief History of NiFi
- Further Reading

### 1\. What is Apache NiFi?

[Apache NiFi](https://nifi.apache.org/docs/nifi-docs/html/overview.html#what-is-apache-nifi) is an open source tool for automating and managing the flow of data between systems. In the tutorial, we will use NiFi to process the flow of data between sensors, web services (NextBus and Google Places API), various locations and our local file system. NiFi will solve our dataflow challenges since it can adapt. Problems we may face include data access exceeds capacity to consume, systems evolve at different rates, compliance and security.


### 2\. Who Uses NiFi, and for what?

NiFi is used for **data ingestion** to pull data into NiFi, from numerous different data sources and create FlowFiles. For the tutorial, GetFile, GetHTTP, InvokeHTTP are processors you will use to stream data into NiFi from the local file system and ingest data from the internet. Once the data is ingested, a DataFlow Manager (DFM), the user, will perform **data management** by monitoring and obtaining feedback about the current status of the NiFi DataFlow. The DFM also has the ability to add, remove and modify components of dataflow. You will use bulletins, located on the processor and management toolbar, which provide a tool-tip of the time, severity and message of the alert to troubleshoot problems in the dataflow. While the data is being managed, you will create **data enrichment** to enhance, refine and improve the quality of data to make it meaningful and valuable for users. NiFi enables users to filter out unnecessary information from data to make easier to understand. You will use NiFi to geographically enrich real-time data to show neighborhoods nearby locations as the locations change.


### 3\. Understand NiFi DataFlow Build Process

### 3.1 Explore NiFi WEB Interface

When NiFi is accessed at `localhost:6434/nifi` by users who run NiFi from Hortonworks Sandbox or `localhost:8080/nifi` by users who run NiFi from their local machine, [NiFi's User Interface (UI)](http://docs.hortonworks.com/HDPDocuments/HDF1/HDF-1.2.0.1/bk_UserGuide/content/User_Interface.html) appears on the screen. The UI is where dataflows will be developed. It includes a canvas and _mechanisms_ to build, visualize, monitor, edit, and administer our dataflows in the tutorials. The **components** toolbar contains all tools for building the dataflow. The **actions** toolbar consists of buttons that manipulate the components on the canvas. The **management** toolbar has buttons for the DFM to manage the flow and a NiFi administrator to manage user access & system properties. The **search** toolbar enables users to search for any component in the dataflow. The image below shows a visualization of where each mechanism is located.

![nifi_dataflow_html_interface](/assets/learning-ropes-nifi-lab-series/lab-concepts-nifi/nifi_dataflow_html_interface.png)


### 3.2 Find and Add Processor Overview

Every dataflow requires a set of processors. In the tutorials, you will use the processor icon ![processor_nifi_iot](/assets/learning-ropes-nifi-lab-series/lab1-build-nifi-dataflow/processor_nifi_iot.png) to add processors to the dataflow. Let’s view the add processor window. There are 3 options to find our desired processor. The **processor list** contains almost 180 items with descriptions for each processor. The **tag cloud** reduces the list by category, so if you know what particular use case your desired processor is associated with, select the tag and find the appropriate processor faster. The **filter bar** searches for the processor based on the keyword entered. The image below illustrates where each option is located on the add processor window.

![add_processor_window](/assets/learning-ropes-nifi-lab-series/lab-concepts-nifi/add_processor_window.png)


### 3.3 Configure Processor Dialog

As we add each processor to our dataflow, we must make sure they are properly configured. DataFlow Managers navigate around the 4 configuration tabs to control the processor's specific behavior and instruct the processor on how to process the data that is flowing. Let's explore these tabs briefly. The **Settings** tab allows users to change the processor's name, define relationships & includes many different parameters. The **Scheduling** tab affects how the processor is scheduled to run. The **Properties** tab affects the processor's specific behavior. The **Comments** tab provides a place for DFMs to include useful information about the processor's use-case. For the tutorial series, you will spend most of time modifying properties.

![putfile_logs_nifi_iot](/assets/learning-ropes-nifi-lab-series/lab-concepts-nifi/putfile_logs_nifi_iot.png)

### 3.4 Configure Processor Properties Tab

Let's further explore the properties tab, so we can be familiar with this tab in advance for the tutorials. If you want to know more about what a particular property does, hover over the **help symbol** ![question_mark_symbol_properties_config_iot](/assets/learning-ropes-nifi-lab-series/lab1-build-nifi-dataflow/question_mark_symbol_properties_config_iot.png) located next to the property name to find additional details about that property, its value and history. Some processors enable the DFM to add new properties into the property table. For the tutorials, you will add user-defined properties into processors, such as **UpdateAttribute**. The custom user-defined property you create will assign unique filenames to each FlowFile that transfer through this processor. View the processor properties tab below:

![updateAttribute_config_property_tab_window](/assets/learning-ropes-nifi-lab-series/lab-concepts-nifi/updateAttribute_config_property_tab_window.png)

### 3.5 Connections & relationships

As each processor configuration is completed, we must [connect](http://docs.hortonworks.com/HDPDocuments/HDF1/HDF-1.2.0.1/bk_UserGuide/content/Connecting_Components.html) it to another component. A connection is a linkage between processors (or components) that contain at least one relationship. The user selects the relationship and based on the processing outcome that will determine where the data is routed. Processors can have zero or more auto-terminate relationships. If the processing outcome for FlowFile is true for a processor with a relationship tied to itself, the FlowFile will be removed from the flow. For instance, if **EvaluateXPath** has an unmatched relationship defined to itself and when that outcome is true, then a FlowFile is removed from the flow. Else a FlowFile is routed to the next processor based on matched. View the visual to see the objects that define connections and relationships.

![completed-data-flow-lab1-connection_relationship_concepts](/assets/learning-ropes-nifi-lab-series/lab-concepts-nifi/completed-data-flow-lab1-connection_relationship_concepts.png)


### 3.6 Running the NiFi DataFlow

Once we finish connecting and configuring the components in our dataflow, there are at least 3 conditions we should check to ensure our dataflow successfully runs. We must verify that all relationships are established, the components are valid, stopped, enabled and have no active tasks. After you complete the verification process, you can select the processors, click the play symbol ![start_button_nifi_iot](/assets/learning-ropes-nifi-lab-series/lab1-build-nifi-dataflow/start_button_nifi_iot.png) in the actions toolbar to run the dataflow. View the image of a dataflow that is active.

![run_dataflow_lab1_nifi_learn_ropes_concepts_section](/assets/learning-ropes-nifi-lab-series/lab-concepts-nifi/run_dataflow_lab1_nifi_learn_ropes_concepts_section.png)

### 4\. The Core Concepts of NiFi

When we learned the process of building a dataflow, we crossed paths with many of the core concepts of NiFi. You may be wondering what is the meaning behind a FlowFile, processor, connection, and other terms? Let's learn briefly about these terms because they will appear throughout the tutorial series. We want you to have the best experience in the tutorial. **Table 1** summarizes each term.

**Table 1**: NiFi Core Concepts

| NiFi Term  | Description  |
|:---|---:|
| `FlowFile`  | `Data brought into NiFi that moves through the system. This data holds attributes and can contain content.` |
| [Processor](http://docs.hortonworks.com/HDPDocuments/HDF1/HDF-1.2.0.1/bk_UserGuide/content/processor_anatomy.html)  | `Tool that pulls data from external sources, performs actions on attributes and content of FlowFiles and publishes data to external source.` |
| `Connection`  | `Linkage between processors that contain a queue and relationship(s) that effect where data is routed.` |
| `Flow Controller` | `Acts as a Broker to facilitate the exchange of FlowFiles between processors.` |
| `Process Group` | `Enables the creation of new components based on the composition of processors, funnels, etc.` |



### 5\. A Brief History of NiFi


Apache NiFi originated from the NSA Technology Transfer Program in Autumn of 2014. NiFi became an official Apache Project in July of 2015. NiFi has been in development for 8 years. NiFi was built with the idea to make it easier for people to automate and manage data-in-motion without having to write numerous lines of code. Therefore, the user interface comes with pallet of data flow components that can be dropped onto the graph and connected together. NiFi was also created to solve many challenges of data-in-motion, such as multi-way dataflows, data ingestion from any data source, data distribution with the required security and governance. NiFi can be used by a wide variety of users who come from a variety of backgrounds(development, business) and want to tackle the challenges stated above.

### Further Reading

The topics covered in the concepts section were brief and tailored toward the tutorial series.

- If you are interested in learning more in depth about these concepts, view [Getting Started with NiFi](https://nifi.apache.org/docs/nifi-docs/html/getting-started.html).

- If there is a particular feature you want to learn more about, view our [Hortonworks NiFi User Guide](https://docs.hortonworks.com/HDPDocuments/HDF2/HDF-2.0.0/bk_user-guide/content/index.html)


### Interesting NiFi Use Cases Blogs:  

- [CREDIT CARD FRAUD PREVENTION ON A CONNECTED DATA PLATFORM](http://hortonworks.com/blog/credit-card-fraud-prevention-on-a-connected-data-platform/)
- [QUALCOMM, HORTONWORKS SHOWCASE CONNECTED CAR PLATFORM AT TU-AUTOMOTIVE DETROIT](http://hortonworks.com/blog/qualcomm-hortonworks-showcase-connected-car-platform-tu-automotive-detroit/)
- [CYBERSECURITY: CONCEPTUAL ARCHITECTURE FOR ANALYTIC RESPONSE](http://hortonworks.com/blog/cybersecurity-conceptual-architecture-for-analytic-response/)
