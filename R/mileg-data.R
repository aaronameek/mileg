#xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
# COMPILE FULL MICHIGAN LEGISLATURE DATA
#xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
#
# Author: Aaron A. Meek
# Email: aaronameek@gmail.com
# Created: 2025-02-15
# Updated: 2025-03-02
#
# This script compiles the FULL dataset for information on the
# Michigan Legislature. This includes lists of legislation by
# session, metadata on committees and actions taken on those
# pieces of legislation, information on (co)sponsorship by
# members, and other tidbits that may be useful to have in a
# single dataset. The compiled data can be used for, well,
# anything. For my purposes, it is a component of the {mileg}
# package that I developed to *analyze* the data.
#
# The script is set to gather data for all *previous* legislative
# sessions -- that is, not the current session. A careful look
# at the {mileg} package version history will reveal that this
# code used to (1) be external to the package and (2) designed
# to accommodate dynamic data from the current session as well
# as previous ones ("dynamic" in the sense that the script would
# run on a set schedule to pick up new changes to bills, actions,
# etc. from the ongoing legislative session). After noodling with
# the code after a short break, I decided this was not the best
# approach, especially for {mileg} package users. Live and learn!
#




#xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
# INITIALIZATION
#xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx

### ~~~ BENCHMARKING ~~~ ###
s_time <- Sys.time()


### PACKAGES
if (!require("pacman")) {
  install.packages("pacman")
}
pacman::p_load(tidyverse,   # data manipulation
               janitor,     # clean dataframes
               epoxy,       # string manipulation
               here,        # project paths
               fs,          # local files
               rvest,       # HTML scraping
               foreach,     # parallel processing
               doParallel   # parallel processing

)


### DIRECTORIES
DATA_DIR <- dir_create(here("data"))
INST_DIR <- dir_create(here("inst"))
raw_dir <- dir_create(here(INST_DIR, "extdata", "raw_legislation"))
raw_session_csv <- dir_create(here(raw_dir, "csv"))
clean_dir <- dir_create(here(INST_DIR, "extdata", "clean_legislation"))
clean_session_csv <- dir_create(here(clean_dir, "csv"))


### VARIABLES
# legislative session strings (always begin with odd-numbered year, e.g., 2005-2006 or 2025-2026)
y1 = seq(2005, year(now()), 2)
y1 = y1[-length(y1)]    # excludes current session
y2 = y1 + 1
sessions <- paste0(y1, "-", y2)

# docTypes (obtained manually by examining www.legislature.mi.gov search URLs)
doc_types <- c(bills = "HB%2CSB",
               res = "HR%2CSR",
               cres = "HCR%2CSCR",
               jres = "HJR%2CSJR")

# create data to loop over
mileg_urls <- c()
mileg_raw <- c()
mileg_clean <- c()
for (s in sessions) {
  for (d in doc_types) {
    mileg_raw <- append(mileg_raw, epoxy("{raw_session_csv}/mileg_{substr(s,1,4)}_{names(doc_types)[which(doc_types==d)]}_raw.csv"))
    mileg_clean <- append(mileg_clean, epoxy("{clean_session_csv}/mileg_{substr(s,1,4)}_{names(doc_types)[which(doc_types==d)]}_clean.csv"))
    mileg_urls <- append(mileg_urls, epoxy("https://www.legislature.mi.gov/Search/ExecuteSearch?chamber=&docTypesList={d}&sessions={s}"))
  }
}
mileg_dat <- data.frame(url = mileg_urls, raw_path = mileg_raw, clean_path = mileg_clean)




#xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
# SCRAPE LEGISLATION (Loop #1)
#xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx

