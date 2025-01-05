test_that("division_season_stats() works", {
  expect_error(division_season_stats(division = 2002),
               "Enter valid division as a number: 1, 2, 3")
  expect_error(division_season_stats(),
               "Enter valid year between 2020-")
  expect_error(division_season_stats(year = 2002, sport = "MVB"),
               "Enter valid year between 2020-")
  expect_error(division_season_stats(year = "2024"),
               "Enter valid year between 2020-")
  expect_error(division_season_stats(year = 2024, sport = "VB"),
               "Enter valid sport")
  expect_error(division_season_stats(year = 2024, save = "TRUE"),
               "`save` must be a logical")
  expect_error(division_season_stats(year = 2024, path = 3),
               "Enter valid path as a character string")
})
