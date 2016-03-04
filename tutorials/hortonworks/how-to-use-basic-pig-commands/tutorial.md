# Transform New York Stock Exchange Data With Apache Pig

### Introduction

In this tutorial you will gain a working knowledge of Pig through the hands-on experience of creating Pig scripts to carry out essential data operations and tasks.

We will first read in two data files that contain New York Stock Exchange dividend prices and stock prices, and then use these files to perform a number of Pig operations including:

*   Define a relation with and without `schema`
*   Define a new relation from an `existing relation`
*   `Select` specific columns from within a relation
*   `Join` two relations
*   Sort the data using `‘ORDER BY’`
*   FILTER and Group the data using `‘GROUP BY’`

## Pre-Requisites
*  Downloaded and Installed latest [Hortonworks Sandbox](http://hortonworks.com/products/hortonworks-sandbox/#install)
*  [Learning the Ropes of the Hortonworks Sandbox](http://hortonworks.com/hadoop-tutorial/learning-the-ropes-of-the-hortonworks-sandbox/)

## Outline
- [What is Pig?](#what-is-pig)
- [Step 1: Download the Data](#download-the-data)
- [Step 2: Upload the data files](#step-2-upload-the-data-files)
- [Step 3: Create Your Script](#step-3-create-your-script)
- [Step 4: Define a relation](#step-4-define-a-relation)
- [Step 5: Save and Execute the Script](#step-5-save-and-execute-the-script)
- [Step 6: Define a Relation with a Schema](#step-6-define-a-relation-with-a-schema)
- [Step 7: Define a new relation from an existing relation](#step-7-define-a-new-relation-from-an-existing-relation)
- [Step 8: View the Data](#step-8-view-the-data)
- [Step 9: Select specific columns from a relation](#step-9-select-specific-columns-from-a-relation)
- [Step 10: Store relationship data into a HDFS File](#step-10-store-relationship-data-into-a-hdfs-file)
- [Step 11: Perform a join between 2 relations](#step-11-perform-a-join-between-2-relations)
- [Step 12: Sort the data using “ORDER BY”](#step-12-sort-the-data-using-order-by)
- [Step 13: Filter and Group the data using “GROUP BY”](#step-13-filter-and-group-the-data-using-group-by)
- [Further Reading](#further-reading)

## What is Pig? <a id="what-is-pig"></a>

`Pig` is a high level scripting language that is used with Apache Hadoop. Pig enables data workers to write complex data transformations without knowing Java. Pig’s simple SQL-like scripting language is called Pig Latin, and appeals to developers already familiar with scripting languages and SQL.

Pig is complete, so you can do all required data manipulations in Apache Hadoop with Pig. Through the User Defined Functions(UDF) facility in Pig, Pig can invoke code in many languages like JRuby, Jython and Java. You can also embed Pig scripts in other languages. The result is that you can use Pig as a component to build larger and more complex applications that tackle real business problems.

Pig works with data from many sources, including structured and unstructured data, and store the results into the Hadoop Data File System.

Pig scripts are translated into a series of MapReduce jobs that are run on the Apache Hadoop cluster.

### Step 1: Download the Data <a id="download-the-data"></a>

You’ll need sample data for this tutorial. The data set you will be using is stock ticker data from the `New York Stock Exchange` from the years 2000-2001\. Download following data file:

[infochimps_dataset_4778_download_16677-csv.zip](https://s3.amazonaws.com/hw-sandbox/tutorial1/infochimps_dataset_4778_download_16677-csv.zip)

The file is about 11 megabytes, and might take a few minutes to download.

Open the folder infochimps_dataset_4778_download_16677 > NYSE and locate the two data files that you will be using for this tutorial:

*   `NYSE_daily_prices_A.csv`
*   `NYSE_dividends_A.csv`

### Step 2: Upload the data files <a id="step-2-upload-the-data-files"></a>

Select the `HDFS Files view` from the Off-canvas menu at the top. That is the `views menu`. The HDFS Files view allows you to view the Hortonworks Data Platform(HDP) file store. The HDP file system is separate from the local file system.

![](/assets/hello-hdp/hdfs_files_view_hello_hdp_lab1.png)

Navigate to `/user/maria_dev` or a path of your choice, click Upload and Browse, which brings up a dialog box where you can select the `NYSE_daily_prices_A.csv` file from you computer. Upload the `NYSE_dividends_A.csv` file in the same way. When finished, notice that both files are now in HDFS.

![](/assets/how-to-use-basic-pig-commands/ny_stock_data_files_use_basic_pig.png)

### Step 3: Create Your Script <a id="step-3-create-your-script"></a>

Open the Pig interface by clicking the `Pig Button` in the `views menu`.

![](/assets/how-to-use-basic-pig-commands/pig_views_button_use_basic_pig.png)

On the left we can choose between our saved `Pig Scripts`, `UDFs` and the `Pig Jobs` executed in the past. To the right of this menu bar we see our saved Pig Scripts.

![](/assets/how-to-use-basic-pig-commands/pig_dashboard_use_basic_pig.png)

Click on the button `"New Script"`, enter “Pig-Dividend” for the title of your script and leave the location path empty:

![](/assets/how-to-use-basic-pig-commands/new_script_use_basic_pig.png)

Below you can find an overview about which functionalities the pig interface makes available. A special feature of the interface is the PIG helper at the top left of the composition area, which provides templates for Pig statements, functions, I/O statements, HCatLoader() and Python user defined functions.

![](/assets/how-to-use-basic-pig-commands/pig_ui_components_use_basic_pig.png)

### Step 4: Define a relation <a id="step-4-define-a-relation"></a>

In this step, you will create a script to load the data and define a relation.

*   On line 1 `define` a relation named STOCK_A that represents the `NYSE stocks` that start with the letter “A”
*   On line 2 use the `DESCRIBE` command to view the STOCK_A relation

The completed code will look like:

~~~
STOCK_A = LOAD '/user/maria_dev/NYSE_daily_prices_A.csv' USING PigStorage(','); 
DESCRIBE STOCK_A; 
~~~

> **Note:** In the LOAD script, you can choose any directory path. Verify the folders have been created in HDFS Files View.

![](/assets/how-to-use-basic-pig-commands/define_relation_use_basic_pig.png)

### Step 5: Save and Execute the Script <a id="step-5-save-and-execute-the-script"></a>

Click the Save button to save your changes to the script. Click Execute to run the script. This action creates one or more MapReduce jobs. After a moment, the script starts and the page changes. Now, you have the opportunity to Kill the job in case you want to stop the job.

Next to the `Kill job button` is a `progress bar` with a text field above that shows the `job’s status`.

When the job completes, check the results in the green box. You can also download results to your system by clicking the download icon. Notice STOCK_A does not have a schema because we did not define one when loading the data into relation STOCK_A.

![](/assets/how-to-use-basic-pig-commands/save_execute_script_use_basic_pig.png)

### Step 6: Define a Relation with a Schema <a id="step-6-define-a-relation-with-a-schema"></a>

Let’s use the above code but this time with a schema. Modify line 1 of your script and add the following **AS** clause to `define a schema` for the daily stock price data. The complete code will be:

        STOCK_A = LOAD '/user/maria_dev/NYSE_daily_prices_A.csv' USING PigStorage(',') 
        AS (exchange:chararray, symbol:chararray, date:chararray,                 
        open:float, high:float, low:float, close:float, volume:int, adj_close:float); 
        DESCRIBE STOCK_A; 


![](/assets/how-to-use-basic-pig-commands/define_relation_schema_use_basic_pig.png)

![](/assets/how-to-use-basic-pig-commands/running_relation_schema_use_basic_pig.png)


Save and execute the script again. This time you should see the schema for the STOCK_A relation:


![](/assets/how-to-use-basic-pig-commands/completed_relation_schema_use_basic_pig.png)


### Step 7: Define a new relation from an existing relation <a id="step-7-define-a-new-relation-from-an-existing-relation"></a>

You can define a new relation based on an existing one. For example, define the following B relation, which is a collection of 100 entries (arbitrarily selected) from the STOCK_A relation.

Add the following line to the end of your code:

        B = LIMIT STOCK_A 100; 
        DESCRIBE B; 

![](/assets/how-to-use-basic-pig-commands/define_relation_existing_relation_use_basic_pig.png)


Save and execute the code. Notice B has the same schema as STOCK_A, because B is a `subset of A` relation.


![](/assets/how-to-use-basic-pig-commands/stock_b_same_schema_a_use_basic_pig.png)


### Step 8: View the Data <a id="step-8-view-the-data"></a>

To view the data of a relation, use the `DUMP` command.

Add the following `DUMP` command to your Pig script, then save and execute it again:

        DUMP B;

![](/assets/how-to-use-basic-pig-commands/view_data_use_basic_pig.png)

The command requires a MapReduce job to execute, so you will need to wait a minute or two for the job to complete. The output should be 100 entries from the contents of `NYSE_daily_prices_A.csv` (and not necessarily the ones shown below, because again, entries are arbitrarily chosen):

![](/assets/how-to-use-basic-pig-commands/print_data_results_use_basic_pig.png)

### Step 9: Select specific columns from a relation <a id="step-9-select-specific-columns-from-a-relation"></a>

Delete the `DESCRIBE A`, `DESCRIBE B` and `DUMP B` commands from your Pig script; you will no longer need those.

One of the key uses of Pig is data transformation. You can define a new relation based on the fields of an existing relation using the `FOREACH` command. Define a new relation `C`, which will contain only the `symbol, date and close fields` from relation B.

Now the complete code is:

        STOCK_A = LOAD '/user/maria_dev/NYSE_daily_prices_A.csv' using PigStorage(',') 
        AS (exchange:chararray, symbol:chararray, date:chararray, open:float, 
        high:float, low:float, close:float, volume:int, adj_close:float); 

        B = LIMIT STOCK_A 100; 
        C = FOREACH B GENERATE symbol, date, close; 
        DESCRIBE C; 

Save and execute the script and your output will look like the following:

![](/assets/how-to-use-basic-pig-commands/select_columns_relation_use_basic_pig.png)

![](/assets/how-to-use-basic-pig-commands/results_select_column_relation_use_basic_pig.png)

### Step 10: Store relationship data into a HDFS File <a id="step-10-store-relationship-data-into-a-hdfs-file"></a>

In this step, you will use the `STORE` command to output a relation into a new file in `HDFS`. Enter the following command to output the C relation to a folder named `output/C` (then save and execute):

        STORE C INTO 'output/C' USING PigStorage(','); 

![](/assets/how-to-use-basic-pig-commands/store_data_hdfs_file_use_basic_pig.png)

Again, this requires a MapReduce job (just like the `DUMP` command), so you will need to wait a minute for the job to complete.

Once the job is finished, go to `HDFS Files view` and look for a newly created folder called “output” under `/user/maria_dev`:

> **Note:** If you didn't use the default path above, then the new folder will exist in the path you created.

![](/assets/how-to-use-basic-pig-commands/output_created_use_basic_pig.png)

Click on “output” folder. You will find a subfolder named “C”.

![](/assets/how-to-use-basic-pig-commands/output_c_use_basic_pig.png)

Click on “C” folder. You will see an output file called “part-r-00000”:

![](/assets/how-to-use-basic-pig-commands/c_part_00000_use_basic_pig.png)

Click on the file “part-r-00000”. It will download the file:

![](/assets/how-to-use-basic-pig-commands/part_r_00000_file_use_basic_pig.png)

### Step 11: Perform a join between 2 relations <a id="step-11-perform-a-join-between-2-relations"></a>

In this step, you will perform a `join` on two NYSE data sets: the daily prices and the dividend prices. Dividends prices are shown for the quarter, while stock prices are represented on a daily basis.

You have already defined a relation for the stocks named STOCK_A. Create a new Pig script named “Pig-Join”. Then define a new relation named DIV_A that represents the dividends for stocks that start with an “A”, then `join A and B` by both the `symbol and date` and describe the schema of the new relation C.

The complete code will be:

        STOCK_A = LOAD 'NYSE_daily_prices_A.csv' using PigStorage(',') 
            AS (exchange:chararray, symbol:chararray, date:chararray,
            open:float, high:float, low:float, close:float, volume:int, adj_close:float); 
        DIV_A = LOAD 'NYSE_dividends_A.csv' using PigStorage(',') 
            AS (exchange:chararray, symbol:chararray, date:chararray, dividend:float); 
        C = JOIN STOCK_A BY (symbol, date), DIV_A BY (symbol, date); 
        DESCRIBE C; 

![](/assets/how-to-use-basic-pig-commands/pig_join_use_basic_pig.png)

Save the script and execute it. Notice C contains all the fields of both STOCK_A and DIV_A. You can use the `DUMP` command to see the data stored in the relation C:

![](/assets/how-to-use-basic-pig-commands/pig_join_results_use_basic_pig.png)

### Step 12: Sort the data using “ORDER BY” <a id="step-12-sort-the-data-using-order-by"></a>

Use the `ORDER BY` command to sort a relation by one or more of its fields. Create a new Pig script named “Pig-sort” and enter the following commands to sort the dividends by symbol then date in ascending order:

        DIV_A = LOAD 'NYSE_dividends_A.csv' using PigStorage(',')
            AS (exchange:chararray, symbol:chararray, date:chararray, dividend:float); 
        B = ORDER DIV_A BY symbol, date asc; 
        DUMP B; 

![](/assets/how-to-use-basic-pig-commands/pig_sort_use_basic_pig.png)

Save and execute the script. Your output should be sorted as shown here:

![](/assets/how-to-use-basic-pig-commands/pig_sort_results_use_basic_pig.png)

### Step 13: Filter and Group the data using “GROUP BY” <a id="step-13-filter-and-group-the-data-using-group-by"></a>

The `GROUP` command allows you to group a relation by one of its fields. Create a new Pig script named “Pig-group”. Then, enter the following commands, which group the DIV_A relation by the dividend price for the “AZZ” stock.

        DIV_A = LOAD 'NYSE_dividends_A.csv' using PigStorage(',') 
            AS (exchange:chararray, symbol:chararray, date:chararray, dividend:float); 
        B = FILTER DIV_A BY symbol=='AZZ'; 
        C = GROUP B BY dividend; 
        DESCRIBE C; 
        DUMP C; 

![](/assets/how-to-use-basic-pig-commands/pig_group_use_basic_pig.png)

Save and execute. Notice that the data for stock symbol “AZZ” is grouped together for each dividend.

![](/assets/how-to-use-basic-pig-commands/results_pig_group_use_basic_pig.png)

Congratulations! You have successfully completed the tutorial and well on your way to pigging on Big Data.

## Further Reading <a id="further-reading"></a>
- [Apache Pig](http://hortonworks.com/hadoop-tutorial/how-to-process-data-with-apache-pig/)
- [Welcome to Apache Pig!](https://pig.apache.org/)
- [Pig Latin Basics](https://pig.apache.org/docs/r0.12.0/basic.html#store)
- [Programming Pig](http://www.amazon.com/Programming-Pig-Alan-Gates/dp/1449302645)
 
