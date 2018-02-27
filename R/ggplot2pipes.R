
#-----------------------------------------------------------------------------
#' Create pipe-enabled ggplot2 functions
#'
#'
#' Initially inspired many years ago when @hadleywickham
#' and @cpsievert were discussing DSLs for plotting:
#' https://twitter.com/cpsievert/status/606190120568365056
#'
#' @param prefix string with which to prefix names of \code{ggplot2} functions in order to name the pipe-enabled functions. default: "add_".
#'               Note: You could set this the empty string, in which case the new functions would mask the name of the library function
#' @param func_regex Regular expression to filter the list of ggplot functions to make pipe-enabled.  The default regex will capture all
#'                   stats and geoms and some other misc stuff.
#'
#' @importFrom purrr keep walk
#' @importFrom dplyr '%>%'
#' @export
#-----------------------------------------------------------------------------
init_ggplot2_pipes <- function(prefix="add_", func_regex = '^(geom_|stat_|coord_|annot|xlim|ylim|theme_|facet_|labs)') {
  ls('package:ggplot2') %>%
    purrr::keep(~is.function(get(.x))) %>%
    purrr::keep(~grepl(func_regex, .x)) %>%
    purrr::walk(create_pipe_enabled_ggplot2_func, prefix=prefix)
}



#-----------------------------------------------------------------------------
#' Create a pipe-aware func from any plus-aware function
#'
#' Assigns the new function in the global environemnt
#'
#' @param ggplot2_func_name Name of a ggplot2 function. character. e.g. "geom_point"
#' @param prefix string with which to prefix names of \code{ggplot2} functions in order to name the pipe-enabled functions. default: "add_".
#'               Note: You could set this the empty string, in which case the new functions would mask the name of the library function
#'
#' @export
#-----------------------------------------------------------------------------
create_pipe_enabled_ggplot2_func <- function(ggplot2_func_name, prefix='add_') {
  pipe_enabled_func_name <- paste0(prefix, ggplot2_func_name)

  assign(
    pipe_enabled_func_name,
    function(lhs, ...) {
      ggplot2_func <- get(ggplot2_func_name, envir = as.environment('package:ggplot2'))
      `+`(lhs, ggplot2_func(...))
    },
    pos = 1
  )
}



#-----------------------------------------------------------------------------
# debug
#-----------------------------------------------------------------------------
if (FALSE) {
  library(dplyr)
  library(ggplot2)

  init_ggplot2_pipes()

  ggplot(mtcars) %>%
    add_geom_line(aes(mpg, wt)) %>%
    add_labs(title="hello") %>%
    add_theme_bw() %>%
    add_facet_wrap(~am)
}