### BEGIN LOOP
for (i in seq_len(nrow(mileg_dat))) {

  ## If no raw file exists --- or --- existing file is more than a month old, scrape data
  if (!file_exists(mileg_dat$raw_path[i]) || (Sys.time() - file_info(mileg_dat$raw_path[i])$birth_time) > 30) {

    # scrape table from URL
    raw_table <- mileg_dat$url[i] %>%
      read_html() %>%
      html_table() %>%
      pluck(1)

    ## If a raw historical file exists but not a clean file, use existing data for cleaning
  } else if (file_exists(mileg_dat$raw_path[i]) && !file_exists(mileg_dat$clean_path[i])) {

    # read raw data
    raw_table <- read_csv(mileg_dat$raw_path[i])

    ## If no conditions met, jump to next iteration (avoids unnecessary scraping)
  } else {

    # skip
    next

  }

  ## Compile after conditions clear
  # wait 5 seconds (web scraping golden rule: be polite!)
  Sys.sleep(5)

  # store at raw data path if new (overwrites existing no matter what)
  write_csv(raw_table, mileg_dat$raw_path[i])

  # clean raw data
  clean_table <- raw_table %>%
    clean_names() %>%
    rename(
      doc_type = type,
      doc_description = description
    ) %>%
    separate_wider_delim(
      cols = "document",
      delim = " (",
      names = c("doc_name", "alt_name"),
      too_few = "align_start",
      too_many = "drop"
    ) %>%
    mutate(
      doc_session = get_doc_session(doc_name),
      alt_name = str_remove_all(alt_name, "\\)"),
      doc_id = get_doc_id(doc_name),
      alt_id = get_doc_id(alt_name),
      doc_type = case_when(
        doc_type == "House Bill" ~ "HB",
        doc_type == "Senate Bill" ~ "SB",
        doc_type == "House Resolution" ~ "HR",
        doc_type == "Senate Resolution" ~ "SR",
        doc_type == "House Concurrent Resolution" ~ "HCR",
        doc_type == "Senate Concurrent Resolution" ~ "SCR",
        doc_type == "House Joint Resolution" ~ "HJR",
        doc_type == "Senate Joint Resolution" ~ "SJR",
        TRUE ~ NA_character_
      ),
      doc_area = get_doc_area(doc_description),
      doc_url = get_doc_url(doc_name)
    ) %>%
    separate_wider_delim(
      cols = "doc_area",
      delim = ": ",
      names = c("doc_area_major", "doc_area_minor"),
      too_few = "align_start",
      too_many = "drop"
    ) %>%
    select(doc_id, doc_name, alt_id, alt_name, doc_session,
           doc_type, doc_area_major, doc_area_minor,
           doc_description, doc_url)

  # store at clean data path
  write_csv(clean_table, mileg_dat$clean_path[i])

}


### CONSOLIDATE & SAVE LEGISLATION DATA
# raw data
raw_full <- bind_rows(lapply(dir_ls(raw_session_csv, glob = "*.csv"), read_csv))
write_csv(raw_full, path(raw_dir, paste0("raw_legislation_", Sys.Date(), ".csv")))

# clean data
clean_full <- bind_rows(lapply(dir_ls(clean_session_csv, glob = "*.csv"), read_csv))
write_csv(clean_full, path(clean_dir, paste0("clean_legislation_", Sys.Date(), ".csv")))

# create package-ready Rdata file
save(clean_full, file = path(DATA_DIR, "legislation.rda"))


### ~~~ BENCHMARKING ~~~ ###
e_time <- Sys.time()
(e_time - s_time)




#xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
# SCRAPE METADATA (Loop #2)
#xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx

### ~~~ BENCHMARKING ~~~ ###
s_time <- Sys.time()


### DIRECTORY
meta_dir <- dir_create(here(INST_DIR, "extdata", "meta"))


### PARALLEL PROCESSING
cluster <- makeCluster(detectCores() - 1)
registerDoParallel(cluster)

# create correctly-sized placeholder (preserves memory)
compiled_info <- vector("list", nrow(clean_full))

# parallel chunk
compiled_info <- foreach(f = 1:nrow(clean_full),
                         .packages = c("tidyverse", "purrr", "janitor", "epoxy", "rvest", "here", "fs"),
                         .errorhandling = "pass") %dopar% {

                           compiled_info[f] <- get_doc_info(
                             doc_id = clean_full$doc_id[f],
                             doc_type = clean_full$doc_type[f],
                             doc_url = clean_full$doc_url[f]
                           )

                         }

# end parallel processing
stopCluster(cl = cluster)


### EXTRACT ACTIONS, COMMITTEES, AND SPONSORS
actions <- bind_rows(map(compiled_info, ~pluck(.x, "actions")))
committees <- bind_rows(map(compiled_info, ~pluck(.x, "committees")))
sponsors <- bind_rows(map(compiled_info, ~pluck(.x, "sponsors")))


### SAVE METADATA
# write CSV files
write_csv(actions, path(meta_dir, "actions.csv"))
write_csv(committees, path(meta_dir, "committees.csv"))
write_csv(sponsors, path(meta_dir, "sponsors.csv"))

# create package-read RData files
save(actions, file = path(DATA_DIR, "actions.rda"))
save(committees, file = path(DATA_DIR, "committees.rda"))
save(sponsors, file = path(DATA_DIR, "sponsors.rda"))


### ~~~ BENCHMARKING ~~~ ###
e_time <- Sys.time()
(e_time - s_time)
