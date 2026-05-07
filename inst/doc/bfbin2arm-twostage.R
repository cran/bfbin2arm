## ----setup, include = FALSE---------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment  = "#>",
  fig.width = 7,
  fig.height = 5,
  echo = TRUE,
  eval = TRUE,      # default, but heavy chunks override with eval = FALSE
  message = FALSE,
  warning = FALSE
)
options(bfbin2arm.ncores = 1L)
library(bfbin2arm)

## ----echo = FALSE, out.width = "80%", fig.align = "center", fig.cap = "Figure 1: Illustration of the calibration algorithm searching for an optimal Bayesian two-arm two-stage phase II design with binary endpoints"----
knitr::include_graphics("figures/algorithm_bayes.png")

## ----eval = TRUE--------------------------------------------------------------
p1_riociguat <- 38/(22+38) # control arm response probability
p1_riociguat 
p2_riociguat <- 48/(48+11)  # treatment arm response probability
p2_riociguat

## ----eval = TRUE--------------------------------------------------------------
# flat design priors under H0 and H1 (Riociguat)
a_0_d_rio <- 1
b_0_d_rio <- 1

# slightly informative design prior under H1 (that is, H_+) for the control group
a_1_d_rio <- 1 
b_1_d_rio <- 3

# slightly informative design prior under H1 (that is, H_+) for the treatment group
a_2_d_rio <- 3
b_2_d_rio <- 1

# Analysis priors under H0 and H1 (Riociguat)
a_0_a_rio <- 1 # flat under H0
b_0_a_rio <- 1

a_1_a_rio <- 1 # flat under H1 for the control group
b_1_a_rio <- 1

a_2_a_rio <- 1 # flat under H1 for the treatment group
b_2_a_rio <- 1

## ----eval = FALSE, fig.height=7-----------------------------------------------
# cat("\n--- Sample size search for riociguat-type trial ---\n")
# res_rio_onestage <- ntwoarmbinbf01(
#   k = 1/10, k_f = 3,
#   power = 0.8, alpha = 0.025, pce_H0 = 0.6,
#   test = "BF+0",
#   nrange = c(10, 160), n_step = 1,
#   progress = TRUE,
#   a_0_d = a_0_d_rio, b_0_d = b_0_d_rio,
#   a_0_a = a_0_a_rio, b_0_a = b_0_a_rio,
#   a_1_d = a_1_d_rio, b_1_d = b_1_d_rio,
#   a_2_d = a_2_d_rio, b_2_d = b_2_d_rio,
#   a_1_a = a_1_a_rio, b_1_a = b_1_a_rio,
#   a_2_a = a_2_a_rio, b_2_a = b_2_a_rio,
#   compute_freq_t1e = TRUE,
#   p1_power = 0.4, p2_power = 0.6,
#   output = "plot"  # Returns recommended n per group
# )

## ----eval = FALSE-------------------------------------------------------------
# res_rio_onestage

## ----echo = FALSE, out.width = "80%", fig.align = "center", fig.cap = "Figure 2: The calibrated Bayesian two-arm one-stage phase II design with binary endpoints. No interim analysis is carried out and the design is calibrated according to the target constraints of 80% Bayesian power, 2.5% Bayesian type-I-error and 60% probability of compelling evidence for the null hypothesis."----
knitr::include_graphics("figures/one-stage-design.png")

## ----riociguat-bayesian-design, eval = FALSE----------------------------------
# res_rio <- optimal_twostage_2arm_bf(
#   alpha = 0.025,
#   beta = 0.20,
#   k = 1/10,
#   k_f = 3,
#   n1_min = c(10, 10),
#   n2_max = c(80, 80),
#   alloc1 = 0.5,
#   alloc2 = 0.5,
#   power_cushion = 0.03,
#   pceH0 = 0.60,
#   interim_fraction = c(0, 1),
#   ncores = 1L,
#   grid_step = 1,
#   progress = TRUE,
#   max_iter = 500L,
#   compute_freq_oc = FALSE,
#   test = "BF+0",
#   a_0_d = a_0_d_rio, b_0_d = b_0_d_rio,
#   a_0_a = a_0_a_rio, b_0_a = b_0_a_rio,
#   a_1_d = a_1_d_rio, b_1_d = b_1_d_rio,
#   a_2_d = a_2_d_rio, b_2_d = b_2_d_rio,
#   a_1_a = a_1_a_rio, b_1_a = b_1_a_rio,
#   a_2_a = a_2_a_rio, b_2_a = b_2_a_rio
# )

