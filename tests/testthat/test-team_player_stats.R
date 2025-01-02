suppressWarnings(neb2024 <- team_player_stats(team_id = "585290"))
suppressWarnings(neb2023 <- team_player_stats(team_id = "558878",
                                              team_stats = FALSE))

test_that("team_player_stats() works", {
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
  expect_error(team_player_stats(team_id = 585290),
               "Enter valid team ID as a character string")
  expect_error(team_player_stats(team_id = "Nebraska"),
               "Enter valid team ID. ")
  expect_error(team_player_stats(team_id = "558878", team_stats = 1),
               "`team_stats` must be a logical")
})
