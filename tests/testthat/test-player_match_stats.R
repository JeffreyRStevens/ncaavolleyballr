test_that("player_match_stats() works", {
  skip_on_cran()
  skip_on_ci()
  suppressWarnings(final2024 <- player_match_stats(contest = "6080706"))
  suppressWarnings(
    final2024b <- player_match_stats(contest = "6080706", team_stats = FALSE)
  )
  suppressWarnings(
    hawaii2023 <- player_match_stats(
      contest = "4475421",
      team = "Hawaii",
      sport = "MVB"
    )
  )
  # Should return a data frame
  expect_true(is.data.frame(final2024))
  expect_s3_class(final2024, "data.frame")

  # Should have expected dimensions and column names
  expect_equal(nrow(final2024), 26)
  expect_equal(ncol(final2024), 26)
  expected_cols <- c(
    "Season",
    "Date",
    "Team",
    "Conference",
    "Opponent Team",
    "Opponent Conference",
    "Location",
    "Number",
    "Player"
  )
  expect_true(all(expected_cols %in% names(final2024)))
  expect_true(length(names(final2024)) >= length(expected_cols))

  expect_equal(final2024$Player[1], "Nayelis Cabello")
  expect_equal(final2024$Assists[1], 31)
  expect_equal(nrow(final2024), 26)
  expect_equal(nrow(final2024b), 22)
  expect_equal(nrow(hawaii2023), 11)
})

test_that("player_match_stats() errors trigger correctly", {
  # Test contest parameter validation
  expect_error(
    player_match_stats(),
    "Enter valid contest ID as a character string"
  )
  expect_error(
    player_match_stats(contest = NULL),
    "Enter valid contest ID as a character string"
  )
  expect_error(
    player_match_stats(contest = NA),
    "Enter valid contest ID as a character string"
  )
  expect_error(
    player_match_stats(contest = 123456),
    "Enter valid contest ID as a character string"
  )
  expect_error(
    player_match_stats(contest = TRUE),
    "Enter valid contest ID as a character string"
  )
  expect_warning(
    player_match_stats(contest = ""),
    "No website available for contest"
  )

  # Test team_stats parameter validation
  expect_error(
    player_match_stats(contest = "6080706", team_stats = "TRUE"),
    "`team_stats` must be a logical"
  )
  expect_error(
    player_match_stats(contest = "6080706", team_stats = 1),
    "`team_stats` must be a logical"
  )
  expect_error(
    player_match_stats(contest = "6080706", team_stats = NA),
    "missing value where TRUE/FALSE needed"
  )
  expect_error(
    player_match_stats(contest = "6080706", team_stats = c(TRUE, FALSE)),
    "Enter single value for `team_stats`"
  )

  # Test sport parameter validation
  expect_error(
    player_match_stats(contest = "6080706", sport = "VB"),
    "Enter valid sport"
  )
  expect_error(
    player_match_stats(contest = "6080706", sport = "volleyball"),
    "Enter valid sport"
  )
  expect_error(
    player_match_stats(contest = "6080706", sport = c("WVB", "MVB")),
    "Enter single value for `sport`"
  )
  expect_error(
    player_match_stats(contest = "6080706", sport = NA),
    "Enter valid sport"
  )
})

test_that("player_match_stats() errors trigger correctly when internet is required", {
  skip_on_cran()
  skip_on_ci()
  expect_error(
    player_match_stats(contest = "6080706", team = "InvalidTeam"),
    "Enter valid team name"
  )
  expect_error(
    player_match_stats(contest = "6080706", team = "Nebraska"),
    "Enter valid team for contest"
  )
  expect_error(
    player_match_stats(contest = "6080706", team = c("Texas", "Penn State")),
    "Enter valid team name"
  )
})

test_that("player_match_stats() warnings trigger correctly", {
  skip_on_cran()
  skip_on_ci()
  expect_warning(
    player_match_stats(contest = "abc123"),
    "No website available for contest abc123"
  )
  expect_warning(
    player_match_stats(contest = "5675914", team = "Franklin"),
    "No website available for contest"
  )
})
