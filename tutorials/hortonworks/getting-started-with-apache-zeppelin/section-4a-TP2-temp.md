### **Configuring Zeppelin Spark and Hive Interpreters**

Before you run a notebook to access Spark and Hive, you need to create and configure interpreters for the two components. To create the Spark interpreter, go to the Zeppelin Web UI. Switch to the “Interpreter” tab and create a new interpreter:

1.  Click on the **+Create** button to the right.
2.  Name the interpreter spark-yarn-client.
3.  Select **spark** as the interpreter type.
4.  The next section of this page contains a form-based list of spark interpreter settings for editing. The remainder of the page contains lists of properties for all supported interpreters.
    1.  In the first list of properties, specify the following values (if they are not already set). To add a property, enter the name and value into the form at the end of the list, and click **+**.

        <pre>master           yarn-client
        spark.home       /usr/hdp/current/spark-client
        spark.yarn.jar   /usr/hdp/current/spark-client/lib/spark-assembly-1.6.0.2.4.0.0-169-hadoop2.7.1.2.4.0.0-169.jar</pre>

    2.  Add the following properties and settings (HDP version may vary; specify the appropriate version for your cluster):

        <pre>spark.driver.extraJavaOptions -Dhdp.version=2.4.0.0-169
        spark.yarn.am.extraJavaOptions -Dhdp.version=2.4.0.0-169</pre>

    3.  When finished, click **Save**. **Note:** Make sure that you save all property settings. Without spark.driver.extraJavaOptions and spark.yarn.am.extraJavaOptions, the Spark job will fail with a message related to bad substitution.

To configure the Hive interpreter:

1.  From the “Interpreter” tab, find the hive interpreter.
2.  Check that the following property references your Hive server node. If not, edit the property value.

    <pre>hive.hiveserver2.url  jdbc:hive2://<hive_server_host>:10000</pre>

    **Note**: the default interpreter setting uses the default Hive Server port of 10000\. If you use a different Hive Server port, change this to match the setting in your environment.
3.  If you changed the property setting, click Save to save the new setting and restart the interpreter.

#### Adding and Referencing a spark.files Property

When you have a jar on the node where Zeppelin is running, the following approach can be useful: Add the spark.files property at SPARK_HOME/conf/spark-defaults.conf. For example:

<pre>spark.files  /path/to/my.jar</pre>

#### Adding and Referencing SPARK_SUBMIT_OPTIONS

When you have a jar on the node where Zeppelin is running, this approach can also be useful: Add the SPARK_SUBMIT_OPTIONS environment variable to the ZEPPELIN_HOME/conf/zeppelin-env.sh file. For example:

<pre>export SPARK_SUBMIT_OPTIONS="--packages group:artifact:version"</pre>

### **Stopping Zeppelin or the Livy Server**

To stop the Zeppelin server, use Ambari. To stop the Livy server:

<pre>su livy; cd /usr/hdp/current/livy-server; ./bin/livy-server stop</pre>
