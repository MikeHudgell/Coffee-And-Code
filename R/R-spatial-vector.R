# Mike Hudgell 2017 
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
df <- read.csv(ais_file, header = FALSE, sep='\t')
df$V4 = as.POSIXct(df$V4, format="%Y-%m-%d %H:%M:%S")
#
# Write shape file point geometry
#
coords  <-  cbind(df$V3, df$V2)
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
one_boat <- df[ which(df$V1 == boat_id),]
# sort the ais point by time to create track
one_track <- one_boat[order(one_boat$V4),]
#
# Write shape file polyline geometry
#     
lats <- one_boat$V3
longs <- one_boat$V2
track <- cbind(longs, lats)
S1 <- Line(track)
S2 <- Lines(S1, as.integer(boat_id))
SL <- SpatialLines((list(S2)))
newrow <- as.data.frame((cbind(toString(one_boat[1,1]), toString(min(one_boat$V4)), toString(max(one_boat$V4)))))
row.names(newrow) = as.integer(boat_id)
spdf_Track = SpatialLinesDataFrame(SL, newrow)
line_shape_file <- paste0(path, 'shapefiles/', 'line_shape_file.shp')
writeOGR(spdf_Track, line_shape_file, "Line Shape File", driver="ESRI Shapefile")
plot(spdf_Track, main = "Test AIS", xlab = "Long", ylab = "Lat", cex=.1)
#
#
#
min(lats)
max(lats)
min(longs)
max(longs)
summary(lats)
#
plot(lats)
print(one_boat[ which(one_boat$V3 > 90),])
indx = one_boat[ which(one_boat$V3 > 90),]

#
test_line_shp <- shapefile(line_shape_file)
plot(line_shape_file, main="Test AIS", xlab="Long", ylab="Lat", cex=.1)
#
#
# Try yourself - create convex hull for boat by day
# 
# clues: 
#   need to loop through AIS data and group by day
#   need the convex hull function  chull(points)
#
