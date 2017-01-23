library(lubridate)

# StationID, timeframe (timeframe = 1: for hourly data, timeframe = 2: for daily
# data, timeframe = 3 for monthly data), start date and end date

envcan <- function(StationID, firstYear, lastYear, timeframe = 2) {

  years <- if (timeframe == 3) {
    firstYear
  } else {
    seq(firstYear, lastYear)
  }

  h <- if (timeframe == 1) {
    16
  } else if (timeframe == 2) {
    25
  } else if (timeframe == 3) {
    18
  }

  m <- if (timeframe == 1) {
    1:12
  } else if (timeframe == 2) {
    1
  } else if (timeframe == 3) {
    1
  }

  weather_data = c()

  for (i in 1:length(years)) {
    year <- years[i]
    for (i in 1:length(m)) {
      month <- m[i]

      URL <- paste(
        'http://climat.weather.gc.ca/climate_data/bulk_data_e.html?format=csv&stationID=',
        StationID,
        '&Year=',
        year,
        '&Month=',
        month,
        '&Day=14&timeframe=',
        timeframe,
        '&submit= Download+Data',
        sep = ''
      )

      data <- read.table(
        URL,
        header = TRUE,
        sep = ",",
        skip = h,
        fill = TRUE,
        stringsAsFactors = FALSE
      )

      if (is.data.frame(data)) {
        # Collate Data
        weather_data <- rbind(weather_data, data)
      }
    }
  }
  return(weather_data)
}
