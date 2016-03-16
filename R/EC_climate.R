library(lubridate)

# WebID, timeframe (timeframe = 1: for hourly data, timeframe = 2: for daily
# data, timeframe = 3 for monthly data), start date and end date

envcan <- function(WebID, startDate , endDate, timeframe = 2) {

  start = ymd(startDate)
  end = ymd(endDate)
  years = seq(start, end, 'years')

  h <- if (timeframe == 1) {
    16
  } else if (timeframe == 2) {
    25
  } else if (timeframe == 3) {
    18
  }

  weather_data = c()

  for (i in 1:length(years)) {
    year <- year(years[i])
    month <- month(years[i])

    URL <- paste(
      'http://climat.weather.gc.ca/climateData/bulkdata_e.html?format=csv&stationID=',
      WebID,
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
  return(weather_data)
}
