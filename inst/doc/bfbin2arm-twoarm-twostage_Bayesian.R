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

## ----eval = FALSE-------------------------------------------------------------
# cat("\n--- One-stage design calibration for riociguat-type trial ---\n")
# res_rio_onestage <- design_twoarm_onestage_bf(
#   n_min = 10,
#   n_max = 160,
#   k = 1/10,
#   k_f = 3,
#   test = "BF+0",
#   alloc1 = 0.5,
#   alloc2 = 0.5,
#   calibration = "Bayesian",
#   target_power = 0.8,
#   target_type1 = 0.025,
#   target_ce_h0 = 0.60,
#   target_freq_power = 0.8,
#   target_freq_type1 = 0.025,
#   p1_grid = seq(0.01, 0.99, 0.02),
#   p2_grid = seq(0.01, 0.99, 0.02),
#   p1_power = 0.4,
#   p2_power = 0.6,
#   power_cushion = 0,
#   sustain_n = 10L,
#   algorithm = "optimal",
#   progress = FALSE,
#   report_freq_type1 = TRUE,
#   a_0_d = a_0_d_rio, b_0_d = b_0_d_rio,
#   a_0_a = a_0_a_rio, b_0_a = b_0_a_rio,
#   a_1_d = a_1_d_rio, b_1_d = b_1_d_rio,
#   a_2_d = a_2_d_rio, b_2_d = b_2_d_rio,
#   a_1_a = a_1_a_rio, b_1_a = b_1_a_rio,
#   a_2_a = a_2_a_rio, b_2_a = b_2_a_rio
# )

## ----eval = FALSE-------------------------------------------------------------
# res_rio_onestage

## ----eval = FALSE-------------------------------------------------------------
# summary(res_rio_onestage)

## ----eval = FALSE, fig.height=7-----------------------------------------------
# plot(res_rio_onestage)

## ----echo = FALSE, out.width = "80%", fig.align = "center", fig.cap = "Figure 2: Calibrated Bayesian two-arm one-stage phase II design with binary endpoints, obtained via design_twoarm_onestage_bf(). No interim analysis is carried out, and the design is calibrated to 80% Bayesian power, 2.5% Bayesian type-I error and 60% probability of compelling evidence for the null hypothesis."----
knitr::include_graphics("figures/twoarm-onestage-design.png")

## ----eval = FALSE-------------------------------------------------------------
# print(res_rio_onestage)

## ----riociguat-bayesian-design, eval = FALSE----------------------------------
# res_rio <- design_twoarm_twostage_bf(
#   n1_min = c(10, 10),
#   n2_max = c(80, 80),
#   alloc1 = 0.5,
#   alloc2 = 0.5,
#   k = 1/10,
#   k_f = 3,
#   test = "BF+0",
#   calibration = "Bayesian",
#   calibration_en = "Bayesian",
#   target_power = 0.8,
#   target_type1 = 0.025,
#   target_ce_h0 = 0.60,
#   power_cushion = 0.03,
#   interim_fraction = c(0, 1),
#   grid_step = 1L,
#   coarse_step = 10L,
#   max_iter = 500L,
#   ncores = 1L,
#   progress = TRUE,
#   a_0_d = a_0_d_rio, b_0_d = b_0_d_rio,
#   a_0_a = a_0_a_rio, b_0_a = b_0_a_rio,
#   a_1_d = a_1_d_rio, b_1_d = b_1_d_rio,
#   a_2_d = a_2_d_rio, b_2_d = b_2_d_rio,
#   a_1_a = a_1_a_rio, b_1_a = b_1_a_rio,
#   a_2_a = a_2_a_rio, b_2_a = b_2_a_rio
# )

## ----eval = FALSE-------------------------------------------------------------
# interim_fraction = c(0, 1)
# n1_min          = c(10, 10)

## ----eval = FALSE-------------------------------------------------------------
# res_rio$design
# #> n1_1 n1_2 n2_1 n2_2
# #>   10   10   34   34

## ----eval = FALSE-------------------------------------------------------------
# res_rio$operating_characteristics
# #> $power
# #>  0.8330913
# #>
# #> $type1
# #>  0.005831181
# #>
# #> $ce_h0
# #>  0.6927951
# #>
# #> $en_bayes
# #>  66.04139
# #>
# #> $freq_type1
# #>  NA
# #>
# #> $freq_power
# #>  NA
# #>
# #> $en_freq
# #>  NA

