################################################
## This code is part of the Rpackage ppMMr    ##
## Franz-S. Krah; Leonie Schmid               ##
## 24 - 05 - 2018                             ##
################################################

#' Second step after MotionMeerkat
#' @param path a character string specifying the path of the motion detection project with folders being MotionMeerkat folders
#' @param batch number of frames after which to write to file
#' @param query.text a character string, e.g. "Animal? (no = 0/ yes = 1/ unclear = 2)"
#' @return does not return, but saves to project folder, see \link{read.motion.table}
#' @importFrom plyr round_any
#' @import stringr
#' @export


remove_non_animal  <- function(path, batch = 1000,
  query.text = "Animal? (no = 0/ yes = 1/ unclear = 2); Consider top left red square!"){


  # load motion table
  mo_tab <- read_motion_table(path)

  # reduce to hits on user-defined target
  inside.new <- inside <- which(mo_tab$inside==1)

  ## continue where stopped if some batches run already
  if(length(grep("animal", names(mo_tab)))>0){
    done <- which(!is.na(mo_tab$animal))
    inside.new <- inside[!inside %in% done]
  }

  # redirect coords
  coords <- mo_tab[, grep("x1|x2|y1|y2", names(mo_tab))]

  # define batches
  if(length(inside) == length(inside.new)){
    batch <- split(inside.new, ceiling(seq_along(inside.new)/batch))
  }

  # run loop
  if(length(grep("animal", names(mo_tab)))==0){
    mo_tab$animal <- NA
  }
  for(j in 1:length(batch)){
    type1error <- list()
    for(i in batch[[j]]){
      cat(which(inside %in% i), " ")

      enter <- is.animal(path =
          paste0(mo_tab$path[i], mo_tab$path.sub[i]),
        frame_nr = mo_tab$Frame[i],
        coord = coords[i,], query.text = query.text)
      mo_tab$animal[i] <- as.numeric(enter)
    }

    out <- list.files(path)
    out <- paste(path, out[grep("motion_table", out)], sep ="/")

    dates <-  as.Date(str_extract(out, "\\d*-\\d*-\\d*"))
    coldate <- Sys.Date()
    out <- out[which(abs(coldate-dates) == min(abs(coldate - dates)))]
    write.table(mo_tab, sep =";", row.names = FALSE, col.names = TRUE, append = FALSE, file = out)
    cat(j, "batches done \n")


    # ask user to stop or continue
    if(i < max(inside)){
    cont <- readkey("Want to continue with next batch? (y/n)")
    if(cont == "n")
      break
    }
  }
}