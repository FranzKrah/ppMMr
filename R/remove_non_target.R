################################################
## This code is part of the Rpackage ppMMr    ##
## Franz-S. Krah; Leonie Schmid               ##
## 24 - 05 - 2018                             ##
################################################

#' Frist step after MotionMeerkat: Delete non-target hits
#' @description Removes putative movement detected by MotionMeerkat which is outside the user-devinded target area (e.g. flower)
#' @param path a character string specifying the path of the motion detection project with folders being MotionMeerkat folders
#' @return does not return, but saves to project folder, see \link{read.motion.table}
#' @export


remove_non_target <- function(path, n){

  dirs <- list.dirs(path)
  dirs <- dirs[grep("\\d{6}[A-Z]{2}", dirs)]
  

  for(i in 1:length(dirs)){
    if(length(grep("updated", list.files(dirs[i])))>0){
      cat(i, "Frames already updated \n")
      next
    }else{
      find_hits(fold = dirs[i], path = path, n = n)
      cat(i, "Frames now updated \n")
    }
  }

  if(length(grep("updated", list.files(dirs))) == length(dirs)){

    updated <- list.files(dirs, recursive = TRUE, full.names = TRUE)
    updated <- updated[grep("updated", updated)]

    updated <- lapply(updated, read.table, sep =";", header = TRUE)
    updated <- data.frame(do.call(rbind, updated))
    date <- Sys.Date()
    write.table(updated, file = paste0(path, "/motion_table_", date, ".csv"),
      row.names = FALSE, sep =";")
    cat("Motion table written to ", path)
  }
}

