
#' Extract teams statistics for season statistics from 2001-2024
#'
#' The NCAA's main page for a team includes a tab called "Game By Game"
#' and a section called "Career Totals". Though the page only shows one
#' season's worth of information, this function extracts season summary stats
#' starting with 2001. We have included the conference starting with 2020
#' (conference data for previous seasons is not currently available).
#'
#' @inheritParams find_team_id
#' @param opponent Logical indicating whether to include team's stats
#' (FALSE) or opponent's stats (TRUE). Default is set to FALSE, returning
#' team stats.
#'
#' @returns
#' Returns a data frame of summary team statistics for each season.
#'
#' @export
#'
#' @family functions that extract team statistics
#'
#' @examples
#' \donttest{
#' team_season_stats(team = "Nebraska")
#' }
team_season_stats <- function(team = NULL,
                              opponent = FALSE,
                              sport = "WVB") {
  # check input
  team_df <- check_sport(sport, vb_only = TRUE)
  check_team_name(team, teams = team_df)
  check_logical("opponent", opponent)

  # get team info and request URL
  team_ids <- find_team_id(team, 2020:most_recent_season(), sport = sport)
  team_info <- get_team_info(team_ids) |>
    dplyr::mutate(yr2 = as.character(.data$yr + 1) |>
                    stringr::str_sub(start = 3L, end = 4L)) |>
    tidyr::unite("year", "yr":"yr2", sep = "-") |>
    dplyr::select(Year = "year", Team = "team_name", Conference = "conference")
  team_id <- team_ids[length(team_ids)]
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

  # extract season summary info
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
      rvest::html_element("table") |>
      rvest::html_table() |>
      dplyr::mutate(Year = dplyr::na_if(.data$Year, "")) |>
      tidyr::fill("Year")
  )
  if (length(table) == 1) {
    if (grepl(pattern = "No website available for team ID", table)) return(invisible())
  }

  # return team or opponent summary info
  if (!opponent) {
    team_info |>
      dplyr::right_join(table, by = dplyr::join_by("Year", "Team")) |>
      dplyr::filter(.data$Team != "Defensive") |>
      dplyr::mutate(dplyr::across("S":dplyr::last_col(),
                                  ~ suppressWarnings(as.numeric(gsub(",", "", .x))))) |>
      dplyr::arrange("Year")
  } else {
    team_info |>
      dplyr::right_join(table, by = dplyr::join_by("Year", "Team")) |>
      dplyr::filter(.data$Team == "Defensive") |>
      dplyr::mutate(Team = "Opponent",
                    dplyr::across("S":dplyr::last_col(),
                                  ~ suppressWarnings(as.numeric(gsub(",", "", .x)))))
  }

}
