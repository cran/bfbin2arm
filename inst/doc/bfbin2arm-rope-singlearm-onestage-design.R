## ----setup, include = FALSE---------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  fig.width  = 6,
  fig.height = 5,
  dpi        = 100,
  fig.retina = 1,
  dev        = "png",
  dev.args   = list(type = "cairo-png")
)

library(bfbin2arm)

## ----echo = FALSE-------------------------------------------------------------
plot_rope_posterior <- function(n, y,
                                p0 = 0.30,
                                delta = 0.12,
                                a = 1, b = 1,
                                gamma_eq = 0.80,
                                gamma_diff = 0.80,
                                main = "") {
  shape1 <- a + y
  shape2 <- b + n - y
  p_min  <- max(0, p0 - delta)
  p_max  <- min(1, p0 + delta)

  p_grid <- seq(0, 1, length.out = 1000)
  dens   <- dbeta(p_grid, shape1, shape2)

  rope_prob <- pbeta(p_max, shape1, shape2) - pbeta(p_min, shape1, shape2)
  diff_prob <- 1 - rope_prob

  decision <- if (rope_prob >= gamma_eq) {
    "Equivalence accepted"
  } else if (diff_prob >= gamma_diff) {
    "Non-equivalence accepted"
  } else {
    "Indecisive"
  }

  plot(p_grid, dens, type = "n",
       xlab = expression(p), ylab = "Posterior density",
       main = main)

  usr <- par("usr")
  x_min <- usr[1]
  x_max <- usr[2]
  y_min <- usr[3]
  y_max <- usr[4]

  # Lighter matte background regions
  h0_col <- adjustcolor("#DCEAF7", alpha.f = 0.55)  # light matte blue
  h1_col <- adjustcolor("#F7DDDD", alpha.f = 0.55)  # light matte red

  # H0: outside ROPE
  rect(xleft = x_min, ybottom = y_min,
       xright = p_min, ytop = y_max,
       col = h0_col, border = NA)
  rect(xleft = p_max, ybottom = y_min,
       xright = x_max, ytop = y_max,
       col = h0_col, border = NA)

  # H1: inside ROPE
  rect(xleft = p_min, ybottom = y_min,
       xright = p_max, ytop = y_max,
       col = h1_col, border = NA)

  # Posterior density and benchmark
  lines(p_grid, dens, lwd = 2)
  abline(v = p0, lty = 2)

  # Build plotmath label explicitly
  rope_label <- expression(scriptstyle(R)[p])

  text(x = (p_min + p_max) / 2 + 0.05,
       y = y_min + 0.06 * (y_max - y_min),
       labels = rope_label,
       cex = 1.05)

  text(x = (x_min + p_min) / 2,
       y = y_min + 0.50 * (y_max - y_min),
       labels = expression(H[0]),
       col = "#5B84B1",
       cex = 1.1)

  text(x = (p_max + x_max) / 2,
       y = y_min + 0.50 * (y_max - y_min),
       labels = expression(H[0]),
       col = "#5B84B1",
       cex = 1.1)

  text(x = (p_min + p_max) / 2,
       y = y_min + 0.78 * (y_max - y_min),
       labels = expression(H[1]),
       col = "#C06C84",
       cex = 1.1)

  legend("topright",
         legend = c(
           sprintf("y = %d / n = %d", y, n),
           sprintf("Pr(ROPE | y) = %.2f", rope_prob),
           sprintf("Pr(outside ROPE | y) = %.2f", diff_prob),
           sprintf("Decision: %s", decision)
         ),
         bty = "n")
}

## ----echo = FALSE, eval = FALSE-----------------------------------------------
# par(mar = c(4, 4, 3, 1))
# plot_rope_posterior(
#   n = 100,
#   y = 30,             # close to p0 * n = 30
#   main = "Scenario 1: Equivalence accepted"
# )

## ----echo = FALSE, out.width = "80%", fig.align = "center", fig.cap = "Figure 1: Illustration of the first possible scenario in a ROPE-based clinical phase II trial with binary endpoints: Equivalence is accepted, because sufficient posterior probability mass concentrates inside the ROPE. The true data-generating process follows the alternative hypothesis, that is, equivalence indeed holds."----
knitr::include_graphics("figures/singlearm-onestage-rope-scenario1.png")

