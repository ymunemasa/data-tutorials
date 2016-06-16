# Lab 3: Ingest NextBus Live Stream Routes to the DataFlow

## Introduction
In this tutorial, You will replace the section of our dataflow that generates the simulation of vehicle location XML data with a new section that ingests a live stream of data from NextBus San Francisco Muni Agency on route OceanView into our NiFi DataFlow.

## Pre-Requisites
- Completed Lab 0: Download, Install and Start NiFi
- Completed Lab 1: Build A Simple NiFi DataFlow
- Completed Lab 2: Enhance the DataFlow with Geo Location Enrichment

## Outline
- Step 1: Attach NextBus Live Stream to the DataFlow
- Step 2: Run the NiFi DataFlow
- Summary
- Further Reading

### Step 1: Attach NextBus Live Stream to the DataFlow

### GetHTTP

1\. Delete GetFile, UnpackContent and ControlRate processors. We will replace them with the GetHTTP processor.

2\. Add the **GetHTTP** processor and drag it to the place where the previous three processors were located. Connect GetHTTP to EvaluateXPath processor located above SplitXML. When the Create Connection window appears, select **success** checkbox. Click **Apply**.

3\. Open GetHTTP Config Property Tab window. We will need to copy and paste Nextbus XML Live Feed URL into the property value. Add the property listed in Table 1.

| Property  | Value  |
|---|---|
| URL  | `http://webservices.nextbus.com/service/publicXMLFeed?command=vehicleLocations&a=sf-muni&r=M&t=0` |

![getHTTP_liveStream_config_property_tab_window](/assets/learning-ropes-nifi-lab-series/lab3-ingest-nextbus-live-stream-nifi-lab-series/getHTTP_liveStream_config_property_tab_window.png)

4\. Open the processor config **Settings** tab, change the processor's Name from GetHTTP to `IngestVehicleLoc_SF_OceanView`. Click **Apply** button.

### Step 2: Run the NiFi DataFlow

Now that we added NextBus San Francisco Muni Live Stream Ingestion to our dataflow , let's run the dataflow and verify if we receive the expected results in our output directory.

1\. Go to the actions toolbar and click the start button ![start_button_nifi_iot](assets/learning-ropes-nifi-lab-series/lab1-build-nifi-dataflow/start_button_nifi_iot.png). Your screen should look like the following:

![complete_dataflow_lab3_live_stream_ingestion](/assets/learning-ropes-nifi-lab-series/lab3-ingest-nextbus-live-stream-nifi-lab-series/complete_dataflow_lab3_live_stream_ingestion.png)

2\. Let's verify the data in output directory is correct. Navigate to the following directories and open a random one to check the data.

~~~
cd /home/nifi/output/nearby_neighborhoods_search
ls
vi 58849126478211
~~~

Did you receive neighborhoods similar to the image below?

![nextbus_liveStream_output_lab3](assets/learning-ropes-nifi-lab-series/lab3-ingest-nextbus-live-stream-nifi-lab-series/nextbus_liveStream_output_lab3.png)

## Summary

Congratulations! You learned how to use the GetHTTP processor to ingest a live stream from NextBus San Francisco Muni!

## Further Reading
