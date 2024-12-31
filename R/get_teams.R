#' Extract data frame of team names, IDs, conference, division, and season
#'
#' NCAA datasets use a unique ID for each sport, team, and season.
#' This function extracts team names, IDs, and conferences for each NCAA team in
#' a division. However, you should not need to use this function for volleyball
#' data from 2020-2024, as it has been used to generate \code{\link{wvb_teams}}
#' and \code{\link{mvb_teams}}. However, it is available to use for other
#' sports, using the appropriate three letter sport code drawn from
#' \code{\link{ncaa_sports}} (e.g., men's baseball is "MBA").
#'
#' @param year Year for fall of desired season.
#' @param division NCAA division (must be 1, 2, or 3).
#' @param sport Three letter abbreviation for NCAA sport (must be upper case;
#' for example "WVB" for women's volleyball and "MVB" for men's volleyball).
#'
#' @returns
#' Returns a data frame of all teams, their team ID, division, conference,
#' and season.
#'
#' @export
#'
#' @examples
#' \dontrun{
#' get_teams(2024)
#' get_teams(2023, division = 3, sport = "MVB")
#' }
get_teams <- function(year = NULL,
                      division = 1,
                      sport = "WVB") {
  max_year <- most_recent_season()
  if (is.null(year)) cli::cli_abort(paste0("Enter valid year between 2002-", max_year, "."))
  if (!is.numeric(year)) cli::cli_abort(paste0("Enter valid year between 2002-", max_year, "."))
  if (year < 2002) stop(paste0("Enter valid year between 2002-", max_year, "."))
  if (!division %in% 1:3) cli::cli_abort("Enter valid division as a number: 1, 2, 3.")
  if (!is.character(sport)) cli::cli_abort("Enter valid sport as a three-letter character string.")
  if (!sport %in% ncaavolleyballr::ncaa_sports$code) cli::cli_abort("Enter valid sport code from `ncaa_sports`.")

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
                       div = division,
                       yr = year,
                       conference_id = x)
    data <- data |>
      dplyr::left_join(conference_df, by = c("conference_id"))
    Sys.sleep(5)
    return(data)
  }) |>
    purrr::list_rbind() |>
    dplyr::mutate(team_id = stringr::str_extract(.data$team_url, "(\\d+)")) |>
    dplyr::select("team_id", "team_name", "conference_id", "conference", "div", "yr")
}
