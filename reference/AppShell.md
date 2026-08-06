# Mantine AppShell family

Responsive layout with header/navbar/main/aside/footer.
`AppShellHeader()`, `AppShellNavbar()`, `AppShellMain()`,
`AppShellAside()`, `AppShellFooter()`, and `AppShellSection()` must be
nested inside `AppShell()`. Each of the four slots (`navbar`, `header`,
`aside`, `footer`) must first be configured with the matching prop on
`AppShell()` itself
(`navbar = list(width = ..., breakpoint = ..., collapsed = ...)`,
`header = list(height = ...)`,
`aside = list(width = ..., breakpoint = ..., collapsed = ...)`,
`footer = list(height = ...)`) — otherwise the corresponding slot does
not reserve space in the layout. See
<https://mantine.dev/core/app-shell/>.

## Usage

``` r
AppShell(...)

AppShellHeader(...)

AppShellNavbar(...)

AppShellMain(...)

AppShellAside(...)

AppShellFooter(...)

AppShellSection(...)
```

## Arguments

- ...:

  Props and children. See <https://mantine.dev/core/app-shell/>.
