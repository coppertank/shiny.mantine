# Mantine PinInput (Shiny stateful input, e.g. an OTP code)

Mantine PinInput (Shiny stateful input, e.g. an OTP code)

## Usage

``` r
PinInput(inputId, value = "", ...)

updateMantinePinInput(
  session = shiny::getDefaultReactiveDomain(),
  inputId,
  value = NULL,
  ...
)
```

## Arguments

- inputId:

  Id of the Shiny input; `input[[inputId]]` is synced on every digit
  entered.

- value:

  Initial value.

- ...:

  Other props (`length`, `type`, `mask`, ...). See
  <https://mantine.dev/core/pin-input/>.

- session:

  Session object passed to the Shiny server function.
