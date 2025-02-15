#' Import historical legislative data into database
#'
#' @param db_path A character vector of \code{length = 1} containing the path where the bill database is located.
#' @param previous_bills_df A dataframe or tibble. This will usually be created using \code{get_bill_table} and later loaded with a simple \code{read_csv} command.
#'
#' @returns Nothing explicitly except for a success, skip, or error message. Inserts data from \code{previous_bills_df} into bill database created using \code{bill_db_init}.
#' @export
#'
#' @examples
#' db_path <- here::here("legislation.db")
#' session_url <- "https://www.legislature.mi.gov/Search/ExecuteSearch?sessions=2025-2026&docTypes=House%20Bill,Senate%20Bill"
#' previous_bills_df <- get_bill_table(session_url)
#' bill_db_import_previous(db_path = db_path, previous_bills_df = previous_bills_df)
#' # If successful, returns "Historical data import completed successfully."
#' # If db_check_history(db_path) is TRUE, returns "Historical bill data has already been imported. Skipping import."
#' # If unsuccessful, returns "Error importing historical bill data:" and the associated error message.
bill_db_import_previous <- function(db_path, previous_bills_df) {

  # Check if historical data has already been imported
  if (db_check_history(db_path)) {
    message("Historical bill data has already been imported. Skipping import.")
    return(FALSE)
  }

  # Establish connection
  con <- DBI::dbConnect(RSQLite::SQLite(), db_path)

  # Use transaction for better performance
  DBI::dbBegin(con)
  tryCatch({
    # Insert or replace static records
    DBI::dbWriteTable(con, "bills", previous_bills_df, append = TRUE, overwrite = FALSE)

    # Record that historical import has been completed
    DBI::dbExecute(con, "
              INSERT INTO metadata (key, value)
              VALUES ('historical_import_completed', 'true')
              ")

    DBI::dbCommit(con)

    message("Historical data import completed successfully.")
    success <- TRUE

  }, error = function(e) {
    DBI::dbRollback(con)
    stop("Error importing historical bill data: ", e$message)
    success <- FALSE
  })

  # Disconnect from database
  DBI::dbDisconnect(con)
  return(success)
}
