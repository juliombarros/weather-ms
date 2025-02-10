# create_fire_map.R - Function to create fire maps
# Purpose: Generate a fire location map for a given year.
# Author: Julio Meir
# Date: Feb-2025

library(ggplot2)
library(sf)
library(ggthemes)
library(scales)

create_fire_map <- function(fires_sf, states, year) {
  year_data <- fires_sf %>% filter(ano == year)
  ggplot() +
    annotation_map_tile(type = "osm", zoom = 6) +
    geom_sf(data = states, fill = NA, color = "black", size = 1) +
    geom_sf(data = year_data, color = "red", alpha = 0.5, size = 0.5) +
    theme_economist() +
    labs(title = paste("Fire Spots in MS -", year),
         subtitle = paste("Total fires:", nrow(year_data)),
         caption = "Source: BDQ, IBGE")
}
