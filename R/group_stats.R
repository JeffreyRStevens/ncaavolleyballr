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
#' @param unique Logical indicating whether to only process unique contests
#' (TRUE) or whether to process duplicated contests (FALSE). Default is TRUE.
#' @inheritParams find_team_id
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
#' \donttest{
#' group_stats(teams = c("Louisville", "Nebraska", "Penn St.", "Pittsburgh"),
#' year = 2024, level = "season")
#' }
group_stats <- function(teams = NULL,
                        year = NULL,
                        level = "season",
                        unique = TRUE,
                        sport = "WVB") {
  # check inputs
  team_df <- check_sport(sport, vb_only = TRUE)
  check_team_name(team = teams, teams = team_df)
  check_year(year)
  check_match("level", level, c("season", "match", "pbp"))
  check_logical("unique", unique)

  # group season-level stats
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
    # group match level stats
    contest_vec <- find_team_id(teams, year, sport)
    contests <- purrr::map(contest_vec, find_team_contests) |>
      purrr::list_rbind() |>
      dplyr::filter(!is.na(.data$contest))
    if (unique) contests <- dplyr::slice_head(contests, by = "contest", n = 1)
    purrr::map2(contests$contest, contests$team,
                ~ player_match_stats(.x, .y, team_stats = FALSE, sport = sport)) |>
      purrr::set_names(contests$team) |>
      purrr::list_rbind(names_to = "team")
  } else if (level == "pbp") {
    # group php stats
    contest_vec <- find_team_id(teams, year, sport)
    contests <- purrr::map(contest_vec, find_team_contests) |>
      purrr::list_rbind() |>
      dplyr::filter(!is.na(.data$contest))
    if (unique) contests <- dplyr::slice_head(contests, by = "contest", n = 1)
    purrr::map(contests$contest, match_pbp) |>
      purrr::set_names(contests$date) |>
      purrr::list_rbind(names_to = "date")
    }
}
