## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----setup--------------------------------------------------------------------
library(bfbin2arm)

# Use default controls for reproducible vignette results.
# For interactive exploratory work, users may supply a faster control list.
control_fast <- list(
  n_search = "two_stage",
  n_step_stage1 = 10L,
  rel_tol_m1 = 1e-6,
  subdivisions_m1 = 100L,
  grid_n = 121L,
  t_max = 6,
  t_max_cap = 16,
  root_tol = 1e-8,
  verify = FALSE
)

control_full_fast <- list(
  n_search = "full_fast",
  rel_tol_m1 = 1e-6,
  subdivisions_m1 = 100L,
  grid_n = 121L,
  t_max = 6,
  root_tol = 1e-8,
  verify = FALSE,
  progress = TRUE
)

vignette_control <- list(
  n_search = "full",
  rel_tol_m1 = 1e-9,
  subdivisions_m1 = 800L,
  grid_n = 801L,
  t_max = 12,
  t_max_cap = 40,
  root_tol = 1e-12,
  verify = TRUE,
  verify_rel_tol_m1 = 1e-10,
  verify_subdivisions_m1 = 1200L,
  verify_grid_n = 1201L,
  verify_t_max = 15,
  verify_root_tol = 1e-12,
  progress = TRUE
)

## ----load-precomputed-composite-design, echo=FALSE----------------------------
composite_lci_continuous <- readRDS("composite-lci-continuous.rds")
composite_lci_no_pce <- readRDS("composite_lci_no_pce.rds")

## ----pulmonary-two-sided, eval = FALSE----------------------------------------
# pulmonary_normal_dp <- calibrate_bf_ttest(
#   design = "one.sample",
#   hypothesis = "two.sided.pointnull",
# 
#   # Search range for the number of evaluable participants
#   n_min = 20,
#   n_max = 200,
# 
#   # Evidence thresholds:
#   # BF01 <= 0.10 is compelling evidence for H1;
#   # BF01 >= 3 is compelling evidence for H0.
#   k1 = 1 / 10,
#   k0 = 3,
# 
#   # Analysis prior under H1: N(0, 0.5^2)
#   analysis_prior_sd = 0.5,
# 
#   # Error probability for incorrectly obtaining evidence for H1
#   # when the true standardized effect is exactly zero.
#   freq_t1e = 0.05,
#   bayes_t1e = 0.05,
# 
#   # Frequentist power at the clinically relevant point alternative.
#   freq_power = list(
#     main = list(effect = 0.40, target = 0.80)
#   ),
# 
#   # Average probability of evidence for H1 under the H1 design prior.
#   bayes_power = 0.80,
# 
#   # Probability of compelling evidence for H0 under the H0 design prior.
#   # Including this argument also computes and stores the H0 evidence region.
#   pce_h0 = 0.60,
# 
#   # Design priors used only for operating-characteristic calculations.
#   design_prior_h0 = list(type = "point", effect = 0),
#   design_prior_h1 = list(
#     type = "truncnormal",
#     mean = 0.40,
#     sd = 0.20,
#     lower = 0,
#     upper = Inf
#   ),
# 
#   control = control_full_fast
# )
# 
# print(pulmonary_normal_dp)

## ----eval = FALSE-------------------------------------------------------------
# plot(pulmonary_normal_dp)

## ----fig.align = "center", echo = FALSE, out.width = "100%", fig.cap = "Figure 1: Output of the plot function for a one-sample Bayesian two-sided point-null t-test design based on full calibration. Both Bayesian and frequentist power and type-I-error are calibrated jointly."----
knitr::include_graphics("figures/bfbin2arm-onesample-t-test-ex1.png")

## ----eval = FALSE-------------------------------------------------------------
# library(bfbin2arm)
# 
# vignette_control <- resolve_control_bf_ttest()
# 
# common_args <- list(
#   design = "one.sample",
#   hypothesis = "two.sided.pointnull",
# 
#   n_min = 20,
#   n_max = 200,
# 
#   # BF01 <= 0.10: evidence for H1
#   # BF01 >= 3: available as a reference threshold, but no PCE constraint here
#   k1 = 1 / 10,
#   k0 = 3,
# 
#   # Analysis prior under H1: N(0, 0.5^2)
#   analysis_prior_sd = 0.5,
# 
#   # H0 design prior: exact null
#   design_prior_h0 = list(type = "point", effect = 0),
# 
#   # H1 design prior: uncertain beneficial effect
#   design_prior_h1 = list(
#     type = "truncnormal",
#     mean = 0.40,
#     sd = 0.20,
#     lower = 0,
#     upper = Inf
#   ),
# 
#   control = control_full_fast
# )

