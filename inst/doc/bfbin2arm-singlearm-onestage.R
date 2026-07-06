## ----setup, include = FALSE---------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  fig.width  = 8,
  fig.height = 5,
  dpi        = 100,
  fig.retina = 1,
  dev        = "png",
  dev.args   = list(type = "cairo-png")
)

library(bfbin2arm)

## ----echo = FALSE, out.width = "90%", fig.align = "center", fig.cap = "Figure 1: Illustration of the calibration algorithm for an optimal Bayesian single-arm phase II design with a binary endpoint"----
knitr::include_graphics("figures/optimal_single_arm_two_stage_bayes_flowchart_rootfinding.png")

## -----------------------------------------------------------------------------
library(bfbin2arm)

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

## ----out.width="100%", fig.align="center", eval = FALSE-----------------------
# plot(des_bayes)

## ----echo = FALSE, out.width = "100%", fig.align = "center", fig.cap = "Figure 2: Visualization of the calibrated Bayesian single-arm one-stage phase II design with a binary endpoint"----
knitr::include_graphics("figures/singlearm-onestage-fig1.png")

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

## ----out.width="90%", fig.align="center", eval = FALSE------------------------
# plot(des_bayes_ce)

## ----echo = FALSE, out.width = "100%", fig.align = "center", fig.cap = "Figure 3: Visualization of the calibrated Bayesian single-arm one-stage phase II design with a binary endpoint. In contrast to the earlier Bayesian calibration for power and type-I-error rate, now an additional constraint fo the probability of compelling evidence is added."----
knitr::include_graphics("figures/singlearm-onestage-fig2.png")

## -----------------------------------------------------------------------------
des_bayes_ce90 <- design_singlearm_onestage_bf(
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
  target_ce_h0 = 0.9,
  k_ce = 3,
  dp = 0.4
)

## -----------------------------------------------------------------------------
summary(des_bayes_ce90)

## ----out.width="90%", fig.align="center", eval = FALSE------------------------
# plot(des_bayes_ce90)

## ----echo = FALSE, out.width = "100%", fig.align = "center", fig.cap = "Figure 3: Visualization of the calibrated Bayesian single-arm one-stage phase II design with a binary endpoint. In contrast to the previous Bayesian calibration, the target probability of compelling evidence for the null hypothesis is increased to 90% now."----
knitr::include_graphics("figures/singlearm-onestage-fig3.png")

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

## ----out.width="100%", fig.align="center", eval = FALSE-----------------------
# plot(des_full_strong_ev)

## ----echo = FALSE, out.width = "100%", fig.align = "center", fig.cap = "Figure 4: Visualization of the fully calibrated single-arm one-stage phase II design with a binary endpoint. In contrast to the previous Bayesian calibration, both Bayesian and frequentist operating characteristics are calibrated now."----
knitr::include_graphics("figures/singlearm-onestage-fig4.png")

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

## ----out.width="100%", fig.align="center", eval = FALSE-----------------------
# plot(des_hybrid_strong_ev)

## ----echo = FALSE, out.width = "100%", fig.align = "center", fig.cap = "Figure 5: Visualization of the hybrid calibrated single-arm one-stage phase II design with a binary endpoint. In contrast to the previous calibration, Bayesian power is calibrated with frequentist type-I-error in this calibration mode."----
knitr::include_graphics("figures/singlearm-onestage-fig5.png")

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

## ----out.width="100%", fig.align="center", eval = FALSE-----------------------
# plot(des_hybrid_strong_ev_with_ce)

## ----echo = FALSE, out.width = "100%", fig.align = "center", fig.cap = "Figure 6: Visualization of the hybrid calibrated single-arm one-stage phase II design with a binary endpoint, this time with an additional constraint on the probability of compelling evidence for the null hypothesis."----
knitr::include_graphics("figures/singlearm-onestage-fig6.png")

