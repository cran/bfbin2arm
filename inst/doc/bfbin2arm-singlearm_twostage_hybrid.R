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
res_hybrid <- design_singlearm_bf(
  n1_min = 5,
  n2_max = 100,
  k      = 1/10,
  k_f    = 3,
  p0     = 0.2,
  a0     = 1,
  b0     = 1,
  a1     = 1,
  b1     = 1,
  dp     = 0.4,
  da0    = 1,
  db0    = 1,
  da1    = 2.5,
  db1    = 2,
  type   = "direction",
  calibration       = "hybrid",
  target_power      = 0.80,
  target_freq_type1 = 0.05,
  power_cushion = 0.025
)

## -----------------------------------------------------------------------------
summary(res_hybrid)

## ----eval = FALSE-------------------------------------------------------------
# plot(res_hybrid)

## ----fig.align = "center", echo = FALSE, out.width = "100%", fig.cap = "Figure 1: Output of the plot function for an optimal hybrid single-arm two-stage design using Bayes factors. The top left panel shows Bayesian and frequentist power, Bayesian type-I-error for varying interim sample sizes. The top right panel provides information about the optimal frequentist design found by the algorithm and its Bayesian and frequentist operating characteristics. The lower left and right panels visualize the analysis and design priors under the null and alternative hypothesis. For the frequentist operating characteristics, these are irrelevant. They influence only the Bayesian operating characteristics."----
knitr::include_graphics("figures/optimal_single_arm_two_stage_hybrid_fig1.png")

## -----------------------------------------------------------------------------
prior_grid <- list(
  list(da1 = 1.5, db1 = 1.0, label = "weakly informative"),
  list(da1 = 2.5, db1 = 2.0, label = "moderately informative"),
  list(da1 = 4.0, db1 = 2.5, label = "more concentrated")
)

extract_row <- function(res, label) {
  if (is.null(res) || isFALSE(res$feasible)) {
    return(data.frame(
      prior_label = label,
      feasible    = FALSE,
      n1          = NA_integer_,
      n2          = NA_integer_,
      power       = NA_real_,
      type1       = NA_real_,
      freq_power  = NA_real_,
      freq_type1  = NA_real_,
      en_h0       = NA_real_,
      en_h1       = NA_real_
    ))
  }

  oc <- res$operating_characteristics
  data.frame(
    prior_label = label,
    feasible    = res$feasible,
    n1          = res$design["n1"],
    n2          = res$design["n2"],
    power       = oc$power,
    type1       = oc$type1,
    freq_power  = oc$freq_power,
    freq_type1  = oc$freq_type1,
    en_h0       = oc$en_h0,
    en_h1       = oc$en_h1
  )
}

hybrid_sensitivity <- lapply(prior_grid, function(pr) {
  fit <- tryCatch(
    design_singlearm_bf(
      n1_min = 5,
      n2_max = 100,
      k      = 1/10,
      k_f    = 3,
      p0     = 0.2,
      a0     = 1,
      b0     = 1,
      a1     = 1,
      b1     = 1,
      dp     = 0.4,
      da0    = 1,
      db0    = 1,
      da1    = pr$da1,
      db1    = pr$db1,
      type   = "direction",
      calibration       = "hybrid",
      target_power      = 0.80,
      target_freq_type1 = 0.05,
      power_cushion = 0.025
    ),
    error = function(e) NULL
  )

  extract_row(fit, pr$label)
})

hybrid_sensitivity <- do.call(rbind, hybrid_sensitivity)
knitr::kable(hybrid_sensitivity, digits = 3)

## -----------------------------------------------------------------------------
res_hybrid_ce <- design_singlearm_bf(
  n1_min = 5,
  n2_max = 180,
  k      = 1/10,
  k_f    = 3,
  p0     = 0.2,
  a0     = 1,
  b0     = 1,
  a1     = 1,
  b1     = 1,
  dp     = 0.4,
  da0    = 1,
  db0    = 1,
  da1    = 2.5,
  db1    = 2,
  type   = "direction",
  calibration       = "hybrid",
  target_power      = 0.80,
  target_freq_type1 = 0.025,
  target_ce_h0      = 0.60
)

## -----------------------------------------------------------------------------
summary(res_hybrid_ce)

## -----------------------------------------------------------------------------
res_no_cushion <- design_singlearm_bf(
  n1_min = 5,
  n2_max = 100,
  k = 1/30,
  k_f = 3,
  p0 = 0.2,
  a0 = 1, b0 = 1,
  a1 = 1, b1 = 1,
  da0 = 1, db0 = 1,
  da1 = 2.5, db1 = 2,
  dp = 0.4,
  type = "direction",
  calibration = "hybrid",
  target_power = 0.80,
  target_freq_type1 = 0.025
)
summary(res_no_cushion)

## -----------------------------------------------------------------------------
head(res_no_cushion$search_results[, c(
  "n1", "n2", "power", "power_naive",
  "erased_power", "freq_type1", "hybrid_ok", "feasible"
)], 12)

range(res_no_cushion$search_results$power)
range(res_no_cushion$search_results$freq_type1)

