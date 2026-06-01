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

## -----------------------------------------------------------------------------
library(bfbin2arm)

## -----------------------------------------------------------------------------
## -------------------------------------------------------------
## 2. ICT-107 trial (immunologic response)
##    Placebo (control): 12 responders, 31 non-responders
##    ICT-107 (treatment): 49 responders, 32 non-responders  
## -------------------------------------------------------------

y1_ict <- 12      # control successes
n1_ict <- 12 + 31
y2_ict <- 49      # treatment successes
n2_ict <- 49 + 32

cat("\n=== ICT-107 Trial (n1 =", n1_ict, ", n2 =", n2_ict, ") ===\n")

# BF01
BF01_ict = twoarmbinbf01(y1_ict, y2_ict, n1_ict, n2_ict, 
                         a_0_a = 1, b_0_a = 1, 
                         a_1_a = 1, b_1_a = 1, 
                         a_2_a = 1, b_2_a = 1)

# BF+1
BFp1_ict = BFplus1(y1_ict, y2_ict, n1_ict, n2_ict, 
                   a_1_a = 1, b_1_a = 1, 
                   a_2_a = 1, b_2_a = 1)

# BF-1
BFm1_ict = BFminus1(y1_ict, y2_ict, n1_ict, n2_ict, 
                    a_1_a = 1, b_1_a = 1, 
                    a_2_a = 1, b_2_a = 1)

# BF+0
cat("=== ICT-107 Trial === Bayes factor BF+0 results in ", BFplus0(BFp1_ict, BF01_ict))

# BF+-
cat("=== ICT-107 Trial === Bayes factor BF+- results in ", BFplusMinus(BFp1_ict, BFm1_ict))

## ----eval = FALSE-------------------------------------------------------------
# ict_results <- powertwoarmbinbf01(
#   n1 = n1_ict, n2 = n2_ict,
#   k = 1/3, k_f = 3,
#   test = "BF+-",  # H+: p2 > p1 vs H-: p2 <= p1
#   a_0_d = 1, b_0_d = 1, a_0_a = 1, b_0_a = 1,
#   a_1_d = 1, b_1_d = 1, a_2_d = 1, b_2_d = 1,
#   a_1_a = 1, b_1_a = 1, a_2_a = 1, b_2_a = 1,
#   output = "numeric",
#   compute_freq_t1e = TRUE,
# )
# print(ict_results)

## ----out.width = "80%", out.height="500px", eval = FALSE, cache = TRUE--------
# des <- design_twoarm_onestage_bf(
#   n_min = 10,
#   n_max = 75,
#   k = 1/10,
#   k_f = 10,
#   test = "BF+-",
#   calibration = "Bayesian",
#   target_power = 0.80,
#   target_type1 = 0.05,
#   target_ce_h0 = 0.80,
#   # design and analysis priors: flat Beta(1,1) everywhere
#   a_0_d = 1, b_0_d = 1,
#   a_0_a = 1, b_0_a = 1,
#   a_1_d = 1, b_1_d = 1,
#   a_2_d = 1, b_2_d = 1,
#   a_1_a = 1, b_1_a = 1,
#   a_2_a = 1, b_2_a = 1,
#   # assumed true proportions for frequentist power (optional here)
#   p1_power = 0.3, p2_power = 0.6,
#   # equal randomisation
#   alloc1 = 0.5,
#   alloc2 = 0.5,
#   # require sustained feasibility over the next 10 larger n
#   sustain_n = 10L,
#   progress = FALSE
# )

## ----eval = FALSE-------------------------------------------------------------
# summary(des)

## ----out.width="80%", out.height="600px", eval = FALSE------------------------
# plot(des, type = "old")

## ----echo = FALSE, out.width = "80%", fig.align = "center", fig.cap = "Figure 1: Visualization of the calibrated Bayesian two-arm one-stage phase II design with a binary endpoint"----
knitr::include_graphics("figures/twoarm_onestage_fig1.png")

## ----eval = FALSE, out.width="80%", cache = TRUE------------------------------
# des_legacy <- ntwoarmbinbf01(
#   k = 1/10, k_f = 10,
#   power = 0.8, alpha = 0.05, pce_H0 = 0.8,
#   test = "BF+-",
#   nrange = c(10, 75), n_step = 1,
#   progress = FALSE,
#   compute_freq_t1e = TRUE,
#   p1_power = 0.3, p2_power = 0.6,
#   alloc1 = 0.5, alloc2 = 0.5,
#   output = "numeric"
# )

## ----eval = FALSE-------------------------------------------------------------
# plot(des_legacy, type = "old")

## ----echo = FALSE, out.width = "80%", fig.align = "center", fig.cap = "Figure 2: Visualization of the calibrated Bayesian two-arm one-stage phase II design with a binary endpoint"----
knitr::include_graphics("figures/twoarm_onestage_fig2.png")

