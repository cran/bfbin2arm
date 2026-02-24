## ----echo = FALSE-------------------------------------------------------------
knitr::opts_chunk$set(
collapse = TRUE,
comment = "#>",
fig.width = 10,
fig.height = 6,
out.width = "100%",
fig.align = "center",
dpi = 300,
warning = FALSE
)

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
                   a_1_d = 1, b_1_d = 1, 
                   a_2_d = 1, b_2_d = 1)

# BF-1
BFm1_ict = BFminus1(y1_ict, y2_ict, n1_ict, n2_ict, 
                    a_1_d = 1, b_1_d = 1, 
                    a_2_d = 1, b_2_d = 1)

# BF+0
cat("=== ICT-107 Trial === Bayes factor BF+0 results in ", BFplus0(BFp1_ict, BF01_ict))

# BF+-
cat("=== ICT-107 Trial === Bayes factor BF+- results in ", BFplusMinus(BFp1_ict, BFm1_ict))

## -----------------------------------------------------------------------------
ict_results <- powertwoarmbinbf01(
  n1 = n1_ict, n2 = n2_ict,
  k = 1/3, k_f = 3,
  test = "BF+-",  # H+: p2 > p1 vs H-: p2 <= p1
  a_0_d = 1, b_0_d = 1, a_0_a = 1, b_0_a = 1,
  a_1_d = 1, b_1_d = 1, a_2_d = 1, b_2_d = 1,
  a_1_a = 1, b_1_a = 1, a_2_a = 1, b_2_a = 1,
  output = "numeric",
  compute_freq_t1e = TRUE,
)
print(ict_results)

## ----fig.width = 12, fig.height = 7-------------------------------------------
ntwoarmbinbf01(
  k = 1/10, k_f = 10,
  power = 0.8, alpha = 0.05, pce_H0 = 0.8,
  test = "BF+-",
  nrange = c(10, 75), n_step = 1,
  progress = FALSE,
  compute_freq_t1e = TRUE,
  p1_power = 0.3, p2_power = 0.6,
  output = "plot"  # Returns recommended n per group
)

## ----out.width='100%'---------------------------------------------------------
ntwoarmbinbf01(
  k = 1/30, k_f = 30,
  power = 0.8, alpha = 0.05, pce_H0 = 0.8,
  test = "BF+-",
  nrange = c(10, 100), n_step = 1,
  progress = FALSE,
  a_1_d = 1, b_1_d = 2,
  a_2_d = 2, b_2_d = 1,
  compute_freq_t1e = TRUE,
  p1_power = 0.3, p2_power = 0.6,
  output = "plot"  # Returns recommended n per group
)

## ----out.width='80%'----------------------------------------------------------
ntwoarmbinbf01(
  k = 1/30, k_f = 30,
  power = 0.8, alpha = 0.05, pce_H0 = 0.8,
  test = "BF+-",
  nrange = c(10, 100), n_step = 1,
  progress = TRUE,
  a_1_d = 1, b_1_d = 2,
  a_2_d = 2, b_2_d = 1,
  a_1_d_Hminus = 2, b_1_d_Hminus = 1,
  a_2_d_Hminus = 1, b_2_d_Hminus = 2,
  compute_freq_t1e = TRUE,
  p1_power = 0.3, p2_power = 0.6,
  output = "plot"  # Returns recommended n per group
)

## ----out.width='80%'----------------------------------------------------------
ntwoarmbinbf01(
  k = 1/30, k_f = 30,
  power = 0.8, alpha = 0.05, pce_H0 = 0.8,
  test = "BF+-",
  nrange = c(10, 100), n_step = 1,
  progress = FALSE,
  a_1_d = 1, b_1_d = 2,
  a_2_d = 2, b_2_d = 1,
  a_1_d_Hminus = 2, b_1_d_Hminus = 1,
  a_2_d_Hminus = 1, b_2_d_Hminus = 2,
  compute_freq_t1e = TRUE,
  p1_power = 0.3, p2_power = 0.6,
  output = "plot",  # Returns recommended n per group
  alloc1 = 1/3,
  alloc2 = 2/3
)

## -----------------------------------------------------------------------------
pred_H0 <- predictiveDensityH0(y1_ict, y2_ict, n1_ict, n2_ict)
pred_H1 <- predictiveDensityH1(y1_ict, y2_ict, n1_ict, n2_ict)
pred_Hplus <- predictiveDensityHplus_trunc(y1_ict, y2_ict, n1_ict, n2_ict)

data.frame(
Hypothesis = c("H0: p1=p2", "H1: p1 != p2", "H+: p2>p1"),
"Pred. Density" = round(c(pred_H0, pred_H1, pred_Hplus), 4)
)

