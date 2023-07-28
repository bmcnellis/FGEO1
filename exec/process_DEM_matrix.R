# BEM July 2023
library(terra)

topo_file <- '../data/TOPODATA.txt'
LAU_DEM_fl <- '../data/LAU_DEM_mat.tif'

tree_df <- read.csv('../../results/test_tree_df.csv')

LAU_df <- read.table(topo_file, sep = '\t', header = T)
LAU_df <- LAU_df[order(LAU_df$GX5, LAU_df$GY5), ]
LAU_df <- LAU_df[, c('GX5', 'GY5', 'ELEV')]
colnames(LAU_df) <- c('x', 'y', 'z')
# 260420, 2205378 UTM x, y for Laupahoehoe, zone 5, EPSG:32605
LAU_rast <- terra::rast(LAU_df, crs = 'epsg:32605', extent = ext(c(260420, 260620, 2205378, 2205578)))
# what is corner in epsg:4326? -155.2889, -155.2869, 19.9301, 19.93193
# write rasterLAU_rast_fl
writeRaster(LAU_rast, LAU_DEM_fl, filetype = "GTIff")

saga <- Rsagacmd::saga_gis(saga_bin = '../saga-9.0.2_x64/saga_cmd.exe', raster_backend = 'terra', cores = 2)
# Variables to calculate will be:
# Topographic wetness index
TWI_FUN <- saga$ta_hydrology$topographic_wetness_index_twi
# Requires slope and catchment area
SLOPE_FUN <- saga$ta_morphometry$slope_aspect_curvature
SCA_FUN <- saga$ta_hydrology$flow_width_and_specific_catchment_area
# catchment area requires flow accumulation
FAT_FUN <- saga$ta_hydrology$flow_accumulation_top_down

fat <- FAT_FUN(LAU_DEM_fl)$flow
fat_fl <- '../data/LAU_fat.tif'
writeRaster(fat, fat_fl, filetype = "GTiff")

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

# Terrain ruggedness index
TRI_FUN <- saga$ta_morphometry$terrain_ruggedness_index_tri
TRI <- TRI_FUN(LAU_DEM_fl)
TRI_fl <- '../data/LAU_TRI.tif'
writeRaster(TRI, TRI_fl, filetype = "GTiff")

# Wind effect index
wind_FUN <- saga$ta_morphometry$wind_exposition_index
wind <- wind_FUN(LAU_DEM_fl)
wind_fl <- '../data/LAU_wind.tif'
writeRaster(wind, wind_fl, filetype = "GTiff")

# clean-up
file.remove('../data/LAU_fat.tif')
file.remove('../data/LAU_sca.tif')
file.remove('../data/LAU_slope.tif')

# save plots for .ppt
tiff('../../results/DEM.tif', 6, 6, units = 'in', res = 300)
plot(LAU_rast, main = 'Laupahoehoe FDP - Elevation')
points(tree_df$x, tree_df$y, pch = 19, cex = 0.3)
dev.off()

tiff('../../results/TWI.tif', 6, 6, units = 'in', res = 300)
plot(TWI, main = 'Laupahoehoe FDP - Topographic Wetness Index')
points(tree_df$x, tree_df$y, pch = 19, cex = 0.3)
dev.off()

tiff('../../results/SRP.tif', 6, 6, units = 'in', res = 300)
plot(rad, main = 'Laupahoehoe FDP - Potential Solar Radiation')
points(tree_df$x, tree_df$y, pch = 19, cex = 0.3)
dev.off()

tiff('../../results/TRI.tif', 6, 6, units = 'in', res = 300)
plot(TRI, main = 'Laupahoehoe FDP - Terrain Ruggedness Index')
points(tree_df$x, tree_df$y, pch = 19, cex = 0.3)
dev.off()

tiff('../../results/WEI.tif', 6, 6, units = 'in', res = 300)
plot(wind, main = 'Laupahoehoe FDP - Wind Exposure Index')
points(tree_df$x, tree_df$y, pch = 19, cex = 0.3)
dev.off()

# visual to check raster
ggplot(data = LAU_df, aes(x = x, y = y, fill = z)) +
  geom_tile() +
  scale_fill_gradientn(colours = terrain.colors(20)) +
  theme_bw() +
  theme(
    axis.text.x = element_text(color = 'black'),
    axis.text.y = element_text(color = 'black')
  ) +
  labs(x = 'X coordinate (m)', y = 'Y coordinate (m)', fill = 'Elevation')
