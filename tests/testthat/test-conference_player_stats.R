test_that("conference_player_stats() works", {
  expect_error(conference_player_stats(),
               "Enter valid year between 2020-")
  expect_error(conference_player_stats(year = 2002),
               "Enter valid year between 2020-")
  expect_error(conference_player_stats(year = "2024"),
               "Enter valid year between 2020-")
  expect_error(conference_player_stats(year = 2024),
               "Enter valid conference.")
  expect_error(conference_player_stats(year = 2024, conf = "Big Conf", sport = "MVB"),
               "Enter valid conference.")
  expect_error(conference_player_stats(year = 2024, conf = "Big Ten", sport = "VB"),
               "Enter valid sport")
  expect_error(conference_player_stats(year = 2024, conf = "Big Ten", save = "TRUE"),
               "`save` must be a logical")
  expect_error(conference_player_stats(year = 2024, conf = "Big Ten", path = 3),
               "Enter valid path as a character string")
})