## ----echo = FALSE, eval = FALSE-----------------------------------------------
# par(mar = c(4, 4, 3, 1))
# plot_rope_posterior(
#   n = 100,
#   y = 35,             # pick y so Pr(ROPE|y) >= 0.8 but mean > p0 + delta
#   main = "Scenario 2: Equivalence accepted (type-I error case)"
# )

## ----echo = FALSE, out.width = "80%", fig.align = "center", fig.cap = "Figure 2: Illustration of the second possible scenario in a ROPE-based clinical phase II trial with binary endpoints: Equivalence is accepted, because sufficient posterior probability mass concentrates inside the ROPE. In contrast to the first possible scenario, the true data-generating process follows the null hypothesis. Thus, a ROPE-based type-I-error occurs."----
knitr::include_graphics("figures/singlearm-onestage-rope-scenario2.png")

## ----echo = FALSE, eval = FALSE-----------------------------------------------
# par(mar = c(4, 4, 3, 1))
# plot_rope_posterior(
#   n = 100,
#   y = 18,             # tuned so ROPE probability is between ~0.3 and 0.7
#   main = "Scenario 3: Indecisive (posterior straddles ROPE)"
# )

## ----echo = FALSE, out.width = "80%", fig.align = "center", fig.cap = "Figure 3: Illustration of the third possible scenario in a ROPE-based clinical phase II trial with binary endpoints: The result is indecisive, because neither does sufficient posterior probability mass concentrate inside the ROPE, nor outside the ROPE."----
knitr::include_graphics("figures/singlearm-onestage-rope-scenario3.png")

## ----echo = FALSE, eval = FALSE-----------------------------------------------
# par(mar = c(4, 4, 3, 1))
# plot_rope_posterior(
#   n = 100,
#   y = 10,             # clearly below the ROPE region
#   main = "Scenario 4: Non-equivalence accepted"
# )

## ----echo = FALSE, out.width = "80%", fig.align = "center", fig.cap = "Figure 4: Illustration of the fourth possible scenario in a ROPE-based clinical phase II trial with binary endpoints: Non-equivalence is accepted, because sufficient posterior probability mass concentrates outside the ROPE."----
knitr::include_graphics("figures/singlearm-onestage-rope-scenario4.png")

## -----------------------------------------------------------------------------
des_baseline <- design_singlearm_onestage_rope(
  n_min = 20,
  n_max = 200,
  p0 = 0.30,     # benchmark response rate p0
  delta = 0.12,  # ROPE half-width: equivalence if p in [0.18, 0.42]
  gamma_eq = 0.80,  # posterior ROPE probability threshold for equivalence

  # Analysis prior: p ~ Beta(a, b), used for posterior and ROPE decision
  a = 1,
  b = 1,

  # Design prior under H0 (non-equivalence): p ~ Beta(da0, db0)
  # Here: mean 0.60, representing clearly higher response than 0.30.
  da0 = 60,
  db0 = 40,

  # Design prior under H1 (equivalence): p ~ Beta(da1, db1)
  # Here: mean 0.30, representing plausible equivalence scenarios.
  da1 = 36,
  db1 = 84,

  # Target ROPE-based power under H1 (equivalence design prior)
  target_power = 0.80,

  # Maximum ROPE-based type-I error under H0 (non-equivalence design prior)
  target_type1 = 0.10,

  # Stability requirement: criteria must hold for 10 consecutive n values
  sustain_n = 10
)

## -----------------------------------------------------------------------------
des_baseline

## ----eval = FALSE-------------------------------------------------------------
# summary(des_baseline)

## ----echo = TRUE, eval = FALSE------------------------------------------------
# plot(des_baseline)

## ----echo = FALSE, out.width = "100%", fig.align = "center", fig.cap = "Figure 5: Illustration of calibrated single-arm one-stage design of a ROPE-based clinical phase II trial with binary endpoint."----
knitr::include_graphics("figures/singlearm-onestage-rope-fig5.png")

## ----echo = TRUE, eval = FALSE------------------------------------------------
# plot(des_baseline, what = "operating_characteristics")

