

#' Extract arena, coach, record, and schedule information for a season
#'
#' @inheritParams player_stats
#'
#' @returns
#' List that includes arena, coach, record, and schedule information.
#' @export
#'
#' @examples
#' \dontrun{
#' team_season("585290")
#' }
team_season <- function(team_id) {
  check_team_id(team_id)
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
  coach <- coach[8]
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

  output <- list(arena = arena, coach = coach, record = record, schedule = schedule)
  return(output)
}
