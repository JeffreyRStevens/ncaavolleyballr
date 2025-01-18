test_that("conference_stats() errors trigger correctly", {
  expect_error(conference_stats(),
               "Enter valid year between 2020-")
  expect_error(conference_stats(year = 2002),
               "Enter valid year between 2020-")
  expect_error(conference_stats(year = "2024"),
               "Enter valid year between 2020-")
  expect_error(conference_stats(year = 2024, level = "season"),
               "Enter valid conference.")
  expect_error(conference_stats(year = 2024, conf = "Big Conf",
                                level = "season", sport = "MVB"),
               "Enter valid conference.")
  expect_error(group_stats(teams = "Nebraska", year = 2024, level = "xxx"),
               "Enter valid level")
  expect_error(conference_stats(year = 2024, conf = "Big Ten",
                                level = "season", sport = "VB"),
               "Enter valid sport")
  expect_error(conference_stats(year = 2024, conf = "Big Ten",
                                level = "season", save = "TRUE"),
               "`save` must be a logical")
  expect_error(conference_stats(year = 2024, conf = "Big Ten",
                                level = "season", path = 3),
               "Enter valid path as a character string")
})
