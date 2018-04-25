################################################
## This code is part of the Rpackage ppMMr    ##
## Franz-S. Krah; Leonie Schmid               ##
## 24 - 05 - 2018                             ##
################################################

#' Displays MotionMeerkat hit frame and waits for user input
#' @import magick
#' @export


is.animal <- function(path, frame_nr, coord, autorange = TRUE, mag = c(50, 50),
  query.text){

  # read image
  im <- image_read(paste0(path, "/", frame_nr, ".jpg"))

  xext <- abs(coord[1,3]-coord[1,1])
  yext <- abs(coord[1,4]-coord[1,2])
  x <- coord[1,1]
  y <- coord[1,4]

  if(autorange){
    rang <- image_info(im)[2:3]

    xmag <- 1 + (abs((10^-(xext/rang[1]))-0.3))*3
    ymag <- 1 + (abs((10^-(yext/rang[1]))-0.3))*3

    xext <- xext * xmag
    yext <- yext * ymag
  }else{
    xext <- xext + mag[1]
    yext <- yext + mag[2]
  }
  im.crop <- image_crop(im, paste0(xext, "x", yext, "+", x, "+", y))
  par(mar = c(0,0,0,0))
  plot(im.crop)

  usr_out <- readkey(text = query.text)

  return(usr_out)
}
