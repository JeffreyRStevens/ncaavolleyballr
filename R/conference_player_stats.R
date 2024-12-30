#' Aggregate all player statistics from a particular conference and year
#'
#' @param year Year for fall volleyball season.
#' @param conf NCAA conference name.
#' @param sport Three letter abbreviation for NCAA sport (must be upper case;
#' for example "WVB" for women's volleyball and "MVB" for men's volleyball).
#' @param save Logical for whether to save the statistics locally as CSVs
#' (default FALSE).
#' @param path Character string of path to save statistics files.
#'
#' @returns
#' Returns list with player statistics and team statistics data frames.
#' @export
#'
#' @family functions that aggregate statistics
#'
#' @examples
#' \dontrun{
#' conference_player_stats(2024, conf = "Big Ten")
#' conference_player_stats(2023, conf = "Big West", sport = "MVB")
#' conference_player_stats(2024, conf = "Big Ten", save = TRUE, path = "data/")
#' }
conference_player_stats <- function(year, conf = NULL, sport = "WVB", save = FALSE, path = "") {
  if (!is.numeric(year)) cli::cli_abort("`year` must be a numeric.")
  if (!year %in% 2020:2024) cli::cli_abort("`year` must be between 2020-2024.")
  if (sport == "WVB") team_df <- ncaavolleyballr::wvb_teams
  else if (sport == "MVB") team_df <- ncaavolleyballr::mvb_teams
  else cli::cli_abort("Invalid sport entered. Must be 'WVB' or 'MVB'.")
  if (is.null(conf)) cli::cli_abort("Conference name is missing.")
  if (!conf %in% team_df$conference) cli::cli_abort("Enter valid conference.")
  if(!is.logical(save)) cli::cli_abort("`save` must be a logical (TRUE or FALSE).")
  if(!is.character(path)) cli::cli_abort("`path` must be a character string.")

  conf_teams <- team_df |>
    dplyr::filter(.data$conference == conf & .data$yr == year)
  teams <- conf_teams$team_name

  output <- group_player_stats(teams, year, sport)

  if (!grepl("/$", path)) path <- paste0(path, "/")

  if (save) {
    shortconf <- tolower(gsub(" ", "", conf))
    utils::write.csv(output$playerdata,
                     paste0(path, tolower(sport), "_playerdata_", shortconf, "_", year, ".csv"),
                     row.names = FALSE)
    utils::write.csv(output$teamdata,
                     paste0(path, tolower(sport), "_teamdata_", shortconf, "_", year, ".csv"),
                     row.names = FALSE)
  }

  return(output)
}
