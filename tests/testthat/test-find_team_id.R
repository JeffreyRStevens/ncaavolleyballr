test_that("find_team_id works correctly", {
  expect_equal(find_team_id("Nebraska", 2024), "585290")
  expect_equal(find_team_id("Long Beach St.", 2024, "MVB"), "593436")
  expect_error(find_team_id("UNL", 2024), "Team name was not found.")
  expect_error(find_team_id("Nebraska", 1980), "`year` must be between")
  expect_error(find_team_id("Nebraska", "2024"), "`year` must be a numeric.")
  expect_error(find_team_id("Nebraska", 2024, sport = "VB"), "Invalid sport entered.")
})
