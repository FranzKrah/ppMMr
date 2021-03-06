% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/find_hits.R
\name{find_hits}
\alias{find_hits}
\title{Subroutine of \link{remove_non_target}}
\usage{
find_hits(fold, file, path, n = 10)
}
\arguments{
\item{fold}{character string of folder beeing processed}

\item{file}{character string of file (frame) beeing processed}

\item{path}{a character string specifying the path of the motion detection project with folders being MotionMeerkat folders}
}
\description{
Takes first image of a series of images with putative animal movement. Then the area of interest is selected by the user. This function. Then adds a hit information to the MotionMerkat CSV file. Hit = detected animal moovement was within the selected area of interest.
}
