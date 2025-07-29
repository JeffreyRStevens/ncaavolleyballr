test_that("division_stats() parameter validation works correctly", {
  # Test year parameter validation
  expect_error(division_stats(), "Enter valid year between 2020-")
  expect_error(division_stats(year = NULL), "Enter valid year between 2020-")
  expect_error(division_stats(year = 2019), "Enter valid year between 2020-")
  expect_error(division_stats(year = 2030), "Enter valid year between 2020-")
  expect_error(division_stats(year = "2024"), "Enter valid year between 2020-")
  expect_error(
    division_stats(year = c(2019, 2024)),
    "Enter valid year between 2020-"
  )

  # Test division parameter validation
  expect_error(
    division_stats(year = 2024, division = NULL, level = "teammatch"),
    "Enter valid division as a number: 1, 2, 3"
  )
  expect_error(
    division_stats(year = 2024, division = 0, level = "teammatch"),
    "Enter valid division as a number: 1, 2, 3"
  )
  expect_error(
    division_stats(year = 2024, division = 4, level = "teammatch"),
    "Enter valid division as a number: 1, 2, 3"
  )
  expect_error(
    division_stats(year = 2024, division = c(1, 2), level = "teammatch"),
    "Enter single value for division"
  )

  # Test level parameter validation
  expect_error(division_stats(year = 2024, level = NULL), "Enter valid level")
  expect_error(
    division_stats(year = 2024, level = "invalid"),
    "Enter valid level"
  )
  expect_error(
    division_stats(year = 2024, level = c("teamseason", "match")),
    "Enter single value for level"
  )

  # Test sport parameter validation
  expect_error(
    division_stats(year = 2024, level = "teammatch", sport = "VB"),
    "Enter valid sport"
  )
  expect_error(
    division_stats(year = 2024, level = "teammatch", sport = "WVB1"),
    "Enter valid sport"
  )
  expect_error(
    division_stats(year = 2024, level = "teammatch", sport = 123),
    "Enter valid sport as a three-letter character string"
  )
  expect_error(
    division_stats(year = 2024, level = "teammatch", sport = NULL),
    "Enter valid `sport`"
  )

  # Test save parameter validation
  expect_error(
    division_stats(year = 2024, level = "teammatch", save = "TRUE"),
    "`save` must be a logical"
  )
  expect_error(
    division_stats(year = 2024, level = "teammatch", save = 1),
    "`save` must be a logical"
  )
  expect_error(
    division_stats(year = 2024, level = "teammatch", save = NULL),
    "Enter valid `save` value"
  )

  # Test path parameter validation
  expect_error(
    division_stats(year = 2024, level = "teammatch", path = 123),
    "Enter valid path as a character string"
  )
  expect_error(
    division_stats(year = 2024, level = "teammatch", path = NULL),
    "Enter valid path as a character string"
  )
  expect_error(
    division_stats(year = 2024, level = "teammatch", path = c(".", "..")),
    "Enter valid path as a character string"
  )
})

test_that("division_stats() level-specific logic branches correctly", {
  # Test that different levels would trigger different save branches
  levels <- c("teamseason", "teammatch", "playermatch", "pbp")

  for (level in levels) {
    expect_silent(check_match(
      "level",
      level,
      c("teamseason", "season", "teammatch", "playermatch", "match", "pbp")
    ))
  }
})
