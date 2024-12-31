#' Aggregate player statistics from a particular division and season
#'
#' This is a wrapper around [group_player_stats()] that extracts
#' all season data from players in all teams from the chosen division.
#' It aggregates all player data and team data into separate data frames and
#' combines them into a list.
#'
#' @inheritParams get_teams
#' @param save Logical for whether to save the statistics locally as CSVs
#' (default FALSE).
#' @param path Character string of path to save statistics files.
#'
#' @inherit group_player_stats return
#'
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
division_player_stats <- function(year = NULL,
                                  division = 1,
                                  sport = "WVB",
                                  save = FALSE,
                                  path = "") {
  max_year <- most_recent_season()
  if (sport == "WVB") team_df <- ncaavolleyballr::wvb_teams
  else if (sport == "MVB") team_df <- ncaavolleyballr::mvb_teams
  else cli::cli_abort("Enter valid sport (\"WVB\" or \"MVB\").")
  if (!division %in% 1:3) cli::cli_abort("Enter valid division as a number: 1, 2, 3.")
  if (is.null(year)) cli::cli_abort(paste0("Enter valid year between 2020-", max_year, "."))
  if (!is.numeric(year)) cli::cli_abort(paste0("Enter valid year between 2020-", max_year, "."))
  if (!year %in% 2020:max_year) cli::cli_abort(paste0("Enter valid year between 2020-", max_year, "."))
  if(!is.logical(save)) cli::cli_abort("`save` must be a logical (TRUE or FALSE).")
  if(!is.character(path)) cli::cli_abort("Enter valid path as a character string.")

  div_teams <- team_df |>
    dplyr::filter(.data$div == division & .data$yr == year)
  teams <- div_teams$team_name

  output <- group_player_stats(teams = teams, year = year, sport = sport)

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
