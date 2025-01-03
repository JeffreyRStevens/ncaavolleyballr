#' Aggregate player statistics from a particular conference and season
#'
#' This is a wrapper around [group_player_stats()] that extracts
#' all season data from players in all teams from the chosen conference.
#' It aggregates all player data and team data into separate data frames and
#' combines them into a list. Conferences names can be found in
#' [ncaa_conferences].
#'
#' @param conf NCAA conference name.
#' @inheritParams division_player_stats
#'
#' @inherit group_player_stats return
#'
#' @export
#'
#' @family functions that aggregate statistics
#'
#' @examples
#' \dontrun{
#' conference_player_stats(year = 2024, conf = "Big Ten")
#' conference_player_stats(year = 2023, conf = "Big West", sport = "MVB")
#' conference_player_stats(year = 2024, conf = "Big Ten", save = TRUE, path = "data/")
#' }
conference_player_stats <- function(year = NULL,
                                    conf = NULL,
                                    sport = "WVB",
                                    save = FALSE,
                                    path = "") {
  max_year <- most_recent_season()
  if (is.null(year)) cli::cli_abort(paste0("Enter valid year between 2020-", max_year, "."))
  if (!is.numeric(year)) cli::cli_abort(paste0("Enter valid year between 2020-", max_year, "."))
  if (!year %in% 2020:max_year) cli::cli_abort(paste0("Enter valid year between 2020-", max_year, "."))
  if (sport == "WVB") team_df <- ncaavolleyballr::wvb_teams
  else if (sport == "MVB") team_df <- ncaavolleyballr::mvb_teams
  else cli::cli_abort("Enter valid sport (\"WVB\" or \"MVB\").")
  if (is.null(conf)) cli::cli_abort("Enter valid conference.  Check `ncaa_conferences` for conference names.")
  if (!conf %in% team_df$conference) cli::cli_abort("Enter valid conference.  Check `ncaa_conferences` for conference names.")
  if(!is.logical(save)) cli::cli_abort("`save` must be a logical (TRUE or FALSE).")
  if(!is.character(path)) cli::cli_abort("Enter valid path as a character string.")

  conf_teams <- team_df |>
    dplyr::filter(.data$conference == conf & .data$yr == year)
  teams <- conf_teams$team_name

  output <- group_player_stats(teams = teams, year = year, sport = sport)

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
