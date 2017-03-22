---
title: Port Forwarding to Azure Sandbox
tutorial-id: 621
platform: hdp-2.5.0
tags: [azure]
---

# Port Forwarding To Azure Sandbox

## Introduction

When you deploy virtual machines on Azure, a good practice is to set up Azure [Network Security Groups](https://docs.microsoft.com/en-us/azure/virtual-network/virtual-networks-nsg) (NSG) to minimize the exposure of endpoints and limit access to those endpoints to only known IPs from the Internet.  In order to access the rest of the endpoints in your Virtual Network (VNet) on Azure, you can set up an SSH tunnel.

SSH tunneling allows us a way to port forward securely, without actually opening the machine's ports for the entire world to access.  Follow these steps to access the endpoints of your Azure deployment from your computer.

## Prerequisites

- [Deploy Hortonworks Sandbox on Microsoft Azure](https://hortonworks.com/hadoop-tutorial/deploying-hortonworks-sandbox-on-microsoft-azure)

## Outline

- [Find the sandbox IP](#find-the-sandbox-ip)
- [Configure SSH Tunneling](#configure-ssh-tunneling)
- [Summary](#summary)
- [Further Reading](#further-reading)

## Find the sandbox IP

Log into Microsoft Azure and select the sandbox you have already deployed.  When its overview appears, take note of the sandbox's public IP address, as we will use this to connect to the sandbox.

![Take note of the machine's IP address.](assets/10.jpg)

## Configure SSH Tunneling

Use your favorite editor and edit your `~/.ssh/config` file.  For example:
```
vi ~/.ssh/config
```

Enter the following configuration, replacing the **HostName** IP with the public IP of your instance.  More forwardings can be entered via the **LocalForward** directive similar to the ones displayed here.

> Note: Spacing and capitalization is important.

```
Host azureSandbox
  Port 22
  User azure
  HostName 52.175.207.131
  LocalForward 8080 127.0.0.1:8080
  LocalForward 8888 127.0.0.1:8888
  LocalForward 9995 127.0.0.1:9995
  LocalForward 9996 127.0.0.1:9996
  LocalForward 8886 127.0.0.1:8886
  LocalForward 10500 127.0.0.1:10500
  LocalForward 4200 127.0.0.1:4200
  LocalForward 2222 127.0.0.1:2222
```

Save and close the file.  Now SSH into the Azure machine by using the **Host** alias we just configured, which will connect us automatically using the IP address we specified in the config file.  You'll be asked for a password, which is the one you set during initial configuration on Azure.

```
ssh azureSandbox
```

That's it!  Keep this SSH connection open for the duration of your interaction with the sandbox on Azure.

## Summary

You can now access all forwarded ports by pointing a browser to [http://localhost:portNumber](http://localhost:portNumber).  For example: [http://localhost:8888](http://localhost:8888) will connect to the Azure machine and sandbox over port 8888.

SSH tunneling allows us a way to port forward securely, without actually opening the machine's ports for the entire world to access.

## Further Reading

Dive into how to use the Sandbox, or read more about exactly how SSH tunneling works.

- [Learning the Ropes of the Hortonworks Sandbox](https://hortonworks.com/hadoop-tutorial/learning-the-ropes-of-the-hortonworks-sandbox)
- [SSH Tunneling Explained](https://chamibuddhika.wordpress.com/2012/03/21/ssh-tunnelling-explained)
