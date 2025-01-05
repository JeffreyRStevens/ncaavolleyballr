suppressWarnings(final2024 <- match_pbp(contest = "6080706"))

test_that("match_pbp() works", {
  expect_equal(final2024$set[nrow(final2024)],
               "4")
  expect_equal(nrow(final2024),
               1448)
  expect_equal(final2024$away_team[1],
               "Louisville")
  expect_error(match_pbp(),
               "Enter valid contest ID as a character string")
  expect_error(match_pbp(contest = 585290),
               "Enter valid contest ID as a character string")
})
