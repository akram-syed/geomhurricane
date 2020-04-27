
[![lifecycle](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)

# Geom for Hurricanes

The purpose of this exercise is to build a new geom using `grid` and
`ggplot2` packages to facilitate in visualizing hurricane winds on a
map.

## Hurricanes

Hurricanes can have asymmetrical wind fields, with much higher winds on
one side of a storm compared to the other. Hurricane wind radii report
how far winds of a certain intensity (e.g., 34, 50, or 64 knots)
extended from a hurricane’s center, with separate values given for the
northeast, northwest, southeast, and southwest quadrants of the storm.
The 34 knot radius in the northeast quadrant, for example, reports the
furthest distance from the center of the storm of any location that
experienced 34-knot winds in that quadrant.

This wind radii data provide a clearer picture of the storm structure
than the simpler measurements of a storm’s position and maximum winds.
For example, if a storm was moving very quickly, the forward motion of
the storm might have contributed significantly to wind speeds to the
right of the storm’s direction of forward motion, and wind radii might
be much larger for the northeast quadrant of the storm than the
northwest quadrant.

## Data

The aforementioned wind radii are available for Atlantic basin tropical
storms since 1988 through the [Extended Best Tract
dataset](http://rammb.cira.colostate.edu/research/tropical_cyclones/tc_extended_best_track_dataset/)
maintained by [Colorodo State University](https://www.colostate.edu/).

## Data

## Build Info

``` r
sessionInfo()$R.version$platform
#> [1] "x86_64-apple-darwin15.6.0"
sessionInfo()$R.version$version.string
#> [1] "R version 3.6.2 (2019-12-12)"
sessionInfo()$basePkgs
#> [1] "stats"     "graphics"  "grDevices" "utils"     "datasets"  "methods"  
#> [7] "base"
```