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
#' @inherit request_live_url note
#'
#' @family functions that extract player statistics
#'
#' @examplesIf interactive()
#' player_season_stats(team_id = "585290")
player_season_stats <- function(team_id, team_stats = TRUE) {
  # check inputs
  check_team_id(team_id)
  if (length(team_id) == 0) {
    cli::cli_warn("No season stats available for team ID {team_id}.")
    return(invisible())
  }
  check_logical("team_stats", team_stats)
  if (length(team_stats) > 1) {
    cli::cli_abort("Enter single value for `team_stats`")
  }

  # get team info and request URL
  team_info <- get_team_info(team_id)
  url <- paste0(
    "https://stats.ncaa.org/teams/",
    team_id,
    "/season_to_date_stats"
  )

  live_url <- tryCatch(
    request_live_url(url),
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
    #if ("Player" %in% colnames(table)) {
    player_stats <- table |>
      dplyr::rename("Number" = "#") |>
      dplyr::mutate(Number = suppressWarnings(as.numeric(.data$Number)))
  }

  # remove team stats if requested
  if (!team_stats) {
    player_stats <- player_stats |>
      dplyr::filter(!.data$Player %in% c("TEAM", "Totals", "Opponent Totals"))
  }

  # combine player stats and roster data
  if (team_info$yr[1] == "2024") {
    url2 <- paste0("https://stats.ncaa.org/teams/", team_id, "/roster")

    live_url <- tryCatch(
      request_live_url(url2),
      error = function(cnd) {
        cli::cli_warn("No website available for team ID {team_id}.")
        return(invisible())
      }
    )
    table2 <- tryCatch(
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

    roster <- table2[[2]] |>
      dplyr::select("Number" = "#", "Name", "Hometown", "High School") |>
      dplyr::mutate(Number = suppressWarnings(as.numeric(.data$Number)))
    dplyr::left_join(
      player_stats,
      roster,
      by = dplyr::join_by("Number", "Player" == "Name")
    ) |>
      dplyr::relocate("Hometown":"High School", .after = "Ht") |>
      dplyr::mutate(
        dplyr::across("Player":"Ht", as.character),
        dplyr::across(
          "GP":dplyr::last_col(),
          ~ suppressWarnings(as.numeric(gsub(",", "", .x)))
        )
      ) |>
      dplyr::mutate(
        Season = team_info$season[1],
        TeamID = team_info$team_id[1],
        Team = team_info$team_name[1],
        Conference = team_info$conference[1],
        .before = 1
      ) |>
      dplyr::arrange(.data$Number)
  } else {
    player_stats |>
      dplyr::mutate(
        dplyr::across("Player":"Ht", as.character),
        dplyr::across(
          "GP":dplyr::last_col(),
          ~ suppressWarnings(as.numeric(gsub(",", "", .x)))
        )
      ) |>
      dplyr::mutate(
        Season = team_info$season[1],
        TeamID = team_info$team_id[1],
        Team = team_info$team_name[1],
        Conference = team_info$conference[1],
        .before = 1
      ) |>
      dplyr::arrange(.data$Number)
  }
}
