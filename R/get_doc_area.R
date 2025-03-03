#' Extract document subject area categories
#'
#' @param doc_descriptions A character vector of document descriptions, typically as part of a tibble produced by \code{get_bill_table}.
#'
#' @returns A character vector containing the major and minor subject area categories as "Major: minor".
#' @export
#'
#' @examples
#' doc_description <- "Transportation: funds; funding for sound wall projects; provide for. Amends 1951 PA 51 (MCL 247.651 - 247.675) by adding sec. 14b."
#' get_doc_area(doc_descriptions = doc_description)
#' # "Transportation: funds"
get_doc_area <- function(doc_descriptions) {
  area_regex <- "^([A-Za-z\\s\\'\\-]+(;|:)){2}"
  extracted <- stringr::str_extract(doc_descriptions, area_regex)
  cleaned <- stringr::str_remove(extracted, "(;|:)$")
  stringr::str_replace(cleaned, ";", ":")
}
