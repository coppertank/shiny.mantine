# A faithful shiny.mantine recreation of the layout and components of the
# Plotly Dash "Investment Insights" example
# (https://financial-dashboard-example.plotly.app/): a 3-page fund
# dashboard (Executive Dashboard, Portfolio Analysis, Fees & Distributions)
# behind a shared AppShell header/navbar, built with Pages()/Page() for
# instant client-side navigation between them (same pattern as
# appshell-app.R). All chart/table numbers below are fictional, chosen to
# resemble the original's shapes and orders of magnitude, not real fund
# data. The "Price Performance" nav item mirrors "Dashboard" (the live
# site renders the same view for both).
#
# Run after installing the package:
#   shiny::runApp(system.file("examples/financial-dashboard-app.R", package = "shiny.mantine"))

library(shiny)
library(shiny.mantine)

# --- Small layout helpers (local to this demo, not exported by the package) ---

kpiCard <- function(label, value, icon, iconColor = "blue", footer = NULL) {
  Paper(
    withBorder = TRUE,
    radius = "md",
    p = "lg",
    Group(
      justify = "space-between",
      mb = "xs",
      Text(label, size = "sm", c = "dimmed"),
      ThemeIcon(
        icon,
        variant = "light",
        color = iconColor,
        size = 28,
        radius = "md"
      )
    ),
    Title(value, order = 2, mb = 4),
    footer
  )
}

trendFooter <- function(text, color = "green", up = TRUE) {
  Group(
    gap = 4,
    (if (up) IconArrowUpRight else IconArrowDownRight)(
      size = 14,
      color = paste0("var(--mantine-color-", color, "-6)")
    ),
    Text(text, size = "xs", c = color, fw = 600)
  )
}

dimFooter <- function(text) Text(text, size = "xs", c = "dimmed")

statTile <- function(label, value, sub = NULL) {
  Paper(
    withBorder = TRUE,
    radius = "md",
    p = "md",
    Text(
      label,
      size = "xs",
      c = "dimmed",
      fw = 600,
      style = list(letterSpacing = "0.3px")
    ),
    Title(value, order = 3, mt = 4),
    if (!is.null(sub)) Text(sub, size = "xs", c = "dimmed")
  )
}

riskBar <- function(label, value, valueLabel, color) {
  Group(
    justify = "space-between",
    wrap = "nowrap",
    gap = "md",
    Text(label, size = "sm", w = 90),
    Progress(
      value = value,
      color = color,
      size = "sm",
      radius = "xl",
      style = list(flexGrow = 1)
    ),
    Text(valueLabel, size = "sm", fw = 600, w = 60, ta = "right")
  )
}

resourceLink <- function(label) {
  Group(
    justify = "space-between",
    wrap = "nowrap",
    gap = 6,
    my = 2,
    Group(
      gap = 6,
      wrap = "nowrap",
      IconFileText(size = 14, color = "var(--mantine-color-blue-6)"),
      Anchor(label, href = "#", size = "sm", onClick = "event.preventDefault()")
    ),
    IconExternalLink(size = 12, color = "var(--mantine-color-gray-6)")
  )
}

fundFactRow <- function(label, value) {
  Grid(
    py = 6,
    GridCol(span = 5, Text(label, size = "sm", c = "dimmed")),
    GridCol(span = 7, Text(value, size = "sm", fw = 600))
  )
}

sectionToolbar <- function(...) {
  Group(
    justify = "space-between",
    align = "flex-end",
    mb = "lg",
    wrap = "wrap",
    ...
  )
}

pageHeading <- function(title, subtitle) {
  Stack(
    gap = 2,
    Title(title, order = 2),
    Text(subtitle, size = "sm", c = "dimmed")
  )
}

# --- Fictional data -----------------------------------------------------

returns_data <- data.frame(
  period = factor(
    c("1Y", "3Y", "5Y", "10Y"),
    levels = c("1Y", "3Y", "5Y", "10Y")
  ),
  fund = c(16.9, 11.0, 14.6, 9.6),
  benchmark = c(17.1, 11.1, 14.7, 9.7)
)

