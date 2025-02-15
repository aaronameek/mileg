
<!-- README.md is generated from README.Rmd. Please edit that file -->

# mileg

<!-- badges: start -->

<!-- badges: end -->

The goal of `{mileg}` is to offer anyone interested in Michigan politics
a convenient way of *programmatically* accessing data on the Mi(chigan)
Leg(islature). The programmatic piece is important: the tools here are
geared first towards researchers, who often find themselves in a
position of needing to compile and reformat state legislative data
before incorporating it into their project or analysis. The structure of
the package, however, could also be useful for folks in the policy
space, who may want to use the database for bill tracking or other
reporting. For casual onlookers, the Legislature’s public website is
likely more than enough, but everyone is welcome to explore this
resource for fun, too.

## Installation

You can install the development version of `{mileg}` from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("aaronameek/mileg")
```

## Setup & General Use

In general, the dual goals of package-ifying this project was to make it
both straightforward and flexible – that is, every `R` user knows *how*
to use a package, but they all have different use *cases*. For example,
a user could run this brief chunk and end up with a fully-functional
local database with 20 years worth of legislative data within a few
minutes:

``` r
## Load package
library(mileg)

## Fetch bill data
fetch_bill_data()

## Compile into database
bill_db_main(
  db_path = here::here("legislation.db"),
  previous_bills_df = readr::read_csv(fs::path("data", "clean", "clean_previous_bills", ext = "csv")),
  current_bills_df = readr::read_csv(fs::path("data", "clean", "clean_current_bills", ext = "csv"))
)
```

*This package is in active development. Apologies for any bugs,
deficiencies, or wild updates as I work out the kinks!*
