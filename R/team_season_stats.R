

#' Extract arena, coach, record, and schedule information for a season
#'
#' @inheritParams team_player_stats
#'
#' @returns
#' List that includes arena, coach, record, and schedule information.
#' @export
#'
#' @examples
#' \dontrun{
#' team_season_stats("585290")
#' team_season_stats(find_team_id("Nebraska", 2024))
#' team_season_stats(find_team_id("UCLA", 2023, sport = "MVB"))
#' }
team_season_stats <- function(team_id) {
  check_team_id(team_id)
  teams <- dplyr::bind_rows(wvb_teams, mvb_teams)
  team <- teams[which(teams == team_id), ]$team_name
  conference <- teams[which(teams == team_id), ]$conference
  yr <- teams[which(teams == team_id), ]$yr
  team_info <- c(Year = yr, Team = team, Conference = conference)

  url <- paste0("https://stats.ncaa.org/teams/", team_id)

  resp <- request_url(url)

  arena <- resp |> httr2::resp_body_html() |>
    rvest::html_element(".mb-0") |>
    rvest::html_text() |>
    stringr::str_split_1("\n      \n") |>
    stringr::str_trim()
  arena <- arena[!arena %in% c("Name:", "Capacity:", "Year Built:", "")]
  names(arena) <- c("Arena name", "Capacity", "Year built")

  coach <- resp |> httr2::resp_body_html() |>
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

  record <- resp |> httr2::resp_body_html() |>
    rvest::html_elements(".row") |>
    rvest::html_elements("span") |>
    rvest::html_text() |>
    stringr::str_trim()
  record <- record[-1]
  names(record) <- c("Overall record", "Overall streak", "Conference record", "Conference streak", "Home record", "Home streak", "Road record", "Road streak", "Neutral record", "Neutral streak", "Non-division record", "Non-division streak")

  schedule <- resp |> httr2::resp_body_html() |>
    rvest::html_element("table") |>
    rvest::html_table() |>
    dplyr::filter(.data$Date != "")

  output <- list(team_info = team_info, arena = arena, coach = coach, record = record, schedule = schedule)
  return(output)
}
