test_that("team_season_stats() works", {
  skip_on_cran()
  skip_on_ci()
  expect_silent(nebseasons <- team_season_stats(team = "Nebraska"))

  # Should return a data frame
  expect_true(is.data.frame(nebseasons))
  expect_s3_class(nebseasons, "data.frame")

  # Should have expected dimensions and column names
  expect_equal(nrow(nebseasons), 6)
  expect_equal(ncol(nebseasons), 24)
  expected_cols <- c("Season", "Team", "Conference", "S")
  expect_true(all(expected_cols %in% names(nebseasons)))
  expect_true(length(names(nebseasons)) >= length(expected_cols))

  # Check returned value
  expect_equal(nebseasons[nebseasons$Season == "2020-21", ]$S, 66)
})

test_that("team_season_stats() errors trigger correctly", {
  # Test team parameter validation
  expect_error(team_season_stats(), "Enter valid team name")
  expect_error(team_season_stats(team = NULL), "Enter valid team name")
  expect_error(team_season_stats(team = NA), "Enter valid team name")
  expect_error(team_season_stats(team = 123), "Enter valid team name")
  expect_error(team_season_stats(team = TRUE), "Enter valid team name")
  expect_error(team_season_stats(team = ""), "Enter valid team name")
  expect_error(team_season_stats(team = "InvalidTeam"), "Enter valid team name")
  expect_error(team_season_stats(team = "UNL"), "Enter valid team name")

  # Test opponent parameter validation
  expect_error(
    team_season_stats(team = "Nebraska", opponent = "TRUE"),
    "`opponent` must be a logical"
  )
  expect_error(
    team_season_stats(team = "Nebraska", opponent = 1),
    "`opponent` must be a logical"
  )
  expect_error(
    team_season_stats(team = "Nebraska", opponent = NA),
    "missing value where TRUE/FALSE needed"
  )
  expect_error(
    team_season_stats(team = "Nebraska", opponent = c(TRUE, FALSE)),
    "Enter single value for `opponent`"
  )

  # Test sport parameter validation
  expect_error(
    team_season_stats(team = "Nebraska", sport = "VB"),
    "Enter valid sport"
  )
  expect_error(
    team_season_stats(team = "Nebraska", sport = "volleyball"),
    "Enter valid sport"
  )
  expect_error(
    team_season_stats(team = "Nebraska", sport = c("WVB", "MVB")),
    "Enter single value for `sport`"
  )
  expect_error(
    team_season_stats(team = "Nebraska", sport = NA),
    "Enter valid sport"
  )
})

test_that("team_season_stats() warnings trigger correctly", {
  expect_warning(
    team_season_stats(team = "Georgetown"),
    "No season stats available"
  )
})
