% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/track_line.R
\name{track_line}
\alias{track_line}
\title{Drive and vectorize an unknown road}
\usage{
track_line(
  seed,
  conductivity,
  network = NULL,
  fov = 160,
  sightline = 100,
  min_conductivity = 0.6,
  ...,
  disp = FALSE
)
}
\arguments{
\item{seed}{\code{sfc_LINESTRING} a seed to start driving a road}

\item{conductivity}{raster a conductivity raster (see references).}

\item{network}{a \code{sf/sfc} with an already existing network such as the algorithm
can stop when vectorizing an already vectorized part of the network.}

\item{fov}{numeric. Field of view (degrees) ahead of the search vector (see references)}

\item{sightline}{numeric (distance unit). Search distance used to find the next most probable
point on the road (see references).}

\item{min_conductivity}{numeric between 0 and 1. corresponds to the sensitivity of the method. A
value close to 1 indicates that the algorithm follows only the pixels with a very high
road probabilities and stops easily and may miss roads. A low value indicates that the algorithm
follows the pixel even with low conductivity and is likely to vectorize road that do not exist but
is less likely to miss existing roads.}

\item{...}{Unused}

\item{disp}{bool. Display in realtime the progress on images. For debugging purposes.}
}
\value{
list, \code{road} contains the road found in a vectorial format (\code{sfc}) and \code{seed} (\code{sfc}) that
contains all the potential intersection and seeds found along the road in a vectorial format (\code{sfc}).
}
\description{
Drive along an unknown road in a probability map starting from small piece
of road segment pointing in the right direction and vectorize it by returning a spatial
line. This function is used by \link{vectorize_network} and is not intended to be used
by regular users except for trial-and-error tests.
}
\examples{
\dontrun{
library(terra)
library(sf)

map <- system.file("extdata", "network.tif", package = "vecnet")
seeds <- system.file("extdata", "seeds.shp", package = "vecnet")
map <- rast(map)
seeds <- st_read(seeds, quiet = TRUE)
seed <- st_geometry(seeds)[1]

res <- track_line(seed, map, min_conductivity = 0.5)

plot(map, col = viridis::inferno(25))
plot(seed, add = TRUE, col = "green", lwd = 3)
plot(res$road, add = TRUE, col = "red", lwd = 2)
plot(res$seeds, add = TRUE, col = "green", lwd = 3)
}
}
\references{
Jean-Romain Roussel, Jean-Fran??ois Bourdon , Ilythia D. Morley , Nicholas C. Coops, Alexis Achim
(2022) Vectorial and topologically valid segmentation of forestry road networks from ALS data. In prep.\cr\cr
Jean-Romain Roussel, Jean-Fran??ois Bourdon , Ilythia D. Morley , Nicholas C. Coops, Alexis Achim
(2022) Correction, update, and enhancement of vectorial forestry road maps using ALS data, a
pathfinder, and seven metrics. Journal of Applied Earth Observation and Geoinformation.
}
