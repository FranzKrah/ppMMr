################################################
## This code is part of the Rpackage ppMMr    ##
## Franz-S. Krah; Leonie Schmid               ##
## 24 - 05 - 2018                             ##
################################################

#' Subroutine of \link{remove_non_target}
#' @description Takes first image of a series of images with putative animal movement. Then the area of interest is selected by the user. This function. Then adds a hit information to the MotionMerkat CSV file. Hit = detected animal moovement was within the selected area of interest.
#' @param fold character string of folder beeing processed
#' @param file character string of file (frame) beeing processed
#' @param path a character string specifying the path of the motion detection project with folders being MotionMeerkat folders
#' @importFrom imager load.image
#' @export

find_hits <- function(fold, file, path){

  files <- list.files(fold)
  files.r <- list.files(fold, recursive = T)

  # list of first images from subfolder and their CSVs
  files.first <- unlist(lapply(files, function(x)  files.r[grep(x, files.r)[1]]))
  files.first <- files.first[grep("jpg", files.first)]
  files.csv <- files.r[grep("csv\\b", files.r)]
  if(length(grep("updated", files.r))>0){
    stop("Frames.csv is already updated")
  }

  # load image and retrive coordinates
  # load image

  im <- load.image(paste(fold, files.first[1], sep ="/"))

  # retrieve coordinates
  coord.within <- define_polygon(im, 10)

  # load csv
  tab <- read.csv(paste(fold, files.csv, sep ="/"))
  tab <- data.frame(tab, do.call(rbind, str_extract_all(tab$Position, "\\d+")))
  colnames(tab)[4:7] <- c("x1", "y1", "x2", "y2")

  # Retrieve all points with polygon
  all.dots <- target_coords(coord = coord.within , x = im)

  # Hits in polyimage
  target <- (((tab$x1 %in% all.dots$polygon$x) & (tab$y1 %in% all.dots$polygon$y))
    |   ((tab$x2 %in% all.dots$polygon$x) & (tab$y2 %in% all.dots$polygon$y)))

  tab <- data.frame(tab, target = target*1)
  tab <- data.frame(path = path, path.sub = gsub(path, "", fold), tab)

  ## prepare file directories
  files.csv <- do.call(rbind, strsplit(files.csv, "\\."))
  dat <- Sys.Date()
  files.csv <- cbind(files.csv[1], "updated", as.character(dat), files.csv[2])
  files.csv <- paste(files.csv[,1], "_", files.csv[,2], "_", files.csv[,3], ".", files.csv[,4], sep ="")

  write.table(tab, file = paste(fold, files.csv, sep ="/"),
    sep = ";",  row.names = FALSE)

}
