library(dplyr)
library(ggplot2)
library(ggthemes)
library(scales)

plot_drought_trend <- function(drought_data) {
  
  # Categorize the number of drought periods
  result_modified <- drought_data %>%
    mutate(period_category = case_when(
      n_30day_periods == 0 ~ "0 periods",
      n_30day_periods == 1 ~ "1 period",
      n_30day_periods >= 2 ~ "2 and more",
      TRUE ~ NA_character_
    )) %>%
    filter(!is.na(period_category))
  
  # Create the bar plot
  drought_plot <- ggplot(result_modified, aes(x = ano)) +
    geom_bar(aes(fill = period_category), position = "fill") +
    theme_economist_white() +
    scale_fill_manual(
      values = c(
        "0 periods"  = economist_pal()(8)[1],
        "1 period"   = economist_pal()(8)[5],
        "2 and more" = economist_pal()(8)[7]
      )
    ) +
    scale_y_continuous(labels = percent_format(), expand = expansion(mult = c(0, 0.05))) +
    scale_x_continuous(
      breaks = seq(
        from = min(result_modified$ano, na.rm = TRUE),
        to   = max(result_modified$ano, na.rm = TRUE),
        by   = 1
      )
    ) +
    labs(
      title    = "Evolution of Extended Drought Periods in Brazil",
      subtitle = "Proportion of weather stations experiencing different numbers of 30-day drought periods",
      x        = "Year",
      y        = "Proportion of Stations",
      fill     = "Number of Dry Periods",
      caption  = "Source: INMET"
    ) +
    theme(
      axis.text.x = element_text(angle = 45, hjust = 1),
      plot.title = element_text(face = "bold", size = 14),
      plot.subtitle = element_text(size = 12),
      legend.title = element_text(face = "bold")
    )
  
  return(drought_plot)
}