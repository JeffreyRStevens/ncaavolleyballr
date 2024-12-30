## code to prepare `wvb_teams` datasets

years <- 2020:2024

wvb_teams <- purrr::map2(rep(years, times = 3),
                        rep(1:3, each = length(years)),
                        ~ get_teams(year = .x, division = .y)) |>
  purrr::list_rbind() |>
  dplyr::filter(team_id != "598395" & team_id != "504440") # remove Vanderbilt 2024, Georgetown 2020

usethis::use_data(wvb_teams, overwrite = TRUE)



## code to prepare `mvb_teams` datasets

years <- 2020:2024

mvb_teams <- purrr::map2(rep(years, times = 2),
                         rep(c(1, 3), each = length(years)),
                         ~ get_teams(year = .x, division = .y, sport = "MVB")) |>
  purrr::list_rbind()

usethis::use_data(mvb_teams, overwrite = TRUE)

