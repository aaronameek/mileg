#' Initialize local database for storing bills
#'
#' @param db_path A character vector of \code{length = 1} that contains a path at which to create a database object. The preferred approach is to set the \code{db_path} beforehand using the \code{here} package (see Examples below). The database will be created if it does not already exist at the specified path; it will also create the \code{bills} and \code{metadata} tables for storing the data.
#'
#' @returns Nothing explicitly; creates a database object at the specified path.
#' @export
#'
#' @examples
#' bill_db_init(db_path = here::here("legislation.db"))
bill_db_init <- function(db_path) {

  # Establish connection
  con <- DBI::dbConnect(RSQLite::SQLite(), db_path)

  # Create bills table with
  DBI::dbExecute(con, "
    CREATE TABLE IF NOT EXISTS bills (
      bill_id TEXT PRIMARY KEY,
      bill_name TEXT,
      pa_id TEXT,
      pa_name TEXT,
      bill_session TEXT,
      bill_type TEXT,
      bill_area_major TEXT,
      bill_area_minor TEXT,
      bill_description TEXT,
      bill_url TEXT,
      is_current_session BOOLEAN,
      created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
      updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    )
  ")

  # Create metadata table to track import status
  DBI::dbExecute(con, "
    CREATE TABLE IF NOT EXISTS metadata (
      key TEXT PRIMARY KEY,
      value TEXT,
      updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    )
  ")

  # Create an index on bill_session for better query performance
  DBI::dbExecute(con, "CREATE INDEX IF NOT EXISTS idx_session ON bills(bill_session)")

  # Disconnect from database
  DBI::dbDisconnect(con)
}
