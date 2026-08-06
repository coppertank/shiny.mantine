# Mantine Accordion (Shiny stateful input)

`AccordionItem()` (containing `AccordionControl()` + `AccordionPanel()`)
must be nested inside `Accordion()`.

## Usage

``` r
Accordion(inputId, ..., value = NULL, multiple = FALSE)

updateMantineAccordion(
  session = shiny::getDefaultReactiveDomain(),
  inputId,
  value = NULL,
  ...
)

AccordionItem(...)

AccordionControl(...)

AccordionPanel(...)
```

## Arguments

- inputId:

  Id of the Shiny input; `input[[inputId]]` (a string, or a vector if
  `multiple = TRUE`) is synced on open/close.

- ...:

  Other props/children.

- value:

  Initial value (an `AccordionItem()`'s `value`, or a vector if
  `multiple = TRUE`).

- multiple:

  If `TRUE`, more than one item can be open at once and
  `input[[inputId]]` becomes a character vector.

- session:

  Session object passed to the Shiny server function.