## ----riociguat-plot, eval = FALSE, fig.height=5-------------------------------
# plot_twostage_2arm_bf(res_rio)

## ----echo = FALSE, out.width = "80%", fig.align = "center", fig.cap = "Figure 3: The calibrated Bayesian two-arm two-stage phase II design with binary endpoints. An interim analysis is carried out at sample sizes of 13 patients per trial arm, and the design is calibrated according to the target constraints of 80% Bayesian power, 2.5% Bayesian type-I-error and 60% probability of compelling evidence for the null hypothesis. THe final analysis is carried out after 34 patients have been recruited per trial arm."----
knitr::include_graphics("figures/optimal-two-stage-design-riociguat.png")

## ----tab:onestage-twostage-riociguat, echo = FALSE----------------------------
tab_onestage_twostage <- data.frame(
  Design      = c("One-stage (fixed)",      "Two-stage (optimal)"),
  n1_1        = c("-",                      "13"),
  n1_2        = c("-",                      "13"),
  n2_1        = c("~26",                    "34"),
  n2_2        = c("~25",                    "34"),
  N_total     = c("51",                     "68"),
  Power       = c("0.80",                   "0.80"),
  Type1_Error = c("0.007",                  "0.006"),
  CE_H0       = c("0.62",                   "0.60"),
  E_H0_N      = c("51.0",                   "67.1")
)

knitr::kable(
  tab_onestage_twostage,
  caption = "Bayesian operating characteristics of the fixed-sample one-stage design at \\\\(N_{\\\\text{total}} = 51\\\\) and the corresponding optimal two-stage design with interim look at \\\\((n_1^{(1)}, n_1^{(2)}) = (13, 13)\\\\) and maximum total sample size \\\\(N_{\\\\text{total}} = 68\\\\) for the riociguat example.",
  booktabs = TRUE
)

## ----eval = FALSE-------------------------------------------------------------
# res_rio_more_informative_design_priors <- optimal_twostage_2arm_bf(
#   alpha = 0.025,
#   beta = 0.20,
#   k = 1/10,
#   k_f = 3,
#   n1_min = c(10, 10),
#   n2_max = c(80, 80),
#   alloc1 = 0.5,
#   alloc2 = 0.5,
#   power_cushion = 0.03,
#   pceH0 = 0.60,
#   interim_fraction = c(0.25, 0.9),
#   grid_step = 1,
#   progress = TRUE,
#   max_iter = 500L,
#   compute_freq_oc = FALSE,
#   test = "BF+0",
#   a_0_d = a_0_d_rio, b_0_d = b_0_d_rio,
#   a_0_a = a_0_a_rio, b_0_a = b_0_a_rio,
#   a_1_d = 1, b_1_d = 5,
#   a_2_d = 5, b_2_d = 1,
#   a_1_a = a_1_a_rio, b_1_a = b_1_a_rio,
#   a_2_a = a_2_a_rio, b_2_a = b_2_a_rio
# )
# 
# plot_twostage_2arm_bf(res_rio_more_informative_design_priors)

## ----echo = FALSE, out.width = "80%", fig.align = "center", fig.cap = "Figure 4: The calibrated Bayesian two-arm two-stage phase II design with binary endpoints, now using slightly more informative Beta design priors. An interim analysis is carried out at sample sizes of 10 patients per trial arm, and the design is calibrated according to the target constraints of 80% Bayesian power, 2.5% Bayesian type-I-error and 60% probability of compelling evidence for the null hypothesis. THe final analysis is carried out after 23 patients have been recruited per trial arm. Note that the expected sample size under the null hypothesis has substantially decreased compared to the earlier optimal design under less informative design priors."----
knitr::include_graphics("figures/optimal-two-stage-design-riociguat-more-informative-design-priors.png")

