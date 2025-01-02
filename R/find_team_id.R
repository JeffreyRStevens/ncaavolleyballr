#' Find team ID for season
#'
#' NCAA datasets use a unique ID for each team and season. To access a team's
#' data, we must know the volleyball team ID. This function looks up the team ID
#' from [wvb_teams] or [mvb_teams] using the team name.
#' Team names can be found in [ncaa_teams] or searched with
#' [find_team_name()].
#'
#' @param team Name of school. Must match name used by NCAA. Find exact team
#' name with [find_team_name()].
#' @inheritParams get_teams
#'
#' @returns
#' Returns a character string of team ID.
#'
#' @export
#'
#' @family search functions
#'
#' @examples
#' find_team_id(team = "Nebraska", year = 2024)
#' find_team_id(team = "UCLA", year = 2023, sport = "MVB")
find_team_id <- function (team = NULL,
                          year = NULL,
                          sport = "WVB") {
  max_year <- most_recent_season()
  if (sport == "WVB") team_df <- ncaavolleyballr::wvb_teams
  else if (sport == "MVB") team_df <- ncaavolleyballr::mvb_teams
  else cli::cli_abort("Enter valid sport (\"WVB\" or \"MVB\").")
  if (is.null(team)) cli::cli_abort("Enter valid team name. Check `ncaa_teams` for names or search using `find_team_name()`.")
  if (!team %in% team_df$team_name) cli::cli_abort("Enter valid team name. Check `ncaa_teams` for names or search using `find_team_name()`.")
  if (is.null(year)) cli::cli_abort(paste0("Enter valid year between 2020-", max_year, "."))
  if (!is.numeric(year)) cli::cli_abort(paste0("Enter valid year between 2020-", max_year, "."))
  if (!year %in% 2020:max_year) cli::cli_abort(paste0("Enter valid year between 2020-", max_year, "."))

  team_df[team_df$team_name == team & team_df$yr == year, ]$team_id
}