## ----eval = FALSE-------------------------------------------------------------
# pulmonary_freq <- do.call(
#   calibrate_bf_ttest,
#   c(
#     common_args,
#     list(
#       freq_t1e = 0.05,
#       freq_power = list(
#         main = list(effect = 0.40, target = 0.80)
#       )
#     )
#   )
# )
# 
# print(pulmonary_freq)

## ----eval = FALSE-------------------------------------------------------------
# pulmonary_bayes <- do.call(
#   calibrate_bf_ttest,
#   c(
#     common_args,
#     list(
#       bayes_t1e = 0.05,
#       bayes_power = 0.80
#     )
#   )
# )
# 
# print(pulmonary_bayes)

## ----eval = FALSE-------------------------------------------------------------
# pulmonary_bayes_power_freq_t1e <- do.call(
#   calibrate_bf_ttest,
#   c(
#     common_args,
#     list(
#       freq_t1e = 0.05,
#       bayes_power = 0.80
#     )
#   )
# )
# 
# print(pulmonary_bayes_power_freq_t1e)

## ----eval = FALSE-------------------------------------------------------------
# pulmonary_full_no_pce <- do.call(
#   calibrate_bf_ttest,
#   c(
#     common_args,
#     list(
#       freq_t1e = 0.05,
#       bayes_t1e = 0.05,
#       freq_power = list(
#         main = list(effect = 0.40, target = 0.80)
#       ),
#       bayes_power = 0.80
# 
#       # Deliberately omit:
#       # pce_h0 = ...
#     )
#   )
# )
# 
# print(pulmonary_full_no_pce)

## ----compare-calibrations, echo = FALSE, eval = FALSE-------------------------
# designs <- list(
#   "Frequentist only" = pulmonary_freq,
#   "Bayesian only" = pulmonary_bayes,
#   "Bayesian power + frequentist type-I error" =
#     pulmonary_bayes_power_freq_t1e,
#   "Full calibration, no PCE" = pulmonary_full_no_pce
# )
# 
# active_constraints <- function(x) {
#   tab <- x$constraint_table
# 
#   labels <- c(
#     freq_t1e = "Freq. type-I error",
#     bayes_t1e = "Bayes type-I error",
#     bayes_power = "Bayes power",
#     freq_power_main = "Freq. power"
#   )
# 
#   paste(unname(labels[tab$constraint]), collapse = "; ")
# }
# 
# attained_value <- function(x, constraint) {
#   tab <- x$constraint_table
#   idx <- match(constraint, tab$constraint)
# 
#   if (is.na(idx)) {
#     return(NA_real_)
#   }
# 
#   tab$estimate[idx]
# }
# 
# comparison_table <- data.frame(
#   Calibration = names(designs),
#   `n*` = vapply(designs, `[[`, integer(1), "n"),
#   `Active constraints` = vapply(designs, active_constraints, character(1)),
#   `Freq. type-I error` = vapply(
#     designs, attained_value, numeric(1), constraint = "freq_t1e"
#   ),
#   `Bayes type-I error` = vapply(
#     designs, attained_value, numeric(1), constraint = "bayes_t1e"
#   ),
#   `Freq. power at delta = 0.40` = vapply(
#     designs, attained_value, numeric(1), constraint = "freq_power_main"
#   ),
#   `Bayes power` = vapply(
#     designs, attained_value, numeric(1), constraint = "bayes_power"
#   ),
#   check.names = FALSE
# )
# 
# probability_columns <- c(
#   "Freq. type-I error",
#   "Bayes type-I error",
#   "Freq. power at delta = 0.40",
#   "Bayes power"
# )
# 
# comparison_table[probability_columns] <- lapply(
#   comparison_table[probability_columns],
#   function(x) ifelse(is.na(x), "", sprintf("%.3f", x))
# )
# 
# knitr::kable(
#   comparison_table,
#   caption = paste(
#     "Comparison of the four calibration strategies.",
#     "Blank cells denote operating characteristics that were not active constraints."
#   ),
#   align = c("l", "r", "l", "r", "r", "r", "r")
# )

