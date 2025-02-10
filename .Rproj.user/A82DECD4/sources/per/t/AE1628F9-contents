# ------------------------------------------------------------------------
# Projects 2050 fleet based on BCG scenario
#
#
# ------------------------------------------------------------------------



# input -------------------------------------------------------------------

load(file.path('./tmp', '3_compute_fleet.rda'))

# Plot Directory
plot.dir <- './output/plots'


# Inertial Growth Scenario ------------------------------------------------

# Computing shares of sales
regis_fleet_shares <- regis_fleet %>%
  mutate(across(starts_with('Registration'), ~ .x / Registration, .names = 'Shr{col}'))

# Sales Expansion Rate (year over year):

sales_growth <- 1.044

# 2023 - 2030
regis_fleet_23_35 <-  regis_fleet_shares %>%
  add_row(Year = 2023:2035) %>%
  filter(Year >= 2022) %>%
  mutate(Registration = accumulate(Registration, ~ .x*sales_growth)) %>% 
  mutate(ShrRegistrationGasoline = case_when(Year <  2035 ~ accumulate(ShrRegistrationGasoline, ~.x -0.00191),
                                             TRUE ~ 0)) %>%
  mutate(ShrRegistrationFlex  = accumulate(ShrRegistrationFlex, ~.x -0.03485)) %>%
  mutate(ShrRegistrationDiesel  = accumulate(ShrRegistrationDiesel, ~.x - 0.00822)) %>%
  mutate(ShrRegistrationHybrid  = accumulate(ShrRegistrationHybrid, ~.x + 0.02917)) %>%
  mutate(ShrRegistrationBEV     = accumulate(ShrRegistrationBEV, ~.x + 0.01582)) %>%
  mutate(ShrRegistrationEthanol = replace_na(ShrRegistrationEthanol, 0)) %>%
  filter(Year >= 2023)



# 2030 - 2045
regis_fleet_36_45 <-  regis_fleet_23_35 %>%
  add_row(Year = 2036:2045) %>%
  filter(Year >= 2035) %>%
  mutate(Registration = accumulate(Registration, ~ .x*sales_growth)) %>% 
  mutate(ShrRegistrationGasoline  = replace_na(ShrRegistrationGasoline, 0)) %>%
  mutate(ShrRegistrationFlex      = case_when( Year < 2045 ~ accumulate(ShrRegistrationFlex, ~.x -0.038),
                                               TRUE ~ 0)) %>%
  mutate(ShrRegistrationDiesel    = case_when( Year < 2045 ~ accumulate(ShrRegistrationDiesel, ~.x - 0.001),
                                               TRUE ~0 )) %>%
  mutate(ShrRegistrationHybrid    = accumulate(ShrRegistrationHybrid, ~.x + 0.023)) %>%
  mutate(ShrRegistrationBEV       = accumulate(ShrRegistrationBEV, ~.x + 0.01582)) %>%
  mutate(ShrRegistrationEthanol   = replace_na(ShrRegistrationEthanol, 0)) %>%
  filter(Year >= 2036)



# 2045 - 2050
regis_fleet_46_50 <-  regis_fleet_36_45 %>%
  add_row(Year = 2046:2050) %>%
  filter(Year >= 2045) %>%
  mutate(Registration = accumulate(Registration, ~ .x*sales_growth)) %>% 
  mutate(ShrRegistrationHybrid = accumulate(ShrRegistrationHybrid, ~.x - 0.01547)) %>%  
  mutate(ShrRegistrationBEV = accumulate(ShrRegistrationBEV, ~.x + 0.01582)) %>%
  mutate(across(c(ShrRegistrationGasoline, 
                  ShrRegistrationEthanol, 
                  ShrRegistrationFlex,
                  ShrRegistrationDiesel), ~ replace_na(.x, 0))) %>%
  filter(Year >= 2046)


# Bind all into one dataframe:

# 2023 - 2050, computing registry: 
regis_fleet_23_50 <- bind_rows(regis_fleet_23_35, 
                               regis_fleet_36_45,  
                               regis_fleet_46_50) %>%
  mutate(RegistrationGasoline = ShrRegistrationGasoline * Registration,
         RegistrationEthanol  = ShrRegistrationEthanol * Registration,
         RegistrationFlex     = ShrRegistrationFlex    * Registration,
         RegistrationDiesel   = ShrRegistrationDiesel  * Registration,
         RegistrationHybrid   = ShrRegistrationHybrid  * Registration,
         RegistrationBEV      = ShrRegistrationBEV     * Registration)

# 1957 - 2050
regis_fleet_57_50 <- bind_rows(regis_fleet, regis_fleet_23_50)


# Compute Fleet -----------------------------------------------------------

# compute exit function 

sucateamento_otto <- function(yr, registration) {
  
  age  <- max(yr) - yr
  exit <- exp(-exp(1.798-0.137*age))
  shr_available <- 1 - exit
  
  shr_available * registration
  
}

