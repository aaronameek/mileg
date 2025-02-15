#' Update current session legislation data in database
#'
#' @param db_path A character vector of \code{length = 1} containing the path where the bill database is located.
#' @param current_bills_df A dataframe or tibble. This will usually be created using \code{get_bill_table} and later loaded with a simple \code{read_csv} command.
#'
#' @returns Nothing explicitly except for a success or error message. Inserts data from \code{current_bills_df} into bill database created using \code{bill_db_init}.
#' @export
#'
#' @examples
#' db_path <- here::here("legislation.db")
#' session_url <- "https://www.legislature.mi.gov/Search/ExecuteSearch?sessions=2025-2026&docTypes=House%20Bill,Senate%20Bill"
#' current_bills_df <- get_bill_table(session_url)
#' bill_db_update_current(db_path = db_path, current_bills_df = current_bills_df)
#' # If successful, returns nothing.
#' # If unsuccessful, returns "Error updating current session data:" and the associated error message.
bill_db_update_current <- function(db_path, current_bills_df) {

  # Establish connection
  con <- DBI::dbConnect(RSQLite::SQLite(), db_path)

  # Use transaction for better performance
  DBI::dbBegin(con)
  tryCatch({
    # First, remove existing records for current session
    DBI::dbExecute(con, "DELETE FROM bills WHERE is_current_session = TRUE")

    # Then, insert the updated current session data
    DBI::dbWriteTable(con, "bills", current_bills_df, append = TRUE)
    DBI::dbCommit(con)

  }, error = function(e) {
    DBI::dbRollback(con)
    stop("Error updating current session data: ", e$message)
  })

  # Disconnect from database
  DBI::dbDisconnect(con)

}
