test_that("single-arm CE correction matches explicit double-sum", {
  n1  <- 17
  n2  <- 37
  p0  <- 0.2
  kce <- 3
  
  bf_int <- singlearm_bf01(
    x   = 0:n1,
    n   = n1,
    p0  = p0,
    a   = 1, b = 1,
    type = "direction"
  )
  bf_fin <- singlearm_bf01(
    x   = 0:n2,
    n   = n2,
    p0  = p0,
    a   = 1, b = 1,
    type = "direction"
  )
  
  # fixed-sample CE at n2
  pce_naive_manual <- sum(dbinom(0:n2, size = n2, prob = p0)[bf_fin >= kce])
  
  # delta_CE0^{(1arm)} as in the remark
  delta_ce0_manual <- 0
  for (x in 0:n1) {
    if (bf_int[x + 1L] >= kce) {
      for (z in 0:(n2 - n1)) {
        y <- x + z
        if (bf_fin[y + 1L] < kce) {
          delta_ce0_manual <- delta_ce0_manual +
            dbinom(x, size = n1, prob = p0) *
            dbinom(z, size = n2 - n1, prob = p0)
        }
      }
    }
  }
  
  res <- powerbinbf01seq(
    n1   = n1,
    n2   = n2,
    k    = 1/3,
    kf   = 3,
    p0   = p0,
    a    = 1, b = 1,
    da   = 1, db = 1,
    dl   = 0.2, du = 1,
    type = "direction",
    k_ce = kce
  )
  
  expect_lt(abs(res$pce0_naive - pce_naive_manual), 1e-12)
  expect_lt(abs(res$pce0_corr  - (pce_naive_manual + delta_ce0_manual)), 1e-12)
})