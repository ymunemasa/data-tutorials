---
layout: tutorial
title: Hortonworks Sandbox Guide
tutorial-id: 730
tutorial-series: Hello World
tutorial-version: hdp-2.5.0
intro-page: true
components: [ sandbox ]
---

## Overview

The **Hortonworks Sandbox** can now be imported as a docker image on those systems that support docker. It works on a virtualization layer on top of your existing hardware and allocates resources from the existing pool offered by the physical machine but without the extra overhead typically associated with virtual machines.  

## Prerequisites

To use Hortonworks Sandbox with Docker the following requirements need to be met:  

### Docker Daemon Installed:

1\. Docker version 1.12.1 or newer     
2\. You can find install instructions [here](https://docs.docker.com/engine/installation/).  

### Host Operating System:

The docker version of the Hortonworks Sandbox was developed on a native linux platform and thus it’s easiest to launch it on a **Linux Distro**. The following tutorial will be Linux centered and will work on any popular distro that has a functional bash shell.  

Information on launching the sandbox on Windows/ Mac OS-boxes without bash will be summarily provided at the end of the tutorials.   

Host operating system refers to the operating system of your computer. You can find the list of supported operating systems [here](https://docs.docker.com/v1.8/installation/).

### Hardware ( The newer the hardware the better )

1\. At least 8GB of RAM available on your machine for launching the application.   
2\. At least 15GB free for the initial image,  30+ GB recommended.  

### Browsers:  

1\. Chrome 25+  
2\. IE 9+ (Sandbox will not run on IE 10)  
3\. Safari 6+  

### Hortonworks Sandbox virtual appliance for Sandbox:  

Download the correct virtual appliance file for your environment from [here](http://hortonworks.com/products/hortonworks-sandbox/#install). The file extension for a virtual appliance for VirtualBox should be .tar **EDIT ME**.

## Procedure

The steps provided describe how to import the Hortonworks Sandbox Docker image. The screenshots displayed are taken from a **Centos7** Linux machine running **Docker 1.12.1**:  

1\. Ensure that docker daemon is running. On linux you can check this with the following command:  

![docker_images](/assets/hortonworks-sandbox-hdp2.5-guide/docker_images.png)

If docker daemon is running on your machine and you have no other images imported this is what the successful output of the command will look like.  

2\. Load the Hortonworks Sandbox Docker image with the following command:  

![docker_load](/assets/hortonworks-sandbox-hdp2.5-guide/docker_load.png)

To check that the image was successfully imported try running the docker images command again.  

![docker_images2](/assets/hortonworks-sandbox-hdp2.5-guide/docker_images2.png)

3\. Download and run the start sandbox script  

You can download the start script [here](https://github.com/hortonworks/sandbox-shared/blob/master/deploy/packer/docker_resources/singlenode/scripts/start_scripts/start_sandbox.sh) **EDIT ME**  

Save it to your computer and execute it, you can ignore the $TERM warnings:  

![bash_start](/assets/hortonworks-sandbox-hdp2.5-guide/bash_start.png)

You can now connect to the sandbox tutorials page at http://localhost:8888

![splash_screen.png](/assets/hortonworks-sandbox-hdp2.5-guide/splash_screen.png)

## Run notes for non-linux users:

In order to launch the sandbox in a non-linux environment, proceed to import the sandbox.tar image as instructed by the version of docker you are using.  

You then need to spawn a container with the --privileged flag from the image making sure to forward the following ports: 6080 , 9090 , 9000 , 8000 , 8020 , 42111 , 10500 , 16030 , 8042 , 8040 , 2100 , 4200 , 4040 , 8050 , 9996 , 9995 , 8080 , 8088 , 8886 , 8889 , 8443 , 8744 , 8888 , 8188 , 8983 , 1000 , 1100 , 11000 , 10001 , 15000 , 10000 , 8993 , 1988 , 5007 , 50070 , 19888 , 16010 , 50111 , 50075 , 50095 , 18080 , 60000 , 8090 , 8091 , 8005 , 8086 , 8082 , 60080 , 8765 , 5011 , 6001 , 6003 , 6008 , 1220 , 21000 , 6188 , 22

Once this is achieved, use the ssh port you forwarded to to login into the sandbox. It will prompt you for a password change, continue to change it ( the in-place password is `hadoop` ):  

![ssh_root](/assets/hortonworks-sandbox-hdp2.5-guide/ssh_root.png)

Once this is achieved, run the startup script and ignore any warnings:  

![startup_script](/assets/hortonworks-sandbox-hdp2.5-guide/startup_script.png)

You can now connect to your machine at http://localhost:8888
