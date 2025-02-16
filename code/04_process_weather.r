# 04_process_weather.R - Process Weather Data
# Purpose: Aggregate weather data for analysis and visualization.
# Author: Julio Meir
# Date: Feb-2025

library(tidyverse)
library(lubridate)

weather <- read_csv('input/weather_cleaned.csv')

# Aggregate daily precipitation and max temperature per station
daily_weather <- weather %>%
  group_by(data, ano, id_estacao) %>%
  summarise(
    precip_daily = sum(precipitacao_total, na.rm = TRUE),
    temperatura_max = max(temperatura_max, na.rm = TRUE),
    .groups = 'drop'
  )


daily_weather %>%
  count(id_estacao, ano) %>%
  count(ano)



# Count dry periods per station
count_dry_periods <- function(data) {
  data %>%
    arrange(id_estacao, data) %>%
    group_by(id_estacao) %>%
    mutate(
      is_dry = precip_daily == 0,
      group_change = is_dry != lag(is_dry, default = first(is_dry)),
      dry_spell_id = cumsum(group_change)
    ) %>%
    group_by(id_estacao, ano, dry_spell_id) %>%
    mutate(
      spell_length = n(),
      is_30day_period = spell_length >= 30 & is_dry
    ) %>%
    group_by(ano, id_estacao) %>%
    summarise(
      n_30day_periods = n_distinct(dry_spell_id[is_30day_period]),
      .groups = 'drop'
    )
}

dry_periods <- count_dry_periods(daily_weather)



# check presence of stations throughout time ------------------------------

# Create a presence/absence table
presence_matrix <- daily_weather %>%
  count(id_estacao, ano) %>%
  mutate(present = 1) %>%
  mutate(n = case_when(n == 365 ~ 365,
                       n == 366 ~ 365,
                       TRUE ~ n)) %>%
  pivot_wider(names_from = ano, values_from = present, values_fill = list(present = 0))

# View the matrix
## View(presence_matrix)


# Reshape data into long format for ggplot
presence_long <- presence_matrix %>%
  pivot_longer(cols = -id_estacao, names_to = "ano", values_to = "present")

# Plot heatmap using ggplot2
stations_thru_time <- ggplot(presence_long, aes(x = ano, y = id_estacao, fill = factor(present))) +
  geom_tile(color = "white") +  # Add white borders for the tiles
  scale_fill_manual(values = c("0" = "white", "1" = "darkgreen")) +  # Set color for presence/absence
  labs(x = "", y = "", fill = "Presence", 
       title = 'Weather Stations Throughout Time - MS') +
  theme_economist_white() +  # Apply the Economist theme
  theme(axis.text.x = element_text(angle = 90, hjust = 1),
        axis.text.y = element_text(size = 7))


# Save the plot
ggsave(
  filename = "stations_thru_time.png",
  plot = stations_thru_time,
  path = "output",
  width = 10,
  height = 6,
  dpi = 300
)


# save --------------------------------------------------------------------


write_rds(daily_weather, 'input/daily_weather.rds')
write_rds(dry_periods, 'input/dry_periods.rds')

message("Weather data processing complete.")
