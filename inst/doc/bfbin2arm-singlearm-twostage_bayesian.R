## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  fig.width = 7,
  fig.height = 5,
  warning = FALSE,
  message = FALSE
)

library(bfbin2arm)

## ----echo = FALSE, out.width = "90%", fig.align = "center", fig.cap = "Figure 1: Illustration of the calibration algorithm for an optimal Bayesian single-arm two-stage phase II design with a binary endpoint"----
knitr::include_graphics("figures/optimal_single_arm_two_stage_bayes_flowchart_rootfinding.png")

## -----------------------------------------------------------------------------
res <- design_singlearm_bf(
  n1_min = 5,
  n2_max = 200,
  k = 1/3,
  k_f = 3,
  p0 = 0.2,
  a0 = 1,
  b0 = 1,
  a1 = 1,
  b1 = 1,
  dp = 0.4,
  da0 = 1,
  db0 = 1,
  da1 = 2.5,
  db1 = 2,
  type = "point",
  calibration = "Bayesian",
  target_power = 0.80,
  target_type1 = 0.05
)

## -----------------------------------------------------------------------------
summary(res)

## ----eval = FALSE-------------------------------------------------------------
# if (!is.null(res$search_results) && nrow(res$search_results) > 0) {
#   knitr::kable(res$search_results)
# } else {
#   cat("No search results are available for this fit.\n")
# }

## ----eval = FALSE-------------------------------------------------------------
# plot(res)

## ----echo = FALSE, out.width = "100%", fig.align = "center", fig.cap = "Figure 2: Output of the plot function for a calibrated optimal single-arm two-stage design using Bayes factors. The top left panel shows Bayesian and frequentist power, Bayesian type-I-error and probability of compelling evidence (if specified) for varying interim sample sizes. The top right panel provides information about the optimal design found by the algorithm and its Bayesian and frequentist operating characteristics. The lower left and right panels visualize the analysis and design priors under the null and alternative hypothesis. Under the null hypothesis $H_0:p=p_0$, the design and analysis priors are point masses at the specified null probability p0."----
knitr::include_graphics("figures/optimal_single_arm_two_stage_bayes_fig2.png")

## -----------------------------------------------------------------------------
res$design

## ----eval = FALSE-------------------------------------------------------------
# res$operating_characteristics

## ----eval = FALSE-------------------------------------------------------------
# if (!is.null(res$search_results) && nrow(res$search_results) > 0) {
#   utils::head(res$search_results)
# } else {
#   cat("No search table is available.\n")
# }

## -----------------------------------------------------------------------------
res_ce <- design_singlearm_bf(
  n1_min = 5,
  n2_max = 200,
  k = 1/3,
  k_f = 3,
  p0 = 0.2,
  a0 = 1,
  b0 = 1,
  a1 = 1,
  b1 = 1,
  dp = 0.4,
  da0 = 1,
  db0 = 1,
  da1 = 2.5,
  db1 = 2,
  type = "point",
  calibration = "Bayesian",
  target_power = 0.80,
  target_type1 = 0.05,
  target_ce_h0 = 0.60
)

## -----------------------------------------------------------------------------
summary(res_ce)

## ----eval = FALSE-------------------------------------------------------------
# plot(res_ce)

## ----echo = FALSE, out.width = "100%", fig.align = "center", fig.cap = "Figure 3: Output of the plot function for a calibrated optimal single-arm two-stage design using Bayes factors. In addition to the previous calibration requirements in terms of power and type-I-error rate, this design also adds a constraint on the probability of compelling evidence in favour of the null hypothesis $H_0$. The top left panel again shows Bayesian and frequentist power, Bayesian type-I-error and probability of compelling evidence (if specified) for varying interim sample sizes. The top right panel provides information about the optimal design found by the algorithm and its Bayesian and frequentist operating characteristics. The lower left and right panels visualize the analysis and design priors under the null and alternative hypothesis. Under the null hypothesis $H_0:p=p_0$, the design and analysis priors are point masses at the specified null probability p0."----
knitr::include_graphics("figures/optimal_single_arm_two_stage_bayes_fig3.png")