growth_years <- 2009:2018
growth_data <- data.frame(
  year = growth_years,
  fund = c(
    10000,
    10550,
    10300,
    11550,
    14550,
    16100,
    15750,
    16550,
    20150,
    20800
  ),
  benchmark = c(
    10000,
    10600,
    10250,
    11650,
    14750,
    16350,
    15900,
    16800,
    20450,
    21100
  )
)

sector_data <- data.frame(
  name = c(
    "Information Technology",
    "Financials",
    "Health Care",
    "Consumer Discretionary",
    "Industrials",
    "Consumer Staples",
    "Energy",
    "Materials",
    "Real Estate",
    "Utilities",
    "Telecommunication Services",
    "Other"
  ),
  fund = c(24.2, 14.9, 13.9, 12.6, 10.3, 7.9, 6.0, 2.9, 2.7, 1.9, 1.2, 1.5),
  color = c(
    "lime.6",
    "red.5",
    "blue.6",
    "teal.5",
    "orange.5",
    "yellow.5",
    "violet.6",
    "pink.5",
    "grape.6",
    "yellow.7",
    "green.4",
    "gray.4"
  )
)
sector_data$benchmark <- pmax(
  0.3,
  sector_data$fund +
    c(-1.1, 1.6, -0.8, 0.9, -1.4, 0.6, -0.5, 0.4, -0.3, 0.2, 0.1, 0.3)
)

fee_years <- 0:30
fund_fee <- 0.0014
cat_fee <- 0.0099
annual_return <- 0.07
fee_growth_data <- data.frame(
  year = fee_years,
  fund = 10000 * (1 + annual_return - fund_fee)^fee_years,
  category = 10000 * (1 + annual_return - cat_fee)^fee_years
)

fee_breakdown_data <- data.frame(
  step = factor(
    c("Management Fee", "Admin Fee", "12b-1 Fee", "Other", "Total Expense"),
    levels = c(
      "Management Fee",
      "Admin Fee",
      "12b-1 Fee",
      "Other",
      "Total Expense"
    )
  ),
  value = c(0.10, 0.02, 0.00, 0.02, 0.14)
)

dividend_data <- data.frame(
  month = factor(month.abb, levels = month.abb),
  amount = c(0, 0, 0.96, 0, 0, 0.96, 0, 0, 1.13, 0, 0, 1.13)
)

distributions_columns <- list(
  list(key = "type", label = "Type"),
  list(key = "amount", label = "Amount"),
  list(key = "record_date", label = "Record Date"),
  list(key = "reinvest_date", label = "Reinvest Date"),
  list(key = "payable_date", label = "Payable Date")
)
distributions_rows <- list(
  list(
    value = "d1",
    type = "Dividend",
    amount = "$1.12620",
    record_date = "12/21/2017",
    reinvest_date = "12/22/2017",
    payable_date = "12/26/2017"
  ),
  list(
    value = "d2",
    type = "Dividend",
    amount = "$1.12900",
    record_date = "09/18/2017",
    reinvest_date = "09/19/2017",
    payable_date = "09/20/2017"
  ),
  list(
    value = "d3",
    type = "Dividend",
    amount = "$0.96000",
    record_date = "06/21/2017",
    reinvest_date = "06/22/2017",
    payable_date = "06/23/2017"
  ),
  list(
    value = "d4",
    type = "Dividend",
    amount = "$0.96100",
    record_date = "03/20/2017",
    reinvest_date = "03/21/2017",
    payable_date = "03/22/2017"
  ),
  list(
    value = "d5",
    type = "Dividend",
    amount = "$1.25400",
    record_date = "12/20/2016",
    reinvest_date = "12/21/2016",
    payable_date = "12/22/2016"
  )
)

# --- Shared header/navbar ------------------------------------------------

