# BEM July 2023

temp_dir <- tempdir()

ppt_dir <- '/home/bem/Documents/HIPPNET/HDCP/PPT_22July2023'
data_dir <- '../data'

daymet <- read.csv(file.path(data_dir, '9733_lat_19.93_lon_-155.28_2023-07-23_155903.csv'), skip = 7)
# climate normal period is January 1981 to December 2010.
# dry season is day 100-200  or 120-215/220
daymet_dry <- daymet |>
  dplyr::filter(yday %in% c(100:200)) |>
  dplyr::group_by(year) |>
  dplyr::summarize(prcp = sum(prcp..mm.day.), vpd = mean(vp..Pa.)) |>
  dplyr::ungroup() |>
  dplyr::mutate(prcp_scale = scale(prcp), vpd_scale = scale(vpd))






ppt_df <- do.call('rbind', ppt_list)
ppt_df <- ppt_df[, c('Station.Name', 'value', 'year', 'month')]
# aggregate(ppt_df$value, by = list(ppt_df$year), FUN = sum)
write.csv(ppt_df, file.path(data_dir, 'PPT_Laupahoehoe.csv'), row.names = F)
