# Internal R -> JSON -> React tree serialization engine.
#
# Conceptually mirrors shiny.react::reactElement()/asReactData() (same idea:
# a nested tree of components gets serialized into a single JSON blob and
# mounted with a single ReactDOM.createRoot()), but is an independent
# reimplementation: reactElement() bakes into the generated HTML a fixed
# call to `jsmodule['@/shiny.react'].findAndRenderReactData()`, which would
# use shiny.react's shared runtime/React (React 18) even to render Mantine
# v9 components (which require React 19) - see the note in
# js/webpack.config.js. Here we instead point to our own mount point,
# `jsmodule['@/shiny.mantine'].mount()`, defined in js/src/index.js.
#
# shiny.react's asProps() (pure R, no dependency on React) is reused as-is
# to interpret `...` as props/children.

#' @keywords internal
displayComponent <- function(name) {
  function(...) mantineElement(name, ...)
}

#' @keywords internal
mantineElement <- function(name, ...) {
  props <- shiny.react::asProps(...)
  structure(
    list(type = "element", name = name, props = lapply(props, toMantineData)),
    class = "mantine_element"
  )
}

#' Coerce a value to always serialize as a JSON array
#'
#' For props the JS side always expects as an array (e.g. `MultiSelect()`'s
#' `value`, a vector of selected values) — never `NULL`/`null` (the JS side
#' typically calls `.map()` on it directly) and never a bare scalar. Two
#' independent `jsonlite::toJSON(..., auto_unbox = TRUE)` calls in this
#' package (`renderMantineRoot()` for the initial element tree,
#' `session$sendCustomMessage()`'s own default serializer for
#' `updateMantineXxx()` calls) both auto-unbox a length-1 atomic vector to a
#' bare JSON value (`"x"` instead of `["x"]`) and serialize `NULL` as
#' `null` — either would crash a component whose JS side unconditionally
#' `.map()`s over the value. `as.list()` sidesteps both: it turns any
#' length-1 (or longer) atomic vector into a genuine (unnamed) R list,
#' which this package's serialization always treats as a JSON array
#' regardless of length, and `as.list(NULL)` is already `list()` (an empty
#' array), not `NULL`.
#' @keywords internal
ensureArray <- function(x) {
  as.list(x)
}

#' @keywords internal
toMantineData <- function(x) {
  # MantineProvider() returns a self-mounting HTML fragment (meant to be
  # used as a top-level UI element), not a nestable mantine_element. If
  # someone passes it as a child of another component anyway (e.g.
  # `ModalsProvider(MantineProvider(...))` instead of the correct
  # `MantineProvider(ModalsProvider(...))`), we extract its underlying raw
  # element (attached as an attribute by renderMantineRoot()) instead of
  # serializing it as a useless HTML string (the embedded mount <script>
  # would never execute once nested).
  root <- attr(x, "mantine_root", exact = TRUE)
  if (!is.null(root)) {
    return(toMantineData(root))
  }
  if (inherits(x, "mantine_element")) {
    return(unclass(x))
  }
  if (
    inherits(x, "shiny.tag") ||
      inherits(x, "shiny.tag.list") ||
      inherits(x, "html")
  ) {
    return(list(type = "html", value = as.character(x)))
  }
  if (is.null(x)) {
    return(list(type = "raw", value = NULL))
  }
  if (is.list(x)) {
    nms <- names(x)
    if (!is.null(nms) && any(nzchar(nms))) {
      return(list(type = "object", value = lapply(x, toMantineData)))
    }
    return(list(type = "array", value = lapply(x, toMantineData)))
  }
  list(type = "raw", value = x)
}

#' @keywords internal
renderMantineRoot <- function(el, containerId = NULL) {
  containerId <- containerId %||%
    paste0(
      "shiny-mantine-",
      paste(sample(c(letters, 0:9), 12, replace = TRUE), collapse = "")
    )
  json <- jsonlite::toJSON(unclass(el), auto_unbox = TRUE, null = "null")
  tag <- htmltools::tagList(
    mantineDependency(),
    htmltools::div(
      id = containerId,
      class = "shiny-mantine-container",
      htmltools::tags$script(
        type = "application/json",
        class = "shiny-mantine-data",
        htmltools::HTML(json)
      )
    ),
    htmltools::tags$script(
      htmltools::HTML(sprintf(
        "window.jsmodule['@/shiny.mantine'].mount('%s');",
        containerId
      ))
    )
  )
  # Lets renderMantine() recognize when the expression called
  # MantineProvider() (which produces a self-mounting HTML fragment, above)
  # and extract its underlying raw element, instead of serializing the
  # static HTML as a nested string (which wouldn't work: the embedded mount
  # <script> would never execute if inserted via dangerouslySetInnerHTML
  # inside another React output).
  attr(tag, "mantine_root") <- el
  tag
}
