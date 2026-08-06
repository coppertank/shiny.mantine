# Open a confirmation modal (`@mantine/modals`)

On confirm, `input[[inputId]]` receives `TRUE`; on cancel, `FALSE`.

## Usage

``` r
openMantineConfirmModal(
  session = shiny::getDefaultReactiveDomain(),
  inputId,
  ...
)
```

## Arguments

- session:

  Session object passed to the Shiny server function.

- inputId:

  Id of the Shiny input that receives `TRUE`/`FALSE`.

- ...:

  Other props (`title`, `children` as plain text (the body message),
  `labels`, `confirmProps`, `cancelProps`, ...).
