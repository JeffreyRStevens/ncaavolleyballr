test_that("team_match_stats() works", {
  skip_on_cran()
  skip_on_ci()
  chromote::local_chrome_version("system", quiet = TRUE)
  expect_silent(neb2020 <- team_match_stats(team_id = "504517"))
  # Should return a data frame
  expect_true(is.data.frame(neb2020))
  expect_s3_class(neb2020, "data.frame")

  # Should have expected dimensions and column names
  expect_equal(nrow(neb2020), 25)
  expect_equal(ncol(neb2020), 24)
  expected_cols <- c(
    "Season",
    "Date",
    "Team",
    "Conference",
    "Opponent",
    "Result",
    "S"
  )
  expect_true(all(expected_cols %in% names(neb2020)))
  expect_true(length(names(neb2020)) >= length(expected_cols))

  # Check returned values
  expect_equal(neb2020[neb2020$Date == "04/19/2021", ]$Kills, 44)
})

test_that("team_match_stats() errors trigger correctly", {
  # Test team_id parameter validation
  expect_error(team_match_stats(), "Enter valid team ID as a character string")
  expect_error(
    team_match_stats(team_id = NULL),
    "Enter valid team ID as a character string"
  )
  expect_error(
    team_match_stats(team_id = NA),
    "Enter valid team ID as a character string"
  )
  expect_error(
    team_match_stats(team_id = 585290),
    "Enter valid team ID as a character string"
  )
  expect_error(
    team_match_stats(team_id = TRUE),
    "Enter valid team ID as a character string"
  )
  expect_error(team_match_stats(team_id = ""), "Enter valid team ID.")
  expect_error(team_match_stats(team_id = "Nebraska"), "Enter valid team ID")
  expect_error(team_match_stats(team_id = "abc123"), "Enter valid team ID")
  expect_error(team_match_stats(team_id = "12345"), "Enter valid team ID")

  # Test sport parameter validation
  expect_error(
    team_match_stats(team_id = "585290", sport = "VB"),
    "Enter valid sport"
  )
  expect_error(
    team_match_stats(team_id = "585290", sport = "volleyball"),
    "Enter valid sport"
  )
  expect_error(
    team_match_stats(team_id = "585290", sport = c("WVB", "MVB")),
    "Enter single value for `sport`"
  )
  expect_error(
    team_match_stats(team_id = "585290", sport = NA),
    "Enter valid sport"
  )
})
