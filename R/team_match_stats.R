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
#' @note
#' This function **requires internet connectivity** as it checks the
#' [NCAA website](https://stats.ncaa.org) for information.
#' It also uses the [`{chromote}`](https://rstudio.github.io/chromote/) package
#' and **requires [Google Chrome](https://www.google.com/chrome/)** to be
#' installed.
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
  team_info <- get_team_info(team_id) #|>
  team_url <- paste0("https://stats.ncaa.org/teams/", team_id)
  resp <- tryCatch(
    error = function(cnd) {
      cli::cli_warn("No website available for team ID {team_id}.")
    },
    request_url(url = team_url)
  )
  if (length(resp) == 1) {
    if (grepl(pattern = "No website available for team ID", resp)) {
      return(invisible())
    }
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
    request_live_url(gbg_url) |>
      rvest::html_elements("table") |>
      rvest::html_table()
  )
  if (length(table) <= 1) {
    cli::cli_warn("No match info available for team ID {team_id}.")
    return(invisible())
  }

  if (names(table[[2]][1]) == "Date" & nrow(table[[2]]) > 2) {
    table_num <- 2
  } else if (names(table[[3]][1]) == "Date" & nrow(table[[3]]) > 2) {
    table_num <- 3
  } else if (names(table[[4]][1]) == "Date" & nrow(table[[4]]) > 2) {
    table_num <- 4
  } else if (names(table[[5]][1]) == "Date" & nrow(table[[5]]) > 2) {
    table_num <- 5
  } else {
    cli::cli_warn(
      "No {team_info$yr[1]} season stats available for {team_info$team_name[1]} (team ID {team_id})."
    )
    return(invisible())
  }

  table[[table_num]] |>
    dplyr::select("Date":"BHE") |>
    dplyr::filter(.data$Date != "Totals" & .data$Date != "Defensive Totals") |>
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
