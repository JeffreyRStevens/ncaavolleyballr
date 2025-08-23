test_that("group_stats() works at team season level", {
  skip_on_cran()
  skip_on_ci()
  expect_equal(
    group_stats(
      teams = c("Nebraska", "UCLA"),
      level = "teamseason",
      year = 2020
    )$playerdata$Player[1],
    "Nicklin Hames"
  )
  expect_equal(
    group_stats(
      teams = "UCLA",
      year = 2020,
      level = "teamseason",
      sport = "MVB"
    )$playerdata$Player[1],
    "Kyle Vom Steeg"
  )
})

test_that("group_stats() works at team match level", {
  skip_on_cran()
  skip_on_ci()
  expect_equal(
    group_stats(teams = "Nebraska", year = 2020, level = "teammatch")$Opponent[
      1
    ],
    "@ Indiana"
  )
})

test_that("group_stats() works at player match level", {
  skip_on_cran()
  skip_on_ci()
  expect_equal(
    group_stats(teams = "Nebraska", year = 2020, level = "match")$Player[1],
    "Keonilei Akana"
  )
})

test_that("group_stats() works at pbp level", {
  skip_on_cran()
  skip_on_ci()
  expect_equal(
    group_stats(teams = "Nebraska", year = 2020, level = "pbp")$home_team[1],
    "Indiana"
  )
})

test_that("group_stats() errors trigger correctly", {
  # Test teams parameter validation
  expect_error(group_stats(), "Enter valid team name")
  expect_error(group_stats(teams = NULL), "Enter valid team name")
  expect_error(group_stats(teams = 123), "Enter valid team name")
  expect_error(
    group_stats(teams = c("Invalid Team", "Another Invalid")),
    "Enter valid team name"
  )

  # Test year parameter validation
  expect_error(
    group_stats(teams = "Nebraska"),
    "Enter valid year between 2020-"
  )
  expect_error(
    group_stats(teams = "Nebraska", year = NULL),
    "Enter valid year between 2020-"
  )
  expect_error(
    group_stats(teams = "Nebraska", year = 2019),
    "Enter valid year between 2020-"
  )
  expect_error(
    group_stats(teams = "Nebraska", year = 2030),
    "Enter valid year between 2020-"
  )
  expect_error(
    group_stats(teams = "Nebraska", year = "2024"),
    "Enter valid year between 2020-"
  )
  expect_error(
    group_stats(teams = "Nebraska", year = c(2019, 2024)),
    "Enter valid year between 2020-"
  )

  # Test level parameter validation
  expect_error(
    group_stats(teams = "Nebraska", year = 2024, level = "invalid"),
    "Enter valid level:"
  )
  expect_error(
    group_stats(teams = "Nebraska", year = 2024, level = c("season", "match")),
    "Enter single value for level"
  )
  expect_error(
    group_stats(teams = "Nebraska", year = 2024, level = 123),
    "Enter valid level:"
  )
  expect_error(
    group_stats(teams = "Nebraska", year = 2024, level = NULL),
    "Enter valid level"
  )

  # Test unique parameter validation
  expect_error(
    group_stats(teams = "Nebraska", year = 2024, unique = "TRUE"),
    "`unique` must be a logical"
  )
  expect_error(
    group_stats(teams = "Nebraska", year = 2024, unique = 1),
    "`unique` must be a logical"
  )
  expect_error(
    group_stats(teams = "Nebraska", year = 2024, unique = NULL),
    "Enter valid `unique` value"
  )

  # Test sport parameter validation
  expect_error(
    group_stats(teams = "Nebraska", year = 2024, sport = "VB"),
    "Enter valid sport"
  )
  expect_error(
    group_stats(teams = "Nebraska", year = 2024, sport = "WVB1"),
    "Enter valid sport"
  )
  expect_error(
    group_stats(teams = "Nebraska", year = 2024, sport = 123),
    "Enter valid sport as a three-letter character string"
  )
  expect_error(
    group_stats(teams = "Nebraska", year = 2024, sport = NULL),
    "Enter valid `sport`"
  )
})