## -----------------------------------------------------------------------------
res_dir <- design_singlearm_bf(
  n1_min = 5,
  n2_max = 200,
  k = 1/3,
  k_f = 3,
  p0 = 0.2,
  a0 = 1,
  b0 = 1,
  a1 = 1,
  b1 = 1,
  dp = 0.4,
  da0 = 1,
  db0 = 1,
  da1 = 2.5,
  db1 = 2,
  type = "direction",
  calibration = "Bayesian",
  target_ce_h0 = 0.60,
  target_power = 0.80,
  target_type1 = 0.05
)

## -----------------------------------------------------------------------------
summary(res_dir)

## ----eval = FALSE-------------------------------------------------------------
# plot(res_dir)

## ----echo = FALSE, out.width = "100%", fig.align = "center", fig.cap = "Figure 4: Output of the plot function for a calibrated optimal single-arm two-stage design using Bayes factors in the directional test setting. The top left panel again shows Bayesian and frequentist power, Bayesian type-I-error and probability of compelling evidence (if specified) for varying interim sample sizes. The top right panel provides information about the optimal design found by the algorithm and its Bayesian and frequentist operating characteristics. The lower left and right panels visualize the analysis and design priors under the null and alternative hypothesis. Under the null hypothesis $H_0:p=p_0$, the design and analysis priors are point masses at the specified null probability p0."----
knitr::include_graphics("figures/optimal_single_arm_two_stage_bayes_fig4.png")

## -----------------------------------------------------------------------------
res_dir_ce <- design_singlearm_bf(
  n1_min = 5,
  n2_max = 200,
  k = 1/3,
  k_f = 3,
  p0 = 0.2,
  a0 = 1,
  b0 = 1,
  a1 = 1,
  b1 = 1,
  dp = 0.4,
  da0 = 1,
  db0 = 1,
  da1 = 2.5,
  db1 = 2,
  type = "direction",
  calibration = "Bayesian",
  target_ce_h0 = 0.80,
  target_power = 0.80,
  target_type1 = 0.05
)

## -----------------------------------------------------------------------------
summary(res_dir_ce)

## ----out.width = "75%", fig.align = "center", fig.cap = "Figure 5: Relationship between the probability of compelling evidence PCE(H0) and the fixed-sample size for the selected design and analysis priors and evidence thresholds in the directional test example."----
fixed_diag_full <- function(n) {
  tmp <- bfbin2arm:::singlearm_fixed_oc(
    n    = n,
    k    = 1/3,
    p0   = 0.2,
    a0   = 1, b0 = 1,
    a1   = 1, b1 = 1,
    da0  = 1, db0 = 1,
    da1  = 2.5, db1 = 2,
    dp   = 0.4,
    type = "direction",
    k_ce = 3
  )
  c(
    n          = n,
    pfineff    = tmp$pfineff,
    pfineff0   = tmp$pfineff0,
    pce0_corr  = tmp$pce0_corr,
    ok         =
      !is.na(tmp$pfineff)  &&
      !is.na(tmp$pfineff0) &&
      !is.na(tmp$pce0_corr) &&
      tmp$pfineff  >= (0.80 + 0.025) &&
      tmp$pfineff0 <= 0.05           &&
      tmp$pce0_corr >= 0.80
  )
}

n_full <- 6:200
fd_full <- t(vapply(n_full, fixed_diag_full, numeric(5)))
colnames(fd_full) <- c("n","pfineff","pfineff0","pce0_corr","ok")

plot(fd_full[, "n"], fd_full[, "pfineff"],
     type = "l", lwd = 2, col = "darkorange",
     ylim = c(0, 1),
     xlab = "n", ylab = "Value",
     main = "Fixed-sample directional OC vs n")

lines(fd_full[, "n"], fd_full[, "pfineff0"], lwd = 2, col = "steelblue")
lines(fd_full[, "n"], fd_full[, "pce0_corr"], lwd = 2, col = "darkmagenta")

abline(h = 0.80 + 0.025, lty = 2, col = "darkorange")   # target power + cushion
abline(h = 0.05,           lty = 2, col = "steelblue")   # target type-I
abline(h = 0.80,           lty = 2, col = "darkmagenta") # target CE(H0)

legend("bottomright",
       legend = c("Bayesian power", "Bayesian type-I", "CE(H0)"),
       col = c("darkorange", "steelblue", "darkmagenta"),
       lwd = 2, bty = "n")

## -----------------------------------------------------------------------------
sessionInfo()

