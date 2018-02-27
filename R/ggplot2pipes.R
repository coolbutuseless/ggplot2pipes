
#-----------------------------------------------------------------------------
#' augment a packages which uses composition via '+' into package which understand pipes
#'
#' augment a packages which uses composition via '+' into package which understand pipes
#'
#' This is proof-of-concept only, which was inspired after seeing @hadleywickham
#' and @cpsievert discussing DSLs for plotting:
#' https://twitter.com/cpsievert/status/606190120568365056
#'
#' @param prefix string with which to prefix names of \code{ggplot2} functions in order to name the pipe-enabled functions
#'
#' @export
#-----------------------------------------------------------------------------
init_ggplot2_pipes <- function(prefix="add_") {

}


#-----------------------------------------------------------------------------
# debug
#-----------------------------------------------------------------------------
if (FALSE) {
  library(dplyr)
  library(ggplot2)

  init_ggplot2_pipes()

  ggplot(mtcars) %>%
    add_geom_line %>% add_labs(title="hello")
}
