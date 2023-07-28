# BEM July 2023

temp_dir <- tempdir()

ppt_dir <- '/home/bem/Documents/HIPPNET/HDCP/PPT_22July2023'
data_dir <- '../data'
#maxT_dir <- '/home/bem/Documents/HIPPNET/HDCP/maxT_22July2023'

#temp_dir <- tempdir()
ppt_zips <- list.files(ppt_dir, pattern = '\\.zip', full.names = T)
#maxT_zips <- list.files(maxT_dir, pattern = '\\.zip', full.names = T)

ppt_list <- lapply(ppt_zips, \(ii) {
#for (i in seq_along(clim_zips)) {
  #ii <- clim_zips[i]

  i_l <- unzip(ii, list = T)[, 1]
  i_fl <- i_l[grepl('\\.csv', i_l)]
  i_uz <- unzip(ii, i_fl, exdir = temp_dir)
  stopifnot(file.exists(i_uz))

  # only works with one csv at a time
  i_csv <- read.csv(i_uz)
  i_csv <- i_csv[which(i_csv$Station.Name == 'Laupahoehoe'), ]
  i_csv <- i_csv[which(i_csv$Network == 'HIPPNET'), ]
  #i_csv <- i_csv[, c('Station.Name', colnames(i_csv)[grepl('X', colnames(i_csv))])]
  i_csv <- tidyr::pivot_longer(i_csv, cols = c(14:ncol(i_csv)))
  i_csv$name <- sapply(strsplit(i_csv$name, 'X'), \(xx) xx[2])
  i_csv$year <- sapply(strsplit(i_csv$name, '\\.'), \(xx) xx[1])
  i_csv$month <- sapply(strsplit(i_csv$name, '\\.'), \(xx) xx[2])
  i_csv <- within(i_csv, rm(name))

})

# instead of mean temperature, do high temperature events?

ppt_df <- do.call('rbind', ppt_list)
ppt_df <- ppt_df[, c('Station.Name', 'value', 'year', 'month')]
# aggregate(ppt_df$value, by = list(ppt_df$year), FUN = sum)
write.csv(ppt_df, file.path(data_dir, 'PPT_Laupahoehoe.csv'), row.names = F)
