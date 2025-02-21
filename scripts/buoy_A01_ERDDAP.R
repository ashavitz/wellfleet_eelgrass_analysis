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
           'cat4FlagPrimary=0', # query limited to "quality_good" observations
           fields = c("time", "current_speed", "current_direction", "temperature")
  )

# Examining the data
# str(A01_aanderaa_hist)
# summary(A01_aanderaa_hist)
# visdat::vis_dat(A01_aanderaa_hist)
# skimr::skim(A01_aanderaa_hist)

# Clean imported data

# Calculate daily mean and high values to reduce size of data sets


# ---- 	 ----





# ---- 	 ----


