# BEM July 2023

# Purpose of

LAU_DEM_fl <- '../data/LAU_DEM.tif'
LAU_demography_fl <- '../data/LAU_processed.csv'

LAU_DEM <- terra::rast(LAU_DEM_fl)
LAU <- read.csv(LAU_demography_fl)
LAU_only5 <- LAU[which(LAU$CensusID == 5), ]

# Table of sp + full sp x sample size + n alive + n dead

# Stacked bar of dfstatus x sp

# Hist of elev x sp

# ggplot of DEM, points (alive), points (dead)

# Base plot of DEM, points (alive), points(dead)
plot(LAU_DEM)
with(subset(LAU_only5, DFstatus == 'alive'), points(x, y, col = 'black', cex = 0.95, pch = 20))
with(subset(LAU_only5, DFstatus == 'dead'), points(x, y, col = 'grey60', cex = 0.95, pch = 20))
