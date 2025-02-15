#' Compile Michigan Legislature data
#'
#' @param raw_dir A character vector of `length = 1` that contains a path where raw data will be stored.
#' @param clean_dir A character vector of `length = 1` that contains a path where clean data will be stored.
#'
#' @returns Nothing explicitly, but does create data directories and store flat files, which can be used independently or loaded into a legislation database created with `bill_db_init`.
#' @export
#'
#' @examples
fetch_bill_data <- function(raw_dir = here::here("data", "raw"), clean_dir = here::here("data", "clean")) {

  ## Create directories (defaults to "[wd]/data/raw" and "[wd]/data/clean")
  raw_dir <- fs::dir_create(raw_dir)
  clean_dir <- fs::dir_create(clean_dir)

  ## Generate legislative term strings
  y1 <- seq(2005, lubridate::year(lubridate::now()), 2)
  sessions <- glue::glue("{y1}-{y1+1}")

  ## Generate session bill table URLs
  session_urls <- glue::glue("https://www.legislature.mi.gov/Search/ExecuteSearch?sessions={sessions}&docTypes=House%20Bill,Senate%20Bill")

  ## Get current session URL and remove from original vector
  current_session_url <- session_urls[length(session_urls)]
  session_urls <- session_urls[-length(session_urls)]


  ### GET HISTORIC BILLS ###
  ## Set previous session path
  raw_previous_bills_path <- fs::path(raw_dir, "raw_previous_bills.csv")

  ## Condition previous session scrape on `file_exists()`
  if (!fs::file_exists(raw_previous_bills_path)) {
    ## Extract bill tables
    bill_tables <- purrr::map(
      .x = session_urls,
      .f = get_bill_table,
      .progress = FALSE   # not great for knitting if set to TRUE, but go for it
    )

    ## Flatten bill tables list
    raw_previous_bills_table <- dplyr::bind_rows(bill_tables) %>%
      dplyr::mutate(is_current_session = FALSE)

    ## Download previous session bills as flat file
    readr::write_csv(raw_previous_bills_table, raw_previous_bills_path)
  }

  ## Read the data whether it was just created or already existed
  raw_previous_bills_table <- readr::read_csv(raw_previous_bills_path, show_col_types = FALSE)

  ## Set processed table as new object
  cleaned_previous_bills <- process_bill_table(raw_previous_bills_table)

  ## Set path for cleaned previous bill data and download as flat file
  clean_previous_bills_path <- fs::path(clean_dir, "clean_previous_bills.csv")
  readr::write_csv(cleaned_previous_bills, clean_previous_bills_path)


  ### GET CURRENT BILLS ###
  ## Extract current bill table with helper function (no need to map since there's only URL)
  raw_current_bills_table <- get_bill_table(current_session_url) %>%
    dplyr::mutate(is_current_session = TRUE)

  ## Download current session bills as flat file
  raw_current_bills_path <- fs::path(raw_dir, "raw_current_bills.csv")
  readr::write_csv(raw_current_bills_table, raw_current_bills_path)

  ## Set cleaned table as new object
  cleaned_current_bills <- process_bill_table(raw_current_bills_table)

  ## Set path for cleaned current bill data and download as file
  clean_current_bills_path <- fs::path(clean_dir, "clean_current_bills.csv")
  readr::write_csv(cleaned_current_bills, clean_current_bills_path)

}
