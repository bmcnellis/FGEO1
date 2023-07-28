# BEM JULY 2023

# Purpose: Initial import script for demography data from Becky's census 1-6 data

data_dir <- '/home/bem/Documents/ForestGEO/analysis/data/Census 1-6 CTFS formatted data/data'

# QA/QC
PAL <- read.table(file.path(data_dir, 'Palamanui_master.txt'), header = T, row.names = NULL, quote = "", sep = '\t', fill = T)
# total lines 221550
# force coercion
PAL <- PAL[which(PAL$sp %in% FGEO1::Palamanui_sp_list), ]
# 221517
# only use census 1 and 5
PAL <- PAL[which(PAL$CensusID %in% c(1, 5)), ]
# fix DFstatus
# dont know what prior is
PAL <- PAL[-which(PAL$DFstatus == 'prior'), ]
PAL$DFstatus <- ifelse(PAL$DFstatus %in% 'alive', 'alive', 'dead')
stop('not finished')
