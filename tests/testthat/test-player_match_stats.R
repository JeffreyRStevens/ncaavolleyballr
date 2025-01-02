suppressWarnings(final2024 <- player_match_stats(contest = "6080706"))
suppressWarnings(final2024b <- player_match_stats(contest = "6080706",
                                                  team_stats = FALSE))
suppressWarnings(hawaii2023 <- player_match_stats(contest = "4475421",
                                                  team = "Hawaii",
                                                  sport = "MVB"))

test_that("player_match_stats() works", {
  expect_equal(final2024$Louisville$Player[1],
               "Nayelis Cabello")
  expect_equal(final2024$Louisville$Assists[1],
               31)
  expect_equal(final2024b$`Penn St.`$Player[1],
               "Ava Falduto")
  expect_equal(final2024b$`Penn St.`$Assists[1],
               2)
  expect_equal(nrow(final2024$Louisville),
               14)
  expect_equal(nrow(final2024b$Louisville),
               12)
  expect_equal(nrow(hawaii2023),
               11)
  expect_error(player_match_stats(),
               "Enter valid contest ID as a character string")
  expect_error(player_match_stats(contest = 585290),
               "Enter valid contest ID as a character string")
  expect_error(player_match_stats(contest = "6080706", team = "Neb"),
               "Enter valid team name. ")
  expect_error(player_match_stats(contest = "6080706", team = "Nebraska"),
               "Enter valid team: ")
  expect_error(player_match_stats(contest = "6080706",  team_stats = 1),
               "`team_stats` must be a logical")
  expect_error(player_match_stats(contest = "6080706", sport = "VB"),
               "Enter valid sport")
})