dashboardHeader <- AppShellHeader(
  Group(
    h = "100%",
    px = "md",
    justify = "space-between",
    wrap = "nowrap",
    Group(
      wrap = "nowrap",
      navbarBurger("navOpened", opened = FALSE, hiddenFrom = "sm", size = "sm"),
      ThemeIcon(
        IconChartLine(size = 18),
        variant = "light",
        color = "blue",
        size = 32,
        radius = "md"
      ),
      Title("Investment Insights", order = 3)
    ),
    Group(
      gap = "lg",
      wrap = "nowrap",
      visibleFrom = "sm",
      Group(
        gap = 6,
        Box(
          w = 8,
          h = 8,
          style = list(
            borderRadius = "50%",
            backgroundColor = "var(--mantine-color-green-6)"
          )
        ),
        Text("Market Open", size = "sm")
      ),
      Text("NYSE", size = "sm", fw = 700),
      Group(
        gap = 4,
        Text("Last Updated", size = "sm", c = "dimmed"),
        Text("Apr 8, 2026 3:45 PM", size = "sm", fw = 600)
      ),
      ActionIcon(
        IconBell(size = 18),
        variant = "subtle",
        color = "gray",
        inputId = "bell_btn"
      )
    )
  )
)

dashboardNavbar <- AppShellNavbar(
  p = "md",
  AppShellSection(
    Text(
      "NAVIGATION",
      size = "xs",
      fw = 700,
      c = "dimmed",
      mb = "xs",
      style = list(letterSpacing = "0.5px")
    )
  ),
  AppShellSection(
    component = "div",
    navLinkItem(
      "navId",
      "dashboard",
      "Dashboard",
      leftSection = IconLayoutDashboard(size = 18)
    ),
    navLinkItem(
      "navId",
      "price",
      "Price Performance",
      leftSection = IconChartLine(size = 18)
    ),
    navLinkItem(
      "navId",
      "portfolio",
      "Portfolio Analysis",
      leftSection = IconChartPie(size = 18)
    ),
    navLinkItem(
      "navId",
      "fees",
      "Fees & Distributions",
      leftSection = IconFileText(size = 18)
    )
  ),
  AppShellSection(
    mt = "md",
    Divider(mb = "sm"),
    Text(
      "FUND INFO",
      size = "xs",
      fw = 700,
      c = "dimmed",
      mb = "xs",
      style = list(letterSpacing = "0.5px")
    ),
    Stack(
      gap = 6,
      Group(
        justify = "space-between",
        Text("Fund:", size = "sm", c = "dimmed"),
        Text("500 Index Fund", size = "sm", fw = 600)
      ),
      Group(
        justify = "space-between",
        Text("Category:", size = "sm", c = "dimmed"),
        Text("Large Blend", size = "sm", fw = 600)
      ),
      Group(
        justify = "space-between",
        Text("Expense:", size = "sm", c = "dimmed"),
        Badge("0.14%", color = "green", variant = "filled", size = "sm")
      )
    )
  ),
  AppShellSection(
    mt = "md",
    Divider(mb = "sm"),
    Text(
      "RESOURCES",
      size = "xs",
      fw = 700,
      c = "dimmed",
      mb = "xs",
      style = list(letterSpacing = "0.5px")
    ),
    Stack(
      gap = 4,
      resourceLink("Prospectus"),
      resourceLink("Fact Sheet"),
      resourceLink("Annual Report"),
      resourceLink("Tax Documents")
    )
  )
)

# --- "Executive Dashboard" page content (shared by Dashboard + Price Performance) ---

