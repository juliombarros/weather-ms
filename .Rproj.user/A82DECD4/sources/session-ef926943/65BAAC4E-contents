# 05_visualize_fires.R - Fire Maps & Heatmaps
# Purpose: Generate fire location maps and heatmaps.
# Author: Julio Meir
# Date: Feb-2025

library(tidyverse)
library(sf)
library(ggplot2)
library(geobr)
library(ggthemes)
library(scales)

fires_sf <- read_rds('input/fires_sf.rds')
states <- read_state(year = 2020) %>% filter(abbrev_state == "MS")

source('code/functions/create_fire_map.R')
source('code/functions/create_heatmap.R')

# list with yearly data
map_data <- fires_sf %>% split(.$ano)

# run fire_plot nd heatmap_plot per year
pmap(list(map_data, names(map_data)), function(data, year) {
  year <- as.numeric(year)
  
  # Generate fire map
  fire_plot <- create_fire_map(data, states, year)
  ggsave(filename = paste0('output/fires_', year, '.pdf'), plot = fire_plot, width = 12, height = 10, dpi = 400, device = cairo_pdf)
  
  # Generate heatmap
  heatmap_plot <- create_heatmap(data, states, year)
  ggsave(filename = paste0('output/fires_heatmap_', year, '.pdf'), plot = heatmap_plot, width = 12, height = 10, dpi = 400, device = cairo_pdf)
})

message("Fire visualization complete.")