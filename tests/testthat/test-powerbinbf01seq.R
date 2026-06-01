## seq_checks_singlearm.R

res <- powerbinbf01seq(
  n1 = 12,
  n2 = 28,
  k = 1/10,
  kf = 3,
  p0 = 0.2,
  a = 1, b = 1,
  da = 1, db = 1,
  dl = 0.2, du = 1,
  type = "direction",
  k_ce = 10
)

stopifnot(res$pfineff  <= res$pnaive  + 1e-12)
stopifnot(res$pfineff0 <= res$pnaive0 + 1e-12)
stopifnot(res$perased  >= -1e-12)
stopifnot(res$perased0 >= -1e-12)
stopifnot(res$nexp  >= res$n1 - 1e-12 && res$nexp  <= res$n2 + 1e-12)
stopifnot(res$nexp0 >= res$n1 - 1e-12 && res$nexp0 <= res$n2 + 1e-12)

if (!is.na(res$pce0_naive) && !is.na(res$pce0_corr)) {
  stopifnot(res$pce0_corr >= res$pce0_naive - 1e-12)
}