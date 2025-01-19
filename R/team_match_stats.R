
#' Extract team summary statistics for all matches in a particular season
#'
#' The NCAA's main page for a team includes a tab called "Game By Game"
#' and a section called "Game by Game Stats".
#' This function extracts the team's summary statistics for each match of the
#' season.
#'
#' @inheritParams player_season_stats
#' @inheritParams team_season_stats
#'
#' @returns
#' Returns a data frame of summary team statistics for each match of the season.
#'
#' @export
#'
#' @family functions that extract team statistics
#'
#' @examples
#' \donttest{
#' team_match_stats(team_id = "585290")
#' }
team_match_stats <- function(team_id = NULL,
                             opponent = FALSE,
                             sport = "WVB") {
  # check input
  check_team_id(team_id)
  check_logical("opponent", opponent)
  check_sport(sport, vb_only = TRUE)

  # get team info and request URL
  team_info <- get_team_info(team_id) #|>
  team_url <- paste0("https://stats.ncaa.org/teams/", team_id)
  resp <- tryCatch(
    error = function(cnd) {
      cli::cli_warn("No website available for team ID {team_id}.")
    },
    request_url(team_url)
  )
  if (length(resp) == 1) {
    if (grepl(pattern = "No website available for team ID", resp)) return(invisible())
  }

  # extract arena info
  gbg_page <- resp |>
    httr2::resp_body_html() |>
    rvest::html_elements(".nav-link") |>
    rvest::html_attr("href") |>
    stringr::str_subset("/players/\\d+")
  gbg_url <- paste0("https://stats.ncaa.org/", gbg_page)

  table <- tryCatch(
    error = function(cnd) {
      cli::cli_warn("No website available for team ID {team_id}.")
    },
    request_url(gbg_url) |>
      httr2::resp_body_html() |>
      rvest::html_elements("table") |>
      rvest::html_table()
  )
  if (length(table) == 1) {
    if (grepl(pattern = "No website available for team ID", table)) return(invisible())
  }

  matches <- table[[2]] |>
    dplyr::mutate(Date = dplyr::na_if(.data$Date, ""),
                  team_opp = ifelse(.data$Opponent == "Defensive Totals", "Opponent", "Team"),
                  Opponent = dplyr::na_if(.data$Opponent, "Defensive Totals"),
                  Result = dplyr::na_if(.data$Result, ""),
                  .after = "Opponent") |>
    dplyr::mutate(Team = team_info$team_name[1],
                  Conference = team_info$conference[1],
                  .after = "Date") |>
    tidyr::fill("Date", "Opponent", "Result") |>
    dplyr::mutate(dplyr::across("S":dplyr::last_col(), ~ suppressWarnings(as.numeric(gsub(",", "", .x)))))

  if (!opponent) {
    matches |>
      dplyr::filter(.data$team_opp == "Team") |>
      dplyr::select(!"team_opp")
  } else {
    matches |>
      dplyr::filter(.data$team_opp == "Opponent") |>
      dplyr::select(!"team_opp")
  }
}
