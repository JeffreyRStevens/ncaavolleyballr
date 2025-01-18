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
#' @param year Numeric vector of years for fall of desired seasons.
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
find_team_id <- function(team = NULL,
                         year = NULL,
                         sport = "WVB") {
  # check inputs
  team_df <- check_sport(sport, vb_only = TRUE)
  check_team_name(team, teams = team_df)
  check_year(year)

  # extract team_id
  team_df[team_df$team_name %in% team & team_df$yr %in% year, ]$team_id
}
