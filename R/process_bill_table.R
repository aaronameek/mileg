#' Process a table of bills
#'
#' @param raw_bills_table A tibble, typically provided by \code{get_bill_table}.
#'
#' @returns A tibble.
#' @export
#'
#' @examples
#' su <- "https://www.legislature.mi.gov/Search/ExecuteSearch?sessions=2025-2026&docTypes=House%20Bill,Senate%20Bill"
#' bt <- get_bill_table(su)
#' process_bill_table(bt)
process_bill_table <- function(raw_bills_table) {
  cleaned_bills_table <- raw_bills_table %>%
    janitor::clean_names() %>%
    dplyr::rename(
      bill_type = type,
      bill_description = description
    ) %>%
    tidyr::separate_wider_delim(
      cols = "document",
      delim = " (",
      names = c("bill_name", "pa_name"),
      too_few = "align_start",
      too_many = "drop"
    ) %>%
    dplyr::mutate(
      bill_session = get_doc_session(bill_name),
      pa_name = stringr::str_remove_all(pa_name, "\\)"),
      bill_id = get_doc_id(bill_name),
      pa_id = get_doc_id(pa_name),
      bill_type = dplyr::if_else(
        bill_type == "Senate Bill", "SB",
        dplyr::if_else(bill_type == "House Bill", "HB", NA_character_)
      ),
      bill_area = get_doc_area(bill_description),
      bill_url = get_doc_url(bill_name)
    ) %>%
    tidyr::separate_wider_delim(
      cols = "bill_area",
      delim = ": ",
      names = c("bill_area_major", "bill_area_minor"),
      too_few = "align_start",
      too_many = "drop"
    ) %>%
    dplyr::select(bill_id, bill_name, pa_id, pa_name, bill_session,
                  bill_type, bill_area_major, bill_area_minor,
                  bill_description, bill_url, is_current_session)

  return(cleaned_bills_table)
}
