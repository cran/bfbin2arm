## ----setup, include = FALSE---------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  fig.width  = 7,
  fig.height = 5,
  dpi        = 100,
  fig.retina = 1,
  dev        = "png",
  dev.args   = list(type = "cairo-png")
)

library(bfbin2arm)

## ----design-setup-------------------------------------------------------------
p0    <- 0.30
delta <- 0.12

a  <- 1;  b  <- 1    # analysis prior
da0 <- 60; db0 <- 40 # design prior under H0
da1 <- 36; db1 <- 84 # design prior under H1

## ----calib-bayes, eval = FALSE------------------------------------------------
# des_bayes <- design_singlearm_onestage_rope(
#   n_min = 20,
#   n_max = 300,
#   p0 = p0,
#   delta = delta,
#   gamma_eq = 0.925,
#   a = a, b = b,
#   da0 = da0, db0 = db0,
#   da1 = da1, db1 = db1,
#   calibration = "Bayesian",
#   target_power = 0.80,
#   target_type1 = 0.10,
#   sustain_n = 10
# )

## ----eval = FALSE-------------------------------------------------------------
# des_bayes

## ----eval = FALSE-------------------------------------------------------------
# plot(des_bayes)

## ----echo = FALSE, out.width = "100%", fig.align = "center", fig.cap = "Figure 1: Bayesian calibration of a ROPE-based clinical phase II trial with binary endpoints."----
knitr::include_graphics("figures/singlearm-onestage-rope-calibration-bayes.png")

## ----calib-freq, eval = FALSE-------------------------------------------------
# des_freq <- design_singlearm_onestage_rope(
#   n_min = 20,
#   n_max = 300,
#   p0 = p0,
#   delta = delta,
#   gamma_eq = 0.925,
#   a = a, b = b,
#   da0 = da0, db0 = db0,
#   da1 = da1, db1 = db1,
#   calibration = "frequentist",
#   dp = 0.30,
#   target_freq_power = 0.80,
#   target_freq_type1 = 0.10,
#   sustain_n = 10
# )
# 
# des_freq

## ----eval = FALSE-------------------------------------------------------------
# plot(des_freq)

## ----echo = FALSE, out.width = "100%", fig.align = "center", fig.cap = "Figure 2: Frequentist calibration of a ROPE-based clinical phase II trial with binary endpoints. In contrast to Bayesian calibration, frequentist type-I-error rates are computed as worst-case scenarios at the ROPE-boundaries. Frequentist power is calculated under a specified point value for the success probability."----
knitr::include_graphics("figures/singlearm-onestage-rope-calibration-frequentist.png")

## ----calib-hybrid, eval = FALSE-----------------------------------------------
# des_hybrid <- design_singlearm_onestage_rope(
#   n_min = 20,
#   n_max = 300,
#   p0 = p0,
#   delta = delta,
#   gamma_eq = 0.925,
#   a = a, b = b,
#   da0 = da0, db0 = db0,
#   da1 = da1, db1 = db1,
#   calibration = "hybrid",
#   dp = 0.30,
#   target_power = 0.80,
#   target_freq_type1 = 0.10,
#   sustain_n = 10
# )
# 
# des_hybrid

## ----eval = FALSE-------------------------------------------------------------
# plot(des_hybrid)

## ----echo = FALSE, out.width = "100%", fig.align = "center", fig.cap = "Figure 3: Hybrid calibration of a ROPE-based clinical phase II trial with binary endpoints. In hybrid calibration mode, Bayesian power is calibrated together with frequentist type-I-error, which often is required from a regulatory agencies perspective."----
knitr::include_graphics("figures/singlearm-onestage-rope-calibration-hybrid.png")

## ----calib-full, eval = FALSE-------------------------------------------------
# des_full <- design_singlearm_onestage_rope(
#   n_min = 20,
#   n_max = 300,
#   p0 = p0,
#   delta = delta,
#   gamma_eq = 0.925,
#   a = a, b = b,
#   da0 = da0, db0 = db0,
#   da1 = da1, db1 = db1,
#   calibration = "full",
#   dp = 0.30,
#   target_power = 0.80,
#   target_type1 = 0.10,
#   target_freq_power = 0.80,
#   target_freq_type1 = 0.10,
#   sustain_n = 10
# )
# 
# print(des_full)

## ----eval = FALSE-------------------------------------------------------------
# plot(des_full)

## ----echo = FALSE, out.width = "100%", fig.align = "center", fig.cap = "Figure 4: Full calibration of a ROPE-based clinical phase II trial with binary endpoints. In full calibration mode, Bayesian and frequentist power and type-I-error must be calibrated simultaneously, which is the strongest form of calibration."----
knitr::include_graphics("figures/singlearm-onestage-rope-calibration-full.png")

## ----gamma-sensitivity, eval = FALSE------------------------------------------
# gamma_grid <- c(0.80, 0.85, 0.90, 0.925, 0.95)
# 
# res_gamma <- lapply(gamma_grid, function(gam) {
#   design_singlearm_onestage_rope(
#     n_min = 20, n_max = 300,
#     p0 = p0, delta = delta, gamma_eq = gam,
#     a = a, b = b,
#     da0 = da0, db0 = db0,
#     da1 = da1, db1 = db1,
#     calibration = "frequentist",
#     dp = 0.30,
#     target_freq_power = 0.80,
#     target_freq_type1 = 0.10,
#     sustain_n = 10
#   )
# })

