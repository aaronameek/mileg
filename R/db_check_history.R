#' Check for historical bill data updates
#'
#' @param db_path A character vector of \code{length = 1} that contains the path location of a database object created by \code{bill_db_init}.
#'
#' @returns \code{TRUE} if historical bill data has already been imported via \code{bill_db_import_previous}.
#' @export
#'
#' @examples
#' db_path <- here::here("legislation.db")
#' db_check_history(db_path = db_path)
#' # TRUE
db_check_history <- function(db_path) {
  con <- DBI::dbConnect(RSQLite::SQLite(), db_path)
  result <- DBI::dbGetQuery(con, "
                         SELECT value FROM metadata
                         WHERE key = 'historical_import_completed'
                       ")

  DBI::dbDisconnect(con)

  return(nrow(result) > 0 && result$value == "true")

}
