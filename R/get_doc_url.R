#' Create MI Legislature document URL from document name
#'
#' @param doc_names A character vector of legislative document names, such as "HB 4001 of 2025".
#'
#' @returns A character vector of properly-formatted MI Legislature URLs for the given \code{doc_names}.
#' @export
#'
#' @examples
#' doc_name <- "HB 4001 of 2025"
#' get_doc_url(doc_names = doc_name)
#' # "https://www.legislature.mi.gov/Bills/Bill?ObjectName=2025-HB-4001"
get_doc_url <- function(doc_names) {
  if (all(is.na(doc_names))) return(rep(NA_character_, length(doc_names)))

  parts <- stringr::str_split(doc_names, "\\s", simplify = TRUE)
  paste0(
    "https://www.legislature.mi.gov/Bills/Bill?ObjectName=",
    parts[, 4], "-", parts[, 1], "-", parts[, 2]
  )
}