## ----out.width='80%', cache = TRUE, eval = FALSE------------------------------
# des_informative <- design_twoarm_onestage_bf(
#   n_min = 10,
#   n_max = 100,
#   k = 1/30,
#   k_f = 30,
#   test = "BF+-",
#   calibration = "Bayesian",
#   target_power = 0.80,
#   target_type1 = 0.05,
#   target_ce_h0 = 0.60,
#   # design and analysis priors: flat Beta(1,1) everywhere
#   a_0_d = 1, b_0_d = 1,
#   a_0_a = 1, b_0_a = 1,
#   a_1_d = 1, b_1_d = 2,
#   a_2_d = 2, b_2_d = 1,
#   a_1_a = 1, b_1_a = 1,
#   a_2_a = 1, b_2_a = 1,
#   # assumed true proportions for frequentist power (optional here)
#   p1_power = 0.3, p2_power = 0.6,
#   # report frequentist type-I-error? (optional here)
#   report_freq_type1 = TRUE,
#   # equal randomisation
#   alloc1 = 0.5,
#   alloc2 = 0.5,
#   # require sustained feasibility over the next 10 larger n
#   sustain_n = 10L,
#   progress = FALSE
# )

## ----eval = FALSE-------------------------------------------------------------
# summary(des_informative)

## ----sustain-logic-schematic, out.width = "80%", echo = FALSE, fig.align = "center"----
library(ggplot2)

# Illustrative total sample sizes
ns <- 68:86

# Hand-crafted operating characteristic:
# first crosses the target, then drops below, then rises and stays above
oc_vals <- c(
  0.72, 0.75, 0.78, 0.81, 0.79, 0.77, 0.78, 0.79, 0.80,
  0.82, 0.84, 0.85, 0.86, 0.87, 0.87, 0.88, 0.88, 0.89, 0.89
)

target <- 0.80
sustain_n <- 4L
window_len <- sustain_n + 1L

first_sustained_index <- function(ok_vec, sustain_n) {
  n <- length(ok_vec)
  if (n == 0L) return(NA_integer_)
  for (i in seq_len(n)) {
    j <- min(n, i + sustain_n)
    win <- ok_vec[i:j]
    if (length(win) > 0L && all(!is.na(win)) && all(win)) {
      return(i)
    }
  }
  NA_integer_
}

ok_pointwise <- oc_vals >= target
i_first_pointwise <- which(ok_pointwise)[1L]
i_first_sustained <- first_sustained_index(ok_pointwise, sustain_n)

n_first_pointwise <- ns[i_first_pointwise]
n_first_sustained <- ns[i_first_sustained]
n_window_max <- ns[min(length(ns), i_first_sustained + sustain_n)]

df <- data.frame(
  n_total = ns,
  oc = oc_vals,
  pointwise_ok = ok_pointwise
)

ggplot(df, aes(x = n_total, y = oc)) +
  annotate(
    "rect",
    xmin = n_first_sustained - 0.5,
    xmax = n_window_max + 0.5,
    ymin = -Inf,
    ymax = Inf,
    fill = "steelblue",
    alpha = 0.08
  ) +
  geom_hline(
    yintercept = target,
    linetype = "dashed",
    colour = "grey35",
    linewidth = 0.8
  ) +
  geom_line(colour = "grey35", linewidth = 0.9) +
  geom_point(aes(colour = pointwise_ok), size = 2.4) +
  geom_vline(
    xintercept = n_first_pointwise,
    colour = "#d95f02",
    linetype = "dotted",
    linewidth = 0.9
  ) +
  geom_vline(
    xintercept = n_first_sustained,
    colour = "#1b3a57",
    linewidth = 1.1
  ) +
  annotate(
    "text",
    x = n_first_pointwise,
    y = 0.715,
    label = paste0("first pointwise crossing\nn = ", n_first_pointwise),
    colour = "#d95f02",
    size = 3.2,
    hjust = -0.02,
    vjust = 1
  ) +
  annotate(
    "text",
    x = n_first_sustained,
    y = 0.905,
    label = paste0("first sustained crossing\nn = ", n_first_sustained),
    colour = "#1b3a57",
    size = 3.2,
    hjust = -0.02,
    vjust = 1
  ) +
  annotate(
    "text",
    x = (n_first_sustained + n_window_max) / 2,
    y = 0.735,
    label = paste0("forward window: sustain_n + 1 = ", window_len),
    colour = "#1b3a57",
    size = 3.1
  ) +
  scale_colour_manual(
    values = c(`TRUE` = "#2c7fb8", `FALSE` = "#d7301f"),
    labels = c(`FALSE` = "Below target", `TRUE` = "At or above target"),
    name = NULL
  ) +
  scale_x_continuous(breaks = ns) +
  coord_cartesian(ylim = c(0.70, 0.92)) +
  labs(
    x = "Total sample size",
    y = "Operating characteristic",
    title = "Illustration of sustained feasibility"
  ) +
  theme_minimal(base_size = 11) +
  theme(
    plot.title = element_text(hjust = 0.5),
    legend.position = "bottom",
    panel.grid.minor = element_blank()
  )

