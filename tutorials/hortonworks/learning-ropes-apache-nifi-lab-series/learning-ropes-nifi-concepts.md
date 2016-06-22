# Introduction to DataFlow Automation with Apache NiFi

## Outline
- 1\. What is Apache NiFi?
- 2\. Who Uses NiFi, and for what?
- 3\. Understand NiFi DataFlow Build Process
- 4\. The Core Concepts of NiFi
- 5\. A Brief Hisotry of NiFi
- Further Reading

### 1\. What is Apache NiFi?

[Apache NiFi](https://nifi.apache.org/docs/nifi-docs/html/overview.html#what-is-apache-nifi) is an open source tool for automating and managing the flow of data between systems. In the lab, we will use NiFi to process the flow of data between sensors, web services (NextBus and Google Places API), various locations and our local file system. NiFi will solve our dataflow challenges since it can adapt. Problems we may face include data access exceeds capacity to consume, systems evolve at different rates, compliance and security.


### 2\. Who Uses NiFi, and for what?

NiFi is used for **data ingestion** to pull data into NiFi from numerous different data sources and create FlowFiles. For lab, GetFile, GetHTTP, InvokeHTTP are processors you will use to stream data into NiFi from the local file system and download data from the internet. Once the data is ingested, a DataFlow Manager (DFM), the user, will perform **data management** by monitoring and obtaining feedback about the current status of the NiFi DataFlow. The DFM also has the ability to add, remove and modify components of dataflow. You will use bulletins, located on the processor and management toolbar, which provide a tool-tip of the time, severity and message of the alert to troubleshoot problems in the dataflow. While the data is being managed, you will create **data enrichment** to enhance, refine and improve the quality of data to make it meaningful and valuable for users. NiFi enables users to filter out unnecessary information from data to make easier to understand. You will use NiFi to geographically enrich real-time data to show neighborhoods nearby locations as the locations change.


### 3\. Understand NiFi DataFlow Build Process

### 3.1 Explore NiFi HTML Interface

When NiFi is accessed at `localhost:6434/nifi`, NiFi's User Interface (UI) appears on the screen. The UI is where dataflows will be built. It includes a canvas and _mechanisms_ to build, visualize, monitor, edit, and administer our dataflows in the labs. The **components** toolbar contains all tools for building the dataflow. The **actions** toolbar consists of buttons that manipulate the components on the canvas. The **management** toolbar has buttons for the DFM to manage the flow and a NiFi administrator to manage user access & system properties. The **search** toolbar enables users to search for any component in the dataflow. The image below shows a visualization of where each mechanism is located.

![nifi_dataflow_html_interface](/assets/learning-ropes-nifi-lab-series/lab-concepts-nifi/nifi_dataflow_html_interface.png)


### 3.2 Add Processor Dialog Overview

Every dataflow requires processors. In the labs, you will use the processor icon to add processors to the dataflow. Let’s view the add processor window. There are 3 options to find our desired processor. The **processor list** contains 157 items with descriptions for each processor. The **tag cloud** reduces the list by category, so if you know what particular use case your desired processor is associated with, select the tag and find the appropriate processor faster. The **filter bar** searches for processor based on the keyword entered. The image below illustrates where each option is located on the add processor window.

![add_processor_window](/assets/learning-ropes-nifi-lab-series/lab-concepts-nifi/add_processor_window.png)


### 3.3 Configure Processor Dialog Overview

As we add each processor to our dataflow, we must make sure they are properly configured. DataFlow Managers navigate around the 4 configuration tabs to control the processor's specific behavior and instruct the processor on how to process data. Let's explore these tabs briefly. The **Settings** tab allows users to change the processor's name, define relationships & includes many different parameters. The **Scheduling** tab affects how the processor is scheduled to run. The **Properties** tab affects the processor's specific behavior. The **Comments** tab provides a place for DFMs to include useful information about the processor's use-case. For the lab series, you will spend most of time modifying properties and their values.

![putfile_logs_nifi_iot](/assets/learning-ropes-nifi-lab-series/lab-concepts-nifi/putfile_logs_nifi_iot.png)

### 3.4 Configure Processor Properties Tab

Let's further explore the properties tab, so we can be familiar with this tab in advance for the labs. If you want to know more about what a particular property does, hover over the **help symbol** located next to the property name to find additional details about that property, its value and history. Some processors enable the DFM to add new properties into the property table. For the labs, you will add user-defined properties into processors, such as **UpdateAttribute**. The custom user-defined property you create will assign unique filenames to each FlowFile that transfer through this processor. View the processor properties tab below:

![updateAttribute_config_property_tab_window](/assets/learning-ropes-nifi-lab-series/lab-concepts-nifi/updateAttribute_config_property_tab_window.png)

### 3.5 Connections & relationships

As each processor configuration is completed, we must connect it to another component. A connection is a linkage between processors (or components) that contain at least one relationship. The user selects the relationship and based on the processing outcome that will determine where the data is routed. Processors can have zero or more auto-terminate relationships. If the processing outcome for FlowFile is true for a processor with a relationship tied to itself, the FlowFile will be removed from the flow. For instance, if **EvaluateXPath** has an unmatched relationship defined to itself and when that outcome is true, then a FlowFile is removed from the flow. Else a FlowFile is routed to the next processor based on matched. View the visual to see the objects that define connections and relationships.

![completed-data-flow-lab1-connection_relationship_concepts](/assets/learning-ropes-nifi-lab-series/lab-concepts-nifi/completed-data-flow-lab1-connection_relationship_concepts.png)


### 3.6 Running the NiFi DataFlow

Once we finish connecting and configuring the components in our dataflow, there are at least 3 conditions we should check to ensure our dataflow successfully runs. We must verify that all relationships are established, the components are valid, stopped, enabled and have no active tasks. After you complete the verification process, you can select the processors, click the play symbol in the actions toolbar to run the dataflow. View the image of a dataflow that is active.

![run_dataflow_lab1_nifi_learn_ropes_concepts_section](/assets/learning-ropes-nifi-lab-series/lab-concepts-nifi/run_dataflow_lab1_nifi_learn_ropes_concepts_section.png)

### 4\. The Core Concepts of NiFi

When we learned the process of building a dataflow, we crossed paths with many of the core concepts of NiFi. You may be wondering what is the meaning behind a FlowFile, processor, connection, and other terms? Let's learn briefly about these terms because they will appear throughout the lab series. We want for you to have the best experience in lab. **Table 1** summarizes each term.

**Table 1**: NiFi Core Concepts

| NiFi Term  | Description  |
|---|---|
| FlowFile  | Data brought into NiFi that moves through the system. This data holds attributes and can contain content. |
| Processor  | Tool that pulls data from external sources, performs actions on attributes and content of FlowFiles and publishes data to external source. |
| Connection  | Linkage between processors that contain a queue and relationship(s) that effect where data is routed. |
| Flow Controller | Acts as a Broker to facilitate the exchange of FlowFiles between processors. |
| Process Group | Enables the creation of new components based on the composition of processors, funnels, etc. |



### 5\. A Brief Hisotry of NiFi


Apache NiFi originated from the NSA Technology Transfer Program in Autumn of 2014. NiFi became an official apache project in July of 2015. NiFi has been in development for 8 years. NiFi was built with the idea to make it easier for people to automate and manage their data-in-motion without having to write numerous lines of code. Therefore, the user interface comes with many shape like tools that can be dropped onto the graph and connected together. NiFi was also created to solve many challenges of data-in-motion, such as multi-way dataflows, data ingestion from any data source, data distribution and the required security and governance. NiFi is a great tool for users who come from strong backgrounds in development or business that want to tackle the challenges stated above.

### Further Reading

The topics covered in the concepts section were brief and tailored toward the lab series. If you are interested in learning more in depth about these concepts, view [Getting Started with NiFi](https://nifi.apache.org/docs/nifi-docs/html/getting-started.html).




To create an effective dataflow, users must understand the various types of processors ![nifi_processor_mini](/assets/realtime-event-processing-with-hdf/lab0-nifi/processor_grey_background_iot.png). This tool is the most important building block available to NiFi because it enables NiFi to perform:

- Data Transformation
- Routing and Mediation
- Database Access
- Attribute Extraction
- System Interaction
- Data Ingestion
- Data Egress/Sending Data
- Splitting and Aggregation
- HTTP Requests
- Amazon Web Services



### Step 5: Understand NiFi DataFlow Build Process <a id="step5-create-nifi-dataflow-lab0"></a>

We can begin to build a data flow by adding, configuring and connecting the processors. We will also troubleshoot common problems that occur when creating data flows.
By the end of the IoT Lab Series, you will have built the following dataflow. Refer back to this image if you want to replicate the processors positions on the graph:

![Completed-dataflow-for-lab3](/assets/learning-ropes-nifi-lab-series/lab-intro-nifi-learning-ropes/completed-dataflow-rd1-lab3.png)

**Figure 1:** This dataflow performs Data Ingestion from HTTP, Splitting and Aggregation, Attribute Extraction, Routing and Mediation, Data Geo Enrichment and Data Egress/Sending Data.

[ExecuteProcess](https://nifi.apache.org/docs/nifi-docs/components/org.apache.nifi.processors.standard.ExecuteProcess/index.html) Runs the operating system command to activate the stream simulator and the StdOut is redirected such that the content is written to StdOut becomes the content of the outbound FlowFile.

[SplitText](https://nifi.apache.org/docs/nifi-docs/components/org.apache.nifi.processors.standard.SplitText/index.html) takes in one FlowFile whose content is textual and splits it into 1 or more FlowFiles based on the configured number of lines. Each FlowFile is 1 line.

[UpdateAttribute](https://nifi.apache.org/docs/nifi-docs/components/org.apache.nifi.processors.attributes.UpdateAttribute/index.html) updates each FlowFile with a unique attribute name. ${UUID()}.

[RouteOnContent](https://nifi.apache.org/docs/nifi-docs/components/org.apache.nifi.processors.standard.RouteOnContent/index.html) search content of the FlowFile to see if it matches the regex regular expression, such as (Normal), (Overspeed), (“Lane Departure”). The expressions are driving event keywords. If so, the Flowfile is routed to the processor with the configured relationship.

[MergeContent(x2)](https://nifi.apache.org/docs/nifi-docs/components/org.apache.nifi.processors.standard.MergeContent/index.html) merges many FlowFiles into a single FlowFile. In the tutorial, each FlowFile is merged by concatenating their content together. There will be two processors: one of them will merge all the truck events into a single FlowFile while the other merges all the log data together.

[PutFile(x2)](https://nifi.apache.org/docs/nifi-docs/components/org.apache.nifi.processors.standard.PutFile/index.html) writes the contents of a FlowFile to a directory on a local file system. There will be two processors: one that writes the filtered logs data to log_data folder. The other that writes the filtered truck event data to truck_events folder.

### 5.3 Troubleshoot Common Processor Issues

You will notice each time you add a new processor, it will have a warning symbol ![warning_symbol_nifi_iot](/assets/realtime-event-processing-with-hdf/lab0-nifi/warning_symbol_nifi_iot.png) in the upper left corner of the processor face. These warning symbols indicate the processors are invalid.

1\. Hover over one of the processors to troubleshoot the issue. This message informs us of the requirements to make a processor valid, such as the ExecuteProcess.

![warning_message_executeprocess_nifi_iot](/assets/realtime-event-processing-with-hdf/lab0-nifi/warning_message_executeprocess_nifi_iot.png)

The warning message indicates: we need to enter a command into the value field of the **property** command since it is empty and connect this processor to another component to establish a relationship.
Each Processor will have its own alert message. Let’s configure and connect each processor to remove all the warning messages, so we can have a complete data flow.


### 5.4 Add, Configure & Connect processors

We will build our NiFi DataFlow by adding, configuring and connecting processors. When adding processors, you have three ways to find your desired processor from the **Add Processor** window: **Tags** section left of the table, **Processor List** located in the table and **filter bar** positioned above the table. After we add our processor, we can configure it from the Configure Processor window using the 4 tabs: **Settings**, **Scheduling**, **Properties** and **Commands**. For this lab, we will spend most of our time in the properties tab. The properties in **bold** must contain default or updated values for the processor to run. If you are curious to learn more about a specific property, hover over the help icon next to the Property Name to read a description on that property. Every processor has a relationship on how it transfers data to the next processor, another word for this is connection. Relationships affect how data is transferred between processors. For instance, you can have a **split** relationship that when true transfer a bunch of FlowFiles that were split from one large FlowFile to the next processor.

If you would like to read more about configuring and connecting processors, refer to [Hortonworks Apache NiFi User Guide](http://docs.hortonworks.com/HDPDocuments/HDF1/HDF-1.2.0.1/bk_UserGuide/content/ch_UserGuide.html), Building a DataFlow: section 6.2 and 6.5.

### Add Processors

To add a processor, we will go to the components toolbar, drag and drop the processor ![processor_nifi_iot](/assets/realtime-event-processing-with-hdf/lab0-nifi/processor_nifi_iot.png) onto the graph.


An **Add Processor** window will open. There are 3 options to find our desired processor. We can scroll through the **processor list**, use the **tag cloud** to reduce the processor list by category or utilize the **filter bar** to search for our processor.

![add_processor_window](/assets/realtime-event-processing-with-hdf/lab0-nifi/add_processor_window.png)

### Description of Processor

Let’s select the [ExecuteProcess](https://nifi.apache.org/docs/nifi-docs/components/org.apache.nifi.processors.standard.ExecuteProcess/index.html) processor. A short description of that processor’s function will appear.

Runs the operating system command to activate the stream simulator and the StdOut is redirected such that the content is written to StdOut becomes the content of the outbound FlowFile.

Click the **add** button to add the processor to the graph.

![processor_description_iot](/assets/realtime-event-processing-with-hdf/lab0-nifi/processor_description_iot.png)
