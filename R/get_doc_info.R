## Helper function to extract document information (actions, sponsors, etc.)
get_doc_info <- function(doc_id, doc_type, doc_url) {
  
  # Declare placeholder list to store document info
  doc_info <- list()
  
  # Extract full page HTML
  doc_page <- read_html(doc_url)
  
  # From HTML, retrieve sponsors
  pluck(.x = doc_info, "sponsors") <- doc_page %>%
    html_elements(css = "#SponsorList") %>%
    html_elements("li") %>%
    html_text() %>%
    trimws("both") %>%
    str_remove_all("[\\(\\)]") %>%
    str_split("\\s+District\\s+") %>%
    lapply(X = ., FUN = function(X) {
      setNames(X, c("legislator_name", "legislator_district"))
    }) %>%
    bind_rows() %>%
    mutate(
      legislator_district = case_when(
        startsWith(doc_type, "S") ~ paste0("S", legislator_district),
        startsWith(doc_type, "H") ~ paste0("H", legislator_district)
      ),
      primary_sponsor = ifelse(row_number() == 1, TRUE, FALSE),
      doc_id = doc_id
    ) %>%
    select(doc_id, legislator_name, legislator_district, primary_sponsor)
  
  # From HTML, retrieve actions
  pluck(.x = doc_info, "actions") <- doc_page %>%
    html_table() %>%
    pluck(1) %>%
    clean_names() %>%
    mutate(
      date = mdy(date),
      doc_id = doc_id,
      action_id = row_number(),
      senate_committee = str_extract(action, "(?<=(SELECT |)COMMITTEE ON ).*?$"),
      house_committee = str_extract(action, "(?<=(Select |)Committee on ).*?$")
    ) %>%
    fill(senate_committee, .direction = "down") %>%
    fill(house_committee, .direction = "down") %>%
    rename(action_date = date,
           action_description = action) %>%
    select(doc_id, action_id, action_date, action_description,
           journal, senate_committee, house_committee)
  
  # From `actions`, retrieve committees
  pluck(.x = doc_info, "committees") <- pluck(.x = doc_info, "actions") %>%
    mutate(
      senate_committee_refdate = first(action_date[!is.na(senate_committee)]),
      house_committee_refdate = first(action_date[!is.na(house_committee)]),
      senate_committee = first(senate_committee[!is.na(senate_committee)]),
      house_committee = first(house_committee[!is.na(house_committee)])
    ) %>%
    select(doc_id, senate_committee, senate_committee_refdate, house_committee, house_committee_refdate) %>%
    distinct()
  
  # Return list of info tibbles
  return(doc_info)
}
