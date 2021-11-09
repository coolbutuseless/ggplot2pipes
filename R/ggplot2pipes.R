
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
#' @importFrom purrr keep walk
#' @importFrom dplyr '%>%'
#' @export
#-----------------------------------------------------------------------------
init_ggplot2_pipes <- function(prefix="", func_regex = '^(geom_|stat_|coord_|annot|xlim|ylim|theme|facet_|labs|guides|scale_x|scale_y)', packages = c("ggplot2")) {
  for (pack_name in packages) {
    tryCatch(
      {
        ls(paste0('package:', pack_name)) %>%
          purrr::keep(~is.function(get(.x))) %>%
          purrr::keep(~grepl(func_regex, .x)) %>%
          purrr::walk(create_pipe_enabled_ggplot2_func, prefix=prefix, pack_name=pack_name)
      },
      error = function(e) e)
  }
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
create_pipe_enabled_ggplot2_func <- function(ggplot2_func_name, prefix='add_', pack_name='ggplot2') {
  pipe_enabled_func_name <- paste0(prefix, ggplot2_func_name)

  assign(
    pipe_enabled_func_name,
    function(lhs = "not supplied", ...) {
      ggplot2_func <- get(ggplot2_func_name, envir = as.environment(paste0('package:', pack_name)))
      if (any(lhs != "not supplied")) {
        if (is.ggplot(lhs)) {
          `+`(lhs, ggplot2_func(...))
        } else {
          ggplot2_func(lhs, ...)
        }
      } else {
        ggplot2_func(...)
      }
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
  library(ggplot2pipes)

  init_ggplot2_pipes(prefix="")

  ggplot(mtcars, aes(mpg, wt)) |>
    geom_point(aes(color = mpg)) |>
    labs(title="hello")
    theme_bw() |>
    facet_wrap(~am, scale = "free") |>
    base_mode()
}
