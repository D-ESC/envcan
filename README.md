# envcan

devtools::install_github("D-ESC/envcan")

Download data in bulk from Environment Canada Climate Website. Based on URL based procedure to automatically download data in bulk from Climate Website. List of available data is located here.  (ftp://ftp.tor.ec.gc.ca/Pub/Get_More_Data_Plus_de_donnees/)

```{R}
ECStations <- read.table(
    "ftp://client_climate@ftp.tor.ec.gc.ca/Pub/Get_More_Data_Plus_de_donnees/Station%20Inventory%20EN.csv", 
    sep = ",", 
    skip = 3,
    header = TRUE 
)
```

You can reference the EC station list after grabbing from the Environment Canada ftp site using the row index of the station your interested in. In this case 5825 for the Muskoka airport.

```{R}
MUSKOKA <- envcan(StationID = ECStations$Station.ID[5825], 
    firstYear = ECStations$DLY.First.Year[5825], 
    lastYear = ECStations$DLY.Last.Year[5825], timeframe = 2)
```

I find it easier to deal with the station list if I simplify the table and rename the columns.

```{R}
library(dplyr)
stations <- ECStations %>% select(Name, Province, Station.ID, 
    lat = Latitude..Decimal.Degrees., lon = Longitude..Decimal.Degrees., 
    firstYear = First.Year, lastYear = Last.Year)
```

Doesn't hurt to be able to view the station locations either.

```{R}
library(ggmap)
stations %>% ggmap(data = ., get_map(c(mean(.$lon), mean(.$lat)), zoom = 3)) + 
    geom_point(data = stations, aes(lon, lat), alpha = 0.1)
```

Filter stations down to locations within a defined bounding box.

```{R}
f_stations <- stations %>% filter(between(lat, 44.75, 45.75) & 
    between(lon, -80.0, -78.0))
ggmap(data = f_stations, 
    get_map(c(mean(f_stations$lon), mean(f_stations$lat)), zoom = 8)) + 
    geom_point(data = f_stations, aes(lon, lat))
```

Loop through and download the data for the stations within the bounding box. Data sets become very large so if you want to grab daily or hourly values you'll have to become familiar with other ways of storing your data. Checkout RSQLite for one solution. 

```{R}
result <- vector("list", length = nrow(f_stations))
for (i in 1:nrow(f_stations)) {result[[i]] <- envcan(StationID = f_stations$Station.ID[i], 
    firstYear = f_stations$firstYear[i], 
    lastYear = f_stations$lastYear[i], timeframe = 3)} 
names(result) <- f_stations$Name
```