## ----echo = FALSE, out.width = "80%", fig.align = "center", fig.cap = "Figure 6: Visualization of the operating characteristics of a calibrated single-arm one-stage design of a ROPE-based clinical phase II trial with binary endpoint."----
knitr::include_graphics("figures/singlearm-onestage-rope-fig6.png")

## ----echo = TRUE, eval = FALSE------------------------------------------------
# plot(des_baseline, what = "decision_region")

## ----echo = FALSE, out.width = "80%", fig.align = "center", fig.cap = "Figure 7: Visualization of the equivalence region for increasing sample size of a calibrated single-arm one-stage design of a ROPE-based clinical phase II trial with binary endpoint."----
knitr::include_graphics("figures/singlearm-onestage-rope-fig7.png")

## -----------------------------------------------------------------------------
des_onc <- design_singlearm_onestage_rope(
  n_min = 20,
  n_max = 200,
  p0 = 0.30,
  delta = 0.12,
  gamma_eq = 0.80,

  # Analysis prior p ~ Beta(a, b)
  a = 1, b = 1,

  # Design priors under H0 and H1
  da0 = 60, db0 = 40,   # H0: non-equivalence, mean ~0.60
  da1 = 36, db1 = 84,   # H1: equivalence, mean ~0.3

  target_power = 0.80,
  target_type1 = 0.10,
  sustain_n = 10
)

des_onc

## ----eval = FALSE-------------------------------------------------------------
# summary(des_onc)

## ----echo = TRUE, eval = FALSE------------------------------------------------
# plot(des_onc)

## ----echo = FALSE, out.width = "100%", fig.align = "center", fig.cap = "Figure 8: Visualization of the calibrated ROPE-based oncology single-arm one-stage phase II design with binary endpoints."----
knitr::include_graphics("figures/singlearm-onestage-rope-fig8.png")

## ----echo = TRUE, eval = FALSE------------------------------------------------
# plot(des_onc, what = "decision_region")

## ----echo = FALSE, out.width = "100%", fig.align = "center", fig.cap = "Figure 9: Visualization of the equivalence region of ROPE-based oncology single-arm one-stage phase II designs with binary endpoints for increasing sample size."----
knitr::include_graphics("figures/singlearm-onestage-rope-fig9.png")

## ----grid-exploration, message=FALSE, warning=FALSE, echo = FALSE-------------
library(dplyr)
library(tidyr)
library(purrr)
library(ggplot2)
library(knitr)

# Fixed setup: oncology-inspired equivalence example
n_min <- 10
n_max <- 250
p0    <- 0.30

# Analysis prior
a <- 1
b <- 1

# Design priors under H0 (non-equivalence) and H1 (equivalence)
da0 <- 60
db0 <- 40   # mean = 0.60

da1 <- 36
db1 <- 84   # mean = 0.30

# Calibration targets
target_power  <- 0.80
target_type1  <- 0.10
sustain_n     <- 10

# Grid for ROPE half-width and posterior threshold
delta_grid    <- c(0.10, 0.12, 0.15)   # 0.08 removed
gamma_eq_grid <- c(0.75, 0.80, 0.90)

grid <- expand.grid(
  delta    = delta_grid,
  gamma_eq = gamma_eq_grid,
  KEEP.OUT.ATTRS = FALSE,
  stringsAsFactors = FALSE
)

# Helper to extract a concise summary from the design object
extract_design_summary <- function(fit, delta, gamma_eq) {
  tibble(
    delta    = delta,
    gamma_eq = gamma_eq,
    n_star   = if (!is.null(fit$n_star)) fit$n_star else NA_real_,
    power_H1 = if (!is.null(fit$selected$power)) fit$selected$power else NA_real_,
    type1_H0 = if (!is.null(fit$selected$type1)) fit$selected$type1 else NA_real_
  )
}

# Wrapper to run the design calibration for one grid point
run_design_grid <- function(delta, gamma_eq) {
  fit <- design_singlearm_onestage_rope(
    n_min      = n_min,
    n_max      = n_max,
    p0         = p0,
    delta      = delta,
    gamma_eq   = gamma_eq,
    gamma_diff = gamma_eq,              # same threshold for non-equivalence
    direction  = "equivalence",
    a          = a,
    b          = b,
    da0        = da0,
    db0        = db0,
    da1        = da1,
    db1        = db1,
    calibration        = "Bayesian",
    dp                 = NULL,
    target_power       = target_power,
    target_type1       = target_type1,
    target_pce_h0      = NULL,
    target_freq_power  = NULL,
    target_freq_type1  = NULL,
    sustain_n          = sustain_n,
    return_grid        = TRUE
  )

  extract_design_summary(fit, delta, gamma_eq)
}

