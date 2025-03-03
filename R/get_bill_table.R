#' Extract a bill table from a MI Legislature session URL
#'
#' @param session_url A character vector with one element, which is a properly-formatted URL string.
#'
#' @returns A tibble.
#' @export
#'
#' @examples
#' session_url <- "https://www.legislature.mi.gov/Search/ExecuteSearch?sessions=2025-2026&docTypes=House%20Bill,Senate%20Bill"
#' get_bill_table(session_url)
get_bill_table <- function(session_url) {
  session_url %>%
    rvest::read_html() %>%
    rvest::html_table() %>%
    purrr::pluck(1)
}
