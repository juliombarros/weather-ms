# 03_process_fires.R - Process Fire Data
# Purpose: Convert fire dataset into spatial format for mapping.
# Author: Julio Meir
# Date: Feb-2025

library(tidyverse)
library(sf)
library(furrr)

fires <- read_csv('input/fires.csv')

# Convert to sf object
fires_sf <- st_as_sf(fires, wkt = "centroide", crs = 4326)
write_rds(fires_sf, 'input/fires_sf.rds')

message("Fire data processing complete.")