# Data Driven Warehousing
This project is dedicated to the data-driven optimization of warehouse locations. This repository aims to determine the most efficient placement of one or more warehouses, ensuring minimal costs.

## Table of Contents

- [Introduction](#introduction)
- [Objective](#objective)
- [Methodology](#methodology)
  - [1. Dataset and Data Cleaning](#1-dataset-and-data-cleaning)
  - [2. Exploratory Analysis](#2-exploratory-analysis)
  - [3. Clustering](#3-clustering)
  - [4. Additional Datasets](#4-additional-datasets)
  - [5. Optimization](#5-optimization)
- [Results](#results)
- [Future Directions](#future-directions)

## Introduction

The aim of this project is to assist in the strategic location selection of logistic hubs, utilizing a data-driven approach. It integrates various datasets and employs advanced optimization techniques to provide actionable insights for warehouse location decisions.

## Objective

The primary objective is to identify optimal locations in the Lombardy region for one or more logistic hubs. This involves using a data-driven strategy to balance various factors such as costs, geographic distribution, and logistical efficiency.

## Methodology

# Tools Used

In our analysis, we leveraged a variety of powerful tools to achieve our results. Each tool contributed uniquely to the process:

| Tool               | Description                                                                                                 | Logo                                                                                                        |
|--------------------|-------------------------------------------------------------------------------------------------------------|-------------------------------------------------------------------------------------------------------------|
| **Excel**          | Utilized for preliminary data analysis, sorting, and basic visualizations.                                   | <img src="images/excel_logo.png" alt="Excel Logo" width="50"/>                                              |
| **R**              | Employed for advanced statistical analysis and data manipulation.                                            | <img src="images/r_logo.png" alt="R Logo" width="50"/>                                                      |
| **Python**         | Used for scripting, data analysis, and automation, including libraries like Pandas and Matplotlib.           | <img src="images/python_logo.png" alt="Python Logo" width="50"/>                                            |
| **OpenStreetMaps** | Integrated for geospatial analysis and visualization of geographic data.                                     | <img src="images/osm_logo.png" alt="OpenStreetMaps Logo" width="50"/>                                       |
| **Docker**         | Implemented for containerizing applications to ensure consistency across different development environments. | <img src="images/docker_logo.png" alt="Docker Logo" width="50"/>                                            |
| **Tableau**        | Used for creating interactive and detailed data visualizations.                                              | <img src="images/tableau_logo.png" alt="Tableau Logo" width="50"/>                                          |

Each tool brought its own set of capabilities to the table, allowing for a robust and thorough analysis process.

![Excel](https://upload.wikimedia.org/wikipedia/commons/7/7f/Microsoft_Office_Excel_%282018%E2%80%93present%29.svg) ![R](https://upload.wikimedia.org/wikipedia/commons/1/1b/R_logo.svg) ![Python](https://upload.wikimedia.org/wikipedia/commons/c/c3/Python-logo-notext.svg) ![OpenStreetMaps](https://upload.wikimedia.org/wikipedia/commons/4/4f/Openstreetmap_logo.svg) ![Docker](https://upload.wikimedia.org/wikipedia/commons/7/79/Docker_%28container_engine%29_logo.png) ![Tableau](https://upload.wikimedia.org/wikipedia/commons/4/42/Tableau_Logo.png)

### 1. Dataset and Data Cleaning

We utilized a dataset containing:
- Customer codes
- Customer locations
- Provinces
- Geographic coordinates
- Order frequency over the last year

Data discrepancies between city/province and geographic coordinates were resolved using verified geographic data. Missing data were filled in by using reverse geocoding of the coordinates.


### 2. Exploratory Analysis

Exploratory data analysis was performed to identify patterns and insights within the dataset. Key findings were used to guide the clustering and optimization stages.
<div class="image-grid">
    <img src="images/Ex_Analysis2.png" alt="Exploratory Analysis 1">
    <img src="images/Ex_Analysis1.png" alt="Exploratory Analysis 2">
</div>

### 3. Clustering

Clustering was performed in three steps:
1. **Initial Elbow Method Analysis**: To determine the optimal number of clusters.

![Elbow Method](images/Elbow.png)

2. **Original Clustering**: Based on initial analysis.
3. **Modified Clustering**: Adjustments were made to refine the clusters. The centroids were forced in Lombardy, calculating the nearest point falling into the region.

![Modified Clustering](images/Modified_Clusters.png)

### 4. Additional Datasets

To enrich the analysis, additional datasets were utilized:
- **Logistic Enterprises**: Open Data from Regione Lombardia.
  
![Logistic Enterprises](images/Logistic_Companies.png)

- **Labor Availability**: Population data from ISTAT.

![Workforce](images/Workforce.png)

- **Real Estate Values**: Data from Immobiliare.it.

### 5. Optimization

The optimization process involved:
- **Initial Clusters**: 3 clusters (Ponti sul Mincio, Palestro, Bollate).
- **Simulation**: 159 points were simulated across various provinces.
- **Decision Variables**: Fixed costs, using the average price per square meter by province, variable costs, using the distance and cost matrices, proximity to logistic enterprises and labor availability.

Optimization resulted in the selection of two warehouse locations:
- **Warehouse 1**: Casorate Primo, Pavia.
- **Warehouse 2**: Ponti sul Mincio, Mantova.

![Optimization](images/Warehouse_Location.png)

![Optimization](images/Warehouse_Distribution.png)

## Results

The optimization process identified two strategic locations for logistic hubs, covering approximately 63% of the customer base within a one-hour reach. These locations balance fixed and variable costs, labor availability, and proximity to logistic enterprises.

![Isochrone Map](images/Isochrone.png)

## Future Directions

Future improvements could include:
- Using road distances instead of straight-line distances.
- Incorporating rental costs as a variable.
- Considering other transportation modes besides highways.

## Contributors

- **Lorenzo Battisti**
- **Andrea Bonassi**
- **Luca Calzaferri**
- **Daniel Conte**
- **Mattia Piantoni**
- **Mattia Tintori**
