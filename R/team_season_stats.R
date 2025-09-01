#' Extract teams statistics for season statistics from 2020-2024
#'
#' The NCAA's main page for a team includes a tab called "Game By Game"
#' and a section called "Career Totals". This function extracts season summary
#' stats.
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
#' @inherit request_live_url note
#'
#' @family functions that extract team statistics
#'
#' @examplesIf interactive()
#' team_season_stats(team = "Nebraska")
team_season_stats <- function(team = NULL, opponent = FALSE, sport = "WVB") {
  # check input
  team_df <- check_sport(sport, vb_only = TRUE)
  check_team_name(team, teams = team_df)
  check_logical("opponent", opponent)
  if (length(opponent) > 1) {
    cli::cli_abort("Enter single value for `opponent`")
  }

  # get team ids
  team_ids <- find_team_id(team, 2020:most_recent_season(), sport = sport)

  # get info for each season
  purrr::map(team_ids, ~ single_season_stats(.x, opponent = opponent)) |>
    purrr::list_rbind()
}


single_season_stats <- function(team_id, opponent) {
  # get team info and URL for season
  team_info <- get_team_info(team_id) |>
    dplyr::mutate(
      year = stringr::`str_sub<-`(.data$season, 6, 7, value = "")
    ) |>
    dplyr::select(
      Season = "year",
      Team = "team_name",
      Conference = "conference"
    )
  team_url <- paste0(
    "https://stats.ncaa.org/teams/",
    team_id,
    "/season_to_date_stats"
  )

  # extract season table
  live_url <- tryCatch(
    request_live_url(team_url),
    error = function(cnd) {
      cli::cli_warn("No website available for team ID {team_id}.")
      return(invisible())
    }
  )
  output <- tryCatch(
    live_url |>
      rvest::html_elements("table") |>
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

  if (length(output) == 1) {
    if (grepl(pattern = "No website available for team ID", output)) {
      return(invisible())
    }
  } else {
    table <- output[[2]]
  }

  if (nrow(table) <= 1 || !"Player" %in% colnames(table)) {
    cli::cli_warn(
      "No {team_info$yr[1]} season stats available for {team_info$team_name[1]} (team ID {team_id})."
    )
    return(invisible())
  } else {
    player_stats <- table |>
      dplyr::rename("Number" = "#") |>
      dplyr::mutate(Number = suppressWarnings(as.numeric(.data$Number)))
  }

  # return team or opponent summary info
  if (!opponent) {
    table <- dplyr::filter(table, .data$Player == "Totals")
  } else {
    table <- dplyr::filter(table, .data$Player == "Opponent Totals")
    team_info <- team_info |>
      dplyr::mutate("Team" = paste0(.data$Team, " Opponents")) |>
      dplyr::select(!"Conference")
  }
  team_info |>
    dplyr::bind_cols(table) |>
    dplyr::mutate(dplyr::across(
      "S":dplyr::last_col(),
      ~ suppressWarnings(as.numeric(gsub(",", "", .x)))
    )) |>
    dplyr::select(!c("#":"GS"))
}
