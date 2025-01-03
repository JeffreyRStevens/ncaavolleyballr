test_that("group_stats() works at season level", {
  expect_equal(group_stats(teams = c("Nebraska", "UCLA"), year = 2024)$playerdata$Player[1],
               "Bergen Reilly")
  expect_equal(group_stats(teams = "UCLA", year = 2023, sport = "MVB")$playerdata$Player[1],
               "Hideharu Nakamura")
  expect_error(group_stats(),
               "Enter valid vector of teams.")
  expect_error(group_stats(teams = c("UNL", "UCLA"), year = 2024),
               "Team name was not found.")
  expect_error(group_stats(teams = "Nebraska"),
               "Enter valid year between 2020-")
  expect_error(group_stats(teams = "Nebraska", year = 2002),
               "Enter valid year between 2020-")
  expect_error(group_stats(teams = "Nebraska", year = "2024"),
               "Enter valid year between 2020-")
  expect_error(group_stats(teams = "Nebraska", year = 2024, sport = "VB"),
               "Enter valid sport")
})

test_that("group_stats() works at match level", {
  expect_equal(group_stats(teams = "Nebraska", year = 2024, level = "match")$Player[1],
               "Rebekah Allick")
  # expect_equal(group_stats(teams = "UCLA", year = 2023, level = "match", sport = "MVB")$Player[1],
  #              "Ethan Champlin")
})

test_that("group_stats() works at pbp level", {
  expect_equal(group_stats(teams = "Nebraska", year = 2024, level = "pbp")$home_team[1],
               "Kentucky")
  # expect_equal(group_stats(teams = "UCLA", year = 2023, level = "pbp", sport = "MVB")$away_team[1],
  #              "Fort Valley St.")
})
