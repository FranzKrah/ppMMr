################################################
## This code is part of the Rpackage ppMMr    ##
## Franz-S. Krah; Leonie Schmid               ##
## 24 - 05 - 2018                             ##
################################################

#' Retrieve coordintas for user-defined target polygon in frame
#' @param x an object of class 'cimg'
#' @param n integer number of polygon points
#' @import magick
#' @importFrom graphics locator
#' @import imager
#' @export

define_polygon <- function(x, n){

  ## click the points you want
  cat(" - Please click ", n, " times in the image (do not click more!) \n")

  ## plot image to console
  par(mar = c(0,0,0,0))
  plot(x)

  ## click
  coord <- locator(n = n, type ="l")

  ## prepare output
  coord <- do.call(rbind, coord)
  coord <- as.data.frame(t(coord))

  return(coord)
}

