# BEM July 2023

tree_fl <- '../data/Laupahoehoe_master_12.11.19.csv'

tree_df <- read.csv(tree_fl)
tree_df <- tree_df[which(tree_df$sp == 'METPOL'), ]
tree_df <- tree_df[, c('x', 'y')]
tree_df <- tree_df[!duplicated(tree_df), ]

write.csv(tree_df, '../../results/test_tree_df.csv', row.names = F)
