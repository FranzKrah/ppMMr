################################################
## This code is part of the Rpackage ppMMr    ##
## Franz-S. Krah; Leonie Schmid               ##
## 24 - 05 - 2018                             ##
################################################

#' @export

readkey <- function(text){
  cat (text)
  line <- readline()
  return(line)
}