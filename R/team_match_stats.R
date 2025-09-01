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
#' @inherit request_live_url note
#'
#' @family functions that extract team statistics
#'
#' @examplesIf interactive()
#' team_match_stats(team_id = "585290")
team_match_stats <- function(team_id = NULL, sport = "WVB") {
  # check input
  check_team_id(team_id)
  check_sport(sport, vb_only = TRUE)

  # get team info and request URL
  team_info <- get_team_info(team_id)
  team_url <- paste0("https://stats.ncaa.org/teams/", team_id)
  live_url <- tryCatch(
    request_live_url(team_url),
    error = function(cnd) {
      cli::cli_warn("No website available for team ID {team_id}.")
      return(invisible())
    }
  )
  gbg_page <- tryCatch(
    live_url |>
      rvest::html_elements(".nav-link") |>
      rvest::html_attr("href") |>
      stringr::str_subset("/players/\\d+"),
    error = function(cnd) {
      cli::cli_warn("No match info available for team ID {team_id}.")
      return(invisible())
    }
  )
  if (inherits(live_url, "LiveHTML")) {
    live_url$session$close()
  } else {
    cli::cli_warn("No match info available for team ID {team_id}.")
    return(invisible())
  }
  rm(live_url)

  gbg_url <- paste0("https://stats.ncaa.org", gbg_page)
  gbg_num <- sub("/players/", "", gbg_page)
  gbg_id <- paste0("#game_log_", gbg_num, "_player")

  live_url <- tryCatch(
    request_live_url(gbg_url),
    error = function(cnd) {
      cli::cli_warn("No website available for team ID {team_id}.")
      return(invisible())
    }
  )
  table <- tryCatch(
    live_url |>
      rvest::html_elements(gbg_id) |>
      rvest::html_table(),
    error = function(cnd) {
      cli::cli_warn("No match info available for team ID {team_id}.")
      return(invisible())
    }
  )
  if (inherits(live_url, "LiveHTML")) {
    live_url$session$close()
  } else {
    cli::cli_warn("No match info available for team ID {team_id}.")
    return(invisible())
  }
  rm(live_url)

  if (length(table) == 0) {
    cli::cli_warn("No match info available for team ID {team_id}.")
    return(invisible())
  }

  table[[1]] |>
    dplyr::select("Date":"BHE") |>
    dplyr::filter(.data$Date != "Totals" & .data$Date != "Defensive Totals") |>
    dplyr::mutate(Season = team_info$season[1], .before = 1) |>
    dplyr::mutate(
      Team = team_info$team_name[1],
      Conference = team_info$conference[1],
      .after = "Date"
    ) |>
    tidyr::fill("Date", "Opponent", "Result") |>
    dplyr::mutate(dplyr::across(
      "S":dplyr::last_col(),
      ~ suppressWarnings(as.numeric(gsub(",", "", .x)))
    )) |>
    dplyr::arrange("Date")
}
