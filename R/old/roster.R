

#' Extract roster information for a particular team and season
#'
#' @inheritParams player_stats
#'
#' @returns
#' Tibble of roster information.
#' @export
#'
#' @examples
#' \dontrun{
#' roster("585290")
#' }
roster <- function(team_id) {
  check_team_id(team_id)
  url <- paste0("https://stats.ncaa.org/teams/", team_id, "/roster")

  resp <- request_url(url)

  resp |> httr2::resp_body_html() |>
    rvest::html_element("table") |>
    rvest::html_table()
}
