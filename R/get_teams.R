#' Get all team IDs for a particular year
#'
#' @param year Year for fall volleyball season
#' @param division NCAA division (must be 1, 2, or 3)
#' @param sport Three letter abbreviation for NCAA sport (must be upper case;
#' for example "WVB" for women's volleyball)
#'
#' @returns
#' Data frame of all teams, their team ID, division, conference, and year.
#' @export
#'
#' @examples
#' \dontrun{
#' get_teams(2024)
#' }
get_teams <- function(year,
                      division = 1,
                      sport = "WVB") {
  if (is.null(year)) {
    cli::cli_abort("Enter valid year as a number (YYYY)")
  }
  if (is.null(division)) {
    cli::cli_abort("Enter valid division as a number: 1, 2, 3")
  }
  if (year < 2002) {
    stop('you must provide a year that is equal to or greater than 2002')
  }

  url_year <- year + 1

  url <- paste0("http://stats.ncaa.org/team/inst_team_list?academic_year=",
                url_year,
                "&conf_id=-1",
                "&division=", division,
                "&sport_code=", sport)

  resp <- request_url(url)

  data_read <- resp |>
    httr2::resp_body_html()

  team_urls <- data_read |>
    rvest::html_elements("table") |>
    rvest::html_elements("a") |>
    rvest::html_attr("href")

  team_names <- data_read |>
    rvest::html_elements("table") |>
    rvest::html_elements("a") |>
    rvest::html_text()

  conference_names <- ((data_read |>
                          rvest::html_elements(".level2"))[[4]] |>
                         rvest::html_elements("a") |>
                         rvest::html_text())[-1]

  conference_ids <- (data_read |>
                       rvest::html_elements(".level2"))[[4]] |>
    rvest::html_elements("a") |>
    rvest::html_attr("href") |>
    stringr::str_extract("javascript:changeConference\\(\\d+\\)") |>
    stringr::str_subset("javascript:changeConference\\(\\d+\\)") |>
    stringr::str_extract("\\d+")

  conference_df <- data.frame(conference = conference_names,
                              conference_id = conference_ids)

  conferences_team_df <- lapply(conference_df$conference_id, function(x){
    conf_team_urls <- paste0("http://stats.ncaa.org/team/inst_team_list?academic_year=",
                             url_year,
                             "&conf_id=", x,
                             "&division=", division,
                             "&sport_code=", sport)
    resp <- request_url(url = conf_team_urls)

    team_urls <- resp |>
      httr2::resp_body_html() |>
      rvest::html_elements("table") |>
      rvest::html_elements("a") |>
      rvest::html_attr("href")

    team_names <- resp |>
      httr2::resp_body_html() |>
      rvest::html_elements("table") |>
      rvest::html_elements("a") |>
      rvest::html_text()

    data <- data.frame(team_url = team_urls,
                       team_name = team_names,
                       division = division,
                       year = year,
                       conference_id = x)
    data <- data |>
      dplyr::left_join(conference_df, by = c("conference_id"))
    Sys.sleep(5)
    return(data)
  }) |>
    purrr::list_rbind() |>
    dplyr::mutate(team_id = stringr::str_extract(.data$team_url, "\\/(\\d+)", group = 1)) |>
    dplyr::select(.data$team_id, .data$team_name, .data$conference_id, .data$conference, .data$division, .data$year)
}
