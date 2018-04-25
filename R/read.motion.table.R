################################################
## This code is part of the Rpackage ppMMr    ##
## Franz-S. Krah; Leonie Schmid               ##
## 24 - 05 - 2018                             ##
################################################

#' Read motion detection table
#' @param path a character string specifying the path of the motion detection project with folders being MotionMeerkat folders
#' @return data.frame
#' @importFrom stringr str_extract
#' @export

read_motion_table <- function(path) {
  mo_tab <- list.files(path)
  mo_tab <- paste(path, mo_tab[grep("motion_table", mo_tab)], sep ="/")
  x <-  as.Date(str_extract(mo_tab, "\\d*-\\d*-\\d*"))
  coldate <- Sys.Date()
  mo_tab_path <- mo_tab[which(abs(coldate-x) == min(abs(coldate - x)))]
  mo_tab <- read.table(mo_tab_path, header = TRUE, sep =";")
  return(mo_tab)
}

