test_that("find_team_id() works", {
  expect_equal(find_team_id(team = "Nebraska", year = 2024),
               "585290")
  expect_equal(find_team_id(team = "UCLA", year = 2023, "MVB"),
               "573670")
  expect_error(find_team_id(),
               "Enter valid team name.")
  expect_error(find_team_id(team = "UNL", year = 2024),
               "Enter valid team name.")
  expect_error(find_team_id(team = "Nebraska"),
               "Enter valid year between 2020-")
  expect_error(find_team_id(team = "Nebraska", year = 1980),
               "Enter valid year between 2020-")
  expect_error(find_team_id(team = "Nebraska", year = "2024"),
               "Enter valid year between 2020-")
  expect_error(find_team_id(team = "Nebraska", year = 2024, sport = "VB"),
               "Enter valid sport")
})
