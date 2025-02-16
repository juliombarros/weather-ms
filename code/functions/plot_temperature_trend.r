# plot_temperature_trend.R - Function to create temperature trend plot
# Purpose: Generate a trend plot for extreme temperature days.
# Author: Julio Meir
# Date: Feb-2025

library(ggplot2)
library(ggthemes)
library(dplyr)

library(dplyr)
library(ggplot2)
library(ggthemes)  # For theme_economist_white and economist_pal
library(lubridate) # For year function
library(scales)    # For percentage scaling, if needed

plot_temperature_trend <- function(weather_data, temperature_goal) {
  # Ensure 'data' is of Date class
  weather_data <- weather_data %>%
    mutate(data = as.Date(data))
  
  # Step 1: Process data to count extreme temperature days per year
  hot_days <- weather_data %>%
    mutate(n = 1) %>%  # Create a counter
    filter(temperatura_max > temperature_goal) %>%  # Filter for extreme temperatures
    group_by(data) %>%  # Group by each day
    summarise(xheat = max(n)) %>%  # Count if any station had >35°C on that day
    ungroup() %>%
    mutate(year = year(data)) %>%  # Extract year from date
    group_by(year) %>%  # Group by year
    summarise(n_xheat = sum(xheat))  # Total extreme days per year
  
  # Step 2: Create the plot
  temperature_plot <- ggplot(hot_days, aes(x = year, y = n_xheat)) +
    geom_smooth(
      method = "loess",
      span = 1,  # Adjust for smoothing level
      se = FALSE,
      color = economist_pal()(8)[2],
      size = 0.8
    ) +
    geom_point(
      color = economist_pal()(8)[7],
      size = 3
    ) +
    theme_economist() +
    scale_x_continuous(
      breaks = seq(min(hot_days$year, na.rm = TRUE), 
                   max(hot_days$year, na.rm = TRUE), 
                   by = 1)
    ) +
    scale_y_continuous(
      breaks = seq(0, max(hot_days$n_xheat, na.rm = TRUE) * 1.1, by = 25),
      limits = c(0, max(hot_days$n_xheat, na.rm = TRUE) * 1.1)
    ) +
    labs(
      title = "Extreme Temperature Days in MS",
      subtitle = "Number of days with temperature above 35°C by year",
      x = "Year",
      y = "Number of Extreme Days",
      caption = "Source: INMET"
    ) 
  
  return(temperature_plot)
}