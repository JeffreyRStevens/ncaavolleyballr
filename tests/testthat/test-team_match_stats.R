test_that("team_match_stats() works", {
  skip_on_cran()
  skip_on_ci()
  chromote::local_chrome_version("system", quiet = TRUE)
  expect_silent(neb2024 <- team_match_stats(team_id = "585290"))
  # Should return a data frame
  expect_true(is.data.frame(neb2024))
  expect_s3_class(neb2024, "data.frame")

  # Should have expected column names
  expected_cols <- c(
    "Season",
    "Date",
    "Team",
    "Conference",
    "Opponent",
    "Result",
    "S"
  )
  expect_true(all(expected_cols %in% names(neb2024)))
  expect_true(length(names(neb2024)) >= length(expected_cols))

  # Check returned values
  expect_equal(nrow(neb2024), 36)
  expect_equal(ncol(neb2024), 22)
  expect_equal(neb2024[neb2024$Date == "08/27/2024", ]$Kills, 47)
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
