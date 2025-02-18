#' Current Michigan Legislature data
#'
#' A dataset containing over 20 years of legislative sponsorship information from the
#' Michigan Legislature. Can easily be converted into an "edge list" for network-like
#' cosponsorship analysis. The variables are as follows:
#'
#' @name sponsors
#' @author Aaron A. Meek \email{aaronameek@gmail.com}
#' @docType data
#'
#' @format A data frame with 1 row for each legislator (by doc_id) and 4 variables:
#' \describe{
#'  \item{doc_id}{unique document ID ("25hb4001")}
#'  \item{legislator_name}{name of the legislative sponsor}
#'  \item{legislator_district}{House or Senate district of the legislator}
#'  \item{primary_sponsor}{TRUE if the legislator is the primary sponsor, FALSE if a cosponsor}
#' }
#'
#' @references \url{legislature.mi.gov}
#' @keywords data
#' @source {mileg} R package
NULL
