# BEM July 2023
library(terra)
library(brms)

data_dir <- '../data'

# get demography data
LAU <- read.csv(file.path(data_dir, 'LAU_processed.csv'))
# need to only use mainstems
LAU <- LAU[which(LAU$mstem == 0), ]

# get DEM covariates
LAU_TRI <- terra::rast(file.path(data_dir, 'LAU_TRI.tif'))
LAU_TWI <- terra::rast(file.path(data_dir, 'LAU_TWI.tif'))
LAU_rad <- terra::rast(file.path(data_dir, 'LAU_rad.tif'))
LAU_wind <- terra::rast(file.path(data_dir, 'LAU_wind.tif'))

LAU$TRI <- terra::extract(LAU_TRI, LAU[, c('x', 'y')])[, 2]
LAU$TWI <- terra::extract(LAU_TWI, LAU[, c('x', 'y')])[, 2]
LAU$rad <- terra::extract(LAU_rad, LAU[, c('x', 'y')])[, 2]
LAU$wind <- terra::extract(LAU_wind, LAU[, c('x', 'y')])[, 2]

# get climate data
ppt_df <- read.csv(file.path(data_dir, 'PPT_Laupahoehoe.csv'), row.names = NULL)
