test_that("team_season_stats() works", {
  skip_on_cran()
  expect_silent(neb2024 <- team_season_stats(team_id = "585290"))
  names(neb2024$record) <- NULL
  expect_equal(neb2024$record[1],
               "33-3 (0.917)")
})

test_that("team_season_stats() errors trigger correctly", {
  expect_error(team_season_stats(team_id = 585290),
               "Enter valid team ID as a character string")
  expect_error(team_season_stats(team_id = "Nebraska"),
               "Enter valid team ID. ")
})
