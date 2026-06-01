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

## -----------------------------------------------------------------------------
res_full <- design_singlearm_bf(
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
  calibration       = "full",
  target_power      = 0.80,
  target_type1      = 0.05,
  target_freq_power = 0.80,
  target_freq_type1 = 0.1,
  power_cushion = 0.025
)

## -----------------------------------------------------------------------------
summary(res_full)

## ----eval = FALSE-------------------------------------------------------------
# if (isTRUE(res_full$feasible)) {
#   plot(res_full)
# }

## ----fig.align = "center", echo = FALSE, out.width = "100%", fig.cap = "Figure 1: Output of the plot function for an optimal fully calibrated single-arm two-stage design using Bayes factors. The top left panel shows Bayesian and frequentist power, Bayesian type-I-error for varying interim sample sizes. The top right panel provides information about the optimal frequentist design found by the algorithm and its Bayesian and frequentist operating characteristics. The lower left and right panels visualize the analysis and design priors under the null and alternative hypothesis. For the frequentist operating characteristics, these are irrelevant. They influence only the Bayesian operating characteristics."----
knitr::include_graphics("figures/optimal_single_arm_two_stage_full_fig1.png")

## -----------------------------------------------------------------------------
res_bayes <- design_singlearm_bf(
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
  calibration       = "Bayesian",
  target_power      = 0.80,
  target_type1      = 0.05,
  target_freq_power = 0.80,
  target_freq_type1 = 0.05,
  power_cushion = 0.025
)

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
  target_power      = 0.80,
  target_type1      = 0.05,
  target_freq_power = 0.80,
  target_freq_type1 = 0.05,
  power_cushion = 0.025
)

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
  dp     = 0.5,
  da0    = 1,
  db0    = 1,
  da1    = 2.5,
  db1    = 2,
  type   = "direction",
  calibration       = "hybrid",
  target_power      = 0.80,
  target_type1      = 0.05,
  target_freq_power = 0.80,
  target_freq_type1 = 0.05,
  power_cushion = 0.025
)

## ----echo = FALSE-------------------------------------------------------------
extract_row <- function(res, label) {
  if (is.null(res) || isFALSE(res$feasible)) {
    return(data.frame(
      calibration = label,
      n1          = NA_integer_,
      n2          = NA_integer_,
      bayes_power = NA_real_,
      bayes_type1 = NA_real_,
      freq_power  = NA_real_,
      freq_type1  = NA_real_,
      bayes_en_h0 = NA_real_,
      bayes_en_h1 = NA_real_,
      freq_en_h0  = NA_real_,
      freq_en_h1  = NA_real_
    ))
  }

  oc <- res$operating_characteristics
  data.frame(
    calibration = label,
    n1          = res$design["n1"],
    n2          = res$design["n2"],
    bayes_power = oc$power,
    bayes_type1 = oc$type1,
    freq_power  = oc$freq_power,
    freq_type1  = oc$freq_type1,
    bayes_en_h0 = oc$en_h0,
    bayes_en_h1 = oc$en_h1,
    freq_en_h0  = oc$freq_en_h0,
    freq_en_h1  = oc$freq_en_h1
  )
}

library(knitr)
library(kableExtra)

cmp <- rbind(
  extract_row(res_bayes,  "Bayesian"),
  extract_row(res_freq,   "frequentist"),
  extract_row(res_hybrid, "hybrid"),
  extract_row(res_full,   "full")
)

kbl(
  cmp,
  digits = 3,
  align  = "l",
  escape = FALSE
) %>%
  kable_styling(
    full_width = FALSE,        # <- do NOT stretch to page width
    font_size  = 10,           # <- slightly smaller font
    bootstrap_options = c("striped", "condensed"),
    position = "left"
  ) %>%
  # narrow columns for labels and n1/n2
  column_spec(1, width = "8em") %>%
  column_spec(2, width = "4em") %>%
  column_spec(3, width = "4em") %>%
  # modest widths for power/type-I columns
  column_spec(4:7, width = "6em") %>%
  # EN columns can be a bit wider but still controlled
  column_spec(8:11, width = "7em") %>%
  # keep the visible box at page width, table can scroll horizontally
  scroll_box(width = "100%", height = "auto")

## -----------------------------------------------------------------------------
summary(res_bayes)

## -----------------------------------------------------------------------------
summary(res_hybrid)

## -----------------------------------------------------------------------------
summary(res_freq)

