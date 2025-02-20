#'--------------------------------------
#' CDIP221 Buoy https://www.ndbc.noaa.gov/station_history.php?station=44090
#' Cape Cod Bay, MA
#' Owned and maintained by Woods Hole Group/NERACOOS
#' Data provided by Scripps Institution of Oceanography
#' National Data Buoy Center Station 44090
#' Waverider Buoy
#' 41.840 N 70.329 W (41°50'24" N 70°19'43" W)
#' Site elevation: sea level
#' Sea temp depth: 0.46 m below water line
#'--------------------------------------

library(readr) # for reading in files
library(lubridate) # for date time formats
library(dplyr) # for data manipulation and transformation
library(rerddap) # for accessing ERDDAP servers

# ---- Importing files via ERDDAP ----
#' -------------------------------------
#' Importing files via ERDDAP
#' CDIP ERDDAP base URL:
#' https://erddap.cdip.ucsd.edu/erddap/index.html
#' -------------------------------------

# ---- Air temperature measurements ----

# Get information about the cat4 (air measurements) data set
data_info_cat4 <- rerddap::info("cat4_agg",
                           url = "erddap.cdip.ucsd.edu/erddap")

# Get time and air temp data from the cat4_agg data set 
buoy_221_cat4 <- 
  tabledap(data_info_cat4,
           'station_id="221"', # query limited to Cape Cod station 221
           'cat4FlagPrimary=1', # query limited to "good" quality observations
           fields = c("time", "cat4AirTemperature")
           )

# # Examining the data
# str(buoy_221_cat4)
# summary(buoy_221_cat4)
# visdat::vis_dat(buoy_221_cat4)
# skimr::skim(buoy_221_cat4)

# Clean imported data
buoy_221_cat4 <- buoy_221_cat4 |> 
  mutate(
    time = ymd_hms(time, tz = "UTC"), # convert time column to date time
    date = as.Date(time), # create date column based on time column
    cat4AirTemperature = as.numeric(cat4AirTemperature) # convert air temp to numeric
  )

# Calculate daily mean and high values to reduce size of data sets
buoy_221_cat4_daily <- 
  buoy_221_cat4 |> 
  group_by(date) |> 
  summarize(
    mean_air_temp = mean(cat4AirTemperature),
    max_air_temp = max(cat4AirTemperature)
  ) |> 
  ungroup()

# ---- Sea surface temperature (SST) measurements ----

# Get data set information
data_info_sst <- rerddap::info("sst_agg",
                               url = "erddap.cdip.ucsd.edu/erddap")

# Get time and SST data from the sst_agg data set
buoy_221_sst <- 
  tabledap(data_info_sst,
           'station_id="221"', # query limited to Cape Cod station 221
           'sstFlagPrimary=1', # query limited to "good" quality observations
           fields = c("time", "sstSeaSurfaceTemperature")
           )

# Clean imported data
buoy_221_sst <- buoy_221_sst |> 
  mutate(
    time = ymd_hms(time, tz = "UTC"), # convert time column to date time
    date = as.Date(time), # create date column based on time column
    sstSeaSurfaceTemperature = as.numeric(sstSeaSurfaceTemperature) # sst to numeric
  )

# Calculate daily mean and high values to reduce size of data sets
buoy_221_sst_daily <- 
  buoy_221_sst |> 
  group_by(date) |> 
  summarize(
    mean_sst = mean(sstSeaSurfaceTemperature),
    max_sst = max(sstSeaSurfaceTemperature)
  ) |> 
  ungroup()

# ---- Surface Current (acm) measurements ----
# (acm = acoustic current measurements ?)

# Get data set information
data_info_acm <- rerddap::info("acm_agg",
                               url = "erddap.cdip.ucsd.edu/erddap")

# Get time, speed, direction, abd vertical speed from the acm_agg data set
# TODO: Do we need other data in this data set?
buoy_221_acm <- 
  tabledap(data_info_acm,
           'station_id="221"', # query limited to Cape Cod station 221
           'acmFlagPrimary=1', # query limited to "good" quality observations
           fields = c("time", "acmSpeed", "acmDirection","acmVerticalSpeed")
           )

# Clean imported data
buoy_221_acm <- buoy_221_acm |> 
  mutate(
    time = ymd_hms(time, tz = "UTC"), # convert time column to date time
    date = as.Date(time), # create date column based on time column
    across( # convert all other variables to numeric
      c(acmSpeed, acmDirection, acmVerticalSpeed), as.numeric)
    )

# Calculate daily mean values to reduce size of data sets
buoy_221_acm_daily <- 
  buoy_221_acm |> 
  group_by(date) |> 
  summarize(
    mean_acm_speed = mean(acmSpeed),
    max_acm_speed = max(acmSpeed),
# TODO: Review this calculation and confirm if correct
    mean_acm_direction = {
  
      # Convert wind direction to radians
      rad = (acmDirection * pi / 180)
      
      # Calculate the x and y components of the wind vector
      x = mean(cos(rad))
      y = mean(sin(rad))
      
      # Convert the x and y components back to an angle (in degrees)
      mean_direction = atan2(y, x) * 180 / pi
      
      # Normalize the result to a range of 0 to 360 degrees
      if (mean_direction < 0) mean_direction + 360 else mean_direction
    },
  mean_acm_vertical_speed = mean(acmVerticalSpeed)
  ) |> 
  ungroup()

# ---- Wave measurements ----

# Get data set information
data_info_wave <- rerddap::info("wave_agg",
                               url = "erddap.cdip.ucsd.edu/erddap")

# Get time, significant wave height, peak wave period, and average wave period
# data from the wave_agg data set
# TODO: Do we need other data in this data set?
buoy_221_wave <- 
  tabledap(data_info_wave,
           'station_id="221"', # query limited to Cape Cod station 221
           'waveFlagPrimary=1', # query limited to "good" quality observations
           fields = c("time", "waveHs", "	waveTp","waveTa")
           )

buoy_221_wave <- buoy_221_wave |> 
  mutate(
    time = ymd_hms(time, tz = "UTC"), # convert time column to date time
    date = as.Date(time), # create date column based on time column
    across( # convert all other variables to numeric
      c(waveHs, waveTp, waveTa), as.numeric)
  )

# Calculate daily mean and high values to reduce size of data sets
buoy_221_wave_daily <- 
  buoy_221_wave |> 
  group_by(date) |> 
  summarize(
    mean_wave_hs = mean(waveHs),
    mean_wave_tp = mean(waveTp),
    mean_wave_Ta = mean(waveTa)
  ) |> 
  ungroup()

# ---- Create data set for analysis ----

# Join all data frames by date
buoy_221_daily <- 
  purrr::reduce(
    list(buoy_221_cat4_daily,
         buoy_221_sst_daily,
         buoy_221_wave_daily,
         buoy_221_wave_daily),
    full_join, by = "date") |> 
  arrange(date)

# ---- TODO ----


# Review structure of files. Identify all NA, Null, or otherwise invalid cells

# Standardize all invalid cells to NA

# Remove all unwanted variables

# Remove all rows with NAs? More likely keep them, but be sure 



# Goal: Group all years into one data frame and display
# summary statistics and exploratory graphs