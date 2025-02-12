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

write_rds(daily_weather, 'input/daily_weather.rds')
write_rds(dry_periods, 'input/dry_periods.rds')

message("Weather data processing complete.")
