test_that("team_season_info() works", {
  skip_on_cran()
  skip_on_ci()
  expect_silent(neb2020 <- team_season_info(team_id = "504517"))
  names(neb2020$record) <- NULL
  # Should return a list
  expect_true(is.list(neb2020))
  expect_type(neb2020, "list")

  # Should have expected list elements
  expected_elements <- c("team_info", "arena", "coach", "record", "schedule")
  expect_true(all(expected_elements %in% names(neb2020)))
  expect_equal(length(neb2020), length(expected_elements))

  # Check returned values
  expect_equal(neb2020$record[1], "16-3 (0.842)")
})

test_that("team_season_info() errors trigger correctly", {
  # Test team_id parameter validation
  expect_error(team_season_info(), "Enter valid team ID as a character string")
  expect_error(
    team_season_info(team_id = NULL),
    "Enter valid team ID as a character string"
  )
  expect_error(
    team_season_info(team_id = NA),
    "Enter valid team ID as a character string"
  )
  expect_error(
    team_season_info(team_id = 585290),
    "Enter valid team ID as a character string"
  )
  expect_error(
    team_season_info(team_id = TRUE),
    "Enter valid team ID as a character string"
  )
  expect_error(team_season_info(team_id = ""), "Enter valid team ID")
  expect_error(team_season_info(team_id = "Nebraska"), "Enter valid team ID")
  expect_error(team_season_info(team_id = "12345"), "Enter valid team ID")
  expect_error(team_season_info(team_id = "abcdef"), "Enter valid team ID")
})
