group_player_stats <- function(teams, year, sport) {
  data <- purrr::map(teams,
                     ~ team_player_stats(find_team_id(.x, year, sport))) |>
    purrr::set_names(teams) |>
    purrr::list_rbind(names_to = "Team") |>
    dplyr::mutate(killsperset = Kills / S,
                  errorsperset = Errors / S,
                  attacksperset = `Total Attacks` / S,
                  assistsperset = Assists / S,
                  acesperset = Aces / S,
                  serviceerrorsperset = SErr / S,
                  digsperset = Digs / S,
                  blockssoloperset = `Block Solos` / S,
                  blocksassistperset = `Block Assists` / S,
                  blockerrorsperset = BErr / S)

  playerdata <- data |>
    dplyr::filter(!is.na(Number))

  teamdata <- data |>
    dplyr::filter(Player == "Totals") |>
    dplyr::select(!c(Number:GS))

  output <- list(playerdata = playerdata, teamdata = teamdata)
  return(output)
}
