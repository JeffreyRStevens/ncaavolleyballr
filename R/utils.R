

#' Submit URL request, check, and return response
#'
#' @param url URL for request.
#' @param timeout Numeric of maximum number of seconds to wait for timeout.
#'
#' @keywords internal
#'
request_url <- function(url, timeout = 5) {
  # First check internet connection
  if (!curl::has_internet()) {
    message("No internet connection.")
    return(invisible(NULL))
  }
  # Perform request and record response
  response <- httr2::request(url) |>
    httr2::req_user_agent("Sample Company Name AdminContact@<sample company domain>.com") |>
    httr2::req_perform()
  # Check status of response and return if status is OK
  httr2::resp_check_status(response)
}


#' Checks if team ID is valid
#'
#' @param id Team ID
#'
#' @keywords internal
#'
check_team_id <- function(id) {
  if (!is.character(id)) cli::cli_abort("Team ID must be a character string.")
  if (!id %in% c(wvb_teams$team_id, mvb_teams$team_id)) cli::cli_abort("Team ID was not found in the list of valid IDs.")
}
