#' Aggregate all player statistics from a vector of teams in a year
#'
#' This function runs \code{\link{team_player_stats()}} on a vector of team names to
#' extract season data for the players and teams in the vector.
#' It aggregates all player data and team data into separate data frames and
#' combines them into a list. So, for instance, if you want to extract the
#' data from the teams in the women's 2024 Final Four, pass a vector of
#' \code{c("Louisville", "Nebraska", "Penn State", "Pittsburgh")}
#' to the function.
#'
#' @param teams Character vector of team names to aggregate.
#' @param year Year for fall volleyball season.
#' @param sport Three letter abbreviation for NCAA sport (must be upper case;
#' for example "WVB" for women's volleyball and "MVB" for men's volleyball).
#'
#' @returns
#' Returns list with player statistics and team statistics data frames.
#' @export
#'
#' @family functions that aggregate statistics
#'
#' @examples
#' \dontrun{
#' group_player_stats(c("Louisville", "Nebraska", "Penn State", "Pittsburgh"), 2024)
#' group_player_stats(c("UCLA", "Long Beach St."), 2023, sport = "MVB")
#' }
group_player_stats <- function(teams, year, sport = "WVB") {
  data <- purrr::map(teams,
                     ~ team_player_stats(find_team_id(.x, year, sport))) |>
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
