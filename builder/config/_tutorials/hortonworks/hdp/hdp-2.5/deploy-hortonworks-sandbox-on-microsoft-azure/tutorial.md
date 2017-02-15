---
title: Deploy Hortonworks Sandbox on Microsoft Azure
tutorial-id: 620
platform: hdp-2.5.0
tags: [azure]
---

# Deploy Hortonworks Sandbox on Microsoft Azure

## Introduction

The Azure cloud infrastructure has become a common place for users to deploy virtual machines on the cloud due to its flexibility, ease of deployment, and cost benefits.  Microsoft has expanded Azure to include a marketplace with thousands of certified, open source, and community software applications and developer services, pre-configured for Microsoft Azure.  This tutorial covers deploying the Hortonworks Sandbox offering via the Azure Marketplace.

## Prerequisites

- [A Microsoft Azure account. You can sign up for an evaluation account if you do not already have one.](https://azure.microsoft.com/en-us/free/)

## Outline

- [Find Hortonworks Sandbox on Azure Marketplace](#find-hortonworks-sandbox-on-azure-marketplace)
- [Creating the Sandbox](#creating-the-sandbox)
- [Set a Static IP](#set-a-static-ip)
- [Connecting to the Sandbox](#connecting-to-the-sandbox)
- [Splash Screen](#splash-screen)
- [Further Reading](#further-reading)

## Find Hortonworks Sandbox on Azure Marketplace

Go to https://azuremarketplace.microsoft.com/en-us/marketplace and enter "Hortonworks" into the search bar.  Submit, and the **Hortonworks Sandbox** product should appear as shown in this screenshot.

![Select "Hortonworks Sandbox" from the bottom view.]({{page.path}}/assets/1.jpg)

Click on **Get It Now** to start the setup process.

![Select "GET IT NOW" to begin the setup process.]({{page.path}}/assets/2.jpg)

If prompted, sign in to Azure Marketplace.  Afterward, you'll be asked to confirm your selection, as shown below.

![Select "Continue" to continue the process.]({{page.path}}/assets/3.jpg)

## Creating the Sandbox

An explanation of the Hortonworks Sandbox will come on the screen.  When ready to being the deployment process, select **Create** from the bottom of the screen.

![Select "Create" on the bottom of the screen.]({{page.path}}/assets/4.jpg)

Fill out some basic sandbox configuration settings.  Scroll down for an explanation of the different fields.

![The basic configuration page with filled-out fields.]({{page.path}}/assets/5.jpg)

The different fields:
-   **Name**: This is the name you want to use to reference the machine.  In the example above, we use the name "MySandbox"
-   **User name**: The name of the user account that will be used to log into the machine.  Throughout these tutorials, we will use azure as the user name.
-   **Authentication type**: By default, the machine will be deployed and allow you to connect via SSH key or password.  In this example, we opt to use a password.
-   **Subscription**: The subscription to deploy the machine under.  Select one already in your list.
-   **Resource group**: The name of the resource group to create, or use an existing one.  Here, we create a new one with the same name as the machine itself.
-   **Location**: Which region in the Azure offering to deploy the machine to.

> Note: Make sure to write down or remember your username and password.  If using SSH, ensure you have the corresponding private key.  Otherwise, you will not be able to log in to the machine.

The next step is to choose a size for the virtual machine.  It is recommended to use a machine with A4 specifications, or higher.

![Select a size for your virtual machine.]({{page.path}}/assets/6.jpg)

Optional settings to configure.  You can safely leave this as default.

![Optional settings for the machine.]({{page.path}}/assets/7.jpg)

Look over the summary and continue when ready.

![Summary of the deployment settings.]({{page.path}}/assets/8.jpg)

Alright, we're ready to deploy!  Review the offer details and purchase when ready.

![Review the offer details.]({{page.path}}/assets/9.jpg)

Once the offer is submitted by selecting **Purchase**, the sandbox will take a few minutes to set up and deploy.  After deployment is complete, we can move on to connecting to the sandbox.

## Set a Static IP

Once the machine is deployed, it's overview will appear on the screen.  Find the sandbox's public IP address and click on it.

![Find the machine's IP address.]({{page.path}}/assets/10.jpg)

Clicking on the IP address will bring up the IP configuration panel.  Select **Static** as the Assignment, and then make sure to save your changes.  This will keep the sandbox from changing IP addresses each time it's rebooted.

![Set the machine's IP to static]({{page.path}}/assets/static-ip.jpg)

## Connecting to the Sandbox

Fantastic, the sandbox is now up and running!  Though we still need to set up a secure connection to it.  Head on over to [Port Forwarding To Azure Sandbox](http://#) for a quick walkthrough on connecting to Azure.

## Splash Screen

Now that you've port forwarded by following the tutorial linked above, you can explore the sandbox as you see fit.  Point your browser to http://localhost:8888 for the sandbox's splash screen.

![Sandbox registration form]({{page.path}}/assets/sandbox-registration.jpg)

Fill out the form and hit **Submit** to access the sandbox.

![The sandbox splash page.]({{page.path}}/assets/sandbox-splash.jpg)

Eureka!

## Further Reading

Now that you've got HDP up and running, check out our other tutorials to learn how to leverage its power.

- [Learning the Ropes of the Hortonworks Sandbox](http://hortonworks.com/hadoop-tutorial/learning-the-ropes-of-the-hortonworks-sandbox)
