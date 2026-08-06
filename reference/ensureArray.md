# Coerce a value to always serialize as a JSON array

For props the JS side always expects as an array (e.g.
[`MultiSelect()`](https://coppertank.github.io/shiny.mantine/reference/MultiSelect.md)'s
`value`, a vector of selected values) — never `NULL`/`null` (the JS side
typically calls `.map()` on it directly) and never a bare scalar. Two
independent `jsonlite::toJSON(..., auto_unbox = TRUE)` calls in this
package (`renderMantineRoot()` for the initial element tree,
`session$sendCustomMessage()`'s own default serializer for
`updateMantineXxx()` calls) both auto-unbox a length-1 atomic vector to
a bare JSON value (`"x"` instead of `["x"]`) and serialize `NULL` as
`null` — either would crash a component whose JS side unconditionally
`.map()`s over the value.
[`as.list()`](https://rdrr.io/r/base/list.html) sidesteps both: it turns
any length-1 (or longer) atomic vector into a genuine (unnamed) R list,
which this package's serialization always treats as a JSON array
regardless of length, and `as.list(NULL)` is already
[`list()`](https://rdrr.io/r/base/list.html) (an empty array), not
`NULL`.

## Usage

``` r
ensureArray(x)
```
