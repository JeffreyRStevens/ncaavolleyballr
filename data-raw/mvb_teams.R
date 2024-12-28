## code to prepare `mvb_teams` datasets

years <- 2020:2024

mvb_teams <- purrr::map2(rep(years, times = 2),
                         rep(c(1, 3), each = length(years)),
                         ~ get_teams(year = .x, division = .y, sport = "MVB")) |>
  purrr::list_rbind()

usethis::use_data(mvb_teams, overwrite = TRUE)