dashboardPageContent <- function() {
  Stack(
    gap = "lg",
    pageHeading(
      "Executive Dashboard",
      "Fund performance overview and key metrics"
    ),

    sectionToolbar(
      Group(
        wrap = "wrap",
        SegmentedControl(
          inputId = "period",
          value = "1Y",
          data = list("1Y", "3Y", "5Y", "10Y", "All")
        ),
        Select(
          inputId = "fund_pick",
          value = "500 Index Fund Inv",
          w = 220,
          data = list(
            "500 Index Fund Inv",
            "Total Market Index",
            "International Index"
          )
        ),
        Switch(inputId = "benchmark_toggle", label = "Benchmark", value = TRUE),
        NumberInput(
          inputId = "invest_amount",
          value = 10000,
          prefix = "$",
          thousandSeparator = ",",
          w = 140
        )
      ),
      Button(
        "Export Report",
        inputId = "export_btn",
        variant = "outline",
        leftSection = IconDownload(size = 16)
      )
    ),

    SimpleGrid(
      cols = list(base = 1, sm = 2, lg = 4),
      spacing = "md",
      kpiCard(
        "Net Asset Value",
        "$2,728.12",
        IconCurrencyDollar(size = 16),
        "blue",
        trendFooter("15.2% 1Y")
      ),
      kpiCard(
        "1 Year Return",
        "16.94%",
        IconTrendingUp(size = 16),
        "teal",
        dimFooter("vs S&P 500")
      ),
      kpiCard(
        "Expense Ratio",
        "0.14%",
        IconPercentage(size = 16),
        "grape",
        trendFooter("85% lower")
      ),
      kpiCard(
        "Category",
        "Large Blend",
        IconCategory(size = 16),
        "orange",
        dimFooter("Domestic Stock - General")
      )
    ),

    Grid(
      GridCol(
        span = list(base = 12, md = 6),
        Paper(
          withBorder = TRUE,
          radius = "md",
          p = "lg",
          h = "100%",
          Title("Average Annual Returns", order = 4, mb = "md"),
          BarChart(
            data = returns_data,
            dataKey = "period",
            h = 260,
            series = list(
              list(name = "fund", color = "blue.6", label = "500 Index Fund"),
              list(
                name = "benchmark",
                color = "gray.5",
                label = "S&P 500 Index"
              )
            ),
            withLegend = TRUE,
            withBarValueLabel = TRUE,
            unit = "%"
          )
        )
      ),
      GridCol(
        span = list(base = 12, md = 6),
        Paper(
          withBorder = TRUE,
          radius = "md",
          p = "lg",
          h = "100%",
          Title("Hypothetical Growth of $10,000", order = 4, mb = "md"),
          AreaChart(
            data = growth_data,
            dataKey = "year",
            h = 260,
            series = list(
              list(name = "fund", color = "blue.6", label = "500 Index Fund"),
              list(
                name = "benchmark",
                color = "gray.5",
                label = "S&P 500 Index"
              )
            ),
            withLegend = TRUE,
            curveType = "monotone",
            unit = "$"
          )
        )
      )
    ),

    Grid(
      GridCol(
        span = list(base = 12, md = 4),
        Paper(
          withBorder = TRUE,
          radius = "md",
          p = "lg",
          h = "100%",
          Title("Fund Facts", order = 4, mb = "sm"),
          Stack(
            gap = 0,
            fundFactRow("Asset Class", "Domestic Stock - General"),
            Divider(),
            fundFactRow("Category", "Large Blend"),
            Divider(),
            fundFactRow("Expense ratio", "0.14%"),
            Divider(),
            fundFactRow("Minimum investment", "$3,000"),
            Divider(),
            fundFactRow("Fund number", "0040"),
            Divider(),
            fundFactRow("Fund advisor", "Equity Index Group")
          )
        )
      ),
      GridCol(
        span = list(base = 12, md = 4),
        Paper(
          withBorder = TRUE,
          radius = "md",
          p = "lg",
          h = "100%",
          Title("Quick Comparison", order = 4, mb = "sm"),
          SimpleGrid(
            cols = 2,
            spacing = "sm",
            statTile("1Y RETURN", "16.94%", "Fund"),
            statTile("3Y RETURN", "11.00%", "Fund"),
            statTile("5Y RETURN", "14.57%", "Fund"),
            statTile("MIN INVESTMENT", "$3,000")
          )
        )
      ),
      GridCol(
        span = list(base = 12, md = 4),
        Paper(
          withBorder = TRUE,
          radius = "md",
          p = "lg",
          h = "100%",
          Title("Risk Overview", order = 4, mb = "md"),
          Stack(
            gap = "md",
            riskBar("Volatility", 32, "Medium", "blue"),
            riskBar("Beta", 68, "1.01", "green"),
            riskBar("Sharpe Ratio", 55, "0.85", "teal"),
            riskBar("Alpha", 15, "-0.05%", "orange")
          )
        )
      )
    )
  )
}

# --- "Portfolio Analysis" page content ------------------------------------