## ----eval = FALSE-------------------------------------------------------------
# res_rio
# summary(res_rio)

## ----riociguat-plot, eval = FALSE, fig.height=5-------------------------------
# plot(res_rio)

## ----echo = FALSE, out.width = "80%", fig.align = "center", fig.cap = "Figure 3: Calibrated Bayesian two-arm two-stage phase II design with binary endpoints, obtained via design_twoarm_twostage_bf(). An interim analysis is carried out at 10 patients per arm, and the design is calibrated to 80% Bayesian power, 2.5% Bayesian type-I error and 60% probability of compelling evidence for the null hypothesis; the final analysis is carried out after 34 patients per arm."----
knitr::include_graphics("figures/optimal-two-stage-design-riociguat.png")

## ----tab:onestage-twostage-riociguat, echo = FALSE----------------------------
tab_onestage_twostage <- data.frame(
  Design      = c("One-stage (fixed)",      "Two-stage (optimal)"),
  n1_1        = c("-",                      "10"),
  n1_2        = c("-",                      "10"),
  n2_1        = c("~26",                    "34"),
  n2_2        = c("~27",                    "34"),
  N_total     = c("53",                     "68"),
  Power       = c("0.80",                   "0.83"),
  Type1_Error = c("0.007",                  "0.006"),
  CE_H0       = c("0.62",                   "0.69"),
  E_H0_N      = c("53.0",                   "66.04")
)

knitr::kable(
  tab_onestage_twostage,
  caption = "Bayesian operating characteristics of the fixed-sample one-stage design at \\\\(N_{\\\\text{total}} = 53\\\\) and the corresponding optimal two-stage design with interim look at \\\\((n_1^{(1)}, n_1^{(2)}) = (10, 10)\\\\) and maximum total sample size \\\\(N_{\\\\text{total}} = 68\\\\) for the riociguat example.",
  booktabs = TRUE
)

## ----eval = FALSE-------------------------------------------------------------
# res_rio_more_informative_design_priors <- design_twoarm_twostage_bf(
#   n1_min = c(10, 10),
#   n2_max = c(80, 80),
#   alloc1 = 0.5,
#   alloc2 = 0.5,
#   k = 1/10,
#   k_f = 3,
#   test = "BF+0",
#   calibration = "Bayesian",
#   calibration_en = "Bayesian",
#   target_power = 0.8,
#   target_type1 = 0.025,
#   target_ce_h0 = 0.60,
#   power_cushion = 0.03,
#   interim_fraction = c(0, 1),
#   grid_step = 1L,
#   coarse_step = 10L,
#   max_iter = 500L,
#   ncores = 1L,
#   progress = TRUE,
#   a_0_d = a_0_d_rio, b_0_d = b_0_d_rio,
#   a_0_a = a_0_a_rio, b_0_a = b_0_a_rio,
#   a_1_d = 1, b_1_d = 5,
#   a_2_d = 5, b_2_d = 1,
#   a_1_a = a_1_a_rio, b_1_a = b_1_a_rio,
#   a_2_a = a_2_a_rio, b_2_a = b_2_a_rio
# )

## ----eval = FALSE-------------------------------------------------------------
# plot(res_rio_more_informative_design_priors)

## ----echo = FALSE, out.width = "80%", fig.align = "center", fig.cap = "Figure 4: The calibrated Bayesian two-arm two-stage phase II design with binary endpoints, now using slightly more informative Beta design priors. An interim analysis is carried out at sample sizes of 10 patients per trial arm, and the design is calibrated according to the target constraints of 80% Bayesian power, 2.5% Bayesian type-I-error and 60% probability of compelling evidence for the null hypothesis. The final analysis is carried out after 23 patients have been recruited per trial arm. Note that the expected sample size under the null hypothesis has substantially decreased compared to the earlier optimal design under less informative design priors."----
knitr::include_graphics("figures/optimal-two-stage-design-riociguat-more-informative-design-priors.png")

