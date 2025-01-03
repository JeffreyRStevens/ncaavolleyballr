
#' Extract date, opponent, and contest ID for team and season
#'
#' NCAA datasets use a unique ID for each sport, team, season, and match.
#' This function returns a data frame of dates, opponent team names, and
#' contest IDs for each NCAA contest (volleyball match) for each team and
#' season.
#'
#' @inheritParams player_season_stats
#'
#' @returns
#' Returns a data frame that includes date, team, opponent, and contest ID for
#' each season's contest.
#'
#' @export
#'
#' @examples
#' \dontrun{
#' find_team_contests(team_id = "585290")
#' find_team_contests(team_id = find_team_id("Nebraska", 2024))
#' find_team_contests(team_id = find_team_id("UCLA", 2023, sport = "MVB"))
#' }
find_team_contests <- function(team_id = NULL) {
  check_team_id(team_id)
  team_info <- get_team_info(team_id)

  url <- paste0("https://stats.ncaa.org/teams/", team_id)

  resp <- request_url(url)

  schedule <- resp |> httr2::resp_body_html() |>
    rvest::html_element("table") |>
    rvest::html_table() |>
    dplyr::filter(.data$Date != "") |>
    dplyr::mutate(team = team_info["Team"], .after = .data$Date)
  names(schedule) <- tolower(names(schedule))

  canceled <- which(schedule$result == "Canceled")

  contests <- resp |> httr2::resp_body_html() |>
    rvest::html_element("table") |>
    rvest::html_elements("a") |>
    rvest::html_attr("href") |>
    stringr::str_subset("contests") |>
    stringr::str_extract("(\\d+)")

  if (length(canceled) > 0) {
    for(i in seq_along(canceled)) {
      contests <- append(contests, NA, after = canceled[i] - 1)
    }
  }

  schedule |>
    cbind(contests)
}