# Run the grid with the *updated* delta_grid and gamma_eq_grid
results_grid <- pmap_dfr(
  list(grid$delta, grid$gamma_eq),
  run_design_grid
) %>%
  arrange(delta, gamma_eq)

# Keep only rows where a feasible design was found
results_grid_feasible <- results_grid %>%
  filter(!is.na(n_star), !is.na(power_H1), !is.na(type1_H0))

# Inspect which combinations dropped out (for checking)
results_grid %>%
  mutate(feasible = !is.na(n_star)) %>%
  print()

# Table for the vignette / paper
kable(
  results_grid,
  digits = 3,
  caption = "Grid exploration for the oncology equivalence example: calibrated sample size n*, ROPE-based Bayesian power under H1, and ROPE-based Bayesian type-I error under H0 for different ROPE half-widths and posterior probability thresholds."
)

## ----echo = FALSE, eval = FALSE-----------------------------------------------
# # Plot n* versus gamma_eq, stratified by delta (feasible designs only)
# ggplot(
#   results_grid_feasible,
#   aes(x = gamma_eq, y = n_star, color = factor(delta), group = factor(delta))
# ) +
#   geom_line(linewidth = 0.8) +
#   geom_point(size = 2) +
#   labs(
#     x = expression(gamma[eq]),
#     y = expression(n^"*"),
#     color = expression(delta),
#     title = "Calibrated sample size n* across ROPE widths and posterior thresholds"
#   ) +
#   theme_minimal(base_size = 12)

## ----echo = FALSE, out.width = "80%", fig.align = "center", fig.cap = "Figure 10: Calibrated sample size n* across ROPE widths and posterior thresholds for the oncology equivalence phase II trial."----
knitr::include_graphics("figures/singlearm-onestage-rope-fig10.png")

## ----echo = FALSE, eval = FALSE-----------------------------------------------
# # Plot type-I error versus gamma_eq, stratified by delta (feasible designs only)
# ggplot(
#   results_grid_feasible,
#   aes(x = gamma_eq, y = type1_H0, color = factor(delta), group = factor(delta))
# ) +
#   geom_line(linewidth = 0.8) +
#   geom_point(size = 2) +
#   geom_hline(
#     yintercept = target_type1,
#     linetype = "dashed",
#     color = "grey40"
#   ) +
#   labs(
#     x = expression(gamma[eq]),
#     y = expression(alpha[H[0]](n^"*")),
#     color = expression(delta),
#     title = "ROPE-based Bayesian type-I error at the calibrated sample size"
#   ) +
#   theme_minimal(base_size = 12)

## ----echo = FALSE, out.width = "80%", fig.align = "center", fig.cap = "Figure 10: ROPE-based Bayesian type-I-error at the calibrated sample sizes for the oncology equivalence phase II trial for different ROPE widths."----
knitr::include_graphics("figures/singlearm-onestage-rope-fig11.png")

## ----example-pce-freq, message=FALSE, warning=FALSE---------------------------
library(dplyr)
library(tidyr)
library(purrr)
library(ggplot2)
library(knitr)

# Oncology-inspired equivalence example: revisited
n_min <- 10
n_max <- 300
p0    <- 0.30

# ROPE and evidence thresholds
delta      <- 0.12
gamma_eq   <- 0.925
gamma_diff <- 0.90

# Analysis prior
a <- 1
b <- 1

# Design priors as in the first example
da0 <- 60
db0 <- 40   # non-equivalence prior (H0)

da1 <- 36
db1 <- 84   # equivalence prior (H1)

# Calibration targets
target_power      <- 0.80   # Bayesian predictive power under H1
target_type1      <- 0.10   # Bayesian predictive type-I error under H0
target_pce_h0     <- 0.80   # predictive compelling evidence for H0
target_freq_power <- 0.80   # frequentist power at dp (here dp = p0)
target_freq_type1 <- 0.10   # frequentist type-I error at ROPE boundaries

