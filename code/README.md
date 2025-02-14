# Visualization and Analysis of Fire and Weather Patterns in Mato Grosso do Sul (MS), Brazil

This repository contains a series of R scripts and functions developed to analyze and visualize spatio-temporal patterns of fires and weather extremes in Mato Grosso do Sul (MS), Brazil. The primary focus is on understanding the environmental drivers—particularly in the Pantanal region, one of Brazil’s most fire-prone biomes—and how extreme weather events, such as prolonged droughts and elevated temperatures, may be associated with increased fire occurrences.

> **Note:** This project is a work in progress. Further analyses—such as refined station selection based on continuous data coverage and advanced econometric investigations to determine causality—are underway.

---

## Project Overview

### Objectives
- **Fire Mapping & Density Analysis:**  
  Generate spatial maps and heatmaps of fire occurrences using data from 2017, 2018, and 2021. These years were chosen because they include periods when fire activity in the Pantanal and adjacent MS biomes peaked.
  
- **Weather and Drought Trends:**  
  Analyze weather trends by summarizing extreme temperature events (days above 35°C) and extended drought periods (30+ consecutive days without precipitation) using INMET data.

- **Data Consistency Assessment:**  
  Evaluate the temporal consistency of weather stations to restrict analyses to those with reliable, long-term records.

### Environmental and Climatic Context
Over recent years, the Pantanal and other biomes in MS have experienced a notable increase in fire events. Climatic factors—such as extended dry spells and rising temperatures—are believed to contribute to this trend. Although our initial analyses reveal correlations between these environmental conditions and fire incidents, further econometric studies are necessary to rigorously establish causality.

---

## Repository Structure

- **Data Acquisition & Preparation:**
  - **00_setup.R:** Loads and installs required packages.
  - **01_import_data.R:** Imports raw data from online repositories.
  - **02_clean_data.R:** Cleans and preprocesses the fire and weather datasets.
  
- **Data Processing:**
  - **03_process_fires.R:** Converts fire incident data into a spatial format.
  - **04_process_weather.R:** Aggregates weather data and identifies extended drought periods as well as available data from weather stations.

- **Visualization:**
  - **05_visualize_fires.R:** Generates annual fire maps and density heatmaps.
  - **06_drought_trend.R:** Analyzes and visualizes trends in extended drought periods.
  - **07_weather_trends.R:** Analyzes and visualizes trends in extreme temperature days.

- **Helper Functions (located in `code/functions/`):**
  - **create_fire_map.R:** Constructs fire location maps.
  - **create_heatmap.R:** Creates fire density heatmaps.
  - **plot_drought_trend.R:** Plots the evolution of extended drought periods.
  - **plot_temperature_trend.R:** Plots trends in extreme temperature days.

---

## Outputs and Visualizations

All plots are saved as PDF files in the `output` folder. Below are the primary visualizations along with their scientific interpretations:

### Fire Maps
These maps display the spatial distribution of fire incidents across MS for key years:

- **2017 Fires**  
  ![Fire Map 2017](output/fires_2017.pdf)  
  *Total fires: 5,737*  
  *Interpretation:* The map shows a significant concentration of fire spots in areas corresponding to the Pantanal region, indicating heightened fire activity during 2017. :contentReference[oaicite:0]{index=0}

- **2018 Fires**  
  ![Fire Map 2018](output/fires_2018.pdf)  
  *Total fires: 2,380*  
  *Interpretation:* Compared to 2017, 2018 exhibits fewer fire events, though spatial clustering suggests that certain regions consistently experience elevated fire risks. :contentReference[oaicite:1]{index=1}

- **2021 Fires**  
  ![Fire Map 2021](output/fires_2021.pdf)  
  *Total fires: 9,377*  
  *Interpretation:* The 2021 map indicates an even higher incidence of fires, with a broader distribution across the state. This surge may reflect a combination of climatic extremes and other environmental stressors. :contentReference[oaicite:2]{index=2}

### Fire Density Heatmaps
Heatmaps provide a density-based view of fire occurrences, highlighting hotspots:

