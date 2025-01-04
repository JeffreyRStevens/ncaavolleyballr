

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
#' @param team_id Team ID
#'
#' @keywords internal
#'
check_team_id <- function(team_id = NULL) {
  teams <- dplyr::bind_rows(ncaavolleyballr::wvb_teams, ncaavolleyballr::mvb_teams)
  if (is.null(team_id)) cli::cli_abort(paste0("Enter valid team ID as a character string."))
  if (!is.character(team_id)) cli::cli_abort("Enter valid team ID as a character string.")
  if (!all(team_id %in% c(teams$team_id))) cli::cli_abort("Enter valid team ID. \"{team_id}\" was not found in the list of valid IDs.")
}


#' Gets year, team, and conference from team ID
#'
#' @param team_id Team ID
#'
#' @keywords internal
#'
get_team_info <- function(team_id = NULL) {
  teams <- dplyr::bind_rows(ncaavolleyballr::wvb_teams, ncaavolleyballr::mvb_teams)
  team <- teams[which(teams == team_id), ]$team_name
  conference <- teams[which(teams == team_id), ]$conference
  yr <- teams[which(teams == team_id), ]$yr
  c(Year = yr, Team = team, Conference = conference)
}

#' Assigns most recent season
#'
#' @keywords internal
#'
most_recent_season <- function() {
  2024
}

#' Save data frames
#'
#' @keywords internal
#'
save_df <- function(x, label, group, year, division, conf, sport, path) {
# save_df <- function(...) {
  if (length(year) > 1) year <- paste0(min(year), "-", max(year))
  if (group == "conf") confdiv <- tolower(gsub(" ", "", conf))
  if (group == "div") confdiv <- paste0(group, division)
  utils::write.csv(x,
                   paste0(path, tolower(sport), "_", label, "_", confdiv, "_", year, ".csv"), row.names = FALSE)
}