## ----pulmonary-directional-setup----------------------------------------------
directional_common_args <- list(
  design = "one.sample",
  hypothesis = "greater.pointnull",

  # Search range for the number of evaluable participants.
  n_min = 20,
  n_max = 200,

  # BF01 <= 0.10: compelling evidence for benefit (H1).
  # BF01 >= 3: available as a decision threshold, but no PCE constraint is
  # imposed in the calibrations below.
  k1 = 1 / 10,
  k0 = 3,

  # Directional H1 analysis prior:
  # N(0, 0.5^2), truncated to delta > 0.
  analysis_prior_sd = 0.5,

  # H0 design prior: exact null effect.
  design_prior_h0 = list(type = "point", effect = 0),

  # H1 design prior: uncertain beneficial effect.
  design_prior_h1 = list(
    type = "truncnormal",
    mean = 0.40,
    sd = 0.20,
    lower = 0,
    upper = Inf
  ),

  control = control_full_fast
)

## ----pulmonary-directional-freq, eval = FALSE---------------------------------
# pulmonary_directional_freq <- do.call(
#   calibrate_bf_ttest,
#   c(
#     directional_common_args,
#     list(
#       freq_t1e = 0.05,
#       freq_power = list(
#         main = list(effect = 0.40, target = 0.80)
#       )
#     )
#   )
# )
# 
# print(pulmonary_directional_freq)

## ----eval = FALSE-------------------------------------------------------------
# plot(pulmonary_directional_freq)

## ----fig.align = "center", echo = FALSE, out.width = "100%", fig.cap = "Figure 2: Output of the plot function for a one-sample Bayesian t-test design based on frequentist calibration."----
knitr::include_graphics("figures/bfbin2arm-onesample-t-test-freq.png")

## ----pulmonary-directional-bayes, eval = FALSE--------------------------------
# pulmonary_directional_bayes <- do.call(
#   calibrate_bf_ttest,
#   c(
#     directional_common_args,
#     list(
#       bayes_t1e = 0.05,
#       bayes_power = 0.80
#     )
#   )
# )
# 
# print(pulmonary_directional_bayes)

## ----eval = FALSE-------------------------------------------------------------
# plot(pulmonary_directional_bayes)

## ----fig.align = "center", echo = FALSE, out.width = "100%", fig.cap = "Figure 3: Output of the plot function for a one-sample Bayesian t-test design based on Bayesian calibration."----
knitr::include_graphics("figures/bfbin2arm-onesample-t-test-bayes.png")

## ----pulmonary-directional-hybrid, eval = FALSE-------------------------------
# pulmonary_directional_bayes_power_freq_t1e <- do.call(
#   calibrate_bf_ttest,
#   c(
#     directional_common_args,
#     list(
#       freq_t1e = 0.05,
#       bayes_power = 0.80
#     )
#   )
# )
# 
# print(pulmonary_directional_bayes_power_freq_t1e)

## ----pulmonary-directional-full, eval = FALSE---------------------------------
# pulmonary_directional_full_no_pce <- do.call(
#   calibrate_bf_ttest,
#   c(
#     directional_common_args,
#     list(
#       freq_t1e = 0.05,
#       bayes_t1e = 0.05,
#       freq_power = list(
#         main = list(effect = 0.40, target = 0.80)
#       ),
#       bayes_power = 0.80
#     )
#   )
# )
# 
# print(pulmonary_directional_full_no_pce)

## ----eval = FALSE-------------------------------------------------------------
# composite_lci_continuous <- calibrate_bf_ttest(
#   design = "one.sample",
#   hypothesis = "greater.composite",
#   n_min = 20,
#   n_max = 120,
#   k1 = 1 / 20,
#   k0 = 3,
# 
#   analysis_prior_h0 = make_analysis_prior_less_equal(sd = 0.5),
#   analysis_prior_h1 = make_analysis_prior_greater(sd = 0.5),
# 
#   freq_t1e = 0.05,
#   freq_power = list(main = list(effect = 0.40, target = 0.80)),
#   bayes_t1e = 0.05,
#   bayes_power = 0.80,
#   pce_h0 = 0.60,
# 
#   design_prior_h0 = list(
#     type = "truncnormal",
#     mean = -0.10,
#     sd = 0.25,
#     lower = -Inf,
#     upper = 0
#   ),
#   design_prior_h1 = list(
#     type = "truncnormal",
#     mean = 0.40,
#     sd = 0.20,
#     lower = 0,
#     upper = Inf
#   ),
# 
#   control = fast_control
# )
# 
# composite_lci_continuous

## ----eval = FALSE-------------------------------------------------------------
# plot(composite_lci_continuous)

