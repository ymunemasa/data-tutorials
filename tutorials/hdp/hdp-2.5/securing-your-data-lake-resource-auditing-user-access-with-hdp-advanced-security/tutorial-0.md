---
title: Securing Your Data Lake Resource & Auditing User Access with HDP Advanced Security
tutorial-id: 570
platform: hdp-2.5.0
tags: [ranger]
---

# Securing Your Data Lake Resource & Auditing User Access with HDP Advanced Security

## Lab 1: Securing HDFS, Hive, HBase Data using Apache Ranger

## Introduction

In this tutorial we will explore how you can use policies in Apache Ranger to protect your enterprise data lake and audit access by users to resources on HDFS, Hive and HBase from a centralized Ranger Administration Console.

## Prerequisites

-   Download [Hortonworks Sandbox](https://hortonworks.com/products/hortonworks-sandbox/#install)
-   Complete the [Learning the Ropes of the HDP Sandbox](https://hortonworks.com/hadoop-tutorial/learning-the-ropes-of-the-hortonworks-sandbox/) tutorial.

## Outline

- [1: Start HBase and Ambari Infra Services](#start-hbase-infra)
- [2: Login to Ranger Administration Console](#login-ranger)
- [3: Review Existing HDFS Policies](#review-hdfs-policies)
- [4: Exercise HDFS Access Scenarios](#exercise-hdfs-access)
- [5: Review Hive Policies](#review-hive-policies)
- [6: Exercise Hive Access Scenarios](#exercise-hive-access)
- [7: Review HBase Policies](#review-hbase-policies)
- [8: Exercise HBase Access Scenarios](#exercise-hbase-access)
- [Summary](#summary)

## 1: Start HBase and Ambari Infra Services <a id="start-hbase-infra"></a>

Go to Ambari and login  with user credentials **raj_ops/raj_ops**. If HBase is switched off go to `Service Actions` button on top right and `Start` the service

![start_hbase](assets/start_hbase.png)

Check the box for **Maintenance Mode**.

![hbase_maintenance_mode](assets/hbase_maintenance_mode.png)

Next, click `Confirm Start`. Wait for 30 seconds and your HBase will start running.
Similarly, start **Ambari Infra** to record all the audits through Ranger. Your **Ambari dashboard** should look like this:

![ambari_dashboard_rajops_infra](assets/ambari_dashboard_rajops_infra.png)

## 2: Login to Ranger Administration Console <a id="login-ranger"></a>

Once the VM is running in VirtualBox, login to the Ranger Administration console at **http://localhost:6080/** from your host machine. The username is **raj_ops** and the password is **raj_ops**.

![ranger_login_rajops](assets/ranger_login_rajops.png)

As soon as you login, you should see list of repositories as shown below:

![list_repositories](assets/list_repositories.png)

## 3: Review Existing HDFS Policies <a id="review-hdfs-policies"></a>

Please click on `Sandbox_hadoop` link under HDFS section

![sandbox_hadoop_policies](assets/sandbox_hadoop_policies.png)

User can review policy details by a single click on the box right to the policy. Click on the `HDFS Global Allow policy`. Click the slider so it is in **disable** position.

![click_hdfs_global_allow_disable](assets/click_hdfs_global_allow_disable.png)

 Then click `Save`.

## 4: Exercise HDFS Access Scenarios <a id="exercise-hdfs-access"></a>

Login to the Ambari by the following credentials:

Username - **raj_ops**
Password - **raj_ops**

Click on 9 square menu icon and select `Files view:`

![select_files_view](assets/select_files_view.png)

 You will see a home page like the one given below. Click on `demo` folder

![files_view_home_page](assets/files_view_home_page.png)

Next, click on `data`. You will see a message like this:

![demo_data_error](assets/demo_data_error.png)

Click on `details`, that will lead you to the page that shows the permission denied for the user **raj_ops**:

![demo_data_message](assets/demo_data_message.png)

Go back to Ranger and then to the `Audits Tab` and check that its event (denied) being audited. You can filter by searching **Result as Denied**

![audit_results_hdfs](assets/audit_results_hdfs.png)

Now, go back to the **HDFS Global Allow Policy**. Click the switch to enable it and try running the command again

![click_hdfs_global_allow_enable](assets/click_hdfs_global_allow_enable.png)

Click `Save`.
Now let us go back to Files view and Navigate back to `/demo/data/`. You will see three folders under data due to enabled HDFS global policy.

Now head back to the Audit tab in Ranger and search by `User: raj_ops`. Here you can see that the request was allowed through

![audit_result_hdfs_allowed](assets/audit_result_hdfs_allowed.png)

## 5: Review Hive Policies <a id="review-hive-policies"></a>

Click on `Access Manager=>Resource Based Policies` section on the top menu, then click on `Sandbox_hive` link under HIVE section to view list of Hive Policies:

![sandbox_hive_policies](assets/sandbox_hive_policies.png)

User can review policy details by a single click on the box right to the policy.
Disable the **Hive Global Tables Allow Policy** :

![click_hive_global_allow_disable](assets/click_hive_global_allow_disable.png)

Also disable the `policy for raj_ops, holger_gov, maria_dev and amy_ds`.
You should see a page like this:

![sandbox_hive_policies_disabled](assets/sandbox_hive_policies_disabled.png)

## 6: Exercise Hive Access Scenarios <a id="exercise-hive-access"></a>

Go back to Ambari and click on 9 square menu icon and select `Hive view`:

![select_hive_view](assets/select_hive_view.png)

Run the following query:

~~~
select * from foodmart.product;
~~~

You will come across error message which states that **Permission denied for raj_ops because it does not have a SELECT privilege**.

![foodmart_product_message](assets/foodmart_product_message.png)

Next, go back to Ranger and then Audits and see its access (denied) being audited. You can do this the same way that we checked for the raj_ops user. Just search the audit log by user to see.

![audit_results_hive](assets/audit_results_hive.png)

Re-Enable the **Global Hive Tables Allow** policy and **Policy for raj_ops, holger_gov, maria_dev and amy_ds**.
Go back to **Hive View** and run the same query again:

~~~
select * from foodmart.product;
~~~

![foodmart_product_successful](assets/foodmart_product_successful.png)

This time, the query runs successfully and you can see all data in product table. Go back to Ranger and then Audits to see its access (granted) being audited.

![audit_results_hive_allowed](assets/audit_results_hive_allowed.png)

## 7: Review HBase Policies <a id="review-hbase-policies"></a>

Click on `Access Manager=>Resource Based Policies` section on the top menu, then click on the `Sandbox_hbase` to view list of hbase Policies.

![sandbox_hbase_policies](assets/sandbox_hbase_policies.png)

User can review policy details by a single click on the box right to the policy. Disable the **HBase Global Allow Policy** in the same manner that we did before.

## 8: Exercise HBase Access Scenarios <a id="exercise-hbase-access"></a>

First you’re going to need to log in to your Sandbox via SSH. If you’re using Virtualbox you can log in with the command:

~~~
ssh root@127.0.0.1 -p 2222
~~~

The first time password to log in is: **hadoop**

![sshTerminal](assets/sshTerminal.png)

Login into HBase shell as **raj_ops** user:

~~~
su raj_ops
hbase shell
~~~

![hbase_shell_rajops](assets/hbase_shell_rajops.png)

Run the hbase shell command to validate access for raj_ops user-id, to see if he can view table data from the iemployee table:

~~~
get 'iemployee', '1'
~~~

Then you should get an Access Denied Exception like:

![iemployee_message](assets/iemployee_message.png)

Let us check the audit log in Ranger too:

![audit_results_hbase](assets/audit_results_hbase.png)

Next, enable the **HBase Global Allow Policy**.
After making a change in the policy, go back to HBase shell and run the same query again:

~~~
get 'iemployee','1'
~~~

![iemployee_successful](assets/iemployee_successful.png)

Now, you can view all the data in **iemployee** table under **rowkey 1**. Go to Ranger to check audit logs:

![audit_results_hbase_allowed](assets/audit%20_results_hbase_allowed.png)

## Summary <a id="summary"></a>

Hopefully by following this tutorial, you got a taste of the power and ease of securing your key enterprise resources using Apache Ranger.

**Happy Hadooping!!!**
