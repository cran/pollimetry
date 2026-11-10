#' @name bodysize
#' @title Predict bee and hoverfly dry body weight
#' @description Predict dry body weight (mg) from intertegular distance and covariates using the fitted models of Kendall et al. (2019).
#' @param x A nonempty data frame with positive, finite ITD measurements in mm. Sex (Female or Male) is required except for type = "ITD". Taxonomic models also require Family for bees or Subfamily for hoverflies. Accepted hoverfly subfamilies are Eristalinae, Pipizinae and Syrphinae. Optional grouping columns are Region and Species (Genus_species); Species requires Region. The phylogenetic model requires both Region and Species.
#' @param taxa One string: "bee" or "hov".
#' @param type One string: "taxo", "sex", "ITD", or "phylo" (bees only).
#' @return The input data frame with Est.Weight and 95 percent Bayesian credible intervals (CI_Lower and CI_Upper) appended, in mg.
#' @details With Region and Species, both fitted grouping effects are included. With Region alone, the regional effect is included. Population-level predictions use group effects set to zero. Species requires Region because the fitted species effect is nested within Region. New grouping levels use brms uncertainty sampling from existing levels. Fixed-effect categories must be supported by the fitted model. Estimates are back-transformed means with 95 percent Bayesian credible intervals, expressed in milligrams. Uses fitted models from pollimetrydata (>= 1.0.1) when installed, or downloads the required models from GitHub and caches them for the current R session.
#' @examples
#' if (requireNamespace("pollimetrydata", quietly = TRUE) &&
#' utils::packageVersion("pollimetrydata") >= "1.0.1") {
#'   x <- data.frame(ITD = c(1.5, 2), Sex = c("Female", "Male"),
#'                   Subfamily = c("Pipizinae", "Syrphinae"))
#'   bodysize(x, taxa = "hov", type = "taxo")
#' }
#' @references Kendall et al. (2019). Pollinator size and its consequences: Robust estimates of body size in pollinating insects. Ecology and Evolution, 9, 1702-1714. \doi{10.1002/ece3.4835}.
#' @export
bodysize <- function(x, taxa, type) {
  taxa <- .choice(taxa, c("bee", "hov"), "taxa")
  type <- .choice(type, c("taxo", "phylo", "sex", "ITD"), "type")
  if (taxa == "hov" && type == "phylo")
    stop("No phylogenetic model is implemented for hoverflies.", call. = FALSE)
  required <- c("ITD", if (type != "ITD") "Sex",
                if (type == "taxo") if (taxa == "bee") "Family" else "Subfamily",
                if (type == "phylo") c("Species", "Region"))
  .frame(x, required, "x")
  .positive(x$ITD, "ITD")
  if ("Sex" %in% names(x)) .levels(x$Sex, c("Female", "Male"), "Sex")
  if (type == "taxo") {
    if (taxa == "bee") .levels(x$Family, c("Andrenidae", "Apidae", "Colletidae",
      "Halictidae", "Melittidae", "Megachilidae"), "Family")
    else .levels(x$Subfamily, c("Eristalinae", "Pipizinae", "Syrphinae"), "Subfamily")
  }
  for (nm in intersect(c("Species", "Region"), names(x))) .groups(x[[nm]], nm)
  species <- "Species" %in% names(x)
  region <- "Region" %in% names(x)
  if (species && !region)
    stop("Supply Region with Species: the model uses Species nested within Region.", call. = FALSE)
  re <- if (species && region) NULL else if (region) ~(1 | Region) else NA
  models <- c(bee_taxo = "bee_tax_mod", bee_phylo = "bee_phy_mod", bee_sex = "bee_sex",
              bee_ITD = "bee_IT", hov_taxo = "hov_tax_mod", hov_sex = "hov_sex", hov_ITD = "hov_IT")
  mod <- .model(models[[paste(taxa, type, sep = "_")]])
  for (nm in intersect(c("Species", "Region"), names(x))) {
    if (any(!as.character(x[[nm]]) %in% as.character(mod$data[[nm]])))
      warning("New ", nm, " levels use the existing model's group-level uncertainty.", call. = FALSE)
  }
  newdata <- x
  newdata$IT <- x$ITD
  mu <- brms::posterior_epred(mod, newdata = newdata,
                              allow_new_levels = TRUE,
                              sample_new_levels = "uncertainty", re_formula = re)
  bounds <- t(apply(exp(mu), 2L, stats::quantile,
                    probs = c(0.025, 0.975), names = FALSE))
  out <- data.frame(Estimate = exp(colMeans(mu)),
                    Q2.5 = bounds[, 1L], Q97.5 = bounds[, 2L])
  names(out) <- c("Est.Weight", "CI_Lower", "CI_Upper")
  cbind(x, out)
}
