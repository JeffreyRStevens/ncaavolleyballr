suppressWarnings(neb2024 <- team_player_stats("585290"))
suppressWarnings(neb2023 <- team_player_stats("558878", team_stats = FALSE))

test_that("player_stats works properly", {
  # expect_silent()
  expect_equal(neb2024$Player[1],
               "Bergen Reilly")
  expect_equal(neb2024$Assists[1],
               1352)
  expect_equal(neb2023$Player[1],
               "Bergen Reilly")
  expect_equal(neb2023$Assists[1],
               1272)
  expect_equal(nrow(neb2023),
               13)
  expect_equal(nrow(neb2024),
               16)
  expect_error(team_player_stats(585290),
               "Team ID must be a character string.")
  expect_error(team_player_stats("Nebraska"),
               "Team ID was not found in the list of valid IDs.")
  expect_error(team_player_stats("558878", team_stats = 1),
               "`team_stats` must be a logical")
})
