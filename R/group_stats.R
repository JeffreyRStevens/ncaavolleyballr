#' Aggregate player statistics and play-by-play information
#'
#' This function aggregates player statistics and play-by-play information
#' within a season by applying [player_season_stats()], [player_match_stats()],
#' or [match_pbp()] across groups of teams (for [player_season_stats()]) or
#' across contests within a season (for [player_match_stats()] and
#' [match_pbp()]). For season stats, it aggregates all player data and team
#' data into separate data frames and combines them into a list.
#' For instance, if you want to extract the data from the teams in the women's
#' 2024 Final Four, pass a vector of
#' \code{c("Louisville", "Nebraska", "Penn State", "Pittsburgh")}
#' to the function. For match or play-by-play data for a team, pass a single
#' team name and year. Team names can be found in [ncaa_teams] or by
#' using [find_team_name()].
#'
#' @param teams Character vector of team names to aggregate.
#' @param level Character string defining whether to aggregate "season",
#' "match", or play-by-play ("pbp") data.
#' @inheritParams get_teams
#'
#' @returns
#' For season level, returns list with data frames of player statistics and
#' team statistics. For match and pbp levels, returns data frame of player
#' statistics and play-by-play information respectively.
#'
#' @export
#'
#' @family functions that aggregate statistics
#'
#' @examples
#' \dontrun{
#' group_stats(teams = c("Louisville", "Nebraska", "Penn St.", "Pittsburgh"),
#' year = 2024, level = "season")
#' group_stats(teams = c("UCLA", "Long Beach St."), year = 2023,
#' level = "season", sport = "MVB")
#' group_stats(teams = "Nebraska", year = 2024, level = "match")
#' group_stats(teams = "Nebraska", year = 2024, level = "pbp")
#' }
group_stats <- function(teams = NULL,
                        year = NULL,
                        level = "season",
                        sport = "WVB") {
  max_year <- most_recent_season()
  if (sport == "WVB") team_df <- ncaavolleyballr::wvb_teams
  else if (sport == "MVB") team_df <- ncaavolleyballr::mvb_teams
  else cli::cli_abort("Enter valid sport (\"WVB\" or \"MVB\").")
  if (is.null(teams)) cli::cli_abort("Enter valid vector of teams.")
  if (length(teams) == 1) {
    if (!teams %in% team_df$team_name) cli::cli_abort("Enter valid team name.")
  } else {
    if (!all(teams %in% team_df$team_name)) cli::cli_abort("Team name was not found.")
  }
  if (is.null(year)) cli::cli_abort(paste0("Enter valid year between 2020-", max_year, "."))
  if (!is.numeric(year)) cli::cli_abort(paste0("Enter valid year between 2020-", max_year, "."))
  if (!all(year %in% 2020:max_year)) cli::cli_abort(paste0("Enter valid year between 2020-", max_year, "."))
  if (!level %in% c("season", "match", "pbp")) cli::cli_abort("Enter valid level: \"season\", \"match\" or \"pbp\"")

  if (level == "season") {
    data <- purrr::map2(rep(teams, each = length(year)), rep(year, times = length(teams)),
                       ~ player_season_stats(find_team_id(.x, .y, sport))) |>
      purrr::set_names(rep(teams, each = length(year))) |>
      purrr::list_rbind(names_to = "Team")
    playerdata <- data |>
      dplyr::filter(!is.na(.data$Number))

    teamdata <- data |>
      dplyr::filter(.data$Player == "Totals") |>
      dplyr::select(!c("Number":"GS"))

    output <- list(playerdata = playerdata, teamdata = teamdata)
    return(output)
  } else if (level == "match") {
    if (length(teams) > 1) cli::cli_abort("Enter single team for match-level data.")
    contest_vec <- find_team_id(teams, year, sport)
    contests <- purrr::map(contest_vec, find_team_contests) |>
      purrr::list_rbind() |>
      dplyr::filter(!is.na(.data$contests))
    purrr::map2(contests$contests, contests$team,
                       ~ player_match_stats(.x, .y, team_stats = FALSE, sport)) |>
      purrr::set_names(contests$team) |>
      purrr::list_rbind(names_to = "team")
  } else if (level == "pbp") {
    if (length(teams) > 1) cli::cli_abort("Enter single team for match-level data.")
    contest_vec <- find_team_id(teams, year, sport)
    contests <- purrr::map(contest_vec, find_team_contests) |>
      purrr::list_rbind() |>
      dplyr::filter(!is.na(.data$contests))
    purrr::map(contests$contests, match_pbp) |>
      purrr::set_names(contests$date) |>
      purrr::list_rbind(names_to = "date")
  }
}

#' Aggregate player statistics
#'
#' @description
#' `r lifecycle::badge("deprecated")`
#'
#' `group_player_stats()` was renamed to `group_stats()` to allow an expanded
#' functionality.
#' @keywords internal
#' @export
group_player_stats <- function(...) {
  lifecycle::deprecate_warn("0.3.0", "group_player_stats()", "group_stats()")
  group_stats(...)
}
