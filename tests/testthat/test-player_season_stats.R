test_that("player_season_stats() works", {
  skip_on_cran()
  skip_on_ci()
  suppressWarnings(neb2020 <- player_season_stats(team_id = "504517"))
  suppressWarnings(
    neb2020b <- player_season_stats(team_id = "504517", team_stats = FALSE)
  )
  # Should return a data frame
  expect_true(is.data.frame(neb2020))
  expect_s3_class(neb2020, "data.frame")

  # Should have expected dimensions and column names
  expect_equal(nrow(neb2020), 17)
  expect_equal(ncol(neb2020), 29)
  expected_cols <- c("Season", "Team", "Conference", "Number", "Player")
  expect_true(all(expected_cols %in% names(neb2020)))
  expect_true(length(names(neb2020)) >= length(expected_cols))

  # Check returned values
  expect_equal(neb2020$Player[1], "Nicklin Hames")
  expect_equal(neb2020$Assists[1], 720)
  expect_equal(neb2020b$Player[1], "Nicklin Hames")
  expect_equal(neb2020b$Assists[1], 720)
  expect_equal(nrow(neb2020b), 14)
  expect_equal(nrow(neb2020), 17)
})

test_that("player_season_stats() errors trigger correctly", {
  # Test team_id parameter validation
  expect_error(
    player_season_stats(),
    'argument "team_id" is missing, with no default'
  )
  expect_error(
    player_season_stats(team_id = NULL),
    "Enter valid team ID as a character string"
  )
  expect_error(
    player_season_stats(team_id = NA),
    "Enter valid team ID as a character string"
  )
  expect_error(
    player_season_stats(team_id = 585290),
    "Enter valid team ID as a character string"
  )
  expect_error(
    player_season_stats(team_id = TRUE),
    "Enter valid team ID as a character string"
  )
  expect_error(player_season_stats(team_id = ""), "Enter valid team ID")
  expect_error(player_season_stats(team_id = "Nebraska"), "Enter valid team ID")
  expect_error(player_season_stats(team_id = "12345"), "Enter valid team ID")
  expect_error(player_season_stats(team_id = "abcdef"), "Enter valid team ID")

  # Test team_stats parameter validation
  expect_error(
    player_season_stats(team_id = "585290", team_stats = 1),
    "`team_stats` must be a logical"
  )
  expect_error(
    player_season_stats(team_id = "585290", team_stats = "TRUE"),
    "`team_stats` must be a logical"
  )
  expect_error(
    player_season_stats(team_id = "585290", team_stats = NA),
    "Enter valid value"
  )
  expect_error(
    player_season_stats(team_id = "585290", team_stats = c(TRUE, FALSE)),
    "Enter single value for `team_stats`"
  )
})

test_that("player_season_stats() warnings trigger correctly", {
  skip_on_cran()
  skip_on_ci()
  expect_warning(
    player_season_stats(team_id = find_team_id("Vanderbilt", 2024)),
    "No 2024 season stats available for Vanderbilt"
  )
  expect_warning(
    player_season_stats(team_id = find_team_id("Saint Augustine's", 2024)),
    "No 2024 season stats available for Saint Augustine's"
  )
})
