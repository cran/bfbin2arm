## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse   = TRUE,
  comment    = "#>",
  fig.width  = 7,
  fig.height = 5,
  warning    = FALSE,
  message    = FALSE
)
library(bfbin2arm)

## -----------------------------------------------------------------------------
res_manual <- design_singlearm_bf(
  n1_min = 8,
  n2_max = 30,
  k      = 1/3,
  k_f    = 3,
  p0     = 0.2,
  a0     = 1,
  b0     = 1,
  a1     = 1,
  b1     = 1,
  dp     = 0.4,
  da0    = 2.5,
  db0    = 2,
  da1    = 1,
  db1    = 1,
  type   = "direction",
  calibration       = "frequentist",
  algorithm         = "manual",
  interim           = 12,
  final             = 24,
  target_freq_power = 0.75,
  target_freq_type1 = 0.10
)

## -----------------------------------------------------------------------------
summary(res_manual)

## -----------------------------------------------------------------------------
res_freq <- design_singlearm_bf(
  n1_min = 5,
  n2_max = 100,
  k      = 1/10,
  k_f    = 3,
  p0     = 0.2,
  a0     = 1,
  b0     = 1,
  a1     = 1,
  b1     = 1,
  dp     = 0.5,
  da0    = 1,
  db0    = 1,
  da1    = 2.5,
  db1    = 2,
  type   = "direction",
  calibration       = "frequentist",
  target_freq_power = 0.8,
  target_freq_type1 = 0.05
)

## -----------------------------------------------------------------------------
summary(res_freq)

## -----------------------------------------------------------------------------
res_freq$design

## ----eval = FALSE-------------------------------------------------------------
# res_freq$operating_characteristics

## ----eval = FALSE-------------------------------------------------------------
# plot(res_freq)

## ----fig.align = "center", echo = FALSE, out.width = "100%", fig.cap = "Figure 1: Output of the plot function for an optimal frequentist single-arm two-stage design using Bayes factors. The top left panel shows Bayesian and frequentist power, Bayesian type-I-error for varying interim sample sizes. The top right panel provides information about the optimal frequentist design found by the algorithm and its Bayesian and frequentist operating characteristics. The lower left and right panels visualize the analysis and design priors under the null and alternative hypothesis. For the frequentist operating characteristics, these are irrelevant. They influence only the Bayesian operating characteristics. Under the null hypothesis $H_0:p=p_0$, the design and analysis priors are point masses at the specified null probability p0."----
knitr::include_graphics("figures/singlearm_twostage_freq_fig1.png")

