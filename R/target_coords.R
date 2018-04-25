################################################
## This code is part of the Rpackage ppMMr    ##
## Franz-S. Krah; Leonie Schmid               ##
## 24 - 05 - 2018                             ##
################################################

#' Extract coordinates from unser-defined target polygon
#' @param coord output of \link{define_polygon}
#' @param x an object of class 'cimg'
#' @return list of points outside and inside of polygon
#' @export

target_coords <- function(coord, x){

  ## create data.frame
  amdf <- as.data.frame(x)
  ## polygon
  res_poly <- amdf[in.poly(amdf, coord),]
  ## non polygon
  res_npoly <- amdf[!in.poly(amdf, coord),]
  ## get color values from image
  res_points <- list()
  ## return result
  return(list(points = res_points, polygon = res_poly))

}

