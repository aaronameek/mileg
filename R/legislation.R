#' Current Michigan Legislature data
#'
#' A dataset containing over 20 years of legislation information from the
#' Michigan Legislature. The variables are as follows:
#'
#' @name legislation
#' @author Aaron A. Meek \email{aaronameek@gmail.com}
#' @docType data
#'
#' @format A data frame with each row as a legislative document and 11 variables:
#' \describe{
#'  \item{doc_id}{unique document ID ("25hb4001")}
#'  \item{doc_name}{original name of the document ("HB 4001 of 2025")}
#'  \item{alt_id}{only present for Public Acts, otherwise NA; unique document ID ("25pa0001")}
#'  \item{alt_name}{original name of the Public Act ("PA 0001 of 2025")}
#'  \item{doc_session}{two-year legislative session string formatted as "2025-2026" that will always have an odd-numbered year first}
#'  \item{doc_type}{abbreviated document type obtained by shortening the Type value in the raw data ("HB")}
#'  \item{doc_area_major}{only present for bills, otherwise NA; general policy area}
#'  \item{doc_area_minor}{only present for bills, otherwise NA; specific policy sub-area}
#'  \item{doc_description}{original Description value from the raw data}
#'  \item{doc_url}{document page URL on the Michigan Legislature's website}
#'  \item{is_current_session}{TRUE if the document is from the current legislative session and FALSE otherwise}
#' }
#'
#' @references \url{legislature.mi.gov}
#' @keywords data
#' @source {mileg} R package
NULL