## ----eval = FALSE-------------------------------------------------------------
# cat("\n--- One-stage design calibration for riociguat-type trial ---\n")
# res_rio_onestage_informative_designpriors <- design_twoarm_onestage_bf(
#   n_min = 10,
#   n_max = 80,
#   k = 1/10,
#   k_f = 3,
#   test = "BF+0",
#   alloc1 = 0.5,
#   alloc2 = 0.5,
#   calibration = "Bayesian",
#   target_power = 0.8,
#   target_type1 = 0.025,
#   target_ce_h0 = 0.60,
#   target_freq_power = 0.8,
#   target_freq_type1 = 0.025,
#   p1_grid = seq(0.01, 0.99, 0.02),
#   p2_grid = seq(0.01, 0.99, 0.02),
#   p1_power = 0.4,
#   p2_power = 0.6,
#   power_cushion = 0,
#   sustain_n = 10L,
#   algorithm = "optimal",
#   progress = FALSE,
#   report_freq_type1 = TRUE,
#   a_0_d = a_0_d_rio, b_0_d = b_0_d_rio,
#   a_0_a = a_0_a_rio, b_0_a = b_0_a_rio,
#   a_1_d = 1, b_1_d = 6,
#   a_2_d = 6, b_2_d = 1,
#   a_1_a = a_1_a_rio, b_1_a = b_1_a_rio,
#   a_2_a = a_2_a_rio, b_2_a = b_2_a_rio
# )
# summary(res_rio_onestage_informative_designpriors)

## ----eval = FALSE-------------------------------------------------------------
# res_rio_more_informative_design_priors_no_ce <- design_twoarm_twostage_bf(
#   n1_min = c(10, 10),
#   n2_max = c(80, 80),
#   alloc1 = 0.5,
#   alloc2 = 0.5,
#   k = 1/10,
#   k_f = 3,
#   test = "BF+0",
#   calibration = "Bayesian",
#   calibration_en = "Bayesian",
#   target_power = 0.8,
#   target_type1 = 0.025,
#   power_cushion = 0.03,
#   interim_fraction = c(0, 1),
#   grid_step = 1L,
#   coarse_step = 10L,
#   max_iter = 500L,
#   ncores = 1L,
#   progress = TRUE,
#   a_0_d = a_0_d_rio, b_0_d = b_0_d_rio,
#   a_0_a = a_0_a_rio, b_0_a = b_0_a_rio,
#   a_1_d = 1, b_1_d = 5,
#   a_2_d = 5, b_2_d = 1,
#   a_1_a = a_1_a_rio, b_1_a = b_1_a_rio,
#   a_2_a = a_2_a_rio, b_2_a = b_2_a_rio
# )

## ----eval = FALSE-------------------------------------------------------------
# summary(res_rio_more_informative_design_priors_no_ce)

## ----eval = FALSE-------------------------------------------------------------
# plot(res_rio_more_informative_design_priors_no_ce)

## ----echo = FALSE, out.width = "80%", fig.align = "center", fig.cap = "Figure 5: The calibrated Bayesian two-arm two-stage phase II design with binary endpoints, now using slightly more informative Beta design priors. An interim analysis is carried out at sample sizes of 10 patients per trial arm, and the design is calibrated according to the target constraints of 80% Bayesian power, 2.5% Bayesian type-I-error and 60% probability of compelling evidence for the null hypothesis. The final analysis is carried out after 13 patients have been recruited per trial arm. Note that the expected sample size under the null hypothesis has substantially decreased compared to the earlier optimal design under less informative design priors."----
knitr::include_graphics("figures/optimal-two-stage-design-more-inf-des-priors-no-ce.png")

## ----eval = FALSE-------------------------------------------------------------
# res_rio_onestage_informative_designpriors_no_ce <- design_twoarm_onestage_bf(
#   n_min = 10,
#   n_max = 80,
#   k = 1/10,
#   k_f = 3,
#   test = "BF+0",
#   alloc1 = 0.5,
#   alloc2 = 0.5,
#   calibration = "Bayesian",
#   target_power = 0.8,
#   target_type1 = 0.025,
#   target_freq_power = 0.8,
#   target_freq_type1 = 0.025,
#   p1_grid = seq(0.01, 0.99, 0.02),
#   p2_grid = seq(0.01, 0.99, 0.02),
#   p1_power = 0.4,
#   p2_power = 0.6,
#   power_cushion = 0,
#   sustain_n = 10L,
#   algorithm = "optimal",
#   progress = FALSE,
#   report_freq_type1 = TRUE,
#   a_0_d = a_0_d_rio, b_0_d = b_0_d_rio,
#   a_0_a = a_0_a_rio, b_0_a = b_0_a_rio,
#   a_1_d = 1, b_1_d = 5,
#   a_2_d = 5, b_2_d = 1,
#   a_1_a = a_1_a_rio, b_1_a = b_1_a_rio,
#   a_2_a = a_2_a_rio, b_2_a = b_2_a_rio
# )
# 
# summary(res_rio_onestage_informative_designpriors_no_ce)