# Point alternative for frequentist power
dp <- p0

# Design calibration in "full" mode
fit_pce_freq <- design_singlearm_onestage_rope(
  n_min      = n_min,
  n_max      = n_max,
  p0         = p0,
  delta      = delta,
  gamma_eq   = gamma_eq,
  gamma_diff = gamma_diff,
  direction  = "equivalence",
  a          = a,
  b          = b,
  da0        = da0,
  db0        = db0,
  da1        = da1,
  db1        = db1,
  calibration        = "full",
  dp                 = dp,
  target_power       = target_power,
  target_type1       = target_type1,
  target_pce_h0      = target_pce_h0,
  target_freq_power  = target_freq_power,
  target_freq_type1  = target_freq_type1,
  sustain_n          = 10,
  return_grid        = TRUE
)

fit_pce_freq

## ----echo = FALSE, eval = FALSE-----------------------------------------------
# plot(fit_pce_freq)

## ----echo = FALSE, out.width = "100%", fig.align = "center", fig.cap = "Figure 12: Calibrated one-stage ROPE-based oncology equivalence phase II design with additional constraints on the probability of compelling evidence for the null hypothesis. In contrast to the earlier example, the probability of compelling evidence must reach 80% now, and frequentist power and type-I-error rate must also fulfill their respective target constraints of 80% and 10%."----
knitr::include_graphics("figures/singlearm-onestage-rope-fig12.png")

## ----example-pce-freq-summary, message=FALSE, warning=FALSE-------------------
library(dplyr)
library(tidyr)
library(purrr)
library(ggplot2)
# Extract selected row and key operating characteristics
sel <- fit_pce_freq$selected

summary_tab <- tibble(
  quantity = c(
    "Selected sample size n*",
    "Bayesian power under H1 at n*",
    "Bayesian type-I error under H0 at n*",
    "PCE(H0) at n*",
    "Frequentist power at p = p0",
    "Frequentist type-I error (worst boundary)"
  ),
  value = c(
    fit_pce_freq$n_star,
    sel$power,
    sel$type1,
    sel$pce_h0,
    sel$freq_power,
    sel$freq_type1
  )
)

kable(
  summary_tab,
  digits = 3,
  col.names = c("Quantity", "Value"),
  caption = "Operating characteristics of the calibrated equivalence design with constraints on Bayesian power, Bayesian type-I error, PCE(H0), and frequentist power/type-I error."
)

## ----example-pce-freq-comparison, message=FALSE, warning=FALSE----------------
des_onc_with_freq_power <- design_singlearm_onestage_rope(
  n_min = 20,
  n_max = 200,
  p0 = 0.30,
  delta = 0.12,
  gamma_eq = 0.80,
  
  # frequentist power at p = 0.3
  dp = 0.3,

  # Analysis prior p ~ Beta(a, b)
  a = 1, b = 1,

  # Design priors under H0 and H1
  da0 = 60, db0 = 40,   # H0: non-equivalence, mean ~0.60
  da1 = 36, db1 = 84,   # H1: equivalence, mean ~0.3

  target_power = 0.80,
  target_type1 = 0.10,
  target_freq_type1 = 0.10,
  target_freq_power = 0.80,
  sustain_n = 10,
  calibration = "Bayesian"
)

sel_orig <- des_onc_with_freq_power$selected
sel_new  <- fit_pce_freq$selected

comparison_tab <- tibble(
  design = c("Bayesian (original)", "Full (Bayes + frequentist + PCE(H0))"),
  n_star = c(sel_orig$n, fit_pce_freq$n),
  bayes_power = c(sel_orig$power, sel_new$power),
  bayes_type1 = c(sel_orig$type1, sel_new$type1),
  pce_h0 = c(sel_orig$pce_h0, sel_new$pce_h0),
  freq_power = c(sel_orig$freq_power, sel_new$freq_power),
  freq_type1 = c(sel_orig$freq_type1, sel_new$freq_type1)
)

kable(
  comparison_tab,
  digits = 3,
  caption = "Comparison of the original Bayesian calibration and the extended design with additional constraints on PCE(H0) and frequentist power/type-I error."
)

