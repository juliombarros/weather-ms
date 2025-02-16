# 01_import_data.R - Download Raw Data
# Purpose: Imports data from Base de Dados repository
# Author: Julio Meir
# Date: Feb-2025


# Ensure prompt is displayed immediately

# Ask user if they want to re-download data
answer <- menu(c("YES", "NO"), 
               title = "Do you want to download all data again? This may take up to 15 minutes. \n(1 for YES / 2 for NO): ")

if (answer == 2) {  # Since menu() returns 2 for "NO"
  message("Skipping data download. Using existing files.")
  
} else if (answer == 1) {  # Since menu() returns 1 for "YES"
  
  download_bq_data <- function(sql) {
    query <- bq_project_query("wbdataexercise", sql)
    bq_table_download(query)
  }
  
  # Downloading data from BigQuery
  fires <- download_bq_data("SELECT * FROM `basedosdados.br_inpe_queimadas.microdados` WHERE id_municipio BETWEEN '5000000' AND '5099999'")
  stations <- download_bq_data("SELECT * FROM `basedosdados.br_inmet_bdmep.estacao` WHERE id_municipio BETWEEN '5000000' AND '5099999'")
  weather <- download_bq_data("SELECT ano, data, hora, id_estacao, precipitacao_total, temperatura_max FROM `basedosdados.br_inmet_bdmep.microdados` WHERE ANO BETWEEN 2003 AND 2022")
  
  # Save data as CSV
  write_csv(fires, 'input/fires.csv')
  write_csv(stations, 'input/stations.csv')
  write_csv(weather, 'input/weather.csv')
  
  message("Data import complete.")
}
