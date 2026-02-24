#' bfbin2arm: Bayesian Power for Two-Arm Binomial Bayes Factors
#'
#' Functions for Bayesian power and sample size calculation in two-arm binomial
#' trials using Bayes factors for point-null and directional hypotheses.
#'
#' @keywords internal
#' @importFrom stats integrate dbeta pbeta dbinom density lbeta lchoose
#' @importFrom utils flush.console globalVariables
#' @importFrom ggplot2 ggplot aes geom_line geom_hline geom_vline annotate labs 
#'   theme_minimal theme element_text scale_color_manual coord_cartesian 
#'   facet_grid scale_linetype_manual guides guide_legend unit element_blank labeller label_parsed
#' @importFrom dplyr `%>%`
#' @importFrom patchwork plot_layout
NULL

utils::globalVariables(c("n", "power", "t1e", "pceH0", "freq_power", 
                         "x", "density", "prior_type"))
