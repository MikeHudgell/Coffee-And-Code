# Mike Hudgell 2017 Version 2.0
#
# Coffee and Code - Code Sample
#
# Write and Read ESRI shape files
# 
# -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=--=-=-=-=-=-=-
#
# Libraries
#
library(sp)
library(rgdal)
library(raster)
#
# Data Load/Prep
#
path <- "/media/mike/HDD/data/"
ais_file <- paste0(path, 'RNLI_AIS.txt')
headings <- c("MMSI", "long", "lat", "date_time", "sog", "cog", "heading", "vessel_class")
df <- read.csv(ais_file, header = FALSE, sep='\t')
colnames(df) = headings
df$date_time <- as.POSIXct(df$date_time, format="%Y-%m-%d %H:%M:%S")
print(nrow(df))
df <- df[ which(df$lat <= 90),]
print(nrow(df))
#
# Write shape file point geometry
#
coords  <-  cbind(df$lat, df$long, )
spdf_AISPoint  <-  SpatialPointsDataFrame(coords, df)
spdf_AISPoint@proj4string <- CRS("+proj=longlat +datum=WGS84")
plot(spdf_AISPoint, main = "Test AIS", xlab = "Long", ylab = "Lat", cex=.1)
point_shape_file <- paste0(path, 'shapefiles/', 'point_shape_file.shp')
writeOGR(spdf_AISPoint, point_shape_file, "Point Shape File", driver="ESRI Shapefile")
#
# read shape file point geometry
#
test_point_shp <- shapefile(point_shape_file)
plot(test_point_shp, main="Test AIS", xlab="Long", ylab="Lat", cex=.1)
#
# get ais pings for one vessel for the next sample
#
boat_id <- '232001870'
one_boat <- df[ which(df$MMSI == boat_id),]
# sort the ais point by time to create track
one_track <- one_boat[order(one_boat$date_time),]
#
# Write shape file polyline geometry
#     
lats <- one_boat$lat
longs <- one_boat$long  
track <- cbind(longs, lats)
S1 <- Line(track)
S2 <- Lines(S1, as.integer(boat_id))
SL <- SpatialLines((list(S2)))
newrow <- as.data.frame((cbind(toString(one_boat[1,1]), toString(min(one_boat$date_time)), toString(max(one_boat$date_time)))))
row.names(newrow) = as.integer(boat_id)
spdf_Track = SpatialLinesDataFrame(SL, newrow)
line_shape_file <- paste0(path, 'shapefiles/', 'line_shape_file.shp')
spdf_Track@proj4string <- CRS("+proj=longlat +datum=WGS84")
writeOGR(spdf_Track, line_shape_file, "Line Shape File", driver="ESRI Shapefile")
plot(spdf_Track, main = "Test AIS", xlab = "Long", ylab = "Lat", cex=.1)
#
#
#
min(one_boat$date_time)
max(one_boat$date_time)
one_boat$date <- as.Date(one_boat$date_time)
days <- unique(one_boat$date)
print(days)
first <- TRUE
for(n in 1:length(days)){
  temp <- one_boat[ which(one_boat$date == days[n]),]
  lats <- temp$lat
  longs <- temp$long
  points <- cbind(longs, lats)
  ch <- chull(points)
  poly <- points[c(ch,ch[1]),]
  # plot(points, pch=19)
  # lines(poly, col="red")
  # print(paste(days[n],nrow(temp)))
  P1 <- list(Polygon(poly))
  SP <- Polygons(P1, ID=days[n])
  SPoly <- SpatialPolygons(list(SP))
  # plot(SPoly)
  newrow <- as.data.frame(cbind(toString(days[n]), toString(min(one_boat$date_time)), toString(max(one_boat$date_time))))
  row.names(newrow) <- days[n]
  spdf_poly <- SpatialPolygonsDataFrame(SPoly, newrow)
  if (first == TRUE){
    spdf_Results <- spdf_poly
    first <- FALSE
  } else {
    spdf_Results = rbind(spdf_Results, spdf_poly)
  }
}
poly_shape_file <- paste0(path, 'shapefiles/', 'poly_shape_file.shp')
spdf_Results@proj4string=CRS("+proj=longlat +datum=WGS84")
writeOGR(spdf_Results, poly_shape_file, "Tracks", driver="ESRI Shapefile" )

