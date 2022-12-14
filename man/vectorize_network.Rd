% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/vectorize.R
\name{vectorize_network}
\alias{vectorize_network}
\title{Vectorize a raster representing a segmented roads network}
\usage{
vectorize_network(
  map,
  seeds,
  network = NULL,
  max_sinuosity = 2.6,
  min_length = 400,
  verbose = FALSE,
  display = FALSE,
  ...
)
}
\arguments{
\item{map}{raster a probability raster.  Either a binary map or a propability map the
former being a special case of the later (see references).}

\item{seeds}{\code{sfc} a set of seeds to start driving the network (see references and examples).}

\item{network}{a \code{sf/sfc} with an already existing network such as the algorithm
can stop when vectorizing an already vectorized part of the network.}

\item{max_sinuosity}{numeric. False positive may be detected and discarded based on the fact that
they have likely an irrelevantly high sinuosity.}

\item{min_length}{numeric. False positive may be detected and discarded based on the fact that
they have likely an very short length.}

\item{verbose}{boolean.}

\item{display}{boolean. display a map in pseudo real time of the advancement. For debbuging purpose mainly.}

\item{...}{propagated to \link{track_line}}
}
\description{
Vectorize a raster representing a segmented roads network. The raster can be either a binary
map or a non binary map (see examples). The algorithm is expected to be robust to gaps, and
false positive (see references).
}
\examples{
\dontrun{
library(terra)
library(sf)

# =======================
# On a perfect binary map
# =======================

# Generate a binary map from a vector for the example
network <- system.file("extdata", "network.shp", package = "vecnet")
network <- buffer(vect(network), 1)
map <- rast(network, resolution = 2)
map <- rasterize(network, map)
map[is.na(map)] = 0.1
seeds <- system.file("extdata", "seeds.shp", package = "vecnet")
seeds <- st_read(seeds) |> st_geometry()

# Takes ~1 min to run
res <- vectorize_network(map, seeds, min_length = 150,  min_conductivity = 0.3, display = TRUE)

# notice that some parts of the network are missing because they are not reachable
# with the seed used in this example.
col = sample(rainbow(length(res)))
plot(network, border = "gray")
plot(res, add = TRUE, col = col, lwd = 2)
starts = lwgeom::st_startpoint(res)
ends = lwgeom::st_endpoint(res)
plot(starts, add = TRUE, col = "black", pch = 19, cex = 0.5)
plot(ends, add = TRUE, col = "black", pch = 19, cex = 0.5)

# =============================
# On an imperfect non binary map
# =============================

map <- system.file("extdata", "network.tif", package = "vecnet")
seeds <- system.file("extdata", "seeds.shp", package = "vecnet")
map <- rast(map)
seeds <- st_read(seeds, quiet = TRUE) |> st_geometry()
plot(map, col = viridis::inferno(25), smooth = TRUE)
plot(seeds, add = T, col = "cyan", lwd = 4)

res <- vectorize_network(map, seeds, min_conductivity = 0.6, display = TRUE)

plot(map, col = viridis::inferno(25), smooth = TRUE, alpha = 0.5)
col = sample(rainbow(length(res)))
plot(res, add = TRUE, col = col, lwd = 2)
starts = lwgeom::st_startpoint(res)
ends = lwgeom::st_endpoint(res)
plot(starts, add = TRUE, col = "black", pch = 19, cex = 0.5)
plot(ends, add = TRUE, col = "black", pch = 19, cex = 0.5)
}
}
\references{
Jean-Romain Roussel, Jean-Fran??ois Bourdon , Ilythia D. Morley , Nicholas C. Coops, Alexis Achim
(2022) Vectorial and topologically valid segmentation of forestry road networks from ALS data. In prep.\cr\cr
Jean-Romain Roussel, Jean-Fran??ois Bourdon , Ilythia D. Morley , Nicholas C. Coops, Alexis Achim
(2022) Correction, update, and enhancement of vectorial forestry road maps using ALS data, a
pathfinder, and seven metrics. Journal of Applied Earth Observation and Geoinformation.
}