- **2017 Fire Density**  
  ![Fire Heatmap 2017](output/fires_heatmap_2017.pdf)  
  *Interpretation:* High fire density areas are clearly demarcated, particularly within the Pantanal region, reinforcing the spatial patterns observed in the fire maps. :contentReference[oaicite:3]{index=3}

- **2018 Fire Density**  
  ![Fire Heatmap 2018](output/fires_heatmap_2018.pdf)  
  *Interpretation:* The 2018 heatmap shows lower overall density compared to 2017, though the focal areas of activity remain consistent. :contentReference[oaicite:4]{index=4}

- **2021 Fire Density**  
  ![Fire Heatmap 2021](output/fires_heatmap_2021.pdf)  
  *Interpretation:* In 2021, the heatmap reveals broader and more intense areas of fire density, which may be associated with extreme weather conditions. :contentReference[oaicite:5]{index=5}

### Weather Station Consistency
- **Stations Through Time**  
  ![Stations Through Time](output/stations_thru_time.pdf)  
  *Interpretation:* This visualization highlights the presence/absence of weather stations across the study period. Consistent station data are crucial for robust temporal analyses of weather trends. :contentReference[oaicite:6]{index=6}

### Weather Trends
- **Temperature Trend**  
  ![Temperature Trend](output/temperaturet_trend.pdf)  
  *Interpretation:* The plot displays the annual count of days with maximum temperatures exceeding 35°C. An upward trend in extreme heat events is observable over time; however, further econometric analysis is necessary to evaluate causal links. :contentReference[oaicite:7]{index=7}

- **Drought Trend**  
  ![Drought Trend](output/drought_trend.pdf)  
  *Interpretation:* This plot shows the evolution of extended drought periods (30+ consecutive days without rain) over the years. Variability in the proportion of stations experiencing multiple drought spells indicates that drought severity and frequency have not been uniform over time. :contentReference[oaicite:8]{index=8}

---

## Methodological Approach

1. **Data Acquisition & Preparation:**  
   Raw data from fire (INPE) and weather (INMET) sources are downloaded and processed. Preprocessing includes merging weather data with station metadata and converting fire data to spatial formats.

2. **Visualization & Spatial Analysis:**  
   Fire maps and heatmaps are generated using spatial visualization libraries (e.g., **sf**, **ggplot2**, **rnaturalearth**). These visualizations help identify spatial clusters and trends in fire occurrences.

3. **Weather and Drought Trends:**  
   Daily weather data are aggregated to capture extreme temperature events and drought spells. The derived trends are visualized to illustrate long-term shifts in weather patterns in MS.

4. **Future Analysis:**  
   A crucial ongoing task is refining the weather station selection to include only those with continuous data. Additionally, while initial correlations between weather extremes and fire occurrences have been observed, rigorous econometric analyses are planned to investigate causality.

---

## Running the Project

### Prerequisites
- **R (version ≥ 4.0)**
- Required R packages: `tidyverse`, `sf`, `ggplot2`, `lubridate`, `ggthemes`, `geobr`, `viridis`, among others (see `00_setup.R`).

### How to Run
1. **Setup:**  
   Run `00_setup.R` to install and load all necessary packages.
2. **Data Import:**  
   Execute `01_import_data.R` to download or load existing data.
3. **Data Cleaning & Processing:**  
   Run `02_clean_data.R` followed by `03_process_fires.R` and `04_process_weather.R`.
4. **Visualization:**  
   Generate the fire maps, heatmaps, and weather trend plots by running `05_visualize_fires.R`, `06_drought_trend.R`, and `07_weather_trends.R`.

Each script produces outputs in the `input` or `output` folders, and all generated PDFs can be viewed for further analysis.

---

## Future Work
- **Enhanced Station Filtering:** Further refine the dataset to include only those weather stations with consistent, long-term data.
- **Causal Analysis:** Employ advanced econometric techniques to rigorously test causal relationships between climatic variables and fire occurrences.
- **Interactive Visualizations:** Develop interactive dashboards for more dynamic exploration of the data.

---

## License

This project is released under the [MIT License](LICENSE).

---
