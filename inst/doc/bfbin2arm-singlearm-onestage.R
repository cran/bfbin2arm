## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  fig.width = 8,
  fig.height = 5
)
library(bfbin2arm)

## ----echo = FALSE, out.width = "90%", fig.align = "center", fig.cap = "Figure 1: Illustration of the calibration algorithm for an optimal Bayesian single-arm phase II design with a binary endpoint"----
knitr::include_graphics("figures/optimal_single_arm_two_stage_bayes_flowchart_rootfinding.png")

## -----------------------------------------------------------------------------
des_bayes <- design_singlearm_onestage_bf(
  n_min = 10,
  n_max = 200,
  k = 1/3,
  p0 = 0.2,
  a0 = 1, b0 = 1,
  a1 = 1, b1 = 1,
  da0 = 1, db0 = 1,
  da1 = 2.5, db1 = 2,
  type = "direction",
  calibration = "Bayesian",
  target_power = 0.8,
  target_type1 = 0.05
)

## -----------------------------------------------------------------------------
summary(des_bayes)

## ----out.width="90%", fig.align="center"--------------------------------------
plot(des_bayes, what = "all")

## -----------------------------------------------------------------------------
des_bayes_ce <- design_singlearm_onestage_bf(
  n_min = 10,
  n_max = 200,
  k = 1/3,
  p0 = 0.2,
  a0 = 1, b0 = 1,
  a1 = 1, b1 = 1,
  da0 = 1, db0 = 1,
  da1 = 2.5, db1 = 2,
  type = "direction",
  calibration = "Bayesian",
  target_power = 0.8,
  target_type1 = 0.05,
  target_ce_h0 = 0.6,
  k_ce = 3,
  dp = 0.4
)

## -----------------------------------------------------------------------------
summary(des_bayes_ce)

## ----out.width="90%", fig.align="center"--------------------------------------
plot(des_bayes_ce, what = "all")

## -----------------------------------------------------------------------------
des_bayes_ce50 <- design_singlearm_onestage_bf(
  n_min = 10,
  n_max = 200,
  k = 1/3,
  p0 = 0.2,
  a0 = 1, b0 = 1,
  a1 = 1, b1 = 1,
  da0 = 1, db0 = 1,
  da1 = 2.5, db1 = 2,
  type = "direction",
  calibration = "Bayesian",
  target_power = 0.8,
  target_type1 = 0.05,
  target_ce_h0 = 0.5,
  k_ce = 3,
  dp = 0.4
)

## -----------------------------------------------------------------------------
summary(des_bayes_ce50)

## ----out.width="90%", fig.align="center"--------------------------------------
plot(des_bayes_ce50, what = "all")

## -----------------------------------------------------------------------------
des_full <- design_singlearm_onestage_bf(
  n_min = 10,
  n_max = 100,
  k = 1/3,
  p0 = 0.2,
  a0 = 1, b0 = 1,
  a1 = 1, b1 = 1,
  dp = 0.4,
  da0 = 1, db0 = 1,
  da1 = 2.5, db1 = 2,
  type = "direction",
  calibration = "full",
  target_power = 0.8,
  target_type1 = 0.05,
  target_freq_power = 0.8,
  target_freq_type1 = 0.05
)

summary(des_full)

## -----------------------------------------------------------------------------
head(des_full$search_results)

## -----------------------------------------------------------------------------
range(des_full$search_results$freq_type1)

## -----------------------------------------------------------------------------
des_full_strong_ev <- design_singlearm_onestage_bf(
  n_min = 10,
  n_max = 100,
  k = 1/10,
  p0 = 0.2,
  a0 = 1, b0 = 1,
  a1 = 1, b1 = 1,
  dp = 0.4,
  da0 = 1, db0 = 1,
  da1 = 2.5, db1 = 2,
  type = "direction",
  calibration = "full",
  target_power = 0.8,
  target_type1 = 0.05,
  target_freq_power = 0.8,
  target_freq_type1 = 0.05
)

## -----------------------------------------------------------------------------
summary(des_full_strong_ev)

## ----out.width="90%", fig.align="center"--------------------------------------
plot(des_full_strong_ev)

## -----------------------------------------------------------------------------
des_freq_strong_ev <- design_singlearm_onestage_bf(
  n_min = 10,
  n_max = 100,
  k = 1/10,
  p0 = 0.2,
  a0 = 1, b0 = 1,
  a1 = 1, b1 = 1,
  dp = 0.4,
  da0 = 1, db0 = 1,
  da1 = 2.5, db1 = 2,
  type = "direction",
  calibration = "frequentist",
  target_power = 0.8,
  target_type1 = 0.05,
  target_freq_power = 0.8,
  target_freq_type1 = 0.05
)

summary(des_freq_strong_ev)

## -----------------------------------------------------------------------------
des_hybrid_strong_ev <- design_singlearm_onestage_bf(
  n_min = 10,
  n_max = 100,
  k = 1/10,
  p0 = 0.2,
  a0 = 1, b0 = 1,
  a1 = 1, b1 = 1,
  dp = 0.4,
  da0 = 1, db0 = 1,
  da1 = 2.5, db1 = 2,
  type = "direction",
  calibration = "hybrid",
  target_power = 0.8,
  target_type1 = 0.05,
  target_freq_power = 0.8,
  target_freq_type1 = 0.05
)

summary(des_hybrid_strong_ev)

## ----out.width="90%", fig.align="center"--------------------------------------
plot(des_hybrid_strong_ev)

## -----------------------------------------------------------------------------
des_hybrid_strong_ev_with_ce <- design_singlearm_onestage_bf(
  n_min = 10,
  n_max = 100,
  k = 1/10,
  k_ce = 3,
  p0 = 0.2,
  a0 = 1, b0 = 1,
  a1 = 1, b1 = 1,
  dp = 0.4,
  da0 = 1, db0 = 1,
  da1 = 2.5, db1 = 2,
  type = "direction",
  calibration = "hybrid",
  target_power = 0.8,
  target_type1 = 0.05,
  target_ce_h0 = 0.6,
  target_freq_power = 0.8,
  target_freq_type1 = 0.05
)

summary(des_hybrid_strong_ev_with_ce)

## ----out.width="90%", fig.align="center"--------------------------------------
plot(des_hybrid_strong_ev_with_ce)

## -----------------------------------------------------------------------------
des_hybrid_strong_ev_with_ce50 <- design_singlearm_onestage_bf(
  n_min = 10,
  n_max = 100,
  k = 1/10,
  k_ce = 3,
  p0 = 0.2,
  a0 = 1, b0 = 1,
  a1 = 1, b1 = 1,
  dp = 0.4,
  da0 = 1, db0 = 1,
  da1 = 2.5, db1 = 2,
  type = "direction",
  calibration = "hybrid",
  target_power = 0.8,
  target_type1 = 0.05,
  target_ce_h0 = 0.5,
  target_freq_power = 0.8,
  target_freq_type1 = 0.05
)

summary(des_hybrid_strong_ev_with_ce50)

## ----out.width="90%", fig.align="center"--------------------------------------
plot(des_hybrid_strong_ev_with_ce50)

