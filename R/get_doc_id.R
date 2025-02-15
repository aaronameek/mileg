#' Rearrange a document name/title into an ID
#'
#' @param doc_names A character vector of legislative document names/titles, such as "HB 4001 of 2025".
#'
#' @returns A character vector.
#' @export
#'
#' @examples
#' doc_name <- "HB 4001 of 2025"
#' get_doc_id(doc_names = doc_name)
#' doc_names <- c("HB 4001 of 2025", "SB 1 of 2025", "PA 127 of 2025")
#' get_doc_id(doc_names = doc_names)
get_doc_id <- function(doc_names) {
  # Handle NA values
  if (all(is.na(doc_names))) return(rep(NA_character_, length(doc_names)))

  # Create result vector of NAs
  result <- rep(NA_character_, length(doc_names))

  # Only process non-NA values
  valid_idx <- !is.na(doc_names)
  if (!any(valid_idx)) return(result)

  # Split all valid names at once
  parts <- stringr::str_split(doc_names[valid_idx], "\\s", simplify = TRUE)

  # Vectorized type conversion
  types <- parts[, 1]
  types[types == "SB"] <- "s"
  types[types == "HB"] <- "h"
  types[types == "PA"] <- "pa"
  types[!types %in% c("s", "h", "pa")] <- NA

  # Vectorized number padding
  numbers <- parts[, 2]
  num_chars <- nchar(numbers)
  numbers <- dplyr::case_when(
    num_chars == 1 ~ paste0("000", numbers),
    num_chars == 2 ~ paste0("00", numbers),
    num_chars == 3 ~ paste0("0", numbers),
    num_chars == 4 ~ numbers,
    TRUE ~ NA_character_
  )

  # Vectorized year processing
  years <- substr(parts[, 4], 3, 4)

  # Combine results only for valid entries
  result[valid_idx] <- ifelse(
    is.na(types) | is.na(numbers) | is.na(years),
    NA_character_,
    paste0(years, types, numbers)
  )

  return(result)
}
