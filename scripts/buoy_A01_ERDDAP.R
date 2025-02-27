#'--------------------------------------
#' NERACOOS Buoy A01 
#' Massachusetts Bay
#' NDBC ID: 44029
#' Lat: 42.53 Lon: -70.56
#' University of Maine
#' https://mariners.neracoos.org/platform/A01
#' https://www.ndbc.noaa.gov/station_page.php?station=44029
#' Massachusetts Bay
#' Owned and maintained by NERACOOS
#'--------------------------------------

# TODO: Simple means are calculated by month, not accounting for missing data.
#       Consider options: impute missing data, use only days with complete data, other?

library(readr) # for reading in files
library(lubridate) # for date time formats
library(dplyr) # for data manipulation and transformation
library(rerddap) # for accessing ERDDAP servers

# ---- Importing files via ERDDAP ----
#' -------------------------------------
#' NERACOOS ERDDAP base URL:
#' https://www.neracoos.org/erddap/index.html
#' -------------------------------------

# ---- 	A01 Aanderaa - Historic Surface Currents (and 2m depth water temperature) ----

# Get information about the A01_aanderaa_hist data set
info_A01_aanderaa_hist <- rerddap::info("A01_aanderaa_hist",
                                        url = "neracoos.org/erddap")

# Get time, current speed, current direction, and water temp data
A01_aanderaa_hist <- 
  tabledap(info_A01_aanderaa_hist,
           # query limited to "quality_good" observations where qc flags = 0
           'current_speed_qc=0',
           'current_direction_qc=0',
           'temperature_qc=0',
           fields = c("time", "current_speed", "current_direction", "temperature")
  )

# Examining the data
# str(A01_aanderaa_hist)
# summary(A01_aanderaa_hist)
# visdat::vis_dat(A01_aanderaa_hist)
# skimr::skim(A01_aanderaa_hist)

# Clean imported data
A01_aanderaa_hist <- A01_aanderaa_hist |> 
  mutate(
    time = ymd_hms(time, tz = "UTC"), # convert time column to date time
    date = as.Date(time), # create date column based on time column
    across(c(current_speed, current_direction, temperature), as.numeric) # convert to numeric
  )

# Calculate daily mean and high values to reduce size of data sets


# TODO: What additional A01 buoy data is needed for analysis?

# ---- A01 Directional Waves ----
# TODO: There are many variables in this data set. What is needed for analysis?

# Get information about the A01_waves_mstrain_all data set
info_A01_wave_dir <- rerddap::info("A01_waves_mstrain_all",
                                        url = "neracoos.org/erddap")

# Get time, significant wave height, dominant wave period, mean wave direction, and swell wave height data
A01_wave_dir <- 
  tabledap(info_A01_wave_dir,
           # query limited to "quality_good" observations where qc flags = 0
           'significant_wave_height_3_qc=0',
           'dominant_wave_period_3_qc=0',
           'mean_wave_direction_3_qc=0',
           'swell_wave_height_3_qc=0',
           fields = c("time",
                      "significant_wave_height_3",
                      "dominant_wave_period_3",
                      "mean_wave_direction_3",
                      "swell_wave_height_3")
           )

# Clean imported data
A01_wave_dir <- A01_wave_dir |> 
  mutate(
    time = ymd_hms(time, tz = "UTC"), # convert time column to date time
    date = as.Date(time), # create date column based on time column
    across(c(significant_wave_height_3,
             dominant_wave_period_3,
             mean_wave_direction_3,
             swell_wave_height_3), as.numeric) # convert to numeric
  )


# ---- A01 Accelerometer - Waves ----

# Get information about the A01_accelerometer_all data set
info_A01_wave_acc <- rerddap::info("A01_accelerometer_all",
                                        url = "neracoos.org/erddap")

# Get time, significant wave height, and dominant wave period data
A01_wave_acc <- 
  tabledap(info_A01_wave_acc,
           # query limited to "quality_good" observations where qc flags = 0
           'significant_wave_height_qc=0',
           'dominant_wave_period_qc=0',
           fields = c("time", "significant_wave_height", "dominant_wave_period")
  )

# Clean imported data
A01_wave_acc <- A01_wave_acc |> 
  mutate(
    time = ymd_hms(time, tz = "UTC"), # convert time column to date time
    date = as.Date(time), # create date column based on time column
    across(c(significant_wave_height, dominant_wave_period), as.numeric) # convert to numeric
  )

# ---- 	----

# ----  ----

