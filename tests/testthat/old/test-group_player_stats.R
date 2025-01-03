test_that("group_player_stats() works", {
  expect_equal(group_player_stats(teams = c("Nebraska", "UCLA"), year = 2024)$playerdata$Player[1],
               "Bergen Reilly")
  expect_equal(group_player_stats(teams = "UCLA", year = 2023, sport = "MVB")$playerdata$Player[1],
               "Hideharu Nakamura")
  expect_error(group_player_stats(),
               "Teams is missing.")
  expect_error(group_player_stats(teams = c("UNL", "UCLA"), year = 2024),
               "Team name was not found.")
  expect_error(group_player_stats(teams = "Nebraska"),
               "Enter valid year between 2020-")
  expect_error(group_player_stats(teams = "Nebraska", year = 2002),
               "Enter valid year between 2020-")
  expect_error(group_player_stats(teams = "Nebraska", year = "2024"),
               "Enter valid year between 2020-")
  expect_error(group_player_stats(teams = "Nebraska", year = 2024, sport = "VB"),
               "Enter valid sport")
})
