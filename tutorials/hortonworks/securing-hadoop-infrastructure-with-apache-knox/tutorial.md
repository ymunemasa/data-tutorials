## Securing Your Hadoop Cluster with Apache Knox

---


## Introduction

In this tutorial we will walk through the process of

*   Configuring Apache Knox and LDAP services on HDP Sandbox
*   Run a MapReduce Program using Apache Knox Gateway Server

### What is Apache Knox?

The [Apache Knox Gateway](http://hortonworks.com/hadoop/knox) is a system that provides a single point of authentication and access for Apache™ Hadoop® services. It provides the following features:

*   Single REST API Access Point
*   Centralized authentication, authorization and auditing for Hadoop REST/HTTP services
*   LDAP/AD Authentication, Service Authorization and Audit
*   Eliminates SSH edge node risks
*   Hides Network Topology

### Layers of Defense for a Hadoop Cluster

*   Perimeter Level Security – Network Security, Apache Knox (gateway)
*   Authentication : Kerberos
*   Authorization
*   OS Security : encryption of data in network and hdfs

Apache Knox can also access a Hadoop cluster over HTTP or HTTPS

### Current Features of Apache Knox

1.  Authenticate : by LDAP or Cloud SSO Provider
2.  Provides services for HDFS, HCat, HBase, Oozie, Hive, YARN, and Storm
3.  HTTP access for Hive over JDBC support is available (ODBC driver Support- In Future)

### Prerequisites:

A working HDP cluster – the easiest way to have a HDP cluster is to download the [Hortonworks Sandbox](http://hortonworks.com/products/hortonworks-sandbox/) or get up and running on [Azure in Minutes](http://hortonworks.com/hadoop-tutorial/deploying-hortonworks-sandbox-on-microsoft-azure/)

## Installation and Setup:

### Step 1:

HDP Sandbox 2.4 comes with Apache Knox installed.  

First you'll need to log in to the Ambari user interface at [http://127.0.0.1:8080](http://127.0.0.1:8080)

Use these credentials:

| User | Pass |
|:----:|:----:|
| admin|4o12t0n|


After logging in, head to the Knox service configs by clicking **Knox** on the left hand side of the page.

![](/assets/securing-hadoop-with-knox/01_knox_ambari.png)

After starting the service and turning on the demo LDAP you should see that Ambari says our service has started

![](/assets/securing-hadoop-with-knox/02_knox_started.png)

Now that Knox has started we can start trying to route requests through it. For this next section you're going to need access to a terminal which utilizes the `curl` command. 

We're going to need to SSH into our Sandbox. You can either use a local shell, the shell from VirtualBox or SSH in using the Shell-In-A-Box at `http://_host_:4200`

**Shell in a Box**: `http://_host_:4200`

**SSH**

| Port | User | Pass |
|:----:|:----:|:----:|
| 2222 | root |hadoop|

    ssh root@localhost -p 2222

### Step 2:

Let’s check if the Hadoop Cluster is accessible via WebHDFS. 

Note that this request is directly accessing the WebHDFS API. This means that we are sending our request directly to WebHDFS without any security or encryption.

~~~
curl -iku guest:guest-password -X GET 'http://sandbox:50070/webhdfs/v1/?op=LISTSTATUS'
~~~

![enter image description here](/assets/securing-hadoop-with-knox/14+connect+to+hadoop+sandbox+.JPG "14 connect to hadoop sandbox .JPG")

### Step 3:

Now let’s check if we can access Hadoop Cluster via Apache Knox services. Using Knox means we can utilize the HTTPS protocol which utilizes SSL to encrypt our requests and makes using it much more secure. 

Not only do we get the added benefit of the extra layer of protection with encryption, but we also get to plug in the LDAP server which many organizations already utilize for authentication


	curl -iku guest:guest-password -X GET 'https://localhost:8443/gateway/default/webhdfs/v1/?op=LISTSTATUS'


This requests routes through the Knox Gateway. Note that here we use the HTTPS protocol meaning our request is completely encrypted. This is great if, for example, you wanted to access Hadoop services via an insecure medium such as the internet.

### Step 4:

Let’s work on an End to end implementation use case using Apache Knox Service. Here we will take a simple example of a mapreduce jar that you might be already familiar with, the WordCount mapreduce program. We will first create the needed directories, upload the datafile into hdfs and also upload the mapreduce jar file into hdfs. Once these steps are done, using Apache Knox service, we will run this jar and process data to produce output result.

**NOTE:** If you get error “{“error”:”User: hcat is not allowed to impersonate guest”}”, do 

	usermod -a -G users guest
 

Let’s go!

	cd /usr/hdp/current/knox-server

You could create the directories `knox-sample`, `knox-sample/input`, and `knox-sample/lib` as follows:

    curl -iku guest:guest-password -X put 'https://localhost:8443/gateway/knox_sample/webhdfs/v1/user/guest/knox-sample?op=MKDIRS&permission=777'

    curl -iku guest:guest-password -X put 'https://localhost:8443/gateway/knox_sample/webhdfs/v1/user/guest/knox-sample/input?op=MKDIRS&permission=777'

    curl -iku guest:guest-password -X put 'https://localhost:8443/gateway/knox_sample/webhdfs/v1/user/guest/knox-sample/lib?op=MKDIRS&permission=777'
    
    curl -iku guest:guest-password -X put 'https://localhost:8443/gateway/knox_sample/webhdfs/v1/user/guest/knox-sample/output?op=MKDIRS&permission=777'
    
Note that if you don't get the `HTTP/1.1 200 OK` Return as a result, you may not have started the Knox LDAP server

Let’s upload the data and the mapreduce jar files:

    curl -iku guest:guest-password  -L -T samples/hadoop-examples.jar -X PUT  "https://localhost:8443/gateway/knox_sample/webhdfs/v1/user/guest/knox-sample/lib/hadoop-examples.jar?op=CREATE"

    curl -iku guest:guest-password  -L -T README -X PUT  "https://localhost:8443/gateway/knox_sample/webhdfs/v1/user/guest/knox-sample/input/README?op=CREATE"

Let’s run the mapreduce program.

    curl -iku guest:guest-password --connect-timeout 60 -X POST -d 'arg=/user/guest/knox-sample/input' -d 'arg=/user/guest/knox-sample/output' -d 'jar=/user/guest/knox-sample/lib/hadoop-examples.jar' -d 'class=org.apache.hadoop.examples.WordCount' https://localhost:8443/gateway/knox_sample/templeton/v1/mapreduce/jar

When you run the mapreduce execution step, you will see the following result. Please note down the Job Id. You will use it for checking status for this Job Id in the next step.  

![enter image description here](/assets/securing-hadoop-with-knox/30.5-+map+reduce+job+submission.JPG "30.5- map reduce job submission.JPG")

### Step 5:

You can check the status of your above Job Id as follows:

    curl -iku guest:guest-password 'https://localhost:8443/gateway/knox_sample/templeton/v1/jobs/job_1394770200462_004'
    
Remember to **replace everything after `jobs/` with your job id**.

![enter image description here](/assets/securing-hadoop-with-knox/30.6-+map+reduce+job+submission+log.JPG "30.6- map reduce job submission log.JPG")

### Step 6:

Let’s look at the list of directories in /knox-sample parent directory in hdfs.

    curl -iku guest:guest-password -X GET 'https://localhost:8443/gateway/knox_sample/webhdfs/v1/user/guest/knox-sample?op=LISTSTATUS'

These are the directories which we created earlier.

### Step 7:

Let’s look at the output result file.

    curl -iku guest:guest-password -X GET 'https://localhost:8443/gateway/knox_sample/webhdfs/v1/user/guest/knox-sample/output?op=LISTSTATUS'

It should look something like below:

![enter image description here](/assets/securing-hadoop-with-knox/output+resuslt+files.JPG "output resuslt files.JPG")

### Step 8:

Let’s look at the output result.

    curl -iku guest:guest-password -L -X GET 'https://localhost:8443/gateway/knox_sample/webhdfs/v1/user/guest/knox-sample/output/part-r-00000?op=OPEN'

![enter image description here](/assets/securing-hadoop-with-knox/results.JPG "results.JPG")

You just ran a mapreduce program on Hadoop through the Apache Knox Gateway!

Remember, Knox is a great way to remotely access API's form your Hadoop cluster securely. You can add many different core Hadoop services to it, and you can even create your own services which you can route through the Gateway. This can keep your cluster safe and secure. Not to mention that there is great LDAP integration for organizations as well.

### Links and Further Reading

- [Knox on Hortonworks Community Connection](https://community.hortonworks.com/search.html?f=&type=question&redirect=search%2Fsearch&sort=relevance&q=knox)
- [Apache Knox Site](http://knox.apache.org)
- [How to set up Apache Knox](http://kminder.github.io/knox/2015/11/18/setting-up-knox.html)
- [Adding a Service to Knox](http://kminder.github.io/knox/2015/11/16/adding-a-service-to-knox.html)
- [Using Knox with Microsoft Active Directory](http://kminder.github.io/knox/2015/11/18/knox-with-activedirectory.html)