portfolioPageContent <- function() {
  Stack(
    gap = "lg",
    sectionToolbar(
      pageHeading(
        "Portfolio Analysis",
        "Asset allocation, sector breakdown, and portfolio characteristics"
      ),
      # A plain SegmentedControl, not Tabs(): Tabs() becomes "page-aware" and
      # hijacks the app's Pages() router as soon as it's nested anywhere
      # inside Pages() (see vignette("architecture")) — fine for real page
      # navigation, but wrong here, where this is just a cosmetic sub-view
      # toggle with no corresponding Page(value = "characteristics"/"risk").
      SegmentedControl(
        inputId = "portfolio_tab",
        value = "allocation",
        data = list(
          list(value = "allocation", label = "Allocation"),
          list(value = "characteristics", label = "Characteristics"),
          list(value = "risk", label = "Risk Analysis")
        )
      )
    ),

    Grid(
      GridCol(
        span = list(base = 12, md = 6),
        Paper(
          withBorder = TRUE,
          radius = "md",
          p = "lg",
          h = "100%",
          Title("Sector Allocation", order = 4, mb = "md"),
          Center(
            DonutChart(
              data = data.frame(
                name = sector_data$name,
                value = sector_data$fund,
                color = sector_data$color
              ),
              h = 320,
              size = 220,
              thickness = 32,
              withLabels = TRUE,
              labelsType = "percent",
              chartLabel = "Sectors"
            )
          )
        )
      ),
      GridCol(
        span = list(base = 12, md = 6),
        Stack(
          gap = "md",
          Paper(
            withBorder = TRUE,
            radius = "md",
            p = "lg",
            Title("Investment Style", order = 4, mb = "md"),
            SimpleGrid(
              cols = 3,
              spacing = 4,
              styleCell("Large Value", FALSE),
              styleCell("Large Blend", TRUE),
              styleCell("Large Growth", FALSE),
              styleCell("Mid Value", FALSE),
              styleCell("Mid Blend", FALSE),
              styleCell("Mid Growth", FALSE),
              styleCell("Small Value", FALSE),
              styleCell("Small Blend", FALSE),
              styleCell("Small Growth", FALSE)
            )
          ),
          Paper(
            withBorder = TRUE,
            radius = "md",
            p = "lg",
            Title("Portfolio Style Summary", order = 4, mb = "sm"),
            Group(
              mb = "sm",
              Badge("Large Cap", color = "blue", variant = "filled"),
              Badge("Blend", color = "gray", variant = "filled"),
              Badge("Domestic", color = "green", variant = "filled")
            ),
            Text(
              "This fund tracks the S&P 500 Index, providing broad exposure to large-cap U.S. equities across value, blend, and growth styles.",
              size = "sm",
              c = "dimmed"
            )
          )
        )
      )
    ),

    Paper(
      withBorder = TRUE,
      radius = "md",
      p = "lg",
      Title("Sector Allocation vs Benchmark", order = 4, mb = "md"),
      BarChart(
        data = sector_data[, c("name", "fund", "benchmark")],
        dataKey = "name",
        h = 420,
        # Counter-intuitively, Mantine's `orientation = "horizontal"` (the
        # default) means a normal chart with vertical bars; "vertical" is
        # what actually flips the bars sideways.
        orientation = "vertical",
        series = list(
          list(name = "fund", color = "blue.6", label = "Fund"),
          list(name = "benchmark", color = "gray.5", label = "Benchmark")
        ),
        # No `unit = "%"` here: in vertical (sideways-bar) orientation the
        # unit suffix attaches to the category axis labels, not the value
        # axis, which would break the sector names ("Financials%").
        withLegend = TRUE
      )
    )
  )
}

styleCell <- function(label, active) {
  Paper(
    p = "sm",
    radius = "sm",
    ta = "center",
    style = list(
      backgroundColor = if (active) {
        "var(--mantine-color-blue-6)"
      } else {
        "var(--mantine-color-gray-1)"
      },
      color = if (active) "white" else "var(--mantine-color-dark-6)"
    ),
    Text(label, size = "sm", fw = if (active) 700 else 400)
  )
}

# --- "Fees & Distributions" page content ----------------------------------

