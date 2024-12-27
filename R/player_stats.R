

#' Extract player season statistics
#'
#' @param team_id Team ID determined by NCAA for season. To find ID, use
#' [`find_team_id()`].
#'
#' @returns
#' Tibble of player statistics.
#' @export
#'
#' @examples
#' \dontrun{
#' player_stats("585290")
#' }
player_stats <- function(team_id) {
  check_team_id(team_id)
  url <- paste0("https://stats.ncaa.org/teams/", team_id, "/season_to_date_stats")

  player_stats <- request_url(url) |>
    httr2::resp_body_html() |>
    rvest::html_element("table") |>
    rvest::html_table() |>
    dplyr::rename(Number = .data$`#`) |>
    dplyr::mutate(Number = as.numeric(.data$Number))

  url2 <- paste0("https://stats.ncaa.org/teams/", team_id, "/roster")
  roster <- request_url(url2) |>
    httr2::resp_body_html() |>
    rvest::html_element("table") |>
    rvest::html_table() |>
    dplyr::select(Number = .data$`#`, .data$Name, .data$Hometown, .data$`High School`) |>
    dplyr::mutate(Number = as.numeric(.data$Number))

  dplyr::left_join(player_stats, roster,
                   by = dplyr::join_by("Number", "Player" == "Name")) |>
    dplyr::relocate(.data$Hometown:.data$`High School`, .after = .data$Ht) |>
    dplyr::mutate(dplyr::across(.data$Kills:.data$PTS, ~ as.numeric(gsub(",", "", .x)))) |>

    dplyr::arrange(.data$Number)
}
