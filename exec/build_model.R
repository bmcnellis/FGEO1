# BEM July 2023
library(brms)
library(ggplot2)
library(lme4)

data_dir <- '../data'

LAU <- read.csv(file.path(data_dir, 'LAU_df_for_model.csv'))

LAU$b_m <- ifelse(LAU$DFstatus == 'dead', 0, 1)
LAU$ppt <- scale(LAU$ppt)
LAU$TWI <- scale(LAU$TWI)
LAU$wind <- scale(LAU$wind)
LAU$rad <- scale(LAU$rad)
# VDCN had some NA, set them to mean
LAU$VDCN <- ifelse(is.na(LAU$VDCN), mean(LAU$VDCN, na.rm = T), LAU$VDCN)
LAU$VDCN <- scale(LAU$VDCN)

f1 <- b_m ~ (rad + VDCN | sp)
# only TWI had no significant effects
m1 <- brms::brm(f1, LAU, family = brmsfamily('binomial', link = 'logit'), cores = 4, iter = 3000)
#m1 <- glm(f1, family = binomial, data = LAU)


#model_results <- fixef(m1)[, c('Estimate', 'Q2.5', 'Q97.5')]
#model_results <- round(model_results, 3)
