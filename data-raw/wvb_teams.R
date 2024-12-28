## code to prepare `wvb_teams` datasets

years <- 2020:2024

wvb_teams <- purrr::map2(rep(years, times = 3),
                        rep(1:3, each = length(years)),
                        ~ get_teams(year = .x, division = .y)) |>
  purrr::list_rbind() |>
  dplyr::filter(team_id != "598395") # remove Vanderbilt 2024

usethis::use_data(wvb_teams, overwrite = TRUE)

