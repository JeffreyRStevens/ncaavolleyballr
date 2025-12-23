#' Aggregate player statistics for a NCAA division and seasons
#'
#' This is a wrapper around [group_stats()] that extracts season, match, or pbp
#' data from players in all teams in the chosen division. For season stats,
#' it aggregates all player data and team data into separate data frames and
#' combines them into a list. For match and pbp stats, it aggregates into a
#' data frame.
#'
#' Note: Changes to the NCAA website have made large-scale scraping unstable, and
#' can trigger IP address blocks when there are lots of requests. This function
#' seems to trigger these blocks frequently now, so use caution when scraping large
#' amounts of data.
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
#' @inherit request_live_url note
#'
#' @family functions that aggregate statistics
#'
#' @examplesIf interactive()
#' division_stats(year = 2024, division = 1, level = "teamseason")
division_stats <- function(
  year = NULL,
  division = 1,
  level = NULL,
  sport = "WVB",
  save = FALSE,
  path = ".",
  delay = 2
) {
  # check inputs
  team_df <- check_sport(sport, vb_only = TRUE)
  check_confdiv(group = "division", value = division, teams = team_df)
  check_year(year)
  check_match(
    "level",
    level,
    c("teamseason", "season", "teammatch", "playermatch", "match", "pbp")
  )
  check_logical("save", save)
  if (!is.character(path) | length(path) > 1) {
    cli::cli_abort("Enter valid path as a character string.")
  }

  # get vector of division teams
  div_teams <- team_df |>
    dplyr::filter(.data$div == division & .data$yr %in% year)
  teams <- div_teams$team_name

  # get pbp data on division teams
  output <- group_stats(
    teams = teams,
    year = year,
    level = level,
    sport = sport,
    delay = delay
  )

  # remove / at end of path
  if (!grepl("/$", path)) {
    path <- paste0(path, "/")
  }

  # save data to files if requested
  if (save) {
    if (level == "teamseason") {
      save_df(
        x = output$playerdata,
        label = "playerseason",
        group = "div",
        year = year,
        division = division,
        sport = sport,
        path = path
      )
      save_df(
        x = output$teamdata,
        label = "teamseason",
        group = "div",
        year = year,
        division = division,
        sport = sport,
        path = path
      )
    } else if (level == "teammatch") {
      save_df(
        x = output,
        label = "teammatch",
        group = "div",
        year = year,
        division = division,
        sport = sport,
        path = path
      )
    } else if (level == "playermatch") {
      save_df(
        x = output,
        label = "playermatch",
        group = "div",
        year = year,
        division = division,
        sport = sport,
        path = path
      )
    } else {
      save_df(
        x = output,
        label = "pbp",
        group = "div",
        year = year,
        division = division,
        sport = sport,
        path = path
      )
    }
  }
  return(output)
}
