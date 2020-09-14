set.seed(1014)
options(digits = 3)

###############################################################################
## setup
###############################################################################
knitr::opts_chunk$set(
  comment = "#>",
  collapse = TRUE,
  cache = TRUE,
  fig.retina = 0.8, # figures are either vectors or 300 dpi diagrams
  dpi = 300,
  out.width = "70%",
  fig.align = 'center',
  fig.width = 6,
  fig.asp = 0.618,  # 1 / phi
  fig.show = "hold",
  eval.after = 'fig.cap' # so captions can use link to demos
)

options(dplyr.print_min = 6,
        dplyr.print_max = 6,
        knitr.graphics.auto_pdf = TRUE)
