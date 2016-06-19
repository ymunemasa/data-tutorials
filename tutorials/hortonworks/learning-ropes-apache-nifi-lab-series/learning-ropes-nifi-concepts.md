# Introduction to DataFlow Automation with Apache NiFi

## Outline
- What is Apache NiFi?
- Who Uses NiFi, and for what?
- Understand NiFi DataFlow Build Process
- The Core Concepts of NiFi
- NiFi Architecture
- Performance Expectations & Characteristics
- NiFi Key Features
- A Brief History of NiFi


### What is Apache NiFi?

[Apache NiFi](https://nifi.apache.org/docs/nifi-docs/html/overview.html#what-is-apache-nifi) is an open source tool for automating and managing the flow of data between systems. To create an effective dataflow, users must understand the various types of processors ![nifi_processor_mini](/assets/realtime-event-processing-with-hdf/lab0-nifi/processor_grey_background_iot.png). This tool is the most important building block available to NiFi because it enables NiFi to perform:

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

NiFi is designed to help tackle modern dataflow challenges, such as system failure, data access exceeds capacity to consume, boundary conditions are mere suggestions, systems evolve at different rates, compliance and security.

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
