#' Current Michigan Legislature data
#'
#' A dataset containing over 20 years of actions on legislative documents from the
#' Michigan Legislature. The variables are as follows:
#'
#' @name actions
#' @author Aaron A. Meek \email{aaronameek@gmail.com}
#' @docType data
#'
#' @format A data frame with each row as an action taken on a legislative document and 7 variables:
#' \describe{
#'  \item{doc_id}{unique document ID ("25hb4001")}
#'  \item{action_id}{counter for the actions on a doc_id}
#'  \item{action_date}{date of the action}
#'  \item{action_description}{raw description of the action from the public website}
#'  \item{journal}{string containing the chamber, volume, and page of the legislative journal}
#'  \item{senate_committee}{name of the Senate committee to which the legislation was referred}
#'  \item{house_committee}{name of the House committee to which the legislation was referred}
#' }
#'
#' @references \url{legislature.mi.gov}
#' @keywords data
#' @source {mileg} R package
NULL
