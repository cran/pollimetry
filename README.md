[![DOI](https://zenodo.org/badge/120989038.svg)](https://zenodo.org/badge/latestdoi/120989038)
[![CRAN status](https://www.r-pkg.org/badges/version/pollimetry)](https://www.r-pkg.org/badges/version/pollimetry)
![](https://cranlogs.r-pkg.org/badges/grand-total/pollimetry?color=green)
![](https://cranlogs.r-pkg.org/badges/pollimetry?color=green)

Pollimetry: Robust estimates of body size and co-varying traits in pollinating insects
==========

Tools to estimate pollinator body size and co-varying ecological traits.

To install
==========
```
if (!requireNamespace("devtools", quietly = TRUE)) {
  install.packages("devtools")
}
devtools::install_github("liamkendall/pollimetry")
library(pollimetry)
```

The Bayesian functions use fitted models from `pollimetrydata`. Installing version 1.0.1 or later is optional and enables offline predictions. Otherwise, only the required models are downloaded from GitHub and reused within the current R session.

```
# Optional: install all fitted models for offline use
devtools::install_github("liamkendall/pollimetrydata")
```

Estimating body size
====================

The `bodysize()` function estimates bee and hoverfly dry body weight from intertegular distance (ITD), sex, taxonomy or phylogeny, and geographical region. It returns back-transformed mean estimates with 95 percent Bayesian credible intervals in milligrams, appended as `Est.Weight`, `CI_Lower` and `CI_Upper`. See the function help for model options and required inputs.

Pre-existing equations for Diptera, Hymenoptera and Lepidopteran taxa using body length (`lengthsize`), body length * width (`lengthwidthsize`) and head width (`headwidthsize`) are also provided.

Supply body length and head width in millimetres; supply length × width in square millimetres. Measurements must be nonempty numeric vectors containing only finite, positive values. `Eq` selects one equation or a supported group using a single character string. Single equations return numeric vectors; equation groups return matrices with one row per measurement and named equation columns.

See the function help pages for supported equation choices. These equations return point predictions.

Allometric traits
=================

Users can predict, i) bee tongue length (`tonguelength`) using combined data from Cariveau et al. (2016) and Melin et al. (2019), including Melittidae, ii) bee foraging distances (`foragedist`) from equations described in van Nieuwstadt and Ruano Iraheta (1996) for Meliponini, Greenleaf et al. (2007) and Guedot et al. (2009) for Osmia spp, iii) wing loading (`wingloading`) from Bullock (1999) and, iv)  field nectar loads (`nectarload`) from Henry and Rodet (2018).

The `foraging.range()` function uses the Bayesian models of Kendall et al. (2022) to estimate typical and maximum realized or potential foraging ranges. It returns back-transformed mean estimates with 95 percent Bayesian credible intervals in kilometres, conditional on estimated female body weight. The older `foragedist()` function is deprecated; its published equations and units are described in its help page.

The package provides three datasets: `pollimetry_dataset` (body size), `forage_dataset` (foraging range), and `tongue_dataset` (combined tongue-length training data).

Example
========

Explore the body size dataset:

```
data("pollimetry_dataset", package = "pollimetry")
head(pollimetry_dataset)
?pollimetry_dataset #for metadata.
```
Let's predict some body sizes from a dataframe using taxonomy:

```
(example <- cbind.data.frame(ITD = c(1.2, 2.3),
                            Sex = c("Female","Male"),
                            Family = c("Apidae","Andrenidae"),
                            Region = c("NorthAmerica","Europe"),
                            Species = c("Ceratina_dupla","Andrena_flavipes")))

bodysize(x = example, taxa = "bee", type = "taxo")
?bodysize
```

Now let's estimate realized foraging ranges using ITD:

```
foraging.range(
  data.frame(ITD = c(2, 3)),
  model.type = "ITD",
  random.effects = "reduced",
  measure.type = "realized"
)
```

Manuscript R code
=================

Kendall, L. (2018). Pollimetry R code. Figshare.
doi:10.6084/m9.figshare.7357217.v1
