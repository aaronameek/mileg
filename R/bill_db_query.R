#' Flexibly query a legislation database
#'
#' @param db_path A character vector of \code{length = 1} containing the path where the bill database is located.
#' @param session_years A character vector of \code{length = 1} containing a valid session-years string, such as "2025-2026".
#' @param current_session_only Set to \code{FALSE} by default; if changed to \code{TRUE}, returns only the current session's bills.
#'
#' @returns A tibble.
#' @export
#'
#' @examples
#' db_path <- here::here("legislation.db")
#' bill_db_query(db_path = db_path, session_years = "2015-2016", current_session_only = FALSE)
#' # Returns a tibble with data on all bills from the 2015-2016 legislative session.
bill_db_query <- function(db_path, session_years = NULL, current_session_only = FALSE) {

  # Establish connection
  con <- dbConnect(RSQLite::SQLite(), db_path)

  # Create dynamic query string
  query <- "SELECT * FROM bills WHERE 1=1"
  if (!is.null(session_years)) {
    query <- paste0(query, " AND bill_session = '", session_years, "'")
  }
  if (current_session_only) {
    query <- paste(query, "AND is_current_session = TRUE")
  }

  # Get results
  results <- DBI::dbGetQuery(con, query)

  # Disconnect from database
  DBI::dbDisconnect(con)

  # Return result object
  return(results)
}