## ----out.width="80%", eval = FALSE--------------------------------------------
# plot(des_informative)

## ----echo = FALSE, out.width = "80%", fig.align = "center", fig.cap = "Figure 3: Visualization of the calibrated Bayesian two-arm one-stage phase II design with a binary endpoint, using informative design priors under the alternative hypothesis"----
knitr::include_graphics("figures/twoarm_onestage_fig3.png")

## ----eval = FALSE-------------------------------------------------------------
# print(des_informative)

## ----out.width='80%', cache = TRUE, eval = FALSE------------------------------
# des_informative_higher_ce <- design_twoarm_onestage_bf(
#   n_min = 10,
#   n_max = 100,
#   k = 1/30,
#   k_f = 30,
#   test = "BF+-",
#   calibration = "Bayesian",
#   target_power = 0.80,
#   target_type1 = 0.05,
#   target_ce_h0 = 0.80,
#   # design and analysis priors: flat Beta(1,1) everywhere
#   a_0_d = 1, b_0_d = 1,
#   a_0_a = 1, b_0_a = 1,
#   a_1_d = 1, b_1_d = 2,
#   a_2_d = 2, b_2_d = 1,
#   a_1_a = 1, b_1_a = 1,
#   a_2_a = 1, b_2_a = 1,
#   # design prior parameters under H_-
#   a_1_d_Hminus = 2, b_1_d_Hminus = 1,
#   a_2_d_Hminus = 1, b_2_d_Hminus = 2,
#   # assumed true proportions for frequentist power (optional here)
#   p1_power = 0.3, p2_power = 0.6,
#   # report frequentist type-I-error? (optional here)
#   report_freq_type1 = TRUE,
#   # equal randomisation
#   alloc1 = 0.5,
#   alloc2 = 0.5,
#   # require sustained feasibility over the next 10 larger n
#   sustain_n = 10L,
#   progress = FALSE
# )

## ----eval = FALSE-------------------------------------------------------------
# summary(des_informative_higher_ce)

## ----eval = FALSE-------------------------------------------------------------
# plot(des_informative_higher_ce)

## ----echo = FALSE, out.width = "80%", fig.align = "center", fig.cap = "Figure 4: Visualization of the calibrated Bayesian two-arm one-stage phase II design with a binary endpoint, using informative design priors under both hypotheses and a stronger requirement on the probability of compelling evidence (80% instead of only 60%)"----
knitr::include_graphics("figures/twoarm_onestage_fig4.png")

## ----eval = FALSE-------------------------------------------------------------
# print(des_informative_higher_ce)

## ----out.width='80%', cache = TRUE, eval = FALSE------------------------------
# des_informative_higher_ce_uneq_alloc <- design_twoarm_onestage_bf(
#   n_min = 10,
#   n_max = 100,
#   k = 1/30,
#   k_f = 30,
#   test = "BF+-",
#   calibration = "Bayesian",
#   target_power = 0.80,
#   target_type1 = 0.05,
#   target_ce_h0 = 0.80,
#   # design and analysis priors: flat Beta(1,1) everywhere
#   a_0_d = 1, b_0_d = 1,
#   a_0_a = 1, b_0_a = 1,
#   a_1_d = 1, b_1_d = 2,
#   a_2_d = 2, b_2_d = 1,
#   a_1_a = 1, b_1_a = 1,
#   a_2_a = 1, b_2_a = 1,
#   # design prior parameters under H_-
#   a_1_d_Hminus = 2, b_1_d_Hminus = 1,
#   a_2_d_Hminus = 1, b_2_d_Hminus = 2,
#   # assumed true proportions for frequentist power (optional here)
#   p1_power = 0.3, p2_power = 0.6,
#   # report frequentist type-I-error? (optional here)
#   report_freq_type1 = TRUE,
#   # equal randomisation
#   alloc1 = 1/3,
#   alloc2 = 2/3,
#   # require sustained feasibility over the next 10 larger n
#   sustain_n = 10L,
#   progress = FALSE
# )

## ----eval = FALSE-------------------------------------------------------------
# summary(des_informative_higher_ce_uneq_alloc)

## ----eval = FALSE-------------------------------------------------------------
# plot(des_informative_higher_ce_uneq_alloc)

## ----echo = FALSE, out.width = "80%", fig.align = "center", fig.cap = "Figure 5: Visualization of the calibrated Bayesian two-arm one-stage phase II design with a binary endpoint, using informative design priors under both hypotheses and a stronger requirement on the probability of compelling evidence (80% instead of only 60%). Additionally, unequal randomization probabilities are used when calibrating the design."----
knitr::include_graphics("figures/twoarm_onestage_fig5.png")

## ----eval = FALSE-------------------------------------------------------------
# print(des_informative_higher_ce_uneq_alloc)

