
<!-- README.md is generated from README.Rmd. Please edit that file -->

# mileg

<!-- badges: start -->

<!-- badges: end -->

The goal of mileg is to offer anyone interested in Michigan politics a
convenient way of programmatically accessing data on the Mi(chigan)
Leg(islature). The programmatic piece is important: the tools here are
geared first towards researchers, who often find themselves in a
position of needing to compile and reformat data from, \*checks notes\*,
*inconvenient* sources before incorporating it into their project or
analysis. The structure of the package, however, could also be useful
for folks in the policy space, who may want to use the database for bill
tracking or other reporting.

For casual onlookers, the Legislature’s public website is likely more
than enough, but everyone is welcome to explore this resource for fun.
As with anything in R, the open-source and free nature of the project is
also hopefully appealing, given the often unreasonable price tags or
other barriers to entry associated with using proprietary APIs or
programs. So there’s that, too.

## Installation

You can install mileg from [GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("aaronameek/mileg")
```

## Setup & General Use

In general, the dual goal of package-ifying this project was to make it
both straightforward and flexible – that is, every `R` user knows *how*
to use a package, but they all have different use *cases*. (An added
bonus was getting myself more comfortable with GitHub and package
development in general.) The package ships with “built-in” data (as .rda
files), the actual CSV files in the inst/extdata directory, and the
script that I use to compile everything locally (R/mileg-data.R).
Regardless of which you use, these will all provide you with data up to
(and including) the legislative session immediately preceding the
current/ongoing one.

Earlier versions of mileg attempted to keep up with current session data
by bifurcating new and previous sessions and then updating the package
with the new data, but I quickly decided to scrap that in favor of a
more straightforward and parsimonious system that only includes past
legislative sessions. Of course, in the event that a user needs to
maintain a truly *fixed* dataset (such as for academic research), it is
wise to save a versioned copy of your desired data locally, import that
copied data in the initialization stage of your workflow, and then use
the package’s other functions accordingly.

``` r
## Load main package
library(mileg)

## View head of built-in legislation data
head(mileg::legislation)

## Export fixed version of legislation data...
write.csv(mileg::legislation, "legislation_YYYY-MM-DD.csv")

## ... and import the fixed version later
my_project_legislation <- read.csv("legislation_YYYY-MM-DD.csv"")
```

## Data

The following datasets are compiled using the mileg_data.R script. They
come included with the package as both RData and CSV files:

- `legislation`: Table containing all legislative bills, resolutions,
  concurrent resolutions, and joint resolutions from both chambers of
  the Michigan Legislature (House of Representatives and Senate)
  starting in the 2005-2006 legislative session.
- `actions`: Table containing all actions taken on legislation in both
  chambers of the legislature and governor (e.g., vetoes). Can be used
  for survival analysis and other time-driven tests.
- `sponsors`: Table containing the standard document ID and information
  about each legislator who sponsored the legislation (name, district,
  and a TRUE/FALSE indicator of whether they are the primary sponsor).
  Can be converted into an edge list to facilitate cosponsorship
  analysis.
- `committees`: Table with one row per legislative document ID
  containing the House and Senate committees to which the bill was
  referred and the date. Good for general information or being combined
  with the `legislation` or `actions` tables.

The data are easily join-able on the `doc_id` variable, which is
essentially a “primary key” in SQL/database terms.

## Package Functions

*In development – stay tuned!*
