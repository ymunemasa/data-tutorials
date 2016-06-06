---
layout: tutorial
title: How to Analyze Machine and Sensor Data
tutorial-id: 310
tutorial-series: Real-World End to End Examples
tutorial-version: hdp-2.4.0
intro-page: false
components: [ hive, zeppelin, ambari ]
---

## Lab 1 - Load Data Into Hive <a name="lab-1"></a>


### Step 2: Load the Sensor Data into the Hortonworks Sandbox

-   Navigate to the ambari login by going to the web address [`http://localhost:8080`](http://localhost:8080) 
-   Login with the username `maria_dev` and password `maria_dev`.

Head on over to the Hive view using the dropdown menu in the top-right corner.

![](/assets/analyzing-machine-and-sensor-data/01_hive_view_dropdown.png)

Then use the **Upload Table** tab to upload the two csv files contained within `SensorFiles.zip`

![](/assets/analyzing-machine-and-sensor-data/02_upload_table_hive.png)

When uploading the two tables we'll need to change a few things.

For `HVAC.csv`

1. Change the table name to `hvac_raw`
2. Change the name of the `Date` column to `date_str`
3. Change the type of the `date_str` column from `DATE` to `STRING`

![](/assets/analyzing-machine-and-sensor-data/03_upload_hvac_raw.png)

For `buildings.csv`

1. Change the table name to `building_raw`

![](/assets/analyzing-machine-and-sensor-data/04_upload_building_raw.png)

-	Now that we have both tables loaded in, we want to get better performance in Hive, so we're going to create new tables that utilize the highly efficient [**ORC** file format](http://hortonworks.com/blog/apache-orc-launches-as-a-top-level-project/). This will allow for faster queries when our datasets are much much larger.
-	Execute the following query to create a new table `hvac` that is stored as an ORC file.


		CREATE TABLE hvac STORED AS ORC AS SELECT * FROM hvac_raw;


![](/assets/analyzing-machine-and-sensor-data/11_hive_orc_1.png)

-	Repeat the previous step, except this time we will make a table for `buildings`.


		CREATE TABLE buildings STORED AS ORC AS SELECT * FROM building_raw;


![](/assets/analyzing-machine-and-sensor-data/12_hive_orc_2.png)

### Step 3: Run Two Hive Scripts to Refine the Sensor Data

We will now use two Hive scripts to refine the sensor data. We hope to accomplish three goals with this data:

-   Reduce heating and cooling expenses.
-   Keep indoor temperatures in a comfortable range between 65-70 degrees.
-   Identify which HVAC products are reliable, and replace unreliable equipment with those models.

-   First, we will identify whether the actual temperature was more than five degrees different from the target temperature.

-	Create a new worksheet in the Hive view and paste the following Hive query into your window.


		CREATE TABLE hvac_temperatures as 
		select *, targettemp - actualtemp as temp_diff, 
		IF((targettemp - actualtemp) > 5, 'COLD', 
		IF((targettemp - actualtemp) < -5, 'HOT', 'NORMAL')) 
		AS temprange, 
		IF((targettemp - actualtemp) > 5, '1', 
		IF((targettemp - actualtemp) < -5, '1', 0)) 
		AS extremetemp from hvac;


- This query creates a new table `hvac_temperatures` and copies data from the `hvac` table

- After you paste the query use **Execute** to create the new table.

![](/assets/analyzing-machine-and-sensor-data/13_hive_hvac_temperatures.png)

- On the Query Results page, use the slider to scroll to the right. You will notice that two new attributes appear in the `hvac_temperatures` table.

The data in the **temprange** column indicates whether the actual temperature was:

-   **NORMAL** **–** within 5 degrees of the target temperature.
-   **COLD** **–** more than five degrees colder than the target temperature.
-   **HOT** **–** more than 5 degrees warmer than the target temperature.

If the temperature is outside of the normal range, `extremetemp` is assigned a value of 1; otherwise its value is 0.

![](/assets/analyzing-machine-and-sensor-data/14_hive_hvac_temps_example.png)

- Next we will combine the **hvac** and **hvac_temperatures** data sets.
 
Create a new worksheet in the hive view and use the following query to create a new table `hvac_building` that contains data from the `hvac_temperatures` table and the `buildings` table.



	create table if not exists hvac_building 
	as select h.*, b.country, b.hvacproduct, b.buildingage, b.buildingmgr 
	from buildings b join hvac_temperatures h on b.buildingid = h.buildingid;



- Use **Execute** to run the query that will produce the table with the intended data.

    ![](/assets/analyzing-machine-and-sensor-data/15_hive_hvac_building_query.png)

- After you've successfully executed the query, use the database explorer to load a sample of the data from the new `hvac_building` table.

    ![](/assets/analyzing-machine-and-sensor-data/16_hive_examine_hvac_building.png)

Now that we've constructued the data into a useful format, we can use different reporting tools to analyze the results.

* * * * *
