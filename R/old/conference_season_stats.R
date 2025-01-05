#' Aggregate player season statistics for a NCAA conference and seasons
#'
#' This is a wrapper around [group_stats()] that extracts season data from
#' players in all teams in the chosen conference.
#' It aggregates all player data and team data into separate data frames and
#' combines them into a list. Conferences names can be found in
#' [ncaa_conferences].
#'
#' @param conf NCAA conference name.
#' @inheritParams division_season_stats
#'
#' @inherit division_season_stats return
#'
#' @export
#'
#' @family functions that aggregate statistics
#'
#' @examples
#' \dontrun{
#' conference_season_stats(year = 2024, conf = "Big Ten")
#' conference_season_stats(year = 2023, conf = "Big West", sport = "MVB")
#' conference_season_stats(year = 2024, conf = "Big Ten", save = TRUE, path = "data/")
#' }
conference_season_stats <- function(year = NULL,
                                    conf = NULL,
                                    sport = "WVB",
                                    save = FALSE,
                                    path = ".") {
  # check inputs
  max_year <- most_recent_season()
  if (is.null(year)) cli::cli_abort(paste0("Enter valid year between 2020-", max_year, "."))
  if (!is.numeric(year)) cli::cli_abort(paste0("Enter valid year between 2020-", max_year, "."))
  if (!all(year %in% 2020:max_year)) cli::cli_abort(paste0("Enter valid year between 2020-", max_year, "."))
  if (sport == "WVB") team_df <- ncaavolleyballr::wvb_teams
  else if (sport == "MVB") team_df <- ncaavolleyballr::mvb_teams
  else cli::cli_abort("Enter valid sport (\"WVB\" or \"MVB\").")
  if (is.null(conf)) cli::cli_abort("Enter valid conference.  Check `ncaa_conferences` for conference names.")
  if (!conf %in% team_df$conference) cli::cli_abort("Enter valid conference.  Check `ncaa_conferences` for conference names.")
  if(!is.logical(save)) cli::cli_abort("`save` must be a logical (TRUE or FALSE).")
  if(!is.character(path)) cli::cli_abort("Enter valid path as a character string.")

  # get vector of conference teams
  conf_teams <- team_df |>
    dplyr::filter(.data$conference == conf & .data$yr %in% year)
  teams <- conf_teams$team_name

  # get season-level data on conference teams
  output <- group_stats(teams = teams, year = year, level = "season", sport = sport)

  # remove / at end of path
  if (!grepl("/$", path)) path <- paste0(path, "/")

  # save data to files if requested
  if (save) {
    save_df(x = output$playerdata, label = "playerseason", group = "conf", year = year, conf = conf, sport = sport, path = path)
    save_df(x = output$teamdata, label = "teamseason", group = "conf", year = year, conf = conf, sport = sport, path = path)
  }
  return(output)
}

#' Aggregate player statistics from a particular conference and season
#'
#' @description
#' `r lifecycle::badge("deprecated")`
#'
#' `conference_player_stats()` was renamed to `conference_season_stats()` to
#' create a more consistent API.
#' @keywords internal
#' @export
conference_player_stats <- function(...) {
  lifecycle::deprecate_warn("0.2.0", "conference_player_stats()", "conference_season_stats()")
  conference_season_stats(...)
}
