# This file intentionally left (almost) blank.
#
# Its presence tells Shiny's loadSupport() mechanism (shiny >= 1.5.0) not to
# auto-source the files in this R/ directory when running app.R (or any app
# in this project) via shiny::runApp()/RStudio-Positron's "Run App".
#
# Without this file, Shiny sources every *.R file in R/ alphabetically and
# evaluates it in a plain environment - ignoring this package's Collate:
# order in DESCRIPTION, which is required because mantine-element.R defines
# displayComponent() that most other files call at the top level. The result
# is "could not find function 'displayComponent'" the moment a file that
# sorts before mantine-element.R (e.g. AdvancedComponents.R) is sourced.
#
# shiny.mantine should always be loaded properly via library(shiny.mantine),
# which uses the compiled NAMESPACE and respects Collate order - so R/ never
# needs to be (and must not be) auto-sourced by a running app.
#
# See ?shiny::loadSupport for details.
#
# Maintainer note: because this filename starts with "_" it is not a valid R
# source filename, so R's own package installer silently ignores it - it must
# NOT appear in the Collate: field of DESCRIPTION (R CMD INSTALL errors with
# "files in 'Collate' field missing" if it does). devtools::document() /
# roxygen2::roxygenise() do not know this rule and will re-add it to Collate
# next time they regenerate it. If R CMD INSTALL suddenly fails that way,
# just delete the '_disable_autoload.R' line from DESCRIPTION's Collate field.
