#' Aggregate player statistics for a NCAA conference and seasons
#'
#' This is a wrapper around [group_stats()] that extracts season, match, or pbp
#' data from players in all teams in the chosen conference. For season stats,
#' it aggregates all player data and team data into separate data frames and
#' combines them into a list. For match and pbp stats, it aggregates into a
#' data frame.
#' Conferences names can be found in
#' [ncaa_conferences].
#'
#' @inheritParams division_stats
#' @param conf NCAA conference name.
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
#' @examplesIf interactive()
#' conference_stats(year = 2024, conf = "Peach Belt", level = "season")
conference_stats <- function(year = NULL,
                             conf = NULL,
                             level = NULL,
                             sport = "WVB",
                             save = FALSE,
                             path = ".") {
  # check inputs
  check_year(year)
  check_match("level", level, c("season", "match", "pbp"))
  team_df <- check_sport(sport, vb_only = TRUE)
  check_confdiv(group = "conf", value = conf, teams = team_df)
  check_logical("save", save)
  if(!is.character(path)) cli::cli_abort("Enter valid path as a character string.")

  # get vector of conference teams
  conf_teams <- team_df |>
    dplyr::filter(.data$conference == conf & .data$yr %in% year)
  teams <- conf_teams$team_name

  # get data on conference teams
  output <- group_stats(teams = teams, year = year,
                        level = level, sport = sport)

  # remove / at end of path
  if (!grepl("/$", path)) path <- paste0(path, "/")

  # save data to files if requested
  if (save) {
    if (level == "season") {
      save_df(x = output$playerdata, label = "playerseason", group = "conf",
              year = year, conf = conf, sport = sport, path = path)
      save_df(x = output$teamdata, label = "teamseason", group = "conf",
              year = year, conf = conf, sport = sport, path = path)
    } else if (level == "match") {
      save_df(x = output, label = "playermatch", group = "conf",
              year = year, conf = conf, sport = sport, path = path)
    } else {
      save_df(x = output, label = "pbp", group = "conf",
              year = year, conf = conf, sport = sport, path = path)
    }
  }
  return(output)
}
