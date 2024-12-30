#' Aggregate all player statistics from a particular conference and year
#'
#' @param year Year for fall volleyball season.
#' @param conference NCAA conference name.
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
#' @family aggregate statistics
#'
#' @examples
#' \dontrun{
#' conference_player_stats(2024)
#' conference_player_stats(2023, division = 3, sport = "MVB")
#' conference_player_stats(2024, save = TRUE, path = "data/")
#' }
conference_player_stats <- function(year, conf = NULL, sport = "WVB", save = FALSE, path = "") {
  if (!is.numeric(year)) cli::cli_abort("`year` must be a numeric.")
  if (!year %in% 2020:2024) cli::cli_abort("`year` must be between 2020-2024.")
  if (sport == "WVB") team_df <- wvb_teams
  else if (sport == "MVB") team_df <- mvb_teams
  else cli::cli_abort("Invalid sport entered. Must be 'WVB' or 'MVB'.")
  if (is.null(conf)) cli::cli_abort("Conference name is missing.")
  if (!conf %in% team_df$conference) cli::cli_abort("Enter valid conference.")
  if(!is.logical(save)) cli::cli_abort("`save` must be a logical (TRUE or FALSE).")
  if(!is.character(path)) cli::cli_abort("`path` must be a character string.")

  conf_teams <- team_df |>
    dplyr::filter(conference == conf & yr == year)
  teams <- conf_teams$team_name[1:3]

  output <- group_player_stats(teams, year, sport)

  if (!grepl("/$", path)) path <- paste0(path, "/")

  if (save) {
    write.csv(output$playerdata, paste0(path, sport, "_playerdata_div", division, "_", year, ".csv"))
    write.csv(output$teamdata, paste0(path,sport, "_teamdata_div", division, "_", year, ".csv"))
  }

  return(output)
}
