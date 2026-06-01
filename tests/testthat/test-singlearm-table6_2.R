test_that("single-arm Example 1 designs match Table 6.2 (selected rows)", {
  tol <- 5e-4
  p0  <- 0.2
  p1  <- 0.4
  
  # Frequentist power row: k=1/3, kf=3
  res1 <- powerbinbf01seq(
    n1   = 17, n2   = 37,
    k    = 1/3, kf  = 3,
    p0   = p0,
    a    = 1, b    = 1,
    dp   = p1,
    da   = 1, db   = 1,
    dl   = 0.2, du = 1,
    type = "direction",
    k_ce = 3
  )
  
  expect_lt(abs(res1$pfineff0 - 0.0948), tol)
  expect_lt(abs(res1$pfineff  - 0.9033), tol)
  expect_lt(abs(res1$nexp0    - 26.02), tol)
  expect_lt(abs(res1$pce0_corr - 0.6681), tol)
  
  # Bayesian power row: k=1/10, kf=3, Beta_[0.2,1](1,1)
  res2 <- powerbinbf01seq(
    n1   = 42, n2   = 100,
    k    = 1/10, kf = 3,
    p0   = p0,
    a    = 1, b    = 1,
    dp   = NA_real_,
    da   = 1, db   = 1,
    dl   = 0.2, du = 1,
    type = "direction",
    k_ce = 3
  )
  
  expect_lt(abs(res2$pfineff0 - 0.0325), tol)
  expect_lt(abs(res2$pfineff  - 0.9002), tol)
  expect_lt(abs(res2$nexp0    - 69.21), tol)
  expect_lt(abs(res2$pce0_corr - 0.6814), tol)
})