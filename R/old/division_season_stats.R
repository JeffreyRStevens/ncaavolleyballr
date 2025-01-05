#' Aggregate player season statistics for a NCAA division and seasons
#'
#' This is a wrapper around [group_stats()] that extracts
#' season data from players in all teams in the chosen division.
#' It aggregates all player data and team data into separate data frames and
#' combines them into a list.
#'
#' @inheritParams find_team_id
#' @inheritParams get_teams
#' @param save Logical for whether to save the statistics locally as CSVs
#' (default FALSE).
#' @param path Character string of path to save statistics files.
#'
#' @return
#' Returns data frame of player and team season statistics.
#'
#' @export
#'
#' @family functions that aggregate statistics
#'
#' @examples
#' \dontrun{
#' division_season_stats(year = 2024)
#' division_season_stats(year = 2023, division = 3, sport = "MVB")
#' division_season_stats(year = 2024, save = TRUE, path = "data/")
#' }
division_season_stats <- function(year = NULL,
                                  division = 1,
                                  sport = "WVB",
                                  save = FALSE,
                                  path = ".") {
  # check inputs
  max_year <- most_recent_season()
  if (sport == "WVB") team_df <- ncaavolleyballr::wvb_teams
  else if (sport == "MVB") team_df <- ncaavolleyballr::mvb_teams
  else cli::cli_abort("Enter valid sport (\"WVB\" or \"MVB\").")
  if (!division %in% 1:3) cli::cli_abort("Enter valid division as a number: 1, 2, 3.")
  if (is.null(year)) cli::cli_abort(paste0("Enter valid year between 2020-", max_year, "."))
  if (!is.numeric(year)) cli::cli_abort(paste0("Enter valid year between 2020-", max_year, "."))
  if (!all(year %in% 2020:max_year)) cli::cli_abort(paste0("Enter valid year between 2020-", max_year, "."))
  if(!is.logical(save)) cli::cli_abort("`save` must be a logical (TRUE or FALSE).")
  if(!is.character(path)) cli::cli_abort("Enter valid path as a character string.")

  # get vector of division teams
  div_teams <- team_df |>
    dplyr::filter(.data$div == division & .data$yr %in% year)
  teams <- div_teams$team_name

  # get pbp data on division teams
  output <- group_stats(teams = teams, year = year, sport = sport)

  if (!grepl("/$", path)) path <- paste0(path, "/")

  if (save) {
    save_df(x = output$playerdata, label = "playerseason", group = "div", year = year, division = division, sport = sport, path = path)
    save_df(x = output$teamdata, label = "teamseason", group = "div", year = year, division = division, sport = sport, path = path)
  }
  return(output)
}

#' Aggregate player statistics from a particular division and season
#'
#' @description
#' `r lifecycle::badge("deprecated")`
#'
#' `division_player_stats()` was renamed to `division_season_stats()` to
#' create a more consistent API.
#' @keywords internal
#' @export
division_player_stats <- function(...) {
  lifecycle::deprecate_warn("0.2.0", "division_player_stats()", "division_season_stats()")
  division_season_stats(...)
}
