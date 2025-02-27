#'--------------------------------------
#' Center for Coastal Studies - Cape Cod Water Quality Data
#' Data download source: https://www.capecodbay-monitor.org/download
#' Map of stations: https://www.capecodbay-monitor.org/
#'--------------------------------------

library(readr) # for reading in files
library(lubridate) # for date time formats
library(dplyr) # for data manipulation and transformation

# ---- csv import from CCS ----

# Read in csv file from local directory
file_path_ccs_data <- "data/ccs_data_all/station_data.csv"
ccs_data_all <- read_csv(file_path_ccs_data, col_names = TRUE)

# # Examining the data
str(ccs_data_all)
summary(ccs_data_all)
visdat::vis_dat(ccs_data_all)
skimr::skim(ccs_data_all)
