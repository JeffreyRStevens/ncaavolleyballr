test_that("match_pbp() works", {
  skip_on_cran()
  skip_on_ci()
  # Test with known valid contest
  suppressWarnings(result <- match_pbp(contest = "6080706"))

  # Should return a data frame
  expect_true(is.data.frame(result))
  expect_s3_class(result, "data.frame")

  # Should have expected column names
  expected_cols <- c(
    "set",
    "away_team",
    "home_team",
    "score",
    "team",
    "event",
    "player",
    "description"
  )
  expect_true(all(expected_cols %in% names(result)))
  expect_equal(length(names(result)), length(expected_cols))

  # Check data types
  expect_true(is.character(result$set))
  expect_true(is.character(result$away_team))
  expect_true(is.character(result$home_team))
  expect_true(is.character(result$score))
  expect_true(is.character(result$team))
  expect_true(is.character(result$event))
  expect_true(is.character(result$player) || is.logical(result$player)) # Can be NA
  expect_true(is.character(result$description))

  # Check returned values are correct
  expect_equal(result$set[nrow(result)], "4")
  expect_equal(nrow(result), 1448)
  expect_equal(result$away_team[1], "Louisville")

  # Set numbers should be sequential starting from 1
  unique_sets <- unique(result$set)
  expect_true(all(unique_sets %in% as.character(1:8))) # Maximum 8 sets possible
  expect_equal(min(as.numeric(unique_sets)), 1)
  expect_true(length(unique_sets) >= 3 & length(unique_sets) <= 5) # Between 3-5 sets in volleyball

  # Check for expected event types
  expected_events <- c(
    "Ace",
    "Service error",
    "Serve",
    "Kill",
    "Attack",
    "Block",
    "Dig",
    "Set",
    "Reception"
  )
  found_events <- unique(result$event)

  # Should have at least some basic volleyball events
  expect_true(any(grepl("Kill|Attack", found_events)))
  expect_true(any(grepl("Serve|Ace", found_events)))

  # Events should not contain filtered entries
  filtered_events <- c(
    "Match started",
    "Set started",
    "Media timeout",
    "Set ended",
    "Match ended"
  )
  expect_true(all(!found_events %in% filtered_events))

  # Should not contain substitution events
  expect_false(any(grepl("^Sub", found_events)))

  # Should not contain team events
  expect_false(any(grepl("^Team", found_events)))

  # Should not contain "End of" events
  expect_false(any(grepl("^End of", found_events)))
})

test_that("match_pbp() errors trigger correctly", {
  expect_error(match_pbp(), "Enter valid contest ID as a character string")
  expect_error(
    match_pbp(contest = 585290),
    "Enter valid contest ID as a character string"
  )
})

test_that("match_pbp() warnings trigger correctly", {
  skip_on_cran()
  skip_on_ci()
  expect_warning(
    match_pbp(contest = "5675914"),
    "Set information not available for contest 5675914"
  )
  expect_warning(
    match_pbp(contest = "5669768"),
    "Set information not available for contest"
  )
})
