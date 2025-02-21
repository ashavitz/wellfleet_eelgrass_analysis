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
    across(c(current_speed, current_direction, temperature), as.numeric) # convert air temp to numeric
  )

# Calculate daily mean and high values to reduce size of data sets


# TODO: What additional A01 buoy data is needed for analysis?
# ---- 	 ----





# ---- 	 ----