feesPageContent <- function() {
  Stack(
    gap = "lg",
    sectionToolbar(
      pageHeading(
        "Fees & Distributions",
        "Expense analysis, dividend history, and capital gains"
      ),
      Button(
        "Download Tax Forms",
        inputId = "download_tax_btn",
        variant = "outline",
        leftSection = IconDownload(size = 16)
      )
    ),

    Paper(
      withBorder = TRUE,
      radius = "md",
      p = "lg",
      Title("Fee Impact Calculator", order = 4),
      Text(
        "Adjust investment amount and time horizon to see the impact of fees",
        size = "sm",
        c = "dimmed",
        mb = "lg"
      ),
      Grid(
        GridCol(
          span = list(base = 12, md = 8),
          Stack(
            gap = "lg",
            NumberInput(
              inputId = "fee_amount",
              label = "Investment Amount",
              value = 10000,
              prefix = "$",
              thousandSeparator = ",",
              w = 220
            ),
            Stack(
              gap = 4,
              Text("Time Horizon (Years)", size = "sm", fw = 500),
              Slider(
                inputId = "fee_horizon",
                value = 10,
                min = 1,
                max = 30,
                marks = list(
                  list(value = 1, label = "1"),
                  list(value = 10, label = "10"),
                  list(value = 20, label = "20"),
                  list(value = 30, label = "30")
                )
              )
            )
          )
        ),
        GridCol(
          span = list(base = 12, md = 4),
          Paper(
            p = "md",
            radius = "md",
            ta = "center",
            style = list(backgroundColor = "var(--mantine-color-gray-0)"),
            Text("YOUR SAVINGS", size = "xs", c = "dimmed", fw = 700),
            Title("$1,913", order = 2, c = "green", mt = 4, mb = "sm"),
            Text("vs category average", size = "xs", c = "dimmed", mb = "md"),
            SimpleGrid(
              cols = 2,
              Stack(
                gap = 0,
                Text("This Fund", size = "xs", c = "dimmed"),
                Text("$19,672", size = "sm", fw = 700, c = "blue")
              ),
              Stack(
                gap = 0,
                Text("Category Avg", size = "xs", c = "dimmed"),
                Text("$17,759", size = "sm", fw = 700)
              )
            )
          )
        )
      )
    ),

    SimpleGrid(
      cols = list(base = 1, sm = 2, lg = 4),
      spacing = "md",
      kpiCard(
        "Expense Ratio",
        "0.14%",
        IconPercentage(size = 16),
        "green",
        Badge("85% below avg", color = "green", variant = "light", size = "sm")
      ),
      kpiCard(
        "Distribution Yield",
        "1.77%",
        IconChartLine(size = 16),
        "blue",
        dimFooter("Annual yield based on distributions")
      ),
      kpiCard(
        "SEC Yield",
        "1.77%",
        IconChartLine(size = 16),
        "blue",
        dimFooter("30-day SEC yield")
      ),
      kpiCard(
        "Annual Fee",
        "$14",
        IconCurrencyDollar(size = 16),
        "grape",
        dimFooter("Per $10,000 invested")
      )
    ),

    Grid(
      GridCol(
        span = list(base = 12, md = 6),
        Paper(
          withBorder = TRUE,
          radius = "md",
          p = "lg",
          h = "100%",
          Title("Fees on $10,000 Over 10 Years", order = 4, mb = "md"),
          # One row, two series (rather than two rows/one series): lets each
          # bar keep a fixed, distinct color (gray vs blue) without a
          # per-bar color callback, which would need to cross the R->JS
          # boundary as a function — not supported by this package's
          # plain-data serialization (see vignette("architecture")).
          BarChart(
            data = data.frame(
              metric = "Total fees",
              categoryAverage = 2242,
              thisFund = 329
            ),
            dataKey = "metric",
            h = 240,
            series = list(
              list(
                name = "categoryAverage",
                color = "gray.5",
                label = "Category Average"
              ),
              list(name = "thisFund", color = "blue.6", label = "This Fund")
            ),
            withLegend = TRUE,
            withBarValueLabel = TRUE,
            unit = "$"
          ),
          Text(
            "Save $1,913 over 10 years by choosing this fund",
            size = "sm",
            c = "green",
            ta = "center",
            fw = 600,
            mt = "xs"
          )
        )
      ),
      GridCol(
        span = list(base = 12, md = 6),
        Paper(
          withBorder = TRUE,
          radius = "md",
          p = "lg",
          h = "100%",
          Title("Expense Ratio Breakdown", order = 4, mb = "md"),
          BarChart(
            data = fee_breakdown_data,
            dataKey = "step",
            h = 240,
            series = list(list(name = "value", color = "blue.6")),
            withBarValueLabel = TRUE,
            unit = "%"
          )
        )
      )
    ),

    Paper(
      withBorder = TRUE,
      radius = "md",
      p = "lg",
      Title("Long-Term Cost Impact (7% annual return)", order = 4, mb = "md"),
      LineChart(
        data = fee_growth_data,
        dataKey = "year",
        h = 300,
        series = list(
          list(name = "fund", color = "blue.6", label = "This Fund (0.14%)"),
          list(
            name = "category",
            color = "gray.5",
            label = "Category Avg (0.99%)"
          )
        ),
        withLegend = TRUE,
        curveType = "monotone",
        unit = "$"
      )
    ),

    Title("Distributions", order = 3, mt = "sm"),
    Grid(
      GridCol(
        span = list(base = 12, md = 5),
        Paper(
          withBorder = TRUE,
          radius = "md",
          p = "lg",
          h = "100%",
          Title("Dividend Payment Calendar", order = 4, mb = "md"),
          BarChart(
            data = dividend_data,
            dataKey = "month",
            h = 280,
            series = list(list(name = "amount", color = "blue.6")),
            withBarValueLabel = TRUE,
            unit = "$"
          )
        )
      ),
      GridCol(
        span = list(base = 12, md = 7),
        Paper(
          withBorder = TRUE,
          radius = "md",
          p = "lg",
          h = "100%",
          Title("Recent Distributions", order = 4, mb = "md"),
          DataTable(
            inputId = "distrib_table",
            data = distributions_rows,
            columns = distributions_columns,
            sortable = TRUE
          )
        )
      )
    ),

    Title("Capital Gains", order = 3, mt = "sm"),
    Grid(
      GridCol(
        span = list(base = 12, md = 6),
        Paper(
          withBorder = TRUE,
          radius = "md",
          p = "lg",
          Title("Realized Gains", order = 4, mb = "sm"),
          Stack(
            gap = 0,
            fundFactRow("Realized capital gain/loss", "-$0.60"),
            Divider(),
            fundFactRow("Realized capital gain/loss as a % of NAV", "-0.23%"),
            Divider(),
            fundFactRow("Fiscal year end", "12/31/2018")
          )
        )
      ),
      GridCol(
        span = list(base = 12, md = 6),
        Paper(
          withBorder = TRUE,
          radius = "md",
          p = "lg",
          Title("Unrealized Appreciation", order = 4, mb = "sm"),
          Stack(
            gap = 0,
            fundFactRow("Unrealized appreciation/depreciation", "$107.02"),
            Divider(),
            fundFactRow(
              "Unrealized appreciation/depreciation as a % of NAV",
              "41.02%"
            )
          )
        )
      )
    )
  )
}

# --- App -------------------------------------------------------------------

ui <- tagList(
  MantineProvider(
    defaultColorScheme = "light",
    Pages(
      active = "dashboard",
      AppShell(
        navbar = list(
          width = 260,
          breakpoint = "sm",
          collapsed = list(mobile = TRUE)
        ),
        header = list(height = 60),
        padding = "lg",

        dashboardHeader,
        dashboardNavbar,

        AppShellMain(
          Page(value = "dashboard", dashboardPageContent()),
          Page(value = "price", dashboardPageContent()),
          Page(value = "portfolio", portfolioPageContent()),
          Page(value = "fees", feesPageContent())
        )
      )
    )
  )
)

server <- function(input, output, session) {
  observeEvent(input$export_btn, {
    showNotification(
      "Report exported (demo — no file is actually generated).",
      type = "message"
    )
  })
  observeEvent(input$download_tax_btn, {
    showNotification(
      "Tax forms downloaded (demo — no file is actually generated).",
      type = "message"
    )
  })
}

shinyApp(ui, server)
