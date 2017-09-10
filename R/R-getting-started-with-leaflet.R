# Install devtools if needed
if(!require(devtools)) install.packages("devtools")
library(leaflet)

# Plot a default web map (brackets display the result)
(m <- leaflet() %>% addTiles()) 

img <- readPNG("~/repos/Creating-maps-in-R/figure//shiny_world.png")
grid.raster(img)