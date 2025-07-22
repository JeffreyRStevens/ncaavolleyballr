test_that("team_match_stats() works", {
  skip_on_cran()
  skip_on_ci()
  chromote::local_chrome_version("system", quiet = TRUE)
  expect_silent(neb2024 <- team_match_stats(team_id = "585290"))
  expect_equal(nrow(neb2024), 36)
  expect_equal(ncol(neb2024), 21)
  expect_equal(neb2024[neb2024$Date == "08/27/2024", ]$Kills, 47)
})

test_that("team_match_stats() errors trigger correctly", {
  expect_error(
    team_match_stats(team_id = 585290),
    "Enter valid team ID as a character string"
  )
  expect_error(team_match_stats(team_id = "Nebraska"), "Enter valid team ID. ")
  expect_error(
    team_match_stats(team_id = "585290", sport = "VB"),
    "Enter valid sport"
  )
})
