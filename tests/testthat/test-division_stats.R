test_that("division_stats() errors trigger correctly", {
  expect_error(division_stats(division = 2002),
               "Enter valid division as a number: 1, 2, 3")
  expect_error(division_stats(),
               "Enter valid year between 2020-")
  expect_error(division_stats(year = 2002, sport = "MVB"),
               "Enter valid year between 2020-")
  expect_error(division_stats(year = "2024"),
               "Enter valid year between 2020-")
  expect_error(division_stats(year = 2024, level = "xxx"),
               "Enter valid level:")
  expect_error(division_stats(year = 2024, level = "season", sport = "VB"),
               "Enter valid sport")
  expect_error(division_stats(year = 2024, level = "season", save = "TRUE"),
               "`save` must be a logical")
  expect_error(division_stats(year = 2024, level = "season", path = 3),
               "Enter valid path as a character string")
})
