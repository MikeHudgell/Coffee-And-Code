library(raster)
# download shapefile from https://www.ngdc.noaa.gov/mgg/shorelines/data/gshhg/latest/
#Load shapefile
shp <- shapefile('/media/mike/HDD/data/GSHHS_shp/c/GSHHS_c_L1.shp')
plot(shp)
