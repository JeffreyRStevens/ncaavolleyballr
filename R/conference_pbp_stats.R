#' Aggregate play-by-play data for a NCAA conference and seasons
#'
#' This is a wrapper around [group_stats()] that extracts play-by-play
#' data from all teams in the chosen conference.
#' Conferences names can be found in
#' [ncaa_conferences].
#'
#' @inheritParams conference_season_stats
#'
#' @inherit division_pbp_stats return
#'
#' @export
#'
#' @family functions that aggregate statistics
#'
#' @examples
#' \dontrun{
#' conference_pbp_stats(year = 2024, conf = "Big Ten")
#' conference_pbp_stats(year = 2023, conf = "Big West", sport = "MVB")
#' conference_pbp_stats(year = 2024, conf = "Big Ten", save = TRUE, path = "data/")
#' }
conference_pbp_stats <- function(year = NULL,
                                    conf = NULL,
                                    sport = "WVB",
                                    save = FALSE,
                                    path = ".") {
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

  conf_teams <- team_df |>
    dplyr::filter(.data$conference == conf & .data$yr %in% year)
  teams <- conf_teams$team_name

  output <- group_stats(teams = teams, year = year, level = "pbp", sport = sport)

  if (!grepl("/$", path)) path <- paste0(path, "/")

  if (save) {
    save_df(x = output, label = "pbp", group = "conf", year = year, conf = conf, sport = sport, path = path)
  }
  return(output)
}
