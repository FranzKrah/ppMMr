################################################
## This code is part of the Rpackage ppMMr    ##
## Franz-S. Krah; Leonie Schmid               ##
## 24 - 05 - 2018                             ##
################################################

#' Add time to motion detection table
#' @param path a character string specifying the path of the motion detection project with folders being MotionMeerkat folders
#' @param exec a character string with the path efixtool (Windows, e.g. C:/Programme/exiftool/exiftool_-k_.exe)
#' @importFrom stringr word str_extract
#' @export

add_time <- function(path, exec = "exiftool"){

  tlvs <- list.files(path, recursive = TRUE, full.names = TRUE)
  tlvs <- tlvs[grep("\\.TLV", tlvs)]
  # "C:/Programme/exiftool/exiftool_-k_.exe"

  tlvs.meta <- lapply(tlvs, R.exiftool, exec = exec)
  names(tlvs.meta) <- tlvs

  time <- lapply(tlvs.meta, function(x) x[c(5), ])
  time <- unlist(lapply(time, function(x)
    paste(strsplit(word(x$val, 2,2), ":")[[1]][1:2], collapse=":")))
  frame.count <- unlist(lapply(tlvs.meta, function(x) x[c(14), ]$val))
  time <- data.frame(time, frame.count)
  time$time <- gsub("00:00", "24:00", time$time)

  ## compute frame seconds
  time$frame.sec <- as.numeric(as.character(time$frame.count))*5
  time <- data.frame(data.frame(do.call(rbind, strsplit(time$time, ":"))), time)
  names(time)[1:2] <- c("hour", "min")

  # compute starting day time in seconds
  sec.hours <- (as.numeric(as.character(time$hour))*3600)
  sec.mins <- (as.numeric(as.character(time$min))*60)
  time$sec.time <- sec.hours + sec.mins

  time$time.start.sec <- time$sec.time - time$frame.sec
  time$time.start.sec[time$time.start.sec<0] <- 0

  # read motion table
  mo_tab <- read_motion_table(path)

  time$path.sub <- str_extract(rownames(time),
    unique(as.character(mo_tab$path.sub)))

  mo_tab <- data.frame(mo_tab,
    time[match(as.character(mo_tab$path.sub), time$path.sub),],
    row.names = NULL)

  frame.sec <- 5
  day.time <- (mo_tab$time.start.sec + (mo_tab$Frame*frame.sec))
  day.time <- day.time/3600
  day.time <- do.call(rbind, strsplit(as.character(day.time), "\\."))
  day.time[,2] <- round(as.numeric(paste0("0.", day.time[,2]))*60)
  day.time <- as.data.frame(day.time)
  names(day.time) <- c("day.time.hour", "day.time.min")
  mo_tab <- data.frame(mo_tab, day.time)
  mo_tab <- mo_tab[, grep("path|path.sub|Frame|x1|y1|x2|y2|inside|animal|day\\.time\\.hour|day\\.time\\.min", names(mo_tab))]
  write.table(mo_tab, file = mo_tab_path, row.names = FALSE, sep =";")
}