## ----eval = FALSE-------------------------------------------------------------
# res_rio_onestage_mod <- design_twoarm_onestage_bf(
#   n_min = 10,
#   n_max = 160,
#   k = 1/10,
#   k_f = 3,
#   test = "BF+0",
#   alloc1 = 0.5,
#   alloc2 = 0.5,
#   calibration = "Bayesian",
#   target_power = 0.9,
#   target_type1 = 0.025,
#   target_ce_h0 = 0,
#   target_freq_power = 0.8,
#   target_freq_type1 = 0.025,
#   p1_grid = seq(0.01, 0.99, 0.02),
#   p2_grid = seq(0.01, 0.99, 0.02),
#   p1_power = 0.4,
#   p2_power = 0.6,
#   sustain_n = 10L,
#   algorithm = "optimal",
#   progress = TRUE,
#   a_0_d = a_0_d_rio, b_0_d = b_0_d_rio,
#   a_0_a = a_0_a_rio, b_0_a = b_0_a_rio,
#   a_1_d = 1, b_1_d = 3,
#   a_2_d = 3, b_2_d = 1,
#   a_1_a = a_1_a_rio, b_1_a = b_1_a_rio,
#   a_2_a = a_2_a_rio, b_2_a = b_2_a_rio
# )

## ----eval = FALSE-------------------------------------------------------------
# print(res_rio_onestage_mod)

## ----eval = FALSE-------------------------------------------------------------
# plot(res_rio_onestage_mod)

## ----echo = FALSE, out.width = "80%", fig.align = "center", fig.cap = "Figure 6: The calibrated Bayesian two-arm one-stage phase II design with binary endpoints, now using slightly more informative Beta design priors. The design is calibrated according to the target constraints of 90% Bayesian power and 2.5% Bayesian type-I-error."----
knitr::include_graphics("figures/optimal-twoarm-twostage-vignette-fixed-design-ss-reduc.png")

## ----eval = FALSE-------------------------------------------------------------
# res_rio_twostage_anchor_near <- design_twoarm_twostage_bf(
#   n1_min = c(10, 10),
#   n2_max = c(150, 150),
#   alloc1 = 0.5,
#   alloc2 = 0.5,
#   k = 1/10,
#   k_f = 3,
#   test = "BF+0",
#   calibration = "Bayesian",
#   calibration_en = "Bayesian",
#   target_power = 0.9,
#   target_type1 = 0.025,
#   target_ce_h0 = 0,        # CE(H0) not constrained in step 1
#   target_freq_power = 0.8,
#   target_freq_type1 = 0.025,
#   power_cushion = 0,       # crucial for matching the anchor
#   interim_fraction = c(0, 1),
#   grid_step = 1L,
#   coarse_step = 10L,
#   max_iter = 500L,
#   ncores = 9,
#   progress = TRUE,
#   a_0_d = a_0_d_rio, b_0_d = b_0_d_rio,
#   a_0_a = a_0_a_rio, b_0_a = b_0_a_rio,
#   a_1_d = 1, b_1_d = 3,
#   a_2_d = 3, b_2_d = 1,
#   a_1_a = a_1_a_rio, b_1_a = b_1_a_rio,
#   a_2_a = a_2_a_rio, b_2_a = b_2_a_rio
# )

## ----eval = FALSE-------------------------------------------------------------
# plot(res_rio_twostage_anchor_near)

## ----echo = FALSE, out.width = "80%", fig.align = "center", fig.cap = "Figure 7: The calibrated Bayesian two-arm two-stage phase II design with binary endpoints, now using slightly more informative Beta design priors. The design is calibrated according to the target constraints of 90% Bayesian power and 2.5% Bayesian type-I-error."----
knitr::include_graphics("figures/optimal-twoarm-twostage-vignette-twostage-opt-des-ss-reduc.png")

## ----eval = FALSE-------------------------------------------------------------
# print(res_rio_twostage_anchor_near)

