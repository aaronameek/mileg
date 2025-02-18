#' Current Michigan Legislature data
#'
#' A dataset containing over 20 years of committee referral information from the
#' Michigan Legislature. The variables are as follows:
#'
#' @name committees
#' @author Aaron A. Meek \email{aaronameek@gmail.com}
#' @docType data
#'
#' @format A data frame with 1 row for each unique doc_id and 5 variables:
#' \describe{
#'  \item{doc_id}{unique document ID ("25hb4001")}
#'  \item{senate_committee}{name of the Senate committee to which the legislation was referred}
#'  \item{senate_committee_refdate}{date that the legislation was referred to the Senate committee}
#'  \item{house_committee}{name of the House committee to which the legislation was referred}
#'  \item{house_committee_refdate}{date that the legislation was referred to the House committee}
#' }
#'
#' @references \url{legislature.mi.gov}
#' @keywords data
#' @source {mileg} R package
NULL
