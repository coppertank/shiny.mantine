# Mantine Pagination.Root (fully custom pagination layout)

The lower-level piece behind
[`Pagination()`](https://coppertank.github.io/shiny.mantine/reference/Pagination.md),
for a fully custom arrangement of the prev/next/first/last controls
(reordering them, dropping some, adding your own elements in between) —
compose it with
[`PaginationFirst()`](https://coppertank.github.io/shiny.mantine/reference/PaginationFirst.md),
[`PaginationPrevious()`](https://coppertank.github.io/shiny.mantine/reference/PaginationPrevious.md),
[`PaginationItems()`](https://coppertank.github.io/shiny.mantine/reference/PaginationItems.md),
[`PaginationNext()`](https://coppertank.github.io/shiny.mantine/reference/PaginationNext.md),
[`PaginationLast()`](https://coppertank.github.io/shiny.mantine/reference/PaginationLast.md)
and
[`PaginationDots()`](https://coppertank.github.io/shiny.mantine/reference/PaginationDots.md),
which read the current page from it automatically (no per-part wiring
needed). Stateful exactly like
[`Pagination()`](https://coppertank.github.io/shiny.mantine/reference/Pagination.md):
`input[[inputId]]` is synced on page change, and
[`updateMantinePagination()`](https://coppertank.github.io/shiny.mantine/reference/Pagination.md)
works on it the same way.

## Usage

``` r
PaginationRoot(inputId, total, ..., value = 1)
```

## Arguments

- inputId:

  Id of the Shiny input; `input[[inputId]]` is synced on page change.

- total:

  Total number of pages.

- ...:

  Children (typically
  [`PaginationFirst()`](https://coppertank.github.io/shiny.mantine/reference/PaginationFirst.md),
  [`PaginationPrevious()`](https://coppertank.github.io/shiny.mantine/reference/PaginationPrevious.md),
  [`PaginationItems()`](https://coppertank.github.io/shiny.mantine/reference/PaginationItems.md),
  [`PaginationNext()`](https://coppertank.github.io/shiny.mantine/reference/PaginationNext.md),
  [`PaginationLast()`](https://coppertank.github.io/shiny.mantine/reference/PaginationLast.md))
  and other props (`siblings`, `boundaries`, ...). See
  <https://mantine.dev/core/pagination/#compound-components>.

- value:

  Initial page. Must be passed by name (as in the example below): with
  children in `...`, an unnamed argument here would bind to `value`
  positionally instead of joining the children, since `...` only
  captures unnamed arguments that come *after* it.

## Examples

``` r
if (FALSE) { # \dontrun{
Group(
  PaginationRoot(
    inputId = "page", total = 10,
    PaginationFirst(), PaginationPrevious(), PaginationItems(),
    PaginationNext(), PaginationLast()
  )
)
} # }
```
