test_that("team_season works properly", {
  expect_silent(neb2024 <- team_season("585290"))
  names(neb2024$record) <- NULL
  expect_equal(neb2024$record[1], "33-3 (0.917)")
  expect_error(team_season(585290), "Team ID must be a character string.")
  expect_error(team_season("Nebraska"), "Team ID was not found in the list of valid IDs.")
})
