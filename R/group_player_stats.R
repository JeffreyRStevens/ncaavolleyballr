#' Aggregate player statistics from a set of teams for a particular season
#'
#' This function runs [player_season_stats()] on a vector of team
#' names to extract season data for the players and teams in the vector.
#' It aggregates all player data and team data into separate data frames and
#' combines them into a list. For instance, if you want to extract the
#' data from the teams in the women's 2024 Final Four, pass a vector of
#' \code{c("Louisville", "Nebraska", "Penn State", "Pittsburgh")}
#' to the function. Team names can be found in [ncaa_teams] or by
#' using [find_team_name()].
#'
#' @param teams Character vector of team names to aggregate.
#' @inheritParams get_teams
#'
#' @returns
#' Returns list with player statistics and team statistics data frames.
#'
#' @export
#'
#' @family functions that aggregate statistics
#'
#' @examples
#' \dontrun{
#' group_player_stats(teams = c("Louisville", "Nebraska", "Penn St.", "Pittsburgh"),
#' year = 2024)
#' group_player_stats(teams = c("UCLA", "Long Beach St."), year = 2023, sport = "MVB")
#' }
group_player_stats <- function(teams = NULL,
                               year = NULL,
                               sport = "WVB") {
  max_year <- most_recent_season()
  if (sport == "WVB") team_df <- ncaavolleyballr::wvb_teams
  else if (sport == "MVB") team_df <- ncaavolleyballr::mvb_teams
  else cli::cli_abort("Enter valid sport (\"WVB\" or \"MVB\").")
  if (is.null(teams)) cli::cli_abort("Teams is missing.")
  if (!all(teams %in% team_df$team_name)) cli::cli_abort("Team name was not found.")
  if (is.null(year)) cli::cli_abort(paste0("Enter valid year between 2020-", max_year, "."))
  if (!is.numeric(year)) cli::cli_abort(paste0("Enter valid year between 2020-", max_year, "."))
  if (!year %in% 2020:max_year) cli::cli_abort(paste0("Enter valid year between 2020-", max_year, "."))

  data <- purrr::map(teams,
                     ~ player_season_stats(find_team_id(.x, year, sport))) |>
    purrr::set_names(teams) |>
    purrr::list_rbind(names_to = "Team") |>
    dplyr::mutate(killsperset = .data$Kills / .data$S,
                  errorsperset = .data$Errors / .data$S,
                  attacksperset = .data$`Total Attacks` / .data$S,
                  assistsperset = .data$Assists / .data$S,
                  acesperset = .data$Aces / .data$S,
                  serviceerrorsperset = .data$SErr / .data$S,
                  digsperset = .data$Digs / .data$S,
                  blockssoloperset = .data$`Block Solos` / .data$S,
                  blocksassistperset = .data$`Block Assists` / .data$S,
                  blockerrorsperset = .data$BErr / .data$S)

  playerdata <- data |>
    dplyr::filter(!is.na(.data$Number))

  teamdata <- data |>
    dplyr::filter(.data$Player == "Totals") |>
    dplyr::select(!c("Number":"GS"))

  output <- list(playerdata = playerdata, teamdata = teamdata)
  return(output)
}
