# 07_weather_trends.R - Weather Trends
# Purpose: Analyze and visualize temperature trends.
# Author: Julio Meir
# Date: Feb-2025

library(tidyverse)
library(ggplot2)
library(ggthemes)
library(lubridate)

daily_weather <- read_rds('input/daily_weather.rds')

source('code/functions/plot_temperature_trend.R')

# Generate the plot
temperature_plot <- plot_temperature_trend(daily_weather, temperature_goal = 35)

# Save the plot
ggsave(
  filename = "temperaturet_trend.png",
  plot = temperature_plot,
  path = "output",
  width = 10,
  height = 6,
  dpi = 300
)


print("Successfully saved: temperature_plot.png")


message("Weather visualization complete.")