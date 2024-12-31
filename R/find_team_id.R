#' Find team ID for season
#'
#' NCAA datasets use a unique ID for each team and season. To access a team's
#' data, we must know the volleyball team ID. This function looks up the team ID
#' from [wvb_teams] or [mvb_teams] using the team name.
#' Team names can be found in [ncaa_teams] or searched with
#' [find_team_name()].
#'
#' @param name Name of school. Must match name used by NCAA.
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
#' find_team_id("Nebraska", 2024)
#' find_team_id("UCLA", 2023, sport = "MVB")
find_team_id <- function (name = NULL,
                          year = NULL,
                          sport = "WVB") {
  max_year <- most_recent_season()
  if (sport == "WVB") team_df <- ncaavolleyballr::wvb_teams
  else if (sport == "MVB") team_df <- ncaavolleyballr::mvb_teams
  else cli::cli_abort("Enter valid sport (\"WVB\" or \"MVB\").")
  if (is.null(name)) cli::cli_abort("Enter valid team name. Check `ncaa_teams` for names or search using `find_team_name()`.")
  if (!name %in% team_df$team_name) cli::cli_abort("Enter valid team name. Check `ncaa_teams` for names or search using `find_team_name()`.")
  if (is.null(year)) cli::cli_abort(paste0("Enter valid year between 2020-", max_year, "."))
  if (!is.numeric(year)) cli::cli_abort(paste0("Enter valid year between 2020-", max_year, "."))
  if (!year %in% 2020:max_year) cli::cli_abort(paste0("Enter valid year between 2020-", max_year, "."))

  team_df[team_df$team_name == name & team_df$yr == year, ]$team_id
}
