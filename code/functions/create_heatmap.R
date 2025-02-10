# create_heatmap.R - Function to create fire density heatmaps
# Purpose: Generate a fire density heatmap for a given year.
# Author: Julio Meir
# Date: Feb-2025

library(ggplot2)
library(sf)
library(MASS)
library(ggthemes)
library(scales)

create_heatmap <- function(fires_sf, states, year) {
  year_data <- fires_sf %>% filter(ano == year)
  coords <- st_coordinates(year_data)
  bbox <- st_bbox(states)
  
  bw_x <- (bbox["xmax"] - bbox["xmin"]) / 100
  bw_y <- (bbox["ymax"] - bbox["ymin"]) / 100
  
  kde <- kde2d(
    coords[,1], coords[,2],
    n = 400,
    lims = c(bbox["xmin"], bbox["xmax"], bbox["ymin"], bbox["ymax"]),
    h = c(bw_x, bw_y)
  )
  
  density_df <- expand.grid(x = kde$x, y = kde$y)
  density_df$z <- as.vector(kde$z)
  
  ggplot() +
    geom_sf(data = states, fill = "white", color = "gray50", size = 0.5) +
    geom_raster(data = density_df, aes(x = x, y = y, fill = z), interpolate = TRUE) +
    geom_sf(data = states, fill = NA, color = "white", size = 1) +
    scale_fill_viridis_c(option = "inferno", name = "Fire\nDensity") +
    theme_economist() +
    labs(title = paste("Fire Density in MS -", year),
         subtitle = paste("Total fires:", nrow(year_data)),
         caption = "Source: BDQ, IBGE")
}
