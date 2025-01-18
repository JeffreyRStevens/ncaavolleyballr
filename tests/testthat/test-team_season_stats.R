test_that("team_season_stats() works", {
  skip_on_cran()
  skip_on_ci()
  expect_silent(nebseasons <- team_season_stats(team = "Nebraska"))
  expect_equal(nebseasons[nebseasons$Year == "2001-02", ]$S,
               108)
})

test_that("team_season_stats() errors trigger correctly", {
  expect_error(team_season_stats(),
               "Enter valid team name.")
  expect_error(team_season_stats(team = "UNL"),
               "Enter valid team name.")
  expect_error(team_season_stats(team = "Nebraska", opponent = "TRUE"),
               "`opponent` must be a logical")
  expect_error(team_season_stats(team = "Nebraska", sport = "VB"),
               "Enter valid sport")
})
