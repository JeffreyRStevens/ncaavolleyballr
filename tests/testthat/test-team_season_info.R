test_that("team_season_info() works", {
  skip_on_cran()
  skip_on_ci()
  expect_silent(neb2024 <- team_season_info(team_id = "585290"))
  names(neb2024$record) <- NULL
  # Should return a list
  expect_true(is.list(neb2024))
  expect_type(neb2024, "list")

  # Should have expected list elements
  expected_elements <- c("team_info", "arena", "coach", "record", "schedule")
  expect_true(all(expected_elements %in% names(neb2024)))
  expect_equal(length(neb2024), length(expected_elements))

  # Check returned values
  expect_equal(neb2024$record[1], "33-3 (0.917)")
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
