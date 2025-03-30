
test_that("player_match_stats() works", {
  skip_on_cran()
  skip_on_ci()
  suppressWarnings(final2024 <- player_match_stats(contest = "6080706"))
  suppressWarnings(final2024b <- player_match_stats(contest = "6080706",
                                                    team_stats = FALSE))
  suppressWarnings(hawaii2023 <- player_match_stats(contest = "4475421",
                                                    team = "Hawaii",
                                                    sport = "MVB"))
  expect_equal(final2024$Player[1],
               "Nayelis Cabello")
  expect_equal(final2024$Assists[1],
               31)
  expect_equal(nrow(final2024),
               26)
  expect_equal(nrow(final2024b),
               22)
  expect_equal(nrow(hawaii2023),
               11)
})

test_that("player_match_stats() errors trigger correctly", {
  expect_error(player_match_stats(),
               "Enter valid contest ID as a character string")
  expect_error(player_match_stats(contest = 585290),
               "Enter valid contest ID as a character string")
  expect_error(player_match_stats(contest = "6080706", team = "Neb"),
               "Enter valid team name. ")
  expect_error(player_match_stats(contest = "6080706",  team_stats = 1),
               "`team_stats` must be a logical")
  expect_error(player_match_stats(contest = "6080706", sport = "VB"),
               "Enter valid sport")
})

test_that("player_match_stats() errors trigger correctly when internet is required", {
  skip_on_cran()
  skip_on_ci()
  expect_error(player_match_stats(contest = "6080706", team = "Nebraska"),
               "Enter valid team for contest ")
})

test_that("player_match_stats() warnings trigger correctly", {
  skip_on_cran()
  skip_on_ci()
  expect_warning(player_match_stats(contest = "5675914", team = "Franklin"),
                 "No website available for contest")
})
