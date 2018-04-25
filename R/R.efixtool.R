################################################
## This code is part of the Rpackage ppMMr    ##
## Franz-S. Krah; Leonie Schmid               ##
## 24 - 05 - 2018                             ##
################################################

#' Interface to the efixtool software to open meta data of image files
#' @param image.path a character string specifying a path to an image file
#' @param exec a character string with the path efixtool (Windows, e.g. C:/Programme/exiftool/exiftool_-k_.exe)
#' @return data.frame with efixtool output
#' @references \url{https://www.sno.phy.queensu.ca/~phil/exiftool/}
#' @export

R.exiftool <- function(image.path, exec ="exiftool"){
  call <- paste(exec, image.path)
  out <- system(call, intern = TRUE)
  res <- data.frame(do.call(rbind, strsplit(out, "\\s\\:\\s")))
  res$X1 <- trimws(res$X1)
  res$X2 <- trimws(res$X2)
  names(res) <- c("var", "val")
  return(res)
}

