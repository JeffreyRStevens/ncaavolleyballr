#' Aggregate player match statistics for a NCAA division and seasons
#'
#' This is a wrapper around [group_stats()] that extracts
#' all match data from players in all teams in the chosen division.
#'
#' @inheritParams division_season_stats
#'
#' @return
#' Returns data frame of player match statistics.
#'
#' @export
#'
#' @family functions that aggregate statistics
#'
#' @examples
#' \dontrun{
#' division_match_stats(year = 2024)
#' division_match_stats(year = 2023, division = 3, sport = "MVB")
#' division_match_stats(year = 2024, save = TRUE, path = "data/")
#' }
division_match_stats <- function(year = NULL,
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

  # get season-level data on division teams
  output <- group_stats(teams = teams, year = year, level = "match", sport = sport)

  if (!grepl("/$", path)) path <- paste0(path, "/")

  if (save) {
    save_df(x = output, label = "playermatch", group = "div", year = year, division = division, sport = sport, path = path)
  }
  return(output)
}
