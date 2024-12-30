

#' Find team ID for year
#'
#' @param name Name of school. Must match name used by NCAA.
#' @param year Year for fall volleyball season
#' @param sport Three letter abbreviation for NCAA sport (must be upper case;
#' for example "WVB" for women's volleyball and "MVB" for men's volleyball).
#'
#' @returns
#' Character string of team ID
#' @export
#'
#' @examples
#' find_team_id("Nebraska", 2024)
#' find_team_id("UCLA", 2023, sport = "MVB")
find_team_id <- function (name, year, sport = "WVB") {
  if (sport == "WVB") teams <- wvb_teams
  else if (sport == "MVB") teams <- mvb_teams
  else cli::cli_abort("Invalid sport entered. Must be 'WVB' or 'MVB'.")
  if (!name %in% teams$team_name) cli::cli_abort("Team name was not found.")
  if (!is.numeric(year)) cli::cli_abort("`year` must be a numeric.")
  if (!year %in% 2020:2024) cli::cli_abort("`year` must be between 2020-2024.")
  teams[teams$team_name == name & teams$yr == year, ]$team_id
}
