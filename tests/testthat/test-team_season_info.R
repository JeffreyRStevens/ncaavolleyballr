test_that("team_season_info() works", {
  skip_on_cran()
  skip_on_ci()
  expect_silent(neb2024 <- team_season_info(team_id = "585290"))
  names(neb2024$record) <- NULL
  expect_equal(neb2024$record[1],
               "33-3 (0.917)")
})

test_that("team_season_info() errors trigger correctly", {
  expect_error(team_season_info(team_id = 585290),
               "Enter valid team ID as a character string")
  expect_error(team_season_info(team_id = "Nebraska"),
               "Enter valid team ID. ")
})
