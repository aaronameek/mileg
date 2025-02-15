#' Main function to maintain legislation database
#'
#' @param db_path A character vector of \code{length = 1} containing the path where the bill database is located.
#' @param previous_bills_df A dataframe or tibble, typically created using \code{get_bill_table} or called using \code{read_csv}, containing all historical bill data.
#' @param current_bills_df A dataframe or tibble, typically created using \code{get_bill_table} or called using \code{read_csv}, containing all current session bill data.
#'
#' @returns Nothing explicitly; inserts and/or updates information in the database.
#' @export
#'
#' @examples
#' db_path <- here::here("legislation.db")
#' bill_db_main(db_path = db_path)  # This will refresh the database to make it current, because data should already be living in a folder!
bill_db_main <- function(db_path, previous_bills_df = NULL, current_bills_df = NULL) {

  # Initialize database if it doesn't exist
  bill_db_init(db_path)

  # Import historical data if provided (and not already imported)
  if (!is.null(previous_bills_df)) {
    bill_db_import_previous(db_path, previous_bills_df)
  }

  # Update current session if provided
  if (!is.null(current_bills_df)) {
    bill_db_update_current(db_path, current_bills_df)
  }
}