sucateamento_diesel <- function(yr, registration) {
  
  age  <- max(yr) - yr
  exit <- (1/(1 + exp(0.17*(age - 15.3)))) + (1/(1+exp(0.17*(age + 15.3))))
  shr_available <- 1 - exit
  
  shr_available * registration
  
}

# Yearly dataframes in a list:
regis_ls <- map(.x = regis_fleet_57_50$Year, 
                ~ regis_fleet_57_50 %>% filter(Year <= .x))

# Pass exit function to compute each year's contribution to net of fleet
yearly_net <- map(.x = regis_ls, 
                  ~ .x %>% mutate( FleetGasoline = sucateamento_otto(Year, RegistrationGasoline),
                                   FleetEthanol  = sucateamento_otto(Year, RegistrationEthanol),
                                   FleetFlex     = sucateamento_otto(Year, RegistrationFlex),
                                   FleetDiesel   = sucateamento_diesel(Year, RegistrationDiesel),
                                   FleetHybrid   = sucateamento_otto(Year, RegistrationHybrid),
                                   FleetBEV      = sucateamento_otto(Year, RegistrationBEV)))

# Summation for each year
yearly_fleet <- map_df(.x = yearly_net, 
                       ~ .x %>% 
                         mutate(across(starts_with("Fleet"), ~ sum(.x))) %>% 
                         filter(Year == max(Year)) %>%
                         select(c(Year, starts_with("Fleet")))) %>%
  mutate(ModeledFleet = rowSums(select(.,starts_with("Fleet"))))


# save fleet data
write_excel_csv2(yearly_fleet, file = file.path('./output', 'cenario_convergencia.csv'))

# plot: share projections -------------------------------------------------

evol_shares <- bind_rows(regis_fleet_shares, regis_fleet_23_50) %>%
  select(Year, starts_with('Shr')) %>%
  mutate(ShrRegistrationICE = rowSums(select(.,c('ShrRegistrationGasoline',
                                                 'ShrRegistrationEthanol',
                                                 'ShrRegistrationDiesel',
                                                 'ShrRegistrationFlex')))) %>%
  select(!c(ShrRegistration, 
            ShrRegistrationGasoline, 
            ShrRegistrationEthanol, 
            ShrRegistrationDiesel,
            ShrRegistrationFlex)) %>%
  pivot_longer(cols = starts_with('Shr'), names_to = 'Fuel', values_to = 'Shr') %>%
  mutate(Fuel = str_replace(Fuel, 'ShrRegistration', ''))



# Plot
# https://yutannihilation.github.io/allYourFigureAreBelongToUs/ggthemes/
evol_shares %>%
  filter(Year >= 2015) %>%
  ggplot(., aes(x=Year, y= Shr, fill= Fuel)) + 
  stat_smooth(
    geom = 'area', method = 'loess', span = 1/5,
    alpha = 0.5) +
  ggtitle('Registration of Light Vehicles, Composition by Powertrain', subtitle = 'Brazil, 2015-2023 (Historical) 2023-2050 (Projection)') +
  theme_economist_white(gray_bg = F) + scale_fill_wsj() +
  ylab("") + guides(fill=guide_legend(title= '')) +
  scale_y_continuous(labels=scales::percent)


evol_shares %>%
  filter(Year >= 2015) %>%
  ggplot(., aes(x=Year, y= Shr, fill= Fuel)) + 
  geom_area(alpha = 0.85)  +
  geom_vline(aes(xintercept = 2035)) + 
  geom_vline(aes(xintercept = 2045)) + 
  geom_vline(aes(xintercept = 2050)) +
  geom_text(aes(2035-1, 0.5, label = '40%', vjust = 1)) +
  geom_text(aes(2035-1, 0.95,label = '21%', vjust = 1)) +
  geom_text(aes(2035-1, 0.2, label = '39%', vjust = 1)) +
  geom_text(aes(2045-1, 0.5, label = '63%', vjust = 1)) +
  geom_text(aes(2045-1, 0.95,label = '37%', vjust = 1)) +
  geom_text(aes(2050-1, 0.5, label = '55%', vjust = 1)) +
  geom_text(aes(2050-1, 0.95,label = '45%', vjust = 1)) +
  ggtitle('Registration of Light Vehicles', 
          subtitle = 'Composition by Powertrain, Historical (2015-2023) and Projection (2023-2050)') +
  theme_economist_white(gray_bg = F) + scale_fill_wsj() +
  ylab("") + guides(fill=guide_legend(title= '')) +
  theme(axis.title.x = element_blank()) +
  scale_x_continuous(breaks = c(2015, 2020, 2025, 2030, 2035, 2040, 2045, 2050)) +
  scale_y_continuous(labels=scales::percent)
ggsave(filename = '5_1_premises_convergence.png', width = 15, height = 10, path = plot.dir)




