## Lab 2 - Analyze Data with Excel or Apache Zeppelin <a name="lab-2"></a>


# Data Reporting 

In this tutorial you can choose to report with

- [Microsoft Excel](#report-with-excel)
- [Apache Zeppelin](#report-with-zeppelin)

* * * * *

## Access the Refined Sensor Data with Microsoft Excel <a name="report-with-excel"></a>

In this section, we will use Microsoft Excel Professional Plus 2013 to
access the refined sentiment data.

- In Windows, open a new Excel workbook, then select **Data > From Other Sources > From Microsoft Query**.

![](../../../assets/analyzing-machine-and-sensor-data/18_open_query.jpg)

- On the Choose Data Source pop-up, select the Hortonworks ODBC data source you installed previously, then click **OK**.

The Hortonworks ODBC driver enables you to access Hortonworks data with Excel and other Business Intelligence (BI) applications that support ODBC.

![](../../../assets/analyzing-machine-and-sensor-data/19_choose_data_source.jpg)

- After the connection to the Sandbox is established, the Query Wizard appears. Select the "hvac_building" table in the Available tables and columns box, then click the right arrow button to add the entire "hvac_building" table to the query. Click **Next** to continue.

![](../../../assets/analyzing-machine-and-sensor-data/20_query_wizard1_choose_columns.jpg)

- On the Filter Data screen, click **Next** to continue without filtering the data.

![](../../../assets/analyzing-machine-and-sensor-data/21_query_wizard2_filter_data.jpg)

- On the Sort Order screen, click **Next** to continue without setting a sort order.

![](../../../assets/analyzing-machine-and-sensor-data/22_query_wizard3_sort_order.jpg)

- Click **Finish** on the Query Wizard Finish screen to retrieve the query data from the Sandbox and import it into Excel.

![](../../../assets/analyzing-machine-and-sensor-data/23_query_wizard4_finish.jpg)

- On the Import Data dialog box, click **OK** to accept the default settings and import the data as a table.

![](../../../assets/analyzing-machine-and-sensor-data/24_import_data.jpg)

- The imported query data appears in the Excel workbook.

![](../../../assets/analyzing-machine-and-sensor-data/25_data_imported.jpg)

Now that we have successfully imported the refined sensor data into Microsoft Excel, we can use the Excel Power View feature to analyze and visualize the data.

### Visualize the Sensor Data Using Excel Power View

We will begin the data visualization by mapping the buildings that are most frequently outside of the optimal temperature range.

- In the Excel worksheet with the imported "hvac_building" table, select **Insert > Power View** to open a new Power View report.

![](../../../assets/analyzing-machine-and-sensor-data/26_open_powerview_hvac_building.jpg)

- The Power View Fields area appears on the right side of the window, with the data table displayed on the left. Drag the handles or click the Pop Out icon to maximize the size of the data table.

![](../../../assets/analyzing-machine-and-sensor-data/27_powerview_hvac_building.jpg)

- In the Power View Fields area, select the checkboxes next to the **country** and **extremetemp** fields, and clear all of the other checkboxes. You may need to scroll down to see all of the check boxes.

![](../../../assets/analyzing-machine-and-sensor-data/28_select_country_extremetemp.jpg)

- In the FIELDS box, click the down-arrow at the right of the **extremetemp** field, then select **Count (Not Blank)**.

![](../../../assets/analyzing-machine-and-sensor-data/29_extremetemp_count_not_blank.jpg)

- Click **Map** on the Design tab in the top menu.

![](../../../assets/analyzing-machine-and-sensor-data/30_open_map.jpg)

- The map view displays a global view of the data. We can see that the office in Finland had 814 sensor readings where the temperature was more than five degrees higher or lower than the target temperature. In contrast, the German office is doing a better job maintaining ideal office temperatures, with only 363 readings outside of the ideal range.

![](../../../assets/analyzing-machine-and-sensor-data/31_extremetemp_map.jpg)

- Hot offices can lead to employee complaints and reduced productivity. Let's see which offices run hot.

In the Power View Fields area, clear the **extremetemp** checkbox and select the **temprange** checkbox. Click the down-arrow at the right of the **temprange** field, then select **Add as Size**.

![](../../../assets/analyzing-machine-and-sensor-data/32_add_temprange_as_size.jpg)

- Drag **temprange** from the Power View Fields area to the Filters box, then select the **HOT** checkbox. We can see that the buildings in Finland and France run hot most often.

![](../../../assets/analyzing-machine-and-sensor-data/33_filter_by_temprange_hot.jpg)

- Cold offices cause elevated energy expenditures and employee
discomfort.

In the Filters box, clear the **HOT** checkbox and select the **COLD** checkbox. We can see that the buildings in Finland and Indonesia run cold most often.

![](../../../assets/analyzing-machine-and-sensor-data/34_filter_by_temprange_cold.jpg)

- Our data set includes information about the performance of five brands of HVAC equipment, distributed across many types of buildings in a wide variety of climates. We can use this data to assess the relative reliability of the different HVAC models.

- Open a new Excel worksheet, then select **Data > From Other Sources

From **Microsoft Query** to access the hvac_building table. Follow the same procedure as before to import the data, but this time only select the "hvacproduct" and "extremetemp" columns.

![](../../../assets/analyzing-machine-and-sensor-data/35_import_hvacproduct_extremetemp.jpg)

- In the Excel worksheet with the imported "hvacproduct" and "extremetemp" columns, select **Insert > Power View** to open a new Power View report.

![](../../../assets/analyzing-machine-and-sensor-data/36_open_powerview_hvacproduct.jpg)

- Click the Pop Out icon to maximize the size of the data table. In the FIELDS box, click the down-arrow at the right of the extremetemp field, then select Count (Not Blank).

![](../../../assets/analyzing-machine-and-sensor-data/37_extremetemp_count_not_blank.jpg)

- Select **Column Chart > Stacked Column**in the top menu.

![](../../../assets/analyzing-machine-and-sensor-data/38_open_stacked_column.jpg)

- Click the down-arrow next to **sort by hvacproduct** in the upper left corner of the chart area, then select **Count of extremetemp**.

![](../../../assets/analyzing-machine-and-sensor-data/39_sort_by_extremetemp.jpg)

- We can see that the GG1919 model seems to regulate temperature most reliably, whereas the FN39TG failed to maintain the appropriate temperature range 9% more frequently than the GG1919.

![](../../../assets/analyzing-machine-and-sensor-data/40_chart_sorted_by_extremetemp.jpg)

We've shown how the Hortonworks Data Platform (HDP) can store and analyze sensor data. With real-time access to massive amounts of temperature and other types of data on HDP, your facilities department can initiate data-driven strategies to reduce energy expenditures and improve employee comfort.

---------------------------------------------------------------

## Access the Refined Sensor Data with Apache Zeppelin <a name="report-with-zeppelin"></a>

Apache Zeppelin makes data reporting easy on Hadoop. It has direct connections to Apache Spark and Hive in your cluster and allows you to create visualizations and analyze your data on the fly.

To start you're going to need to open up the [Apache Zeppelin view](http://localhost:8080/#/main/views/ZEPPELIN/1.0.0/INSTANCE_1) in Ambari.

Start by navigating back to the [Ambari Dashboard](http://localhost:8080) at `http://localhost:8080`

- Use the dropdown menu to open the Zeppelin View.

![](../../../assets/analyzing-machine-and-sensor-data/41_ambari_zeppelin_view.png)
   
- From here we're going to need to create a new Zeppelin Notebook. 
- Notebooks in Zeppelin is how we differentiate reports from one another.
- Hove over **Notebook**. Use the dropdown menu and **Create a new note**.
   
![](../../../assets/analyzing-machine-and-sensor-data/42_create_zeppelin_note.png)
   
- Name the note **HVAC Analysis Report** and then **Create Note**.
   
![](../../../assets/analyzing-machine-and-sensor-data/43_zeppelin_naming_note.png)
   
   
- Head back to the Zeppelin homepage.
- Use the **Notebook** dropdown menu to open the new notebook **HVAC Analysis Report**.

![](../../../assets/analyzing-machine-and-sensor-data/43_1_opening_note.png)
   
- Zeppelin integrates with Hadoop by using things called *interpreters*.
- In this tutorial we'll be working with the Hive interpreter to run Hive queries in Zeppelin, then visualize the results from our Hive queries directly in Zeppelin.
- To specify the Hive interpreter for this note, we need to put `%hive` at the top of the note. Everything afterwards will be interpreted as a Hive query.
   
![](../../../assets/analyzing-machine-and-sensor-data/44_blank_zeppelin_notebook.png)
   
- Type the following query into the note, then run it by clicking the **Run** arrow or by using the shortcut **Shift+Enter**.

```
%hive

select country, extremetemp, temprange from hvac_building
```
   
![](../../../assets/analyzing-machine-and-sensor-data/45_zeppelin_query.png)
   
- After running the previous query we can view a chart of the data by clicking the chart button located just under the query.

![](../../../assets/analyzing-machine-and-sensor-data/46_table_to_chart.png)
   
- Click **settings** to open up more advanced settings for creating the chart. Here you can experiment with different values and columns to create different types of charts.
   
![](../../../assets/analyzing-machine-and-sensor-data/47_changing_chart_settings.png)
   
- Arrange the fields according to the following image.
- Drag the field `temprange` into the **groups** box.
- Click **SUM** on `extremetemp` and change it to **COUNT**.
- Make sure that `country` is the only field under **Keys**.
   
![](../../../assets/analyzing-machine-and-sensor-data/48_chart_setup.png)
   
Awesome! You've just created your first chart using Apache Zeppelin.

-	From this chart we can see which countries have the most extreme temperature and how many **NORMAL** events there are compared to **HOT** and **COLD**.
-	It could be possible to figure out which buildings might need HVAC upgrades, and which do not.
   
![](../../../assets/analyzing-machine-and-sensor-data/49_chart_finished.png)
   
-	Let's try creating one more note to visualize which types of HVAC systems result in the least amount of `extremetemp` readings.
-	Paste the following query into the blank Zeppelin note following the chart we made previously.

```
%hive

select hvacproduct, extremetemp from hvac_building
```

-	Now use **Shift+Enter** to run the note.
   
   ![](../../../assets/analyzing-machine-and-sensor-data/50_second_query.png)
   
-	Arrange the fields according to the following image so we can recreate the chart below.
-	Make sure that `hvacproduct` is in the **Keys** box.
-	Make sure that `extremetemp` is in the **Values** box and that it is set to **COUNT**.
   
   ![](../../../assets/analyzing-machine-and-sensor-data/51_chart_two.png)
  
- Now we can see which HVAC units result in the most `extremetemp` readings. Thus we can make a more informed decision when purchasing new HVAC systems.


Apache Zeppelin gives you the power to connect right to your Hadoop cluster to quickly obtain results from the data inside of Hadoop without having to export data to any other sources.

It's also important to note that Zeppelin contains many, many interpreters that can be utilized to obtain data in a variety of ways.

One of the default interpreters included with Zeppelin is for Apache Spark. With the popularity of Apache Spark rising, you can simply write Spark scripts to execute directly on Apache Zeppelin to obtain results from your data in a matter of seconds.


### Feedback

We are eager to hear your feedback on this tutorial. Please let us know
what you think. 

[Click here to take survey](https://www.surveymonkey.com/s/Sandbox_Machine_Sensor)