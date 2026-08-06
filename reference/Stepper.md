# Mantine Stepper (multi-step wizard)

Renders a horizontal sequence of steps. The active step is controlled by
the app (via
`mantineId`/[`updateMantineProps()`](https://coppertank.github.io/shiny.mantine/reference/updateMantineProps.md),
e.g. `updateMantineProps(session, "wizard", active = 1)`) — Stepper
itself does not advance automatically. If `inputId` is set, clicking any
step header reports its index (0-based) to `input[[inputId]]`, so the
server can decide whether/how to advance.

## Usage

``` r
Stepper(mantineId = NULL, inputId = NULL, active = 0, ...)

StepperStep(...)

StepperCompleted(...)
```

## Arguments

- mantineId:

  Id used to update `active` reactively from R via
  [`updateMantineProps()`](https://coppertank.github.io/shiny.mantine/reference/updateMantineProps.md).

- inputId:

  If set, `input[[inputId]]` receives the index of the step the user
  clicked.

- active:

  Index (0-based) of the currently active step.

- ...:

  `StepperStep()`/`StepperCompleted()` children, plus other props
  (`allowNextStepsSelect`, `color`, ...). See
  <https://mantine.dev/core/stepper/>.

## Examples

``` r
if (FALSE) { # \dontrun{
Stepper(
  mantineId = "wizard", inputId = "wizard_click", active = 0,
  StepperStep(label = "Step 1", description = "Create an account"),
  StepperStep(label = "Step 2", description = "Verify email"),
  StepperCompleted("All steps completed!")
)
} # }
```
