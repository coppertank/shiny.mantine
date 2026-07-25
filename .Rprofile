# Suppresses Shiny's automatic sourcing of R/*.R when running any app in
# this project (shiny::runApp(), incl. RStudio/Positron's "Run App") - R/
# here is this package's own source, not "app support files" for the app:
# auto-sourcing it ignores this package's Collate: order in DESCRIPTION
# (required because mantine-element.R defines displayComponent(), which
# most other files call at the top level), crashing with "could not find
# function 'displayComponent'" the moment a file that alphabetically sorts
# before mantine-element.R is sourced. See ?shiny::loadSupport.
#
# Shiny's other supported opt-out is a file named R/_disable_autoload.R,
# but its underscore-prefixed name makes R's own package tooling silently
# ignore it - so it must never appear in DESCRIPTION's Collate: field, and
# devtools::document()/roxygen2 don't know that rule: they re-add it to
# Collate every time docs are regenerated, breaking R CMD INSTALL until
# it's manually removed again. Setting the option here instead - sourced
# automatically whenever an R session starts with this directory as its
# working directory (opening the project in Positron/RStudio, or running
# Rscript/R from a terminal here) - avoids that recurring breakage.
options(shiny.autoload.r = FALSE)
