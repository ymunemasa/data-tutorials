# Running the Demo

## Introduction

## Outline

-   [Environment Setup](#)
-   [The Data Involved](#)
-   [Demo Start!](#)
-   [What's going on](#)
-   [Next: Building the Topology](#)

## Setup

SSH into your HDP environment and download the two components to this reference application:

```
git clone https://github.com/orendain/trucking-iot
git clone https://github.com/orendain/trucking-iot-demo-1
```

## The Data Involved

### Simulated Data

The project includes a very robust data simulator, which generates data of two types and stores them in Kafka topics.

`EnrichedTruckData`: Data simulated by sensors onboard each truck.  For the purposes of this demo, this data has been pre-enriched with data from a weather service.

```
1488767711734|26|1|Edgar Orendain|107|Springfield to Kansas City Via Columbia|38.95940879245423|-92.21923828125|65|Speeding|1|0|1|60
```
![EnrichedTruckData fields](assets/enriched-truck-data_fields.png)


`TrafficData`: Data simulated from an online traffic service, which reports on traffic congestion on any particular trucking route.

```
1488767711734|107|60
```
![TrafficData fields](assets/traffic-data_fields.png)

### Data Processing

With the simulated data available in Kakfa topics, we leverage Storm and put the data through the following flow.

![General Storm Process](assets/storm-flow-general.jpg)

### Visualization

With the processed data in a Kafka topic, our reactive web application subscribes to this Kafka topic, reading in data as it shows up in the topic.


## Demo Start

Now that we know what to expect, let's run the demo and see the data flow in action:
```
./trucking-iot/scripts/demo-1/run-simulator-and-webapp.sh
./trucking-iot-demo-1/scripts/deploy-topology.sh
```

The first script does the following:
-  Start the simulator and generates IoT data
-  Bring up the web application so we can visualize the data processed by Storm

The second script deploys the Storm topology to handle the data processing.

Next, bring up the web application, accessible through your brower at: `sandbox.hortonworks.com:17000`

This application is rendering data after it has made its way through the pipeline.


## What Storm is Doing

In order to make this happen, Storm is doing the following:

![Storm Process - High Level Overview](assets/storm-flow-overview.jpg)

- Here's the same graphic as before, only this time with terminology. (color-coded/arrows)


## Next: Build

Now that we know the work that Storm is doing, let's dive into the code that powers this topology and see exactly how this system is built with actual code.
