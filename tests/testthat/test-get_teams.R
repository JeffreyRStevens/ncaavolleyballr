test_that("get_teams() errors trigger correctly", {
  # Test year parameter validation
  expect_error(get_teams(), "Enter valid year between 2020-")
  expect_error(get_teams(year = NULL), "Enter valid year between 2020-")
  expect_error(get_teams(year = "2024"), "Enter valid year between 2020-")
  expect_error(get_teams(year = TRUE), "Enter valid year between 2020-")
  expect_error(get_teams(year = 1999), "Enter valid year between 2020-")
  expect_error(get_teams(year = 2030), "Enter valid year between 2020-")
  expect_error(
    get_teams(year = c(2019, 2024)),
    "Enter valid year between 2020-"
  )

  # Test division parameter validation
  expect_error(get_teams(year = 2024, division = NULL), "Enter valid division")
  expect_error(get_teams(year = 2024, division = 0), "Enter valid division")
  expect_error(get_teams(year = 2024, division = 4), "Enter valid division")
  expect_error(
    get_teams(year = 2024, division = c(1, 2)),
    "Enter single value for division"
  )

  # Test sport parameter validation
  expect_error(get_teams(year = 2024, sport = NULL), "Enter valid `sport`")
  expect_error(
    get_teams(year = 2024, sport = 123),
    "Enter valid sport as a three-letter character string"
  )
  expect_error(
    get_teams(year = 2024, sport = TRUE),
    "Enter valid sport as a three-letter character string"
  )
  expect_error(
    get_teams(year = 2024, sport = "volleyball"),
    "Enter valid sport code from `ncaa_sports`"
  )
  expect_error(
    get_teams(year = 2024, sport = "XXX"),
    "Enter valid sport code from `ncaa_sports`"
  )
  expect_error(
    get_teams(year = 2024, sport = "wvb"),
    "Enter valid sport code from `ncaa_sports`"
  )
  expect_error(
    get_teams(year = 2024, sport = c("WVB", "MVB")),
    "Enter single value for `sport`"
  )
})
