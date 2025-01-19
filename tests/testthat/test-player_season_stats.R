
test_that("player_season_stats() works", {
  skip_on_cran()
  skip_on_ci()
  suppressWarnings(neb2024 <- player_season_stats(team_id = "585290"))
  suppressWarnings(neb2023 <- player_season_stats(team_id = "558878",
                                                  team_stats = FALSE))
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
})

test_that("player_season_stats() errors trigger correctly", {
  expect_error(player_season_stats(team_id = 585290),
               "Enter valid team ID as a character string")
  expect_error(player_season_stats(team_id = "Nebraska"),
               "Enter valid team ID. ")
  expect_error(player_season_stats(team_id = "558878", team_stats = 1),
               "`team_stats` must be a logical")
})

test_that("player_season_stats() warnings trigger correctly", {
  skip_on_cran()
  expect_warning(player_season_stats(team_id =
                                       find_team_id("Vanderbilt", 2024)),
                 "No 2024 season stats available for Vanderbilt")
  expect_warning(player_season_stats(team_id =
                                       find_team_id("Saint Augustine's", 2024)),
                 "No 2024 season stats available for Saint Augustine's")
})
