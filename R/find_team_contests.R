
#' Extract date, opponent, and contest ID for team and season
#'
#' NCAA datasets use a unique ID for each sport, team, season, and match.
#' This function returns a data frame of dates, opponent team names, and
#' contest IDs for each NCAA contest (volleyball match) for each team and
#' season.
#'
#' @inheritParams team_player_stats
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

  date <- resp |> httr2::resp_body_html() |>
    rvest::html_element("table") |>
    rvest::html_table() |>
    dplyr::filter(.data$Date != "") |>
    dplyr::pull(.data$Date)

  opponents <- resp |> httr2::resp_body_html() |>
    rvest::html_element("table") |>
    rvest::html_elements("img") |>
    rvest::html_attr("alt")

  contests <- resp |> httr2::resp_body_html() |>
    rvest::html_element("table") |>
    rvest::html_elements("a") |>
    rvest::html_attr("href") |>
    stringr::str_subset("contests") |>
    stringr::str_extract("(\\d+)")

  data.frame(date = date, team = rep(team_info["Team"], length(date)),
                                     opponent = opponents, contest = contests)
}