## ----fig.align = "center", echo = FALSE, out.width = "100%", fig.cap = "Figure 3: Output of the plot function for a one-sample Bayesian composite-null versus directional t-test design based on full calibration. Both Bayesian and frequentist power and type-I-error are calibrated jointly. Also, a 60% threshold on the probability of compelling evidence for the null hypothesis is guaranteed."----
knitr::include_graphics("figures/bfbin2am-onesample-t-test-ex3.png")

## -----------------------------------------------------------------------------
## Conventional frequentist one-sided one-sample t-test
freq_design <- power.t.test(
  delta = 0.40,
  sd = 1,
  sig.level = 0.05,
  power = 0.80,
  type = "one.sample",
  alternative = "one.sided"
)

freq_n <- ceiling(freq_design$n)

## ----sample-size-comparisons, eval = FALSE------------------------------------
# ## Bayes-factor design: H1 evidence only, no PCE requirement.
# composite_lci_no_pce <- calibrate_bf_ttest(
#   design = "one.sample",
#   hypothesis = "greater.composite",
#   n_min = 20,
#   n_max = 120,
#   k1 = 1 / 20,
#   k0 = 3,
# 
#   analysis_prior_h0 = make_analysis_prior_less_equal(sd = 0.5),
#   analysis_prior_h1 = make_analysis_prior_greater(sd = 0.5),
# 
#   freq_t1e = 0.05,
#   freq_power = list(main = list(effect = 0.40, target = 0.80)),
# 
#   design_prior_h0 = list(
#     type = "truncnormal",
#     mean = -0.10,
#     sd = 0.25,
#     lower = -Inf,
#     upper = 0
#   ),
#   design_prior_h1 = list(
#     type = "truncnormal",
#     mean = 0.40,
#     sd = 0.20,
#     lower = 0,
#     upper = Inf
#   ),
# 
#   control = fast_control
# )

## -----------------------------------------------------------------------------
sample_size_comparison <- data.frame(
  design = c(
    "Frequentist one-sample t-test",
    "Bayes-factor design: H1 evidence only",
    "Bayes-factor design: H1 and H0 evidence"
  ),
  type_I_error_control = c(
    "One-sided alpha = 0.05",
    "P(delta = 0; BF01 <= 1/20) <= 0.05",
    "P(delta = 0; BF01 <= 1/20) <= 0.05"
  ),
  power_requirement = c(
    "Power(delta = 0.40) >= 0.80",
    "P(delta = 0.40; BF01 <= 1/20) >= 0.80",
    "P(delta = 0.40; BF01 <= 1/20) >= 0.80"
  ),
  H0_evidence_requirement = c(
    "None",
    "None",
    "P_design,H0(BF01 >= 3) >= 0.60"
  ),
  sample_size = c(
    freq_n,
    composite_lci_no_pce$n,
    composite_lci_continuous$n
  ),
  stringsAsFactors = FALSE
)

knitr::kable(
  sample_size_comparison,
  col.names = c(
    "Design",
    "Type-I-error control",
    "Power requirement",
    "H0-evidence requirement",
    "Required n"
  ),
  caption = "Sample-size comparison under a one-sided standardized effect of 0.40."
)

## ----paired-bp-calibration, eval = FALSE--------------------------------------
# paired_bp <- calibrate_bf_ttest(
#   design = "paired",
#   hypothesis = "greater.composite",
# 
#   # Number of evaluable participant pairs.
#   n_min = 20,
#   n_max = 120,
# 
#   # Prespecified, fixed evidence thresholds.
#   k1 = 1 / 20,
#   k0 = 3,
# 
#   # Default composite-null analysis priors:
#   # N(0, 0.5^2), truncated to the respective half-lines.
#   analysis_prior_sd = 0.5,
# 
#   freq_t1e = 0.05,
#   freq_power = list(
#     main = list(effect = 0.40, target = 0.80)
#   ),
#   bayes_t1e = 0.05,
#   bayes_power = 0.80,
#   pce_h0 = 0.60,
# 
#   design_prior_h0 = list(
#     type = "truncnormal",
#     mean = -0.10,
#     sd = 0.25,
#     lower = -Inf,
#     upper = 0
#   ),
#   design_prior_h1 = list(
#     type = "truncnormal",
#     mean = 0.40,
#     sd = 0.20,
#     lower = 0,
#     upper = Inf
#   ),
# 
#   control = control_full_fast
# )
# 
# print(paired_bp)

