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
#' By default, returns list with two data frames: home and away team match
#' statistics. If team is specified, only single data frame is returned.
#'
#' @export
#'
#' @examples
#' \dontrun{
#' player_match_stats(contest = "6080706")
#' player_match_stats(contest = "6080706", team = "Louisville")
#' player_match_stats(contest = "4475421", team_stats = FALSE, sport = "MVB")
#' }
player_match_stats <- function(contest = NULL,
                               team = NULL,
                               team_stats = TRUE,
                               sport = "WVB") {
  if (is.null(contest)) cli::cli_abort(paste0("Enter valid contest ID as a character string."))
  if (!is.character(contest)) cli::cli_abort("Enter valid contest ID as a character string.")
  if (sport == "WVB") team_df <- ncaavolleyballr::wvb_teams
  else if (sport == "MVB") team_df <- ncaavolleyballr::mvb_teams
  else cli::cli_abort("Enter valid sport (\"WVB\" or \"MVB\").")
  if (!is.null(team)) {
    if (!team %in% team_df$team_name) cli::cli_abort("Enter valid team name. Check `ncaa_teams` for names or search using `find_team_name()`.")
  }
  if(!is.logical(team_stats)) cli::cli_abort("`team_stats` must be a logical (TRUE or FALSE).")

  url <- paste0("https://stats.ncaa.org/contests/", contest, "/individual_stats")

  match_all <- request_url(url) |>
    httr2::resp_body_html() |>
    rvest::html_elements("table") |>
    rvest::html_table()
  match_info <- match_all[[1]]

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


  away_stats <- match_all[[4]] |>
    dplyr::mutate(Season = season, Date = match_date, Team = away_team, Conference = away_conf,
                  `Opponent Team` = home_team, `Opponent Conference` = home_conf,
                  Location = "Away", .before = 1) |>
    dplyr::rename("Number" = "#", "Player" = "Name") |>
    dplyr::mutate(Number = suppressWarnings(as.numeric(.data$Number)))
  home_stats <- match_all[[5]] |>
    dplyr::mutate(Season = season, Date = match_date, Team = home_team, Conference = home_conf,
                  `Opponent Team` = away_team, `Opponent Conference` = away_conf,
                  Location = "Home", .before = 1) |>
    dplyr::rename("Number" = "#", "Player" = "Name") |>
    dplyr::mutate(Number = suppressWarnings(as.numeric(.data$Number)))

  if (!team_stats) {
    away_stats <- away_stats |>
      dplyr::filter(.data$Number != "")
    home_stats <- home_stats |>
      dplyr::filter(.data$Number != "")
  }

  stats_list <- list(away_team = away_stats, home_stats = home_stats) |>
    purrr::set_names(away_team, home_team)

  if (is.null(team)) {
    return(stats_list)
  } else {
    if (!team %in% c(away_team, home_team)) cli::cli_abort("Enter valid team: \"{away_team}\" or \"{home_team}\"")
    return(stats_list[[team]])
  }
}