# plot: fleet projection --------------------------------------------------


evol_fleet <- yearly_fleet %>%
  pivot_longer(cols = starts_with('Fleet'), names_to = 'Fuel', values_to = 'Fleet') %>%
  mutate(Fuel = str_replace(Fuel, 'Fleet', replacement = ''))



# Plot
# https://yutannihilation.github.io/allYourFigureAreBelongToUs/ggthemes/
evol_fleet %>%
  filter(Year >= 2015) %>%
  ggplot(., aes(x=Year, y= Fleet, fill= Fuel)) + 
  stat_smooth(
    geom = 'area', method = 'loess', span = 1/15,
    alpha = 0.5) +
  ggtitle('Registration of Light Vehicles, Share of Propulsion Type', 
          subtitle = 'Brazil, 2015-2023 (Historical) 2023-2050 (Projection)') +
  theme_economist_white(gray_bg = F) + scale_fill_wsj() +
  ylab("") + guides(fill=guide_legend(title= ''))



evol_fleet %>%
  filter(Year >= 2015) %>%
  arrange(Year, rev(Fleet)) %>%
  group_by(Year) %>%
  mutate(Fleet     = Fleet/10^6,
         Fleet_lbl = if_else(Year == 2050, round(Fleet, 1), NA),
         Fleet_lbl = if_else(Fleet_lbl < 1, NA, Fleet_lbl),
         y_lbl     = if_else(Year == 2050, cumsum(Fleet) - 0.3*Fleet, NA)) %>%
  ggplot(., aes(x=Year, y= Fleet, fill = Fuel)) + 
  geom_bar(position="stack", stat="identity") +
  geom_text(aes(label = Fleet_lbl), position = position_stack(vjust = 0.5), col = 'white') +
  ggtitle('Fleet Composition, Convergence Scenario', subtitle = 'Brazil, in Millions') +
  theme_economist_white(gray_bg = F) + 
  scale_fill_wsj() +
  ylab("") + 
  guides(fill=guide_legend(title= ''))
ggsave(filename = '5_2_fleet_convergence.png', width = 15, height = 10, path = plot.dir)




# Same graph with just a few years
select_years <- c(2022,2030,2035,2040,2045,2050)

evol_fleet %>%
  filter(Year %in% select_years) %>%
  mutate(Fleet     = Fleet/10^6,
         Fleet_lbl = if_else(Year %in% select_years, round(Fleet, 1), NA),
         Fleet_lbl = if_else(Fleet_lbl < 1, NA, Fleet_lbl),
         y_lbl     = cumsum(Fleet)) %>%
  ggplot(., aes(x=Year, y= Fleet, fill = Fuel)) + 
  geom_bar(position="stack", stat="identity") + #geom_text(aes(label = Fleet_lbl, y = y_lbl), vjust = 1.5, col = 'white') +
  ggtitle('Fleet Composition, Convergence Scenario', subtitle = 'Brazil, in Millions') +
  geom_text(aes(label = Fleet_lbl), size = 4.5, position = position_stack(vjust = 0.5), colour = 'white') +
  theme_economist_white(gray_bg = F) + 
  scale_fill_wsj() +
  ylab("") + 
  scale_x_continuous(breaks = c(2022,2030,2035,2040,2045,2050))  +
  guides(fill=guide_legend(title= ''))
ggsave(filename = '5_3_fleet_convergence_selectedYears.png', width = 15, height = 10, path = plot.dir)


evol_fleet %>%
  filter(Year %in% select_years) %>%
  mutate(Fleet     = Fleet/ModeledFleet,
         Fleet_lbl = if_else(Fleet < 0.01, NA, Fleet),
         Fleet_lbl = if_else(Year %in% select_years, paste0(round(Fleet_lbl,2)*100, "%"), NA),
         Fleet_lbl = if_else(Fleet_lbl == 'NA%', "", Fleet_lbl),
         y_lbl     = cumsum(Fleet)) %>%
  ggplot(., aes(x=Year, y= Fleet, fill = Fuel)) + 
  geom_bar(position="stack", stat="identity") + #geom_text(aes(label = Fleet_lbl, y = y_lbl), vjust = 1.5, col = 'white') +
  ggtitle('Fleet Composition, Base Scenario', subtitle = 'Brazil, in Millions') +
  geom_text(aes(label = Fleet_lbl), size = 4.5, position = position_stack(vjust = 0.5), colour = 'white') +
  theme_economist_white(gray_bg = F) + 
  scale_fill_wsj() +
  ylab("") + 
  scale_x_continuous(breaks = c(2022,2030,2035,2040,2045,2050))  +
  scale_y_continuous(labels=scales::percent) +
  guides(fill=guide_legend(title= ''))
ggsave(filename = '5_4_fleet_convergence_selectedYears_Pct.png', width = 15, height = 10, path = plot.dir)


