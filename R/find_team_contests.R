
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
#' \donttest{
#' find_team_contests(team_id = "585290")
#' }
find_team_contests <- function(team_id = NULL) {
  # check team_id
  check_team_id(team_id)
  if (length(team_id) == 0) return() # skip teams with no team_id

  # get team info and request URL
  team_info <- get_team_info(team_id)
  url <- paste0("https://stats.ncaa.org/teams/", team_id)

  resp <- tryCatch(
    error = function(cnd) {
      cli::cli_warn("No website available for team ID {team_id}.")
    },
    request_url(url)
  )
  if (length(resp) == 1) {
    if (grepl(pattern = "No website available for team ID", resp)) return(invisible())
  }

  html_table <- resp |>
    httr2::resp_body_html() |>
    rvest::html_element("table")

  schedule <- html_table |>
    html_table_raw() |>
    dplyr::mutate(Team = team_info$team_name[1], .after = "Date") |>
    dplyr::mutate(dplyr::across(dplyr::everything(),
                                ~ sub("<td>", "", .x)),
                  dplyr::across(dplyr::everything(),
                                ~ sub("</td>", "", .x)),
                  dplyr::across(dplyr::everything(),
                                ~ sub("<td nowrap>", "", .x)),
                  dplyr::across(dplyr::everything(),
                                ~ sub("<td align=\"right\">", "", .x)),
                  Opponent = sub(".*\\.gif\"> ", "", .data$Opponent),
                  Opponent = sub(".*>\\#\\d", "", .data$Opponent),
                  Opponent = sub("</a>.*", "", .data$Opponent),
                  Opponent = sub("<br>.*", "", .data$Opponent),
                  Opponent = stringr::str_trim(.data$Opponent),
                  Opponent = sub("\\&amp;", "\\&", .data$Opponent),
                  contest = stringr::str_extract(.data$Result, "(\\d+)(?=/box)"),
                  Result = sub(".*box_score\">", "", .data$Result),
                  dplyr::across(dplyr::everything(),
                                ~ sub("</a>", "", .x)),
                  dplyr::across(dplyr::everything(),
                                stringr::str_trim),
                  Attendance = suppressWarnings(as.numeric(gsub(",", "", .data$Attendance)))
    )
  names(schedule) <- tolower(names(schedule))

  # skip teams with no data
  if (nrow(schedule) == 0) return()

  schedule
}
