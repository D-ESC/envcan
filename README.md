# envcan
Download data in bulk from Environmnet Canada Climate Website. Based on URL based procedure to automatically download data in bulk from Climate Website. List of available data is located here.  (ftp://ftp.tor.ec.gc.ca/Pub/Get_More_Data_Plus_de_donnees/)

```{R}
ECStations = read.table(
    "ftp://client_climate@ftp.tor.ec.gc.ca/Pub/Get_More_Data_Plus_de_donnees/Station%20Inventory%20EN.csv", 
    sep = ",", 
    skip = 3,
    header = TRUE 
)
```

You can reference the EC station list after grabing from the Environmnet Canada ftp site using the row index of the station your interested in. In this case 5825 for the Muskoka airport.

```{R}
MUSKOKA <- envcan(StationID = ECStations$Station.ID[5825], 
    firstYear = ECStations$DLY.First.Year[5825], 
    lastYear = ECStations$DLY.Last.Year[5825], timeframe = 2)
```
