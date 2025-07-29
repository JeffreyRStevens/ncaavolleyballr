test_that("player_season_stats() works", {
  skip_on_cran()
  skip_on_ci()
  suppressWarnings(neb2024 <- player_season_stats(team_id = "585290"))
  suppressWarnings(
    neb2023 <- player_season_stats(team_id = "558878", team_stats = FALSE)
  )
  # Should return a data frame
  expect_true(is.data.frame(neb2024))
  expect_s3_class(neb2024, "data.frame")

  # Should have expected column names
  expected_cols <- c("Season", "Team", "Conference", "Number", "Player")
  expect_true(all(expected_cols %in% names(neb2024)))
  expect_true(length(names(neb2024)) >= length(expected_cols))

  # Check returned values
  expect_equal(neb2024$Player[1], "Bergen Reilly")
  expect_equal(neb2024$Assists[1], 1352)
  expect_equal(neb2023$Player[1], "Bergen Reilly")
  expect_equal(neb2023$Assists[1], 1272)
  expect_equal(nrow(neb2023), 13)
  expect_equal(nrow(neb2024), 16)
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
    "missing value where TRUE/FALSE needed"
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
    "No website available for team ID 598395"
  )
  expect_warning(
    player_season_stats(team_id = find_team_id("Saint Augustine's", 2024)),
    "No 2024 season stats available for Saint Augustine's"
  )
})
