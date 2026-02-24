#' Two-arm binomial Bayes factor BF01
#'
#' Computes the Bayes factor BF\eqn{_{01}} comparing the point-null
#' \eqn{H_0: p_1 = p_2} to the alternative \eqn{H_1: p_1 \neq p_2}
#' in a two-arm binomial setting with Beta priors.
#'
#' @param y1 Number of successes in arm 1 (control).
#' @param y2 Number of successes in arm 2 (treatment).
#' @param n1 Sample size in arm 1.
#' @param n2 Sample size in arm 2.
#' @param a_0_a,b_0_a Shape parameters of the Beta prior for the common-\eqn{p}
#'   under the null model.
#' @param a_1_a,b_1_a Shape parameters of the Beta prior for \eqn{p_1} under the
#'   alternative.
#' @param a_2_a,b_2_a Shape parameters of the Beta prior for \eqn{p_2} under the
#'   alternative.
#'
#' @return Numeric scalar, the Bayes factor BF\eqn{_{01}}.
#' @export
#'
#' @examples
#' twoarmbinbf01(10, 20, 30, 30)
twoarmbinbf01 <- function(y1, y2, n1, n2,
                          a_0_a = 1, b_0_a = 1,
                          a_1_a = 1, b_1_a = 1,
                          a_2_a = 1, b_2_a = 1) {
  numerator <- beta(a_0_a + y1 + y2,
                    b_0_a + n1 + n2 - y1 - y2) / beta(a_0_a, b_0_a)
  
  denominator <- (beta(a_1_a + y1, b_1_a + n1 - y1) *
                    beta(a_2_a + y2, b_2_a + n2 - y2)) /
    (beta(a_1_a, b_1_a) * beta(a_2_a, b_2_a))
  
  numerator / denominator
}

#' Prior probability P(p2 > p1) under independent Beta priors
#'
#' @param a_1_d,b_1_d Shape parameters of the Beta prior for \eqn{p_1}.
#' @param a_2_d,b_2_d Shape parameters of the Beta prior for \eqn{p_2}.
#'
#' @return Numeric scalar, prior probability P(p2 > p1).
#' @export
priorProbHplus <- function(a_1_d, b_1_d, a_2_d, b_2_d) {
  integrand <- function(p2) {
    dbeta_p2 <- stats::dbeta(p2, a_2_d, b_2_d)
    pbeta_p2 <- stats::pbeta(p2, a_1_d, b_1_d)
    dbeta_p2 * pbeta_p2
  }
  stats::integrate(integrand, lower = 0, upper = 1, rel.tol = 1e-4)$value
}

#' Prior probability P(p2 <= p1) under independent Beta priors
#'
#' @inheritParams priorProbHplus
#'
#' @return Numeric scalar, prior probability P(p2 <= p1).
#' @export
priorProbHminus <- function(a_1_d, b_1_d, a_2_d, b_2_d) {
  1 - priorProbHplus(a_1_d, b_1_d, a_2_d, b_2_d)
}

#' Posterior probability P(p2 > p1 | data) under independent Beta priors
#'
#' @inheritParams twoarmbinbf01
#' @param a_1_d,b_1_d Design-prior shape parameters for \eqn{p_1}.
#' @param a_2_d,b_2_d Design-prior shape parameters for \eqn{p_2}.
#'
#' @return Numeric scalar, posterior probability \eqn{P(p_2 > p_1 | y_1, y_2)}.
#' @export
postProbHplus <- function(y1, y2, n1, n2,
                          a_1_d = 1, b_1_d = 1,
                          a_2_d = 1, b_2_d = 1) {
  integrand <- function(p2) {
    dbeta_p2 <- stats::dbeta(p2, a_2_d + y2, b_2_d + n2 - y2)
    pbeta_p2 <- stats::pbeta(p2, a_1_d + y1, b_1_d + n1 - y1)
    dbeta_p2 * pbeta_p2
  }
  stats::integrate(integrand, lower = 0, upper = 1, rel.tol = 1e-4)$value
}

#' Posterior probability P(p2 <= p1 | data)
#'
#' @inheritParams postProbHplus
#'
#' @return Numeric scalar, posterior probability \eqn{P(p_2 <= p_1 | y_1, y_2)}.
#' @export
postProbHminus <- function(y1, y2, n1, n2,
                           a_1_d = 1, b_1_d = 1,
                           a_2_d = 1, b_2_d = 1) {
  1 - postProbHplus(y1, y2, n1, n2, a_1_d, b_1_d, a_2_d, b_2_d)
}

#' Bayes factor BF+1: H+ vs H1
#'
#' @inheritParams postProbHplus
#'
#' @return Numeric scalar, BF\eqn{_{+1}} = posterior odds / prior odds for H+ vs H1.
#' @export
BFplus1 <- function(y1, y2, n1, n2,
                    a_1_d = 1, b_1_d = 1,
                    a_2_d = 1, b_2_d = 1) {
  postProbHplus(y1, y2, n1, n2, a_1_d, b_1_d, a_2_d, b_2_d) /
    priorProbHplus(a_1_d, b_1_d, a_2_d, b_2_d)
}

#' Bayes factor BF-1: H- vs H1
#'
#' @inheritParams postProbHplus
#'
#' @return Numeric scalar, BF\eqn{_{-1}}.
#' @export
BFminus1 <- function(y1, y2, n1, n2,
                     a_1_d = 1, b_1_d = 1,
                     a_2_d = 1, b_2_d = 1) {
  postProbHminus(y1, y2, n1, n2, a_1_d, b_1_d, a_2_d, b_2_d) /
    priorProbHminus(a_1_d, b_1_d, a_2_d, b_2_d)
}

#' Bayes factor BF+0: H+ vs H0
#'
#' @param BFplus1 Value of BF\eqn{_{+1}}.
#' @param BF01 Value of BF\eqn{_{01}}.
#'
#' @return Numeric scalar, BF\eqn{_{+0}}.
#' @export
BFplus0 <- function(BFplus1, BF01) {
  BFplus1 / BF01
}

#' Bayes factor BF-0: H- vs H0
#'
#' @param BFminus1 Value of BF\eqn{_{-1}}.
#' @param BF01 Value of BF\eqn{_{01}}.
#'
#' @return Numeric scalar, BF\eqn{_{-0}}.
#' @export
BFminus0 <- function(BFminus1, BF01) {
  BFminus1 / BF01
}

#' Bayes factor BF+-: H+ vs H-
#'
#' @param BFplus1 Value of BF\eqn{_{+1}}.
#' @param BFminus1 Value of BF\eqn{_{-1}}.
#'
#' @return Numeric scalar, BF\eqn{_{+-}}.
#' @export
BFplusMinus <- function(BFplus1, BFminus1) {
  BFplus1 / BFminus1
}
