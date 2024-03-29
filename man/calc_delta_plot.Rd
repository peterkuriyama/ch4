% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/calc_delta_plot.R
\name{calc_delta_plot}
\alias{calc_delta_plot}
\title{Calculate values for delta plots
Delta plots come from Gillis et al. (2008) paper. Used to compare the proportion of zeroes and
skew of the catch distributions. Targeted species have skewed distributions. Function relies on
pull_catch and calc_skew functions.}
\usage{
calc_delta_plot(data, spp, focus = "apound")
}
\arguments{
\item{data}{Input data, defaults to wc_data}

\item{spp}{Species of interest}

\item{focus}{Column of interest, Options are hpounds, apounds}
}
\description{
Calculate values for delta plots
Delta plots come from Gillis et al. (2008) paper. Used to compare the proportion of zeroes and
skew of the catch distributions. Targeted species have skewed distributions. Function relies on
pull_catch and calc_skew functions.
}
\examples{
calc_delta_plot(data = wc_data, spp = 'Dover Sole', focus = 'apound')
}
