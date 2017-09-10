# Mike Hudgell 2017 Version 2.0
#
# Coffee and Code - Code Sample
#
# aggregate rows by day of week
# 
# -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=--=-=-=-=-=-=-
#
# Libraries
#

#
# Data Load/Prep
#
path <- "/media/mike/HDD/data/JA/"
ais_file <- paste0(path, 'ais2016Q2Q3-JA_54.74_55.1_24.97_25.2-joinedIhs201608.csv')
#ais_file <- paste0(path, 'ais2016Q2Q3-JA-test.csv')
df <- read.csv(ais_file, header = FALSE, sep=',')
df$V16 <- as.POSIXct(df$V16, format="%Y-%m-%d %H:%M:%S")
df$date <- as.Date(df$V16)
df$day_of_week = weekdays(df$date)

counts = aggregate(V16 ~ day_of_week, data = df, FUN=length)
