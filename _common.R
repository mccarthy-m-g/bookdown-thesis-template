set.seed(1014)
options(digits = 3)

###############################################################################
## setup
###############################################################################
knitr::opts_chunk$set(
  comment = "#>",
  collapse = TRUE,
  cache = FALSE,
  echo = FALSE,
  fig.align = "left",
  # fig.width = 6,
  # fig.asp = 0.618,  # 1 / phi
  fig.show = "hold",
  message = FALSE
)

options(dplyr.print_min = 6,
        dplyr.print_max = 6,
        knitr.graphics.auto_pdf = TRUE)
