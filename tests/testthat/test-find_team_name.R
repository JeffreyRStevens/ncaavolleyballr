test_that("find_team_name() works", {
  skip_on_cran()
  skip_on_ci()
  expect_equal(find_team_name(pattern = "Neb")[1], "Neb. Wesleyan")
})

test_that("find_team_name() accepts valid patterns", {
  # Test valid character string patterns
  expect_silent(find_team_name(pattern = "Neb"))
  expect_silent(find_team_name(pattern = "UCLA"))
  expect_silent(find_team_name(pattern = "State"))
  expect_silent(find_team_name(pattern = "")) # Empty string should be valid
  expect_silent(find_team_name(pattern = " ")) # Whitespace should be valid
  expect_silent(find_team_name(pattern = "123")) # Numeric string should be valid
  expect_silent(find_team_name(pattern = "Team-Name")) # Special characters should be valid
})

test_that("find_team_name() errors trigger correctly", {
  expect_error(find_team_name(), "Enter valid pattern as a character string")
  expect_error(
    find_team_name(pattern = NULL),
    "Enter valid pattern as a character string"
  )
  expect_error(
    find_team_name(pattern = 123),
    "Enter valid pattern as a character string"
  )
  expect_error(
    find_team_name(pattern = TRUE),
    "Enter valid pattern as a character string"
  )
  expect_error(
    find_team_name(pattern = list("Neb")),
    "Enter valid pattern as a character string"
  )
})
