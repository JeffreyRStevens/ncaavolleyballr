test_that("find_team_id() works", {
  skip_on_cran()
  skip_on_ci()
  expect_equal(find_team_id(team = "Nebraska", year = 2024), "585290")
  expect_equal(
    find_team_id(team = "Nebraska", year = 2023:2024),
    c("558878", "585290")
  )
  expect_equal(
    find_team_id(team = c("Nebraska", "Wisconsin"), year = 2024),
    c("585290", "585357")
  )
  expect_equal(find_team_id(team = "UCLA", year = 2023, "MVB"), "573670")
})

test_that("find_team_id() errors trigger correctly", {
  # Test team parameter validation
  expect_error(find_team_id(), "Enter valid team name.")
  expect_error(find_team_id(team = NULL), "Enter valid team name")
  expect_error(find_team_id(team = ""), "Enter valid team name")
  expect_error(find_team_id(team = 123), "Enter valid team name")
  expect_error(find_team_id(team = c()), "Enter valid team name")
  expect_error(
    find_team_id(team = "Invalid Team Name"),
    "Enter valid team name"
  )
  expect_error(
    find_team_id(team = "UNL", year = 2024),
    "Enter valid team name."
  )

  # Test year parameter validation
  expect_error(
    find_team_id(team = "Nebraska"),
    "Enter valid year between 2020-"
  )
  expect_error(
    find_team_id(team = "Nebraska", year = NULL),
    "Enter valid year between 2020-"
  )
  expect_error(
    find_team_id(team = "Nebraska", year = 2019),
    "Enter valid year between 2020-"
  )
  expect_error(
    find_team_id(team = "Nebraska", year = 2030),
    "Enter valid year between 2020-"
  )
  expect_error(
    find_team_id(team = "Nebraska", year = "2024"),
    "Enter valid year between 2020-"
  )
  expect_error(
    find_team_id(team = "Nebraska", year = c(2019, 2024)),
    "Enter valid year between 2020-"
  )

  # Test sport parameter validation
  expect_error(
    find_team_id(team = "Nebraska", year = 2024, sport = "VB"),
    "Enter valid sport"
  )
  expect_error(
    find_team_id(team = "Nebraska", year = 2024, sport = "WVB1"),
    "Enter valid sport"
  )
  expect_error(
    find_team_id(team = "Nebraska", year = 2024, sport = 123),
    "Enter valid sport as a three-letter character string"
  )
  expect_error(
    find_team_id(team = "Nebraska", year = 2024, sport = NULL),
    "Enter valid `sport`"
  )
  expect_error(
    find_team_id(team = "Nebraska", year = 2024, sport = c("WVB", "MVB")),
    "Enter single value for `sport`"
  )
})
