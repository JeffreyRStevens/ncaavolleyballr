

#' Extract player season statistics
#'
#' @param team_id Team ID determined by NCAA for season. To find ID, use
#' `find_team_id()`.
#'
#' @returns
#' Tibble of player statistics. Note that hometown and high school were added
#' in 2024.
#' @export
#'
#' @examples
#' \dontrun{
#' team_player_stats("585290")
#' team_player_stats(find_team_id("Nebraska", 2023))
#' team_player_stats(find_team_id("UCLA", 2023, sport = "MVB"))
#' }
team_player_stats <- function(team_id) {
  check_team_id(team_id)
  teams <- dplyr::bind_rows(volleyballr::wvb_teams, volleyballr::mvb_teams)
  team <- teams[which(teams == team_id), ]$team_name
  conference <- teams[which(teams == team_id), ]$conference
  yr <- teams[which(teams == team_id), ]$yr

  url <- paste0("https://stats.ncaa.org/teams/", team_id, "/season_to_date_stats")

  player_stats <- request_url(url) |>
    httr2::resp_body_html() |>
    rvest::html_element("table") |>
    rvest::html_table() |>
    dplyr::rename("Number" = "#") |>
    dplyr::mutate(Number = suppressWarnings(as.numeric(.data$Number)))

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
                    dplyr::across("GP":"PTS", ~ suppressWarnings(as.numeric(gsub(",", "", .x))))) |>
      dplyr::mutate(Year = yr, Team = team, Conference = conference, .before = 1) |>
      dplyr::arrange(.data$Number)
  } else {
    player_stats |>
      dplyr::mutate(dplyr::across("Player":"Ht", as.character),
                    dplyr::across("GP":"PTS", ~ suppressWarnings(as.numeric(gsub(",", "", .x))))) |>
      dplyr::mutate(Year = yr, Team = team, Conference = conference, .before = 1) |>
      dplyr::arrange(.data$Number)
  }
}
