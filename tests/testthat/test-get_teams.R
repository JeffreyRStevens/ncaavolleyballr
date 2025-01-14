test_that("get_teams() errors trigger correctly", {
  expect_error(get_teams(),
               "Enter valid year between 2020-")
  expect_error(get_teams(year = "xxx"),
               "Enter valid year between 2020-")
  expect_error(get_teams(year = 1999),
               "Enter valid year between 2020-")
  expect_error(get_teams(year = 2024, division = 4),
               "Enter valid division")
  expect_error(get_teams(year = 2024, sport = 1),
               "Enter valid sport as a three-letter character string.")
  expect_error(get_teams(year = 2024, sport = "xxx"),
               "Enter valid sport code from `ncaa_sports`")
})
