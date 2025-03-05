#' Aggregate player statistics for a NCAA division and seasons
#'
#' This is a wrapper around [group_stats()] that extracts season, match, or pbp
#' data from players in all teams in the chosen division. For season stats,
#' it aggregates all player data and team data into separate data frames and
#' combines them into a list. For match and pbp stats, it aggregates into a
#' data frame.
#'
#' @inheritParams group_stats
#' @inheritParams get_teams
#' @param save Logical for whether to save the statistics locally as CSVs
#' (default FALSE).
#' @param path Character string of path to save statistics files.
#'
#' @inherit group_stats return
#'
#' @export
#'
#' @note
#' This function **requires internet connectivity** as it checks the
#' [NCAA website](https://stats.ncaa.org) for information.
#'
#' @family functions that aggregate statistics
#'
division_stats <- function(year = NULL,
                           division = 1,
                           level = NULL,
                           sport = "WVB",
                           save = FALSE,
                           path = ".") {
  # check inputs
  team_df <- check_sport(sport, vb_only = TRUE)
  check_confdiv(group = "div", value = division, teams = team_df)
  check_year(year)
  check_match("level", level, c("season", "match", "pbp"))
  check_logical("save", save)
  if (!is.character(path)) cli::cli_abort("Enter valid path as a character string.")

  # get vector of division teams
  div_teams <- team_df |>
    dplyr::filter(.data$div == division & .data$yr %in% year)
  teams <- div_teams$team_name

  # get pbp data on division teams
  output <- group_stats(teams = teams, year = year,
                        level = level, sport = sport)

  # remove / at end of path
  if (!grepl("/$", path)) path <- paste0(path, "/")

  # save data to files if requested
  if (save) {
    if (level == "season") {
      save_df(x = output$playerdata, label = "playerseason", group = "div",
              year = year, division = division, sport = sport, path = path)
      save_df(x = output$teamdata, label = "teamseason", group = "div",
              year = year, division = division, sport = sport, path = path)
    } else if (level == "match") {
      save_df(x = output, label = "playermatch", group = "div",
              year = year, division = division, sport = sport, path = path)
    } else {
      save_df(x = output, label = "pbp", group = "div",
              year = year, division = division, sport = sport, path = path)
    }
  }
  return(output)
}
