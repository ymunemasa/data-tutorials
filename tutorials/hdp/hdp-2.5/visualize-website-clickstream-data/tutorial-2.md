---
title: Visualize Website Clickstream Data
tutorial-id: 250
platform: hdp-2.5.0
tags: [ambari, hive, zeppelin, excel]
---

# Visualize Website Clickstream Data

## Lab 2: Visualize Clickstream Log Data with Excel

## Introduction

In this section, You can choose to use  Excel Professional Plus 2013  or Apache Zeppelin (built in to the sandbox) to access the refined clickstream data.

## Prerequisites

-   Hortonworks Sandbox 2.5 (installed and running)
-   Completed Lab 1

## Outline

-   [Section 1: Visualize Data with Apache Zeppelin](#visualize-data-zeppelin)
-   [Step 1: Identify from which State's Customers Visit the Website Most](#identify-customers-website)
-   [Step 2: Understand Demographics from Data to Pull in More Customers](#demographics-pull-customers)
-   [Step 3: Analyze the Interest Category Distribution for Users](#interest-category-distribution)
-   [Section 2: Visualize Data with Excel](#visualize-data-excel)
-   [Step 1: Connect Microsoft Excel](#connect-excel)
-   [Step 2: Visualize the Website Clickstream Data Using Excel Power View](#visualize-web-clickstream-excel)
-   [Summary](#summary-clickstream)
-   [Further Reading](#further-reading)



## Section 1: Visualize Data with Apache Zeppelin <a id="visualize-data-zeppelin"></a>

### Analyze Clickstream Data with Apache Zeppelin

If you don't have access to Microsoft Excel Professional Plus, you can also utilize Apache Zeppelin to do you data visualization as well.

Open up Ambari and make sure Zeppelin is running. If not, start the service. Go to browser and type `sandbox.hortonworks.com:9995` to open Zeppelin UI.
<!---Then use the dropdown menu to access the views and select **Zeppelin**--->

![Zeppelin View](assets/36_zeppelin_create_note.png)

Once the Zeppelin UI is open you can either create a new note and run the commands, or import the following notebook from this URL: `

`https://raw.githubusercontent.com/hortonworks/data-tutorials/cf9f67737c3f1677b595673fc685670b44d9890f/tutorials/hdp/hdp-2.5/visualize-website-clickstream-data/assets/ClickstreamAnalytics.json`

## Step 1: Identify from which State's Customers Visit the Website Most <a id="identify-customers-website"></a>

-   Write the query to filter states
-   open **settings**, make sure `state COUNT` is in the **Values** field
-   select `bar graph` to represent the data visually

~~~sql
%jdbc(hive)
select state from webloganalytics
~~~

![Zeppelin Bar Graph](assets/zeppelin-chart-1.png)

Therefore, we have better idea of where our customers are coming from.
Which are the top three states that have customers who view the website most?

## Step 2: Understand Demographics from Data to Pull in More Customers <a id="demographics-pull-customers"></a>

-   Write the query to filter demographics (age, gender, category)
-   open **settings**, make sure
   -   `age` is in **Keys** field,
   -   `gender_cd` is in **Groups** field,
   -   `category COUNT` is in **Values** field
-   select `area chart`

~~~sql
%jdbc(hive)
select age, gender_cd, category from webloganalytics where age is not NULL LIMIT 1000
~~~

![Zeppelin Area Chart](assets/zeppelin-chart-2.png)

Thus, the majority of users who come into the website are within age range of 20-30. Additionally, there seems to be an even split between both genders.
Which gender seems to dominate the website views for the older age?

## Step 3: Analyze the Interest Category Distribution for Users <a id="interest-category-distribution"></a>

-   Write the query to find the number of users interested toward particular categories
-   open **settings**, make sure
   -   `category` is in **Keys** field
   -   `category SUM` is in **Values** field
-   select `pie chart`

~~~sql
%jdbc(hive)
select category from webloganalytics
~~~

![Zeppelin Pie Chart](assets/zeppelin-chart-3.png)

Hence, clothing is clearly the most popular reason customers visit the website.
What are the next two interest categories that are most popular?

## Section 2: Visualize Data with Excel <a id="visualize-data-excel"></a>

## Step 1: Connect Microsoft Excel <a id="connect-excel"></a>

-   In Windows, open a new Excel workbook, then select **Data > From Other Sources > From Microsoft Query**.

![](assets/11_open_query.jpg)

-   On the Choose Data Source pop-up, select the Hortonworks ODBC data source you installed previously, then click **OK**. The Hortonworks ODBC driver enables you to access Hortonworks data with Excel and other Business Intelligence (BI) applications that support ODBC.

![](assets/12_choose_data_source.jpg)

-   After the connection to the sandbox is established, the Query Wizard appears. Select the webloganalytics table in the Available tables and columns box, then click the right arrow button to add the entire webloganalytics table to the query. Click **Next** to continue.

![](assets/13_query_wizard1.jpg)

-   On the Filter Data screen, click **Next** to continue without filtering the data.

![](assets/14_query_wizard2.jpg)

-   On the Sort Order screen, click **Next** to continue without setting a sort order.

![](assets/15_query_wizard3.jpg)

-   Click **Finish** on the Query Wizard Finish screen to retrieve the query data from the sandbox and import it into Excel.

![](assets/16_query_wizard4.jpg)

-   On the Import Data dialog box, click **OK** to accept the default settings and import the data as a table.

![](assets/17_import_data.jpg)

-   The imported query data appears in the Excel workbook.

![](assets/18_data_imported.jpg)

Now that we have successfully imported Hortonworks Sandbox data into Microsoft Excel, we can use the Excel Power View feature to analyze and visualize the data.

## Step 2: Visualize the Website Clickstream Data Using Excel Power View <a id="visualize-web-clickstream-excel"></a>

Data visualization can help you optimize your website and convert more visits into sales and revenue. In this section we will:

-   Analyze the clickstream data by location
-   Filter the data by product category
-   Graph the website user data by age and gender
-   Pick a target customer segment
-   Identify a few web pages with the highest bounce rates

In the Excel workbook with the imported webloganalytics data, select **Insert > Power View** to open a new Power View report.

![](assets/19_open_powerview.jpg)

-   The Power View Fields area appears on the right side of the window, with the data table displayed on the left. Drag the handles or click the Pop Out icon to maximize the size of the data table.

![](assets/20_powerview_initial_popout.jpg)

-   Let’s start by taking a look at the countries of origin of our website visitors. In the Power View Fields area, leave the **country** checkbox selected, and clear all of the other checkboxes. The data table will update to reflect the selections.

![](assets/21_country_selected.jpg)

-   On the Design tab in the top menu, click **Map**.

![](assets/22_open_map.jpg)

-   The map view displays a global view of the data. Now let’s take a look at a count of IP address by state. First, drag the **ip** field into the SIZE box.

![](assets/23_add_ip_count.jpg)

-   Drag **country** from the Power View Fields area into the Filters area, then select the **usa** checkbox.

![](assets/24_filter_by_usa.jpg)

-   Next, drag **state** into the LOCATIONS box. Remove the **country** field from the LOCATIONS box by clicking the down-arrow and then **Remove Field**.

![](assets/25_state_to_locations.jpg)

-   Use the map controls to zoom in on the United States. Move the pointer over each state to display the IP count for that state.

![](assets/26_ip_count_by_state.jpg)

-   Our dataset includes product data, so we can display the product categories viewed by website visitors in each state. To display product categories in the map by color, drag the **category** field into the COLOR box.

![](assets/27_category_by_color.jpg)

-   The map displays the product categories by color for each state. Move the pointer over each state to display detailed category information. We can see that the largest number of page hits in Florida were for clothing, followed by shoes.

![](assets/28_category_by_color_florida.jpg)

-   Now let’s look at the clothing data by age and gender so we can optimize our content for these customers. Select **Insert > Power View** to open a new Power View report.

![](assets/29_new_powerview1.jpg)

To set up the data, set the following fields and filters:

-   In the Power View Fields area, select **ip** and **age**. All of the other fields should be unselected.
-   Drag **category** from the Power View Fields area into the Filters area, then select the **clothing** checkbox.
-   Drag **gender** from the Power View Fields area into the Filters area, then select the **M** (male) checkbox.

After setting these fields and filters, select **Column Chart > Clustered Column** in the top menu.

![](assets/30_open_clustered_column1.jpg)

-   To finish setting up the chart, drag **age** into the AXIS box. Also, remove **ip** from the AXIS box by clicking the down-arrow and then **Remove Field**. The chart shows that the majority of men shopping for clothing on our website are between the ages of 22 and 30\. With this information, we can optimize our content for this market segment.

![](assets/31_clothing_by_age.jpg)

-   Let’s assume that our data includes information about website pages (URLs) with high bounce rates. A page is considered to have a high bounce rate if it is the last page a user visited before leaving the website. By filtering this URL data by our target age group, we can find out exactly which website pages we should optimize for this market segment. Select **Insert > Power View** to open a new Power View report.

![](assets/32_new_powerview2.jpg)

To set up the data, set the following fields and filters:

-   Drag **age** from the Power View Fields area into the Filters area, then drag the sliders to set the age range from 22 to 30.
-   Drag **gender** from the Power View Fields area into the Filters area, then select the **M** (male) checkbox.
-   Drag **country** from the Power View Fields area into the Filters area, then select the **usa** checkbox.
-   In the Power View Fields area, select **url**. All of the other fields should be unselected.
-   In the Power View Fields area, move the pointer over **url**, click the down-arrow, and then select **Add to Table as Count.**

After setting these fields and filters, select **Column Chart > Clustered Column** in the top menu.

![](assets/33_open_clustered_column2.jpg)

-   The chart shows that we should focus on optimizing four of our website pages for the market segment of men between the ages of 22 and 30\. Now we can redesign these four pages and test the new designs based on our target demographic, thereby reducing the bounce rate and increasing customer retention and sales.

![](assets/34_urls_for_age_group.jpg)

-   You can use the controls in the upper left corner of the map to sort by Count of URL in ascending order.

![](assets/35_urls_for_age_group_sorted.jpg)

## Summary <a id="summary-clickstream"></a>

Now that you have successfully analyzed and visualized Hortonworks Sandbox data with Microsoft Excel, you can see how Excel and other BI tools can be used with the Hortonworks platform to derive insights about customers from various data sources.

The data in the Hortonworks platform can be refreshed frequently and used for basket analysis, A/B testing, personalized product recommendations, and other sales optimization activities.

## Further Reading

-   [Zeppelin Notebook for Analysing Web Server Logs](https://community.hortonworks.com/content/repo/56765/zeppelin-notebook-for-analysing-web-server-logs.html)
-   [Zeppelin in Hortonworks Blog](https://hortonworks.com/apache/zeppelin/#blog)
