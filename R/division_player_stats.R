#' Aggregate all player statistics from a particular division and year
#'
#' @param year Year for fall volleyball season.
#' @param division NCAA division (must be 1, 2, or 3 for women's and 1 or 3
#' for men's).
#' @param sport Three letter abbreviation for NCAA sport (must be upper case;
#' for example "WVB" for women's volleyball and "MVB" for men's volleyball).
#' @param save Logical for whether to save the statistics locally as CSVs
#' (default FALSE).
#' @param path Character string of path to save statistics files.
#'
#' @returns
#' Returns list with player statistics and team statistics data frames.
#' @export
#'
#' @family functions that aggregate statistics
#'
#' @examples
#' \dontrun{
#' division_player_stats(2024)
#' division_player_stats(2023, division = 3, sport = "MVB")
#' division_player_stats(2024, save = TRUE, path = "data/")
#' }
division_player_stats <- function(year, division = 1, sport = "WVB", save = FALSE, path = "") {
  if (!is.numeric(year)) cli::cli_abort("`year` must be a numeric.")
  if (!year %in% 2020:2024) cli::cli_abort("`year` must be between 2020-2024.")
  if (!division %in% 1:3) cli::cli_abort("Enter valid division as a number: 1, 2, 3")
  if (sport == "WVB") team_df <- ncaavolleyballr::wvb_teams
  else if (sport == "MVB") team_df <- ncaavolleyballr::mvb_teams
  else cli::cli_abort("Invalid sport entered. Must be 'WVB' or 'MVB'.")
  if(!is.logical(save)) cli::cli_abort("`save` must be a logical (TRUE or FALSE).")
  if(!is.character(path)) cli::cli_abort("`path` must be a character string.")

  div_teams <- team_df |>
    dplyr::filter(.data$div == division & .data$yr == year)
  teams <- div_teams$team_name

  output <- group_player_stats(teams, year, sport)

  if (!grepl("/$", path)) path <- paste0(path, "/")

  if (save) {
    utils::write.csv(output$playerdata,
                     paste0(path, tolower(sport), "_playerdata_div", division, "_", year, ".csv"),
                     row.names = FALSE)
    utils::write.csv(output$teamdata,
                     paste0(path, tolower(sport), "_teamdata_div", division, "_", year, ".csv"),
                     row.names = FALSE)
  }

  return(output)
}
