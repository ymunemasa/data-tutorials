### **(Optional) Enabling Zeppelin for Security**

This section describes how to configure Zeppelin to authenticate an end user. (Zeppelin uses Livy to execute jobs, with Spark on YARN as the end user.) Here are the high-level steps to enable Zeppelin Security:

1.  Configure Zeppelin for Authentication
2.  Install the Livy Server and Configure Livy for Zeppelin
3.  (Optional) Enable access control on Zeppelin notebook

**Configure Zeppelin for Authentication**

1.  Create a Zeppelin User Account. When Zeppelin is authenticating end users and Livy propagates the end-user identity to Hadoop, the end user must exist on all nodes. In production you can leverage sssd or pam for this process.In this tech preview, manually add "user1" to all hosts in your cluster.For example, to run Zeppelin as user "user1", issue the following commands as the OS root equivalent on all worker nodes:

    <pre>useradd user1 -g hadoop</pre>

2.  As hdfs user, create an HDFS home directory for user1:

    <pre>su hdfs
    hdfs dfs -mkdir /user/user1
    hdfs dfs -chown user1 /user/user1</pre>

    **Note:** if you configure Zeppelin to run as another user, you must add that user to the OS and create an HDFS home directory for that user.
3.  Edit the Zeppelin shiro configuration. On the node where the Zeppelin server is installed, edit /usr/hdp/current/zeppelin-server/lib/conf/shiro.ini. Make sure that the following lines are in the URL section:

    <pre>[urls]
    /api/version = anon
    #/** = anon
    /** = authcBasic</pre>

    You can use user accounts defined in shiro for authentication. For example, to enable the section to authenticate as user1/password2:

    <pre>[users]
    admin = password1
    user1 = password2
    user2 = password3</pre>

    Alternately, to use LDAP as the identity store, configure the section for your LDAP settings. For example:

    <pre>[main]
    #ldapRealm = org.apache.shiro.realm.ldap.JndiLdapRealm
    #ldapRealm.userDnTemplate = cn={0},cn=engg,ou=testdomain,dc=testdomain,dc=com
    #ldapRealm.contextFactory.url = ldap://ldaphost:389
    #ldapRealm.contextFactory.authenticationMechanism = SIMPLE</pre>

4.  Use Ambari to restart the Zeppelin server. (Ignore the error in Ambari when Zeppelin restarts.)
5.  Access Zeppelin-Tutorial. Login as user1/password2 (or any user defined in your LDAP).

**Note**: Logout functionality is not available in this technical preview, but is being added.

**Install the Livy Server and Configure Livy for Zeppelin**

1.  On the Zeppelin node, install Livy:

    <pre>sudo yum install livy</pre>

2.  Configure the Livy Server:Create /etc/livy/conf/livy-env.sh with the following values. Make sure that the path to Java is accurate for the node.

    <pre>export SPARK_HOME=/usr/hdp/current/spark-client
    export JAVA_HOME=/usr/jdk64/jdk1.8.0_60
    export PATH=/usr/jdk64/jdk1.8.0_60/bin:$PATH
    export HADOOP_CONF_DIR=/etc/hadoop/conf
    export LIVY_SERVER_JAVA_OPTS="-Xmx2g"</pre>

    Create /etc/livy/conf/livy-defaults.conf with the following content:

    <pre>livy.impersonation.enabled = true</pre>

3.  On the node where Livy is installed, create a "livy" user. The Livy process will run as user livy.

    <pre>useradd livy -g hadoop</pre>

4.  Create a logs directory for Livy, and grant user livy permissions to write to it:

    <pre>mkdir /usr/hdp/current/livy-server/logs
    chmod 777 logs</pre>

5.  On the Livy node, edit /etc/spark/conf/spark-defaults.conf to add the following:

    <pre>spark.master yarn-client</pre>

6.  Grant user livy the ability to proxy users in the Hadoop core-site.xml file. Use Ambari to add the following lines to the /etc/hadoop/conf/core-site.xml file. Then restart HDFS using Ambari.

    <pre><property>
        <name>hadoop.proxyuser.**livy**.groups</name>
        <value>*</value>
    </property>

    <property>
        <name>hadoop.proxyuser.**livy**.hosts</name>
        <value>*</value>
    </property></pre>

7.  Start the Livy server as user livy:

    <pre>cd /usr/hdp/current/livy-server
    su livy
    ./bin/livy-server start</pre>

8.  Configure Zeppelin to use Livy. In Zeppelin, notebooks are run against configured interpreters. Go to your notebook and click on "interpreter binding."<br><br> ![interp-binding](http://hortonworks.com/wp-content/uploads/2016/05/interp-binding.png) <br><br> On the next page, select the interpreters you want to use. (To select an interpreter, click on the interpreter in a toggle manner. An un-selected interpreter appears in white text.)You can reorder the interpreters available to your notebook by dragging and dropping them. For example, in the following screenshot the Livy Spark interpreter is selected ahead of Spark. It will be launched with %lspark.<br><br> ![livy-interp](http://hortonworks.com/wp-content/uploads/2016/05/livy-interp-268x300.png)<br>
9.  Confirm Livy Interpreter settings. If you have Livy installed on another node, replace localhost in the Livy URL with your Livy host.If you made any changes to the Livy interpreter setting, re-start the Livy interpreter.<br><br> ![livy-interp-setting](http://hortonworks.com/wp-content/uploads/2016/05/livy-interp-setting-300x99.png)<br><br>
10.  Run Notebooks with the Livy Interpreter. Livy supports Spark, SparkSQL, PySpark, and SparkR.To run notes with Livy, use the corresponding "magic string" at the top of your note. For example, specify %lspark to run Scala code via Livy, or %lspark.sql to run against SparkSQL via Livy.To use SQLContext with Livy, do not create SQLContext explicitly. Zeppelin creates SQLContext by default. If necessary, remove the following lines from your SparkSQL note:

    <pre>//val sqlContext = new org.apache.spark.sql.SQLContext(sc)
    //import sqlContext.implicits._</pre>

**(Optional) Enable access control on Zeppelin notebook** Zeppelin now supports access control on each notebook. The following instructions configure Zeppelin to authorize end users to access Zeppelin notebooks.

1.  Click the lock icon on the notebook to configure access to that notebook:<br><br> ![default-button](http://hortonworks.com/wp-content/uploads/2016/05/default-button.png)<br><br>
2.  On the next popup menu, add users who should have access to the policy:<br><br>![add-users](http://hortonworks.com/wp-content/uploads/2016/05/add-users-300x112.png) <br><br>**Note**: with identity propagation enabled via Livy, data access is controlled by the data source being accessed. For example, when you access HDFS as user1, data access is controlled by HDFS permissions.

### **Importing External Libraries**

As you explore Zeppelin you will probably want to use one or more external libraries. For example, to run [Magellan](http://hortonworks.com/blog/magellan-geospatial-analytics-in-spark/) you need to import its dependencies; you will need to include the Magellan library in your environment. There are three ways to include an external dependency in a Zeppelin notebook: **Using the %dep interpreter** (**Note**: This will only work for libraries that are published to Maven.)

<pre>%dep
z.load("group:artifact:version")
%spark
import ...</pre>

Here is an example that imports the dependency for Magellan:

<pre>%dep
z.addRepo("Spark Packages Repo").url("http://dl.bintray.com/spark-packages/maven")
z.load("com.esri.geometry:esri-geometry-api:1.2.1")
z.load("harsha2010:magellan:1.0.3-s_2.10")</pre>

For more information, see [https://zeppelin.incubator.apache.org/docs/interpreter/spark.html#dependencyloading](https://zeppelin.incubator.apache.org/docs/interpreter/spark.html#dependencyloading). **Adding and Referencing a spark.files Property** When you have a jar on the node where Zeppelin is running, the following approach can be useful: Add the spark.files property at SPARK_HOME/conf/spark-defaults.conf. For example:

<pre>spark.files  /path/to/my.jar</pre>

**Adding and Referencing SPARK_SUBMIT_OPTIONS** When you have a jar on the node where Zeppelin is running, this approach can also be useful: Add the SPARK_SUBMIT_OPTIONS environment variable to the ZEPPELIN_HOME/conf/zeppelin-env.sh file. For example:

<pre>export SPARK_SUBMIT_OPTIONS="--packages group:artifact:version"</pre>

### **Stopping Zeppelin or the Livy Server**

To stop the Zeppelin server, use Ambari. To stop the Livy server:

<pre>su livy; cd /usr/hdp/current/livy-server; ./bin/livy-server stop</pre>
