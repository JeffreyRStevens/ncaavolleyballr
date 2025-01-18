
test_that("match_pbp() works", {
  skip_on_cran()
  skip_on_ci()
  suppressWarnings(final2024 <- match_pbp(contest = "6080706"))
  expect_equal(final2024$set[nrow(final2024)],
               "4")
  expect_equal(nrow(final2024),
               1448)
  expect_equal(final2024$away_team[1],
               "Louisville")
})

test_that("match_pbp() errors trigger correctly", {
  expect_error(match_pbp(),
               "Enter valid contest ID as a character string")
  expect_error(match_pbp(contest = 585290),
               "Enter valid contest ID as a character string")
})

test_that("match_pbp() warnings trigger correctly", {
  expect_warning(match_pbp(contest = "5675914"),
                 "No website available for contest")
  expect_warning(match_pbp(contest = "5669768"),
                 "Set information not available for contest")
})
