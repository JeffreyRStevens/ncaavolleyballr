#' Extract arena, coach, record, and schedule information for a particular team
#' and season
#'
#' The NCAA's main page for a team includes a tab called "Schedule/Results".
#' This function extracts information about the team's venue, coach, and
#' records, as well as the table of the schedule and results. This returns a
#' list, so you can subset specific components with `$` (e.g., for coach
#' information from an object called `output`, use `output$coach`).
#'
#' @inheritParams player_season_stats
#'
#' @returns
#' Returns a list that includes arena, coach, schedule, and record information.
#'
#' @export
#'
#' @inherit request_live_url note
#'
#' @family functions that extract team statistics
#'
#' @examplesIf interactive()
#' team_season_info(team_id = "585290")
team_season_info <- function(team_id = NULL) {
  # check input
  check_team_id(team_id)

  # get team info and request URL
  team_info <- get_team_info(team_id)

  url <- paste0("https://stats.ncaa.org/teams/", team_id)
  live_url <- tryCatch(
    request_live_url(url),
    error = function(cnd) {
      cli::cli_warn("No website available for team ID {team_id}.")
      return(invisible())
    }
  )

  # extract arena info
  arena <- live_url |>
    # httr2::resp_body_html() |>
    rvest::html_element(".mb-0") |>
    rvest::html_text() |>
    stringr::str_split_1("\n      \n") |>
    stringr::str_trim()
  arena <- arena[!arena %in% c("Name:", "Capacity:", "Year Built:", "")]
  names(arena) <- c("Arena name", "Capacity", "Year built")

  # extract coach info
  coach <- live_url |>
    # httr2::resp_body_html() |>
    rvest::html_elements(".mb-0") |>
    rvest::html_text()
  if (coach[8] == "Primary Venue:") {
    coach <- coach[19]
  } else {
    coach <- coach[8]
  }
  coach <- coach |>
    stringr::str_split_1("\n          \n") |>
    stringr::str_squish() |>
    stringr::str_trim() |>
    stringr::str_replace(" Record:", "")
  coach <- coach[!coach %in% c("Name:", "Alma Mater:", "Seasons:", "")]
  names(coach) <- c("Name", "Alma mater", "Seasons", "Record")

  # extract record info
  record <- live_url |>
    rvest::html_elements(".row") |>
    rvest::html_elements(".card-body.p-0") |>
    rvest::html_text() |>
    stringr::str_split("\\n\\s+")
  record <- record[[1]][
    !record[[1]] %in%
      c(
        "",
        "Overall",
        "Conference",
        "Home",
        "Road",
        "Neutral",
        "Neutral ",
        "Non-Division"
      )
  ]
  names(record) <- c(
    "Overall record",
    "Overall streak",
    "Conference record",
    "Conference streak",
    "Home record",
    "Home streak",
    "Road record",
    "Road streak",
    "Neutral record",
    "Neutral streak",
    "Non-division record",
    "Non-division streak"
  )

  # extract schedule info
  schedule <- live_url |>
    # httr2::resp_body_html() |>
    rvest::html_element("table") |>
    rvest::html_table() |>
    dplyr::filter(.data$Date != "")

  if (inherits(live_url, "LiveHTML")) {
    live_url$session$close()
  } else {
    cli::cli_warn("No match info available for team ID {team_id}.")
    return(invisible())
  }
  rm(live_url)

  output <- list(
    team_info = team_info,
    arena = arena,
    coach = coach,
    record = record,
    schedule = schedule
  )
  return(output)
}
