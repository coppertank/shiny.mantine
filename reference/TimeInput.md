# Mantine TimeInput (Shiny stateful input, native time field)

Mantine TimeInput (Shiny stateful input, native time field)

## Usage

``` r
TimeInput(inputId, label = NULL, value = "", ...)
```

## Arguments

- inputId:

  Id of the Shiny input; `input[[inputId]]` (a `"HH:mm"` string) is
  synced on every change.

- label:

  Field label.

- value:

  Initial value (a `"HH:mm"` string).

- ...:

  Other props (`withSeconds`, `minTime`, `maxTime`, ...). See
  <https://mantine.dev/dates/time-input/>.
