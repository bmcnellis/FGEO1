library(ggplot2)

setwd("C:/Users/BrandonMcNellis/Documents/ForestGEO")

source('m_sim_functions.R')

m_df_1 <- mort_sim_1(seq(0.01, 0.1, length.out = 12), seq(20), 100000)
m_df_1$N_t <- m_df_1$N_t / 1000

m_plot_1 <- ggplot(m_df_1, aes(x = t, y = N_t, color = model)) +
  geom_point() +
  geom_hline(yintercept = 0) +
  facet_wrap(~ m) +
  ylim(-5, 100) +

  scale_color_discrete(labels = c('Cumulative Loss', 'Instantaneous', 'Linear Loss')) +

  theme_bw() +
  theme(
    axis.text.x = element_text(color = 'black'),
    axis.text.y = element_text(color = 'black'),
  ) +

  labs(x = 'Year', y = 'N x 1000', color = "Model Assumption")

m_plot_1
