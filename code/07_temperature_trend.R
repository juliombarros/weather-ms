# 06_visualize_weather.R - Weather Trends
# Purpose: Analyze and visualize weather trends such as drought and temperature changes.
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
  filename = "temperaturet_trend.pdf",
  plot = temperature_plot,
  path = "output",
  width = 10,
  height = 6,
  dpi = 300
)


print("Successfully saved: temperature_plot.pdf")


message("Weather visualization complete.")