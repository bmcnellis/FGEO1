# BEM JULY 2023

# Purpose: Initial import script for demography data from Becky's census 1-6 data

data_dir <- '/home/bem/Documents/ForestGEO/analysis/data/Census 1-6 CTFS formatted data'

# QA/QC
LAU <- read.csv(file.path(data_dir, '/data/Laupahoehoe_master.csv'), header = T)
# total lines 124278
# drop extra columns
LAU <- LAU[, c(1:33)]
colnames(LAU) <- c(colnames(LAU)[c(1:23)], 'SPACE', colnames(LAU)[24:(length(colnames(LAU)) - 1)])
# force coercion
LAU$treeID <- as.numeric(LAU$treeID)
LAU <- LAU[!is.na(LAU$treeID), ]
# 124246 stems, less than 1% drop
# drop weird columns
LAU <- LAU[, -c(1, 2, 11, 14, 17, 18, 24)]
# some columns are empty
LAU <- LAU[, -which(colnames(LAU) %in% c('StemTag', 'agb', 'codes'))]
# drop records which dont have a species
LAU <- LAU[!is.na(LAU$sp), ]
# drop records which dont have a status
LAU <- LAU[!is.na(LAU$status), ]

# short-term filters
# use only main stems
LAU <- LAU[which(LAU$mstem == 0), ]
# drop the METPOL which were not measured in every census
MET_full <- LAU[which(LAU$sp == 'METPOL' & !is.na(LAU$dbh)), ]
table(MET_full$CensusID)
# census 1 and 5 are the full census
rm(MET_full)
LAU <- LAU[which(LAU$CensusID %in% c(1, 5)), ]
# don't know what 'prior' means
LAU <- LAU[-which(LAU$DFstatus == 'prior'), ]
LAU[which(LAU$DFstatus %in% c('gone', 'missing')), 'DFstatus'] <- 'dead'
# all trees alive in first census
# just use species with > 100 total stems
sp_tbl <- table(LAU$sp, LAU$DFstatus)
sp_tbl <- as.data.frame(sp_tbl)
sp_tbl <- aggregate(sp_tbl$Freq, by = list(sp_tbl$Var1), FUN = sum)
sp_tbl <- sp_tbl[which(sp_tbl$x > 300), ] # cutoff of 300 total stems
# 15486 before
LAU <- LAU[which(LAU$sp %in% sp_tbl$Group.1), ]
# 14325 after, 8% reduction
# 2476 / 11849 stems, ~20% dead
write.csv(LAU, '../data/LAU_processed.csv', row.names = F)
