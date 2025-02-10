# Ask user if they want to re-download data
answer <- readline(prompt = "Do you want to download all data again? This may take up to 15 minutes. (1 for YES / 0 for NO): ")
answer <- as.numeric(answer)  # Convert input to numeric

if (is.na(answer) || !answer %in% c(0, 1)) {
  tryCatch({
    stop(">>> Error <<<< Answers allowed: 0 or 1. Please rerun from start\n______________________________________________________________")
  }, error = function(e) {
    message("\n", conditionMessage(e))  # Display only the custom error message
  })
} else if (answer == 0) {
  message("Skipping data download. Using existing files.")
  
} else if (answer == 1) {
  download_bq_data <- function(sql) {
    query <- bq_project_query("wbdataexercise", sql)
    bq_table_download(query)
  }
  
  fires <- download_bq_data("SELECT * FROM `basedosdados.br_inpe_queimadas.microdados` WHERE id_municipio BETWEEN '5000000' AND '5099999'")
  stations <- download_bq_data("SELECT * FROM `basedosdados.br_inmet_bdmep.estacao` WHERE id_municipio BETWEEN '5000000' AND '5099999'")
  weather <- download_bq_data("SELECT ano, data, hora, id_estacao, precipitacao_total, temperatura_max FROM `basedosdados.br_inmet_bdmep.microdados` WHERE ANO BETWEEN 2003 AND 2022")

  write_csv(fires, 'input/fires.csv')
  write_csv(stations, 'input/stations.csv')
  write_csv(weather, 'input/weather.csv')

  message("Data import complete.")
}
