
<!-- README.md is generated from README.Rmd. Please edit that file -->

# mileg

<!-- badges: start -->

<!-- badges: end -->

The goal of mileg is to offer anyone interested in Michigan politics a
convenient way of *programmatically* accessing data on the Mi(chigan)
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
to use a package, but they all have different use *cases*. In this vein,
the package ships with up-to-date data that is compiled on the back-end
(read: outside of the package) to eliminate the need for users to gather
it themselves, while the functions draw on this included data for the
package’s core operations. Of course, in the event that a user needs to
maintain a fixed dataset (such as for academic research), it is wise to
save a timestamped copy of the data locally, import the copied data in
the initialization stage of your workflow, and then use the package’s
functions accordingly.

``` r
## Load main package
library(mileg)

## View head of built-in legislation data
head(mileg::legislation)

## Export fixed version of legislation data...
write.csv(mileg::legislation, "my_legislation.csv")

## ... and import the fixed version later
my_legislation <- read.csv("my_legislation.csv")
```

## Data

The following datasets come included with the package:

- `legislation`: All legislative bills, resolutions, concurrent
  resolutions, and joint resolutions from both chambers of the Michigan
  Legislature (House of Representatives and Senate) starting in the
  2005-2006 legislative session. <!--
  - `actions`: AAA
  - `legislators`: AAA
  - `sponsors`: AAA
  - `committees`: AAA
  -->

*NOTE: This package is in active development. Apologies for any bugs,
deficiencies, or wild updates as I work out the kinks!*
