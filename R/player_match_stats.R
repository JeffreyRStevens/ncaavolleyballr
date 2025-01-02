#' Extract player statistics for a particular match
#'
#' The NCAA's page for a match/contest includes a tab called
#' "Individual Statistics". This function extracts the tables of player
#' match statistics for both visitor and home teams, as well as team statistics
#' (though these can be omitted). If a particular team is specified, only that
#' team's statistics will be returned.
#'
#' @param contest Contest ID determined by NCAA for match. To find ID, use
#' [find_team_contests()] for a team and season.
#' @inheritParams find_team_id
#' @inheritParams player_season_stats
#'
#' @returns
#' By default, returns list with two data frames: visitor and home team match
#' statistics. If team is specified, only single data frame is returned.
#'
#' @export
#'
#' @examples
#' \dontrun{
#' player_match_stats(contest = "6080706")
#' player_match_stats(contest = "6080706", team = "Louisville)
#' player_match_stats(contest = "4475421"", team_stats = FALSE, sport = "MVB")
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

  match_date <- match_info[5, 1] |>
    dplyr::pull() |>
    as.Date(format = "%m/%d/%Y %H:%M %p")
  yr <- match_date |>
    format("%Y") |>
    as.numeric()
  season <- paste0(yr, "-", yr + 1)

  visitor_team <- match_info[3, 1] |>
    dplyr::pull()
  visitor_conf <- team_df[team_df$team_name == visitor_team & team_df$yr == yr, ]$conference

  home_team <- match_info[4, 1] |>
    dplyr::pull()
  home_conf <- team_df[team_df$team_name == home_team & team_df$yr == yr, ]$conference


  visitor_stats <- match_all[[4]] |>
    dplyr::mutate(Season = season, Team = visitor_team, Conference = visitor_conf,
                  `Opponent Team` = home_team, `Opponent Conference` = home_conf,
                  Location = "Visitor", .before = 1) |>
    dplyr::rename("Number" = "#", "Player" = "Name") |>
    dplyr::mutate(Number = suppressWarnings(as.numeric(.data$Number)))
  home_stats <- match_all[[5]] |>
    dplyr::mutate(Season = season, Team = home_team, Conference = home_conf,
                  `Opponent Team` = visitor_team, `Opponent Conference` = visitor_conf,
                  Location = "Home", .before = 1) |>
    dplyr::rename("Number" = "#", "Player" = "Name") |>
    dplyr::mutate(Number = suppressWarnings(as.numeric(.data$Number)))

  if (!team_stats) {
    visitor_stats <- visitor_stats |>
      dplyr::filter(.data$Number != "")
    home_stats <- home_stats |>
      dplyr::filter(.data$Number != "")
  }

  stats_list <- list(visitor_team = visitor_stats, home_stats = home_stats) |>
    purrr::set_names(visitor_team, home_team)

  if (is.null(team)) {
    return(stats_list)
  } else {
    if (!team %in% c(visitor_team, home_team)) cli::cli_abort("Enter valid team: \"{visitor_team}\" or \"{home_team}\"")
    return(stats_list[[team]])
  }
}
