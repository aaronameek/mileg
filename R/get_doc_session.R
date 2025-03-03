#' Reformat legislative document session year string
#'
#' @param doc_names A character vector of document names, such as "HB 4001 of 2025".
#'
#' @returns A character vector of properly-formatted, two-year legislative session IDs, formatted as "2025-2026". Adjusts for bills with even-number years in their name to the correct "odd-even" structure.
#' @export
#'
#' @examples
#' doc_name <- "HB 4001 of 2025"
#' get_doc_session(doc_names = doc_name)
#' # "2025-2026"
#' doc_names <- c("HB 4001 of 2025", "SB 1 of 2012", "PA 127 of 2018")
#' get_doc_session(doc_names = doc_names)
#' # "2025-2026" "2011-2012" "2017-2018")
get_doc_session <- function(doc_names) {
  # Compile regular expression for bill year
  bill_year_regex <- "(?<=of\\s)\\d{4}"

  # Extract all years at once
  years <- as.numeric(stringr::str_extract(doc_names, bill_year_regex))

  # Vectorized year adjustment
  is_even <- years %% 2 == 0
  year1 <- ifelse(is_even, years - 1, years)
  year2 <- year1 + 1

  paste0(year1, "-", year2)
}
