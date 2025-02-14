# 06_drought_trend.R - Weather Trends
# Purpose: Analyze and visualize drought trends.
# Author: Julio Meir
# Date: Feb-2025

library(tidyverse)
library(ggplot2)
library(ggthemes)
library(lubridate)

daily_weather <- read_rds('input/daily_weather.rds')
dry_periods <- read_rds('input/dry_periods.rds')

source('code/functions/plot_temperature_trend.R')
source('code/functions/plot_drought_trend.R')

# Generate the plot
drought_plot <- plot_drought_trend(dry_periods)

# Save the plot
ggsave(
  filename = "drought_trend.png",
  plot = drought_plot,
  path = "output",
  width = 10,
  height = 6,
  dpi = 300
)

print("Successfully saved: drought_trend.png")

message("Drought visualization complete.")