---
title: Opening Sandbox Ports on Azure
tutorial-id: 622
platform: hdp-2.5.0
tags: [azure, docker, ports]
---

# Opening Sandbox Ports on Azure

## Introduction

The Hortonworks Sandbox running on Azure requires opening ports a bit differently than when the sandbox is running locally on Virtualbox or Docker.  We'll walk through how to open a port in Azure so that outside connections make their way into the sandbox, which is a Docker container inside an Azure virtual machine.

> Note: There are multiple ways to open ports to a Docker container (i.e. the sandbox).  This tutorial will cover the simplest method, which reinitializes the sandbox to its original state.  In other words, you will lose all changes made to the sandbox.

## Prerequisites

-   [Deploying Hortonworks Sandbox on Microsoft Azure](https://hortonworks.com/hadoop-tutorial/deploying-hortonworks-sandbox-on-microsoft-azure/)

## Outline

-   [SSH Into The Azure VM](#ssh-into-the-azure-vm)
-   [Add Ports to the Docker Script](#add-ports-to-the-docker-script)
-   [Remove the Current Sandbox Container](#section-title-2))
-   [Restart the Azure VM](#restart-the-azure-vm)
-   [(Optional) Add New Ports to the SSH Config](#optional-add-new-ports-to-the-ssh-config)

## SSH Into the Azure VM

If you followed the previous tutorial, [Deploying Hortonworks Sandbox on Microsoft Azure](https://hortonworks.com/hadoop-tutorial/deploying-hortonworks-sandbox-on-microsoft-azure/), this step is as easy as running:

```
ssh azureSandbox
```

Otherwise, follow whichever method you prefer to SSH into the Azure VM that is running the sandbox.

## Add Ports to the Docker Script

The script in the Azure VM that is responsible for creating the dockerized Sandbox container is located at `/root/start_scripts/start_sandbox.sh`.

> Note: You're probably not logged in as root, so do not forget to **sudo** your commands.

Open `/root/start_scripts/start_sandbox.sh` to reveal the docker script, which looks something like the following:

```
docker run -v hadoop:/hadoop --name sandbox --hostname "sandbox.hortonworks.com" --privileged -d \
-p 6080:6080 \
-p 9090:9090 \
-p 9000:9000 \
-p 8000:8000 \
-p 8020:8020 \
-p 2181:2181 \
-p 42111:42111 \
...
```

Edit this file and add your desired port forward.  In this example, we're going to forward host port 15000 to sandbox port 15000.  The file should now look something like the following:

```
docker run -v hadoop:/hadoop --name sandbox --hostname "sandbox.hortonworks.com" --privileged -d \
-p 15000:15000 \
-p 6080:6080 \
-p 9090:9090 \
-p 9000:9000 \
-p 8000:8000 \
-p 8020:8020 \
-p 2181:2181 \
-p 42111:42111 \
...
```

## Remove the Current Sandbox Container

Terminate the existing sandbox container, and then remove it.

> Warning: Be aware that this deletes the sandbox, changes are not saved.

```
sudo docker stop sandbox
sudo docker rm sandbox
```

## Restart the Azure VM

We now restart the Azure VM.  Upon restart, the script we modified above will be run in order to start the sandbox container.  Since we removed the container in the previous step, the sandbox container is first rebuilt with your newly specified port forwards.

You may restart the Azure VM by stopping and starting via the Azure Portal, or you can execute the following while SSH'd in.

```
sudo init 6
```

## (Optional) Add New Ports to the SSH Config

If you're connecting to Azure via SSH tunneling, be sure to add new forwarding directives to your SSH config.  See the [Deploying Hortonworks Sandbox on Microsoft Azure tutorial](https://hortonworks.com/hadoop-tutorial/deploying-hortonworks-sandbox-on-microsoft-azure/#configure-ssh-tunneling) for more information.
