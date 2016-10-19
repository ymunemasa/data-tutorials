---
layout: tutorial
title: Introducing Apache Ambari for Deploying and Managing Apache Hadoop
tutorial-id: 320
tutorial-series: Operations
tutorial-version: hdp-2.5.0
intro-page: true
components: [ ambari , vagrant ]
---

## Introduction

In this tutorial, we will explore how to quickly and easily deploy Apache Hadoop with [Apache Ambari](http://hortonworks.com/hadoop/ambari). We will spin up our own VM with [Vagrant](http://www.vagrantup.com/) and [Apache Ambari](http://hortonworks.com/hadoop/ambari). Vagrant is very popular with developers as it lets one mirror the production environment in a VM while staying with all the IDEs and tools in the comfort of the host OS.

If you’re just looking to get started with Hadoop in a VM, then you can simply download the [Hortonworks Sandbox](http://hortonworks.com/sandbox).

## Prerequisites

*   [VirtualBox](https://www.virtualbox.org/wiki/Downloads)
*   [Vagrant](http://vagrantup.com/)

## Outline

- [1. Spin up a VM with Vagrant](#spin-up)
- [2. Configure the VM](#configure-vm)
- [3. Setting up Passwordless SSH](#passwordless-ssh)
- [4. Set up Ambari](#setup-ambari)
- [5. Pseudo-Mode HDP Cluster Set up using Ambari](#pseudo-mode)


### 1. Spin up a VM with Vagrant <a id="spin-up"></a>

Create a folder for this VM using:

~~~
mkdir hdp_vm
~~~

Install Virtualbox and Vagrant and then issue the following command:

~~~
vagrant box add hdp_vm https://github.com/2creatives/vagrant-centos/releases/download/v6.5.1/centos65-x86_64-20131205.box
~~~

It starts the download and gets added to the library of VMs with the name **hdp_vm**. Issue below command now to initialize the vagrant:

~~~
vagrant init hdp_vm
~~~

This command creates a VagrantFile in the folder. Use vi editor to make changes.

~~~
vi VagrantFile
~~~

Change the forwarded port to 8080 like this:

![change_port](/assets/introducing-apache-ambari-deploying-managing-hadoop/change_port.png)

Change the memory size to 8 GB,

![change_memory](/assets/introducing-apache-ambari-deploying-managing-hadoop/change_memory.png)

Save the file and launch the VM and SSH in and login as root and change to the home directory. Follow below steps:

~~~
vagrant up
vagrant ssh
sudo su
cd ~
~~~

### 2. Configure the VM <a id="configure-vm"></a>

Type `hostname` on command line to find out the hostname of the machine.

![hostname](/assets/introducing-apache-ambari-deploying-managing-hadoop/hostname.png)

Edit /etc/hosts file to map the IP address with the hostname.

![hosts_file](/assets/introducing-apache-ambari-deploying-managing-hadoop/hosts_file.png)

Install **ntp** and **wget** utility using following commands:

~~~
yum install ntp
yum install wget
~~~

Start the **ntpd** service through:

~~~
chkconfig ntpd on
service ntpd start
~~~

![chkconfig](/assets/introducing-apache-ambari-deploying-managing-hadoop/chkconfig.png)

### 3. Setting up Passwordless SSH <a id="passwordless-ssh"></a>

Generate the key using ssh-keygen

![ssh_keygen](/assets/introducing-apache-ambari-deploying-managing-hadoop/ssh_keygen.png)

The keys will be placed in the folder **.ssh**.  

Copy the **id_rsa** file to /vagrant folder so that you can access the private key from the host machine as /vagrant is automatically the shared folder between host and guest OSs.

Also append id_rsa.pub, the public key to the authorized_keys keys file.

![authorized_keys](/assets/introducing-apache-ambari-deploying-managing-hadoop/authorized_keys.png)

### 4. Set up Ambari <a id="setup-ambari"></a>

Download and copy the ambari repository bits to **/etc/yum/repos.d**:

~~~
wget http://public-repo-1.hortonworks.com/ambari/centos6/2.x/updates/2.2.2.0/ambari.repo
mv ambari.repo /etc/yum.repos.d
yum repolist
~~~

![ambari_repo](/assets/introducing-apache-ambari-deploying-managing-hadoop/ambari_repo.png)

![yum_repolist](/assets/introducing-apache-ambari-deploying-managing-hadoop/yum_repolist.png)

Install ambari-server now using:

~~~
yum install ambari-server
~~~

![install_ambari_server](/assets/introducing-apache-ambari-deploying-managing-hadoop/install_ambari_server.png)

Setup the ambari-server and follow the default configurations:

~~~
ambari-server setup
~~~

![ambari_server_setup](/assets/introducing-apache-ambari-deploying-managing-hadoop/ambari_server_setup.png)

Start the ambari-server using:

~~~
service ambari-server start
~~~

![ambari_start_successfully](/assets/introducing-apache-ambari-deploying-managing-hadoop/ambari_start_successfully.png)

### 5. Pseudo-Mde HDP Cluster Set up using Ambari <a id="pseudo-mode"></a>

Go to browser and type `127.0.0.1:8080` to access Ambari. The default username and password is **admin** and **admin** respectively.

![sign_in](/assets/introducing-apache-ambari-deploying-managing-hadoop/sign_in.png)

Go to Launch Install Wizard to start the installation

![launch_cluster_wizard](/assets/introducing-apache-ambari-deploying-managing-hadoop/launch_cluster_wizard.png)

Give a name to your cluster. It is really difficult to change the cluster name after it is set. Perhaps, pick a good name.

![get_started](/assets/introducing-apache-ambari-deploying-managing-hadoop/get_started.png)

Select the HDP version.

![select_stack](/assets/introducing-apache-ambari-deploying-managing-hadoop/select_stack.png)

Give the hostname of your machine . You can also put hostnames like host[1-100].domain.com to avoid typing each one. Then click on the `Choose file` button to provide the SSH key that was created earlier.

![select_file](/assets/introducing-apache-ambari-deploying-managing-hadoop/select_file.png)

Next, click on Register and Confirm.

![upload_private_key](/assets/introducing-apache-ambari-deploying-managing-hadoop/upload_private_key.png)

Confirm the list of hosts that needs to be added in the cluster.

![confirm_hosts](/assets/introducing-apache-ambari-deploying-managing-hadoop/confirm_hosts.png)

View the progress and wait for the Success message. Remove warnings for the smooth installation of the cluster.

![confirm_hosts_success](/assets/introducing-apache-ambari-deploying-managing-hadoop/confirm_hosts_success.png)

Choose the services that you want to install on your cluster.

![choose_services](/assets/introducing-apache-ambari-deploying-managing-hadoop/choose_services.png)

After checking the required boxes, click on Next

![choose_services_next](/assets/introducing-apache-ambari-deploying-managing-hadoop/choose_services_next.png)

Assign the hostname of all master components. As it is a pseudo-mode cluster, all master components will be installed on 1 machine.

![assign_masters](/assets/introducing-apache-ambari-deploying-managing-hadoop/assign_masters.png)

![assign_masters_next](/assets/introducing-apache-ambari-deploying-managing-hadoop/assign_masters_next.png)

Assign slave and client components.

![assign_slaves](/assets/introducing-apache-ambari-deploying-managing-hadoop/assign_slaves.png)

In **Customize Services** step, give the credentials for the service components that are marked with a white number against the red background.

![customize_services](/assets/introducing-apache-ambari-deploying-managing-hadoop/customize_services.png)

After entering the credentials, start the installation.

![install_start_test](/assets/introducing-apache-ambari-deploying-managing-hadoop/install_start_test.png)

You can view the progress of each component installation

![start_progress](/assets/introducing-apache-ambari-deploying-managing-hadoop/start_progress.png)

and the standard output of each component.

![start_progress_logs](/assets/introducing-apache-ambari-deploying-managing-hadoop/start_progress_logs.png)

Wait for some time for the installation. Once it gets completed, you will see the Ambari Dashboard:

![ambari-dashboard](/assets/introducing-apache-ambari-deploying-managing-hadoop/ambari-dashboard.png)

Voila!!! We have our very own Hadoop VM.
Happy Hadooping!
