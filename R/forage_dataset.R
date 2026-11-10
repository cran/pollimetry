#' Bee foraging range measurements.
#'
#' A dataset of 425 foraging range estimates, with body size, sociality, taxonomic and study metadata.
#' @format A data frame with 425 rows and 23 columns.
#' \describe{
#' \item{\code{publication}}{Source publication.}
#' \item{\code{year}}{Publication year.}
#' \item{\code{region}}{Geographical region.}
#' \item{\code{country}}{Study country.}
#' \item{\code{habitat}}{Study habitat.}
#' \item{\code{family}}{Bee family.}
#' \item{\code{genus}}{Bee genus.}
#' \item{\code{species}}{Bee species.}
#' \item{\code{sex}}{Bee sex.}
#' \item{\code{range.type}}{Foraging range category.}
#' \item{\code{measure.type}}{Potential or realized range.}
#' \item{\code{metric}}{Method used to measure foraging range.}
#' \item{\code{N}}{Reported sample size.}
#' \item{\code{distance}}{Reported foraging distance in metres.}
#' \item{\code{sd}}{Reported standard deviation.}
#' \item{\code{se}}{Reported standard error.}
#' \item{\code{ci95}}{Reported 95 percent confidence interval.}
#' \item{\code{itd}}{Intertegular distance in mm.}
#' \item{\code{sociality}}{Social organisation.}
#' \item{\code{notes}}{Original study notes.}
#' \item{\code{dist10}}{Base-10 logarithm of foraging distance in kilometres.}
#' \item{\code{range.4}}{Combined range and measure category.}
#' \item{\code{wgt10}}{Base-10 logarithm of predicted body mass in mg.}
#' }
#' @details The model_training attribute identifies the training data for two foraging range models. Stored model variables are populated for the corresponding training subsets.
#' @references Kendall et al. (2022). The potential and realized foraging movements of bees are differentially determined by body size and sociality. Ecology, 103(11), e3809. \doi{10.1002/ecy.3809}.
#' @usage data(forage_dataset)
#' @keywords datasets
"forage_dataset"
