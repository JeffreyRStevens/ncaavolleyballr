
#' Extract player statistics from a particular team and season
#'
#' The NCAA's main page for a team includes a tab called "Team Statistics".
#' This function extracts the table of player statistics for the season, as
#' well as team and opponent statistics (though these can be omitted).
#'
#' @param team_id Team ID determined by NCAA for season. To find ID, use
#' [find_team_id()].
#' @param team_stats Logical indicating whether to include (TRUE) or exclude
#' (FALSE) team statistics. Default includes team statistics with player
#' statistics.
#'
#' @returns
#' Returns a data frame of player statistics. Note that hometown and high school
#' were added in 2024.
#'
#' @export
#'
#' @family functions that extract team statistics
#'
#' @examples
#' \dontrun{
#' player_season_stats(team_id = "585290")
#' player_season_stats(team_id = find_team_id("Nebraska", 2024), team_stats = FALSE)
#' player_season_stats(team_id = find_team_id("UCLA", 2023, sport = "MVB"))
#' }
player_season_stats <- function(team_id,
                              team_stats = TRUE) {
  check_team_id(team_id)
  if(!is.logical(team_stats)) cli::cli_abort("`team_stats` must be a logical (TRUE or FALSE).")

  teams <- dplyr::bind_rows(ncaavolleyballr::wvb_teams, ncaavolleyballr::mvb_teams)
  team <- teams[which(teams == team_id), ]$team_name
  conference <- teams[which(teams == team_id), ]$conference
  yr <- teams[which(teams == team_id), ]$yr
  season <- paste0(yr, "-", yr + 1)

  url <- paste0("https://stats.ncaa.org/teams/", team_id, "/season_to_date_stats")

  player_stats <- request_url(url) |>
    httr2::resp_body_html() |>
    rvest::html_element("table") |>
    rvest::html_table() |>
    dplyr::rename("Number" = "#") |>
    dplyr::mutate(Number = suppressWarnings(as.numeric(.data$Number)))

  if (!team_stats) {
    player_stats <- player_stats |>
      dplyr::filter(!.data$Player %in% c("TEAM", "Totals", "Opponent Totals"))
  }

  if (yr == 2024) {
    url2 <- paste0("https://stats.ncaa.org/teams/", team_id, "/roster")
    roster <- request_url(url2) |>
      httr2::resp_body_html() |>
      rvest::html_element("table") |>
      rvest::html_table() |>
      dplyr::select("Number" = "#", "Name", "Hometown", "High School") |>
      dplyr::mutate(Number = suppressWarnings(as.numeric(.data$Number)))

    dplyr::left_join(player_stats, roster,
                     by = dplyr::join_by("Number", "Player" == "Name")) |>
      dplyr::relocate("Hometown":"High School", .after = "Ht") |>
      dplyr::mutate(dplyr::across("Player":"Ht", as.character),
                    dplyr::across("GP":dplyr::last_col(), ~ suppressWarnings(as.numeric(gsub(",", "", .x))))) |>
      dplyr::mutate(Season = season, Team = team, Conference = conference, .before = 1) |>
      dplyr::arrange(.data$Number)
  } else {
    player_stats |>
      dplyr::mutate(dplyr::across("Player":"Ht", as.character),
                    dplyr::across("GP":dplyr::last_col(), ~ suppressWarnings(as.numeric(gsub(",", "", .x))))) |>
      dplyr::mutate(Season = season, Team = team, Conference = conference, .before = 1) |>
      dplyr::arrange(.data$Number)
  }
}

#' Extract player statistics from a particular team and season
#'
#' @description
#' `r lifecycle::badge("deprecated")`
#'
#' `team_player_stats()` was renamed to `player_season_stats()` to create a more
#' consistent API.
#' @keywords internal
#' @export
team_player_stats <- function(...) {
  lifecycle::deprecate_warn("0.2.0", "team_player_stats()", "player_season_stats()")
  player_season_stats(...)
}
