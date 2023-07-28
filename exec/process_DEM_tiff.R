# BEM July 2023
library(terra)

LAU_topo_file <- '../data/USGS_1M_5_x26y221_HI_Hawaii_Island_Lidar_NOAA_2017_B17.tif'
PAL_topo_file <- '../data/USGS_1M_5_x18y219_HI_Hawaii_Island_Lidar_NOAA_2017_B17.tif'
LAU_DEM_fl <- '../data/LAU_DEM_tif.tif'
PAL_DEM_fl <- '../data/PAL_DEM_tif.tif'

tree_df <- read.csv('../../results/test_tree_df.csv')

LAU_DEM <- terra::rast(LAU_topo_file)
LAU_DEM <- terra::project(LAU_DEM, y = crs('epsg:32605'))
LAU_rast <- terra::rast(crs = 'epsg:32605', extent = ext(c(260420, 260620, 2205378, 2205578)))
LAU_DEM <- terra::crop(LAU_DEM, LAU_rast)
writeRaster(LAU_DEM, LAU_DEM_fl, filetype = "GTIff")

# Palamanui
#censusx0000 = 185950.  # UTM longitude (I think)
#censusy0000 = 2185420.  # UTM lattitude (I think)
PAL_DEM <- terra::rast(PAL_topo_file)
PAL_DEM <- terra::project(PAL_DEM, y = crs('epsg:32605'))
PAL_rast <- terra::rast(crs = 'epsg:32605', extent = ext(c(185950, 186150, 2185420, 2185620)))
PAL_DEM <- terra::crop(PAL_DEM, PAL_rast)
writeRaster(PAL_DEM, PAL_DEM_fl, filetype = "GTIff")

saga <- Rsagacmd::saga_gis(raster_backend = 'terra', cores = 2)
# Variables to calculate will be:
# Topographic wetness index
TWI_FUN <- saga$ta_hydrology$topographic_wetness_index_twi
# Requires slope and catchment area
SLOPE_FUN <- saga$ta_morphometry$slope_aspect_curvature
SCA_FUN <- saga$ta_hydrology$flow_width_and_specific_catchment_area
# catchment area requires flow accumulation
FAT_FUN <- saga$ta_hydrology$flow_accumulation_top_down
# VDCN requires channel network
chan_FUN <- saga$ta_channels$channel_network
# first fill sinks
#sink_FUN <- saga$ta_preprocessor$fill_sinks_wang_liu
# then flow-accumulation top down
# = FAT_FUN

fat <- FAT_FUN(LAU_DEM_fl)$flow
fat_fl <- '../data/LAU_fat.tif'
writeRaster(fat, fat_fl, filetype = "GTiff")

CN <- chan_FUN(LAU_DEM_fl, init_grid = fat)$chnlntwrk
CN_fl <- '../data/LAU_CN.tif'
writeRaster(CN, CN_fl, filetype = 'GTiff')

sca <- SCA_FUN(LAU_DEM_fl, fat_fl)$sca
sca_fl <- '../data/LAU_sca.tif'
writeRaster(sca, sca_fl, filetype = "GTiff")

slope <- SLOPE_FUN(LAU_DEM_fl)$slope
slope_fl <- '../data/LAU_slope.tif'
writeRaster(slope, slope_fl, filetype = "GTIff")

TWI <- TWI_FUN(slope_fl, sca_fl)
twi_fl <- '../data/LAU_TWI.tif'
writeRaster(TWI, twi_fl, filetype = "GTiff")

# Potential solar radiation
RAD_FUN <- saga$ta_lighting$potential_incoming_solar_radiation
rad <- RAD_FUN(LAU_DEM_fl)$grd_total
rad_fl <- '../data/LAU_rad.tif'
writeRaster(rad, rad_fl, filetype = "GTiff")

# Create 9-pixel rad mean raster

# Terrain ruggedness index
#TRI_FUN <- saga$ta_morphometry$terrain_ruggedness_index_tri
#TRI <- TRI_FUN(LAU_DEM_fl)
#TRI_fl <- '../data/LAU_TRI.tif'
#writeRaster(TRI, TRI_fl, filetype = "GTiff")
# ACH instead

# Wind effect index
wind_FUN <- saga$ta_morphometry$wind_exposition_index
wind <- wind_FUN(LAU_DEM_fl)
wind_fl <- '../data/LAU_wind.tif'
writeRaster(wind, wind_fl, filetype = "GTiff")

# Vertical Distance Channel Network
VDCN_FUN <- saga$ta_channels$vertical_distance_to_channel_network
VDCN <- VDCN_FUN(LAU_DEM_fl, CN)$distance
VDCN_fl <- '../data/VDCN.tif'
writeRaster(VDCN, VDCN_fl, filetype = 'GTiff')

# clean-up
file.remove('../data/LAU_fat.tif')
file.remove('../data/LAU_CN.tif')
file.remove('../data/LAU_sca.tif')
file.remove('../data/LAU_slope.tif')