## -----------------------------------------------------------------------------
res_with_cushion <- design_singlearm_bf(
  n1_min = 5,
  n2_max = 100,
  k = 1/30,
  k_f = 3,
  p0 = 0.2,
  a0 = 1, b0 = 1,
  a1 = 1, b1 = 1,
  da0 = 1, db0 = 1,
  da1 = 2.5, db1 = 2,
  dp = 0.4,
  type = "direction",
  calibration = "hybrid",
  target_power = 0.80,
  target_freq_type1 = 0.025,
  power_cushion = 0.025
)

summary(res_with_cushion)

## -----------------------------------------------------------------------------
res_with_cushion$design
res_with_cushion$operating_characteristics

## ----echo = FALSE-------------------------------------------------------------
library(knitr)
library(kableExtra)

br_at_semicolon <- function(x) {
  gsub(";\\s*", ";<br>", x)
}

power_cushion_tbl <- data.frame(
  Mode = c("Bayesian", "frequentist", "hybrid", "full"),
  Anchor = c(
    "Bayesian power >= target_power + power_cushion; Bayesian type-I <= target_type1; optional CE for H0 >= target_ce_h0",
    "Frequentist power >= target_freq_power + power_cushion; frequentist type-I <= target_freq_type1",
    "Bayesian power >= target_power + power_cushion; frequentist type-I <= target_freq_type1",
    "Bayesian power >= target_power + power_cushion; Bayesian type-I <= target_type1; frequentist power >= target_freq_power + power_cushion; frequentist type-I <= target_freq_type1; optional CE for H0 >= target_ce_h0"
  ),
  `Step 2` = c(
    "Bayesian power >= target_power; Bayesian type-I <= target_type1; optional CE for H0 >= target_ce_h0",
    "Frequentist power >= target_freq_power; frequentist type-I <= target_freq_type1",
    "Bayesian power >= target_power; frequentist type-I <= target_freq_type1",
    "Bayesian power >= target_power; Bayesian type-I <= target_type1; frequentist power >= target_freq_power; frequentist type-I <= target_freq_type1; optional CE for H0 >= target_ce_h0"
  ),
  Explanation = c(
    "The anchor is a fixed-sample design that slightly overshoots the target Bayesian power to allow for the power loss that may occur once an interim futility analysis is introduced. In step 2, the actual two-stage design only needs to satisfy the original corrected Bayesian targets.",
    "The anchor is a fixed-sample design with cushioned frequentist power at the fixed alternative dp, so that after introducing the interim analysis the resulting two-stage design still has a realistic chance of achieving the original frequentist power target. No Bayesian constraints are imposed in this mode.",
    "Hybrid calibration combines a Bayesian power requirement with a frequentist type-I requirement, but it does not constrain frequentist power. Therefore, only the Bayesian power target is cushioned in step 1; in step 2, the selected two-stage design must meet the original Bayesian power target and the frequentist type-I constraint.",
    "Full calibration enforces both Bayesian and frequentist criteria. The anchor therefore has to overshoot both power targets, so that after adding interim futility the two-stage design can still satisfy the original Bayesian and frequentist constraints."
  ),
  check.names = FALSE
)

power_cushion_tbl$Anchor <- br_at_semicolon(power_cushion_tbl$Anchor)
power_cushion_tbl$`Step 2` <- br_at_semicolon(power_cushion_tbl$`Step 2`)

kbl(
  power_cushion_tbl,
  align = "l",
  escape = FALSE,
  caption = "Use of power_cushion in the fixed-sample anchor step across calibration modes."
) %>%
  kable_styling(
    bootstrap_options = c("striped", "condensed"),
    full_width = TRUE,
    font_size = 12,
    position = "left"
  ) %>%
  column_spec(1, width = "8%") %>%
  column_spec(2, width = "24%") %>%
  column_spec(3, width = "20%") %>%
  column_spec(4, width = "48%") %>%
  scroll_box(width = "100%")

## ----eval = FALSE-------------------------------------------------------------
# plot(res_with_cushion)

## ----fig.align = "center", echo = FALSE, out.width = "100%", fig.cap = "Figure 2: Output of the plot function for an optimal hybrid single-arm two-stage design using Bayes factors after adding a power cushion to the calibration algorithm call. The top left panel shows Bayesian and frequentist power, Bayesian type-I-error for varying interim sample sizes. The top right panel provides information about the optimal frequentist design found by the algorithm and its Bayesian and frequentist operating characteristics. The lower left and right panels visualize the analysis and design priors under the null and alternative hypothesis. For the frequentist operating characteristics, these are irrelevant. They influence only the Bayesian operating characteristics."----
knitr::include_graphics("figures/optimal_single_arm_two_stage_hybrid_fig2.png")

## -----------------------------------------------------------------------------
res_hybrid_ce_with_power_cushion <- design_singlearm_bf(
  n1_min = 5,
  n2_max = 180,
  k      = 1/10,
  k_f    = 3,
  p0     = 0.2,
  a0     = 1,
  b0     = 1,
  a1     = 1,
  b1     = 1,
  dp     = 0.4,
  da0    = 1,
  db0    = 1,
  da1    = 2.5,
  db1    = 2,
  type   = "direction",
  calibration       = "hybrid",
  target_power      = 0.80,
  target_freq_type1 = 0.05,
  target_ce_h0      = 0.60,
  power_cushion = 0.025
)

## -----------------------------------------------------------------------------
summary(res_hybrid_ce_with_power_cushion)

## ----eval = FALSE-------------------------------------------------------------
# res_hybrid_ce_with_power_cushion

