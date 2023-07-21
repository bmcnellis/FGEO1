m_1 <- function(N_o, t, m) N_o * (1 - m) ^ t
m_6 <- function(N_o, t, gamma) N_o * exp(-gamma * t)
m_X <- function(N_o, t, m) N_o - (N_o * m * t)
mort_sim_1 <- function(m_levels, t_levels, N_o) {

  N_o_level <- N_o

  m_out <- data.frame(m = numeric(), t = numeric(), m_1 = numeric(), m_6 = numeric(), m_X = numeric())

  for (i in t_levels) {
    for (j in m_levels) {
      m_1_ij <- m_1(N_o_level, i, j)
      m_6_ij <- m_6(N_o_level, i, j)
      m_X_ij <- m_X(N_o_level, i, j)

      ij_row <- data.frame(m = j, t = i, m_1 = m_1_ij, m_6 = m_6_ij, m_X = m_X_ij)

      m_out <- rbind(m_out, ij_row)
    }
  }

  m_out$m <- round(m_out$m, 3)
  m_out$m <- as.factor(m_out$m)
  m_out[, c('m_1', 'm_6', 'm_X')] <- round(m_out[, c('m_1', 'm_6', 'm_X')])
  m_out <- tidyr::pivot_longer(m_out, -c(m, t), 'model', values_to = 'N_t')

  return(m_out)
}
