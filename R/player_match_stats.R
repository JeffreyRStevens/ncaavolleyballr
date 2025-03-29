#' Extract player statistics for a particular match
#'
#' The NCAA's page for a match/contest includes a tab called
#' "Individual Statistics". This function extracts the tables of player
#' match statistics for both home and away teams, as well as team statistics
#' (though these can be omitted). If a particular team is specified, only that
#' team's statistics will be returned.
#'
#' @param contest Contest ID determined by NCAA for match. To find ID, use
#' [find_team_contests()] for a team and season.
#' @inheritParams find_team_id
#' @inheritParams player_season_stats
#'
#' @returns
#' By default, returns data frame that includes both home and away team match
#' statistics. If team is specified, only that team's data are returned.
#'
#' @export
#'
#' @note
#' This function **requires internet connectivity** as it checks the
#' [NCAA website](https://stats.ncaa.org) for information.
#'
#' @family functions that extract player statistics
#'
#' @examplesIf interactive()
#' player_match_stats(contest = "6080706")
player_match_stats <- function(contest = NULL,
                               team = NULL,
                               team_stats = TRUE,
                               sport = "WVB") {
  # check inputs
  check_contest(contest)
  team_df <- check_sport(sport = sport, vb_only = TRUE)
  if (!is.null(team)) check_team_name(team = team, teams = team_df)
  check_logical("team_stats", team_stats)

  # get and request URL
  url <- paste0("https://stats.ncaa.org/contests/", contest,
                "/individual_stats")

  match_all <- tryCatch(
    error = function(cnd) {
      cli::cli_warn("No website available for contest {contest}.")
    },
    request_url(url = url) |>
      httr2::resp_body_html() |>
      rvest::html_elements("table") |>
      rvest::html_table()
  )
  if (length(match_all) == 1) {
    if (grepl(pattern = "No website available for contest", match_all)) return(invisible())
  }
  match_info <- match_all[[1]]

  # extract date
  match_date_time <- match_info[5, 1] |>
    dplyr::pull()
  if (grepl("TBA", match_date_time)) {
    match_date <- sub("TBA", "", match_date_time) |>
      stringr::str_trim() |>
      as.Date(format = "%m/%d/%Y")
  } else {
    match_date <- match_date_time |>
      as.Date(format = "%m/%d/%Y %H:%M %p")
  }
  yr <- match_date |>
    format("%Y") |>
    as.numeric()
  season <- paste0(yr, "-", yr + 1)

  # extract home and away teams and conferences
  away_team <- match_info[3, 1] |>
    dplyr::pull() |>
    fix_teams()
  away_conf <- team_df[team_df$team_name == away_team & team_df$yr == yr, ]$conference
  if (length(away_conf) == 0) {
    away_conf <- team_df[team_df$team_name == away_team & team_df$yr == (yr - 1), ]$conference
  }
  if (length(away_conf) == 0) {
    away_conf <- NA
  }

  home_team <- match_info[4, 1] |>
    dplyr::pull() |>
    fix_teams()

  home_conf <- team_df[team_df$team_name == home_team & team_df$yr == yr, ]$conference
  if (length(home_conf) == 0) {
    home_conf <- team_df[team_df$team_name == home_team & team_df$yr == (yr - 1), ]$conference
  }
  if (length(home_conf) == 0) {
    home_conf <- NA
  }

  # extract stats for home and away teams
  away_stats <- match_all[[4]] |>
    dplyr::mutate(Season = season, Date = match_date, Team = away_team,
                  Conference = away_conf, `Opponent Team` = home_team,
                  `Opponent Conference` = home_conf, Location = "Away",
                  .before = 1) |>
    dplyr::rename("Number" = "#", "Player" = "Name") |>
    dplyr::mutate(Number = suppressWarnings(as.numeric(.data$Number)))
  home_stats <- match_all[[5]] |>
    dplyr::mutate(Season = season, Date = match_date, Team = home_team,
                  Conference = home_conf, `Opponent Team` = away_team,
                  `Opponent Conference` = away_conf, Location = "Home",
                  .before = 1) |>
    dplyr::rename("Number" = "#", "Player" = "Name") |>
    dplyr::mutate(Number = suppressWarnings(as.numeric(.data$Number)))

  if (!team_stats) {
    away_stats <- away_stats |>
      dplyr::filter(.data$Number != "")
    home_stats <- home_stats |>
      dplyr::filter(.data$Number != "")
    if (nrow(home_stats) == 0 ||
        nrow(away_stats) == 0 ||
        !"Player" %in% colnames(home_stats) ||
        !"Player" %in% colnames(away_stats)) {
      cli::cli_warn("No player match stats available for {home_team} and {away_team} (contest {contest}).")
      return(invisible())
    }
  }

  stats_list <- list(away_team = away_stats, home_stats = home_stats) |>
    purrr::set_names(away_team, home_team)

  # subset a single team's data when requested
  if (is.null(team)) {
    return(purrr::list_rbind(stats_list))
  } else {
    if (!team %in% c(away_team, home_team)) cli::cli_abort("Enter valid team for contest {contest}: \"{away_team}\" or \"{home_team}\".")
    return(stats_list[[team]])
  }
}
