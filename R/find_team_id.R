#' Find team ID for season
#'
#' NCAA datasets use a unique ID for each team and season. To access a team's
#' data, we must know the team ID. This function looks up the team ID from
#' \code{\link{wvb_teams}} or \code{\link{mvb_teams}} using the team name.
#' Team names can be found in \code{\link{ncaa_teams}} or searched with
#' \code{\link{find_team_name}()}.
#'
#' @param name Name of school. Must match name used by NCAA.
#' @inheritParams get_teams
#'
#' @returns
#' Returns a character string of team ID.
#'
#' @export
#'
#' @examples
#' find_team_id("Nebraska", 2024)
#' find_team_id("UCLA", 2023, sport = "MVB")
find_team_id <- function (name,
                          year,
                          sport = "WVB") {
  if (sport == "WVB") teams <- ncaavolleyballr::wvb_teams
  else if (sport == "MVB") teams <- ncaavolleyballr::mvb_teams
  else cli::cli_abort("Invalid sport entered. Must be 'WVB' or 'MVB'.")
  if (!name %in% teams$team_name) cli::cli_abort("Team name was not found.")
  if (!is.numeric(year)) cli::cli_abort("`year` must be a numeric.")
  if (!year %in% 2020:2024) cli::cli_abort("`year` must be between 2020-2024.")

  teams[teams$team_name == name & teams$yr == year, ]$team_id
}
