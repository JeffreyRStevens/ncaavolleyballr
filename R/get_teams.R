#' Extract data frame of team names, IDs, conference, division, and season
#'
#' NCAA datasets use a unique ID for each sport, team, and season.
#' This function extracts team names, IDs, and conferences for each NCAA team in
#' a division. However, you should not need to use this function for volleyball
#' data from 2020-2024, as it has been used to generate [wvb_teams]
#' and [mvb_teams]. However, it is available to use for other
#' sports, using the appropriate three letter sport code drawn from
#' [ncaa_sports] (e.g., men's baseball is "MBA").
#'
#' @param year Single numeric year for fall of desired season.
#' @param division NCAA division (must be 1, 2, or 3).
#' @param sport Three letter abbreviation for NCAA sport (must be upper case;
#' for example "WVB" for women's volleyball and "MVB" for men's volleyball).
#'
#' @note
#' This function **requires internet connectivity** as it checks the
#' [NCAA website](https://stats.ncaa.org) for information.
#'
#' This function is a modification of the `ncaa_teams()` function from the
#' [`{baseballr}`](https://billpetti.github.io/baseballr/) package.
#'
#' @returns
#' Returns a data frame of all teams, their team ID, division, conference,
#' and season.
#'
#' @export
#'
get_teams <- function(year = NULL,
                      division = 1,
                      sport = "WVB") {
  # check inputs
  check_year(year)
  check_match("division", division, 1:3)
  check_sport(sport, vb_only = FALSE)

  # increment year for NCAA website
  url_year <- year + 1

  # get and request URL
  url <- paste0("http://stats.ncaa.org/team/inst_team_list?academic_year=",
                url_year,
                "&conf_id=-1",
                "&division=", division,
                "&sport_code=", sport)
  resp <- tryCatch(
    error = function(cnd) {
      cli::cli_warn("No website available.")
    },
    request_url(url = url)
  )
  if (length(resp) == 1) {
    if (grepl(pattern = "No website available", resp)) return(invisible())
  }

  # create HTML table
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

  conferences_team_df <- lapply(conference_df$conference_id, function(x) {
    conf_team_urls <- paste0("http://stats.ncaa.org/team/inst_team_list?academic_year=",
                             url_year,
                             "&conf_id=", x,
                             "&division=", division,
                             "&sport_code=", sport)
    resp <- tryCatch(
      error = function(cnd) {
        cli::cli_warn("No website available.")
      },
      request_url(url = conf_team_urls)
    )
    if (length(resp) == 1) {
      if (grepl(pattern = "No website available", resp)) return(invisible())
    }

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

    # assemble data frame
    data <- data.frame(team_url = team_urls,
                       team_name = team_names,
                       div = division,
                       yr = year,
                       conference_id = x)
    data <- data |>
      dplyr::left_join(conferences_team_df, by = c("conference_id"))
    Sys.sleep(5)
    return(data)
  }) |>
    purrr::list_rbind() |>
    dplyr::mutate(team_id = stringr::str_extract(.data$team_url, "(\\d+)")) |>
    dplyr::select("team_id", "team_name", "conference_id", "conference", "div", "yr")
}
