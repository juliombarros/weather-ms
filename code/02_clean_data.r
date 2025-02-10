# 02_clean_data.R - Data Cleaning & Processing
# Purpose: Clean and preprocess raw data for further analysis.
# Author: Julio Meir
# Date: Feb-2025

library(tidyverse)

fires <- read_csv('input/fires.csv')
stations <- read_csv('input/stations.csv')
weather <- read_csv('input/weather.csv')

# Merge weather data with station metadata
weather_cleaned <- weather %>% 
  inner_join(stations, by = "id_estacao") 

write_csv(weather_cleaned, 'input/weather_cleaned.csv')

message("Data cleaning complete. Processed files saved.")
