
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
  # check inputs
  check_team_id(team_id)
  check_logical("team_stats", team_stats)

  # get team info and request URL
  teams <- dplyr::bind_rows(ncaavolleyballr::wvb_teams, ncaavolleyballr::mvb_teams)
  team_info <- get_team_info(team_id)
  url <- paste0("https://stats.ncaa.org/teams/", team_id, "/season_to_date_stats")

  table <- request_url(url) |>
    httr2::resp_body_html() |>
    rvest::html_element("table") |>
    rvest::html_table()
  if (nrow(table) == 0 | !"Player" %in% colnames(table)) {
    cli::cli_warn("No {team_info['Year']} season stats available for {team_info['Team']}.")
    return(invisible())
  } else {#if ("Player" %in% colnames(table)) {
    player_stats <- table |>
      dplyr::rename("Number" = "#") |>
      dplyr::mutate(Number = suppressWarnings(as.numeric(.data$Number)))
  } #else {
  #   cli::cli_warn("No {team_info['Year']} season stats available for {team_info['Team']}.")
  #   return(invisible())
  # }

  # remove team stats if requested
  if (!team_stats) {
    player_stats <- player_stats |>
      dplyr::filter(!.data$Player %in% c("TEAM", "Totals", "Opponent Totals"))
  }

  # combine player stats and roster data
  if (team_info["Year"] == "2024") {
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
      dplyr::mutate(Season = team_info["Season"], Team = team_info["Team"],
                    Conference = team_info["Conference"], .before = 1) |>
      dplyr::arrange(.data$Number)
  } else {
    player_stats |>
      dplyr::mutate(dplyr::across("Player":"Ht", as.character),
                    dplyr::across("GP":dplyr::last_col(), ~ suppressWarnings(as.numeric(gsub(",", "", .x))))) |>
      dplyr::mutate(Season = team_info["Season"], Team = team_info["Team"],
                    Conference = team_info["Conference"], .before = 1) |>
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
