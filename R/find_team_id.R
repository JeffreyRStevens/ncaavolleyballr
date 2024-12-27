

#' Find team ID for year
#'
#' @param name Name of school. Must match name used by NCAA.
#' @param year Year for fall volleyball season
#'
#' @returns
#' Character string of team ID
#' @export
#'
#' @examples
#' find_team_id("Nebraska", 2024)
find_team_id <- function (name, year) {
  if (!name %in% wvb_teams$team_name) cli::cli_abort("Team name was not found.")
  if (!is.numeric(year)) cli::cli_abort("`year` must be a numeric.")
  if (!year %in% 2020:2024) cli::cli_abort("`year` must be between 2020-2024.")
  wvb_teams[wvb_teams$team_name == name & wvb_teams$year == year, ]$team_id
}
