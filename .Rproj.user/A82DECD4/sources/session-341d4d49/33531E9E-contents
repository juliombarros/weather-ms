# run_all.R - Master Script to Run All Steps
# Purpose: Execute all scripts in sequence to ensure a complete workflow.
# Author: Julio Meir
# Date: Feb-2025

message("Starting project execution...\n")

gc()

# Load required packages in a single place
source("code/00_setup.R")

# Run scripts in sequence

source("code/01_import_data.R")
source("code/02_clean_data.R")
source("code/03_process_fires.R")
source("code/04_process_weather.R")
source("code/05_visualize_fires.R")
source("code/06_drought_trend.R")
source("code/07_temperature_trend.R")

message("All scripts executed successfully! Output files are available in the output/ folder.\n")
