suppressWarnings(final2024 <- match_pbp(contest = "6080706"))

test_that("match_pbp() works", {
  expect_equal(length(final2024),
               4)
  expect_equal(length(final2024$Louisville),
               1892)
  expect_equal(final2024$Louisville[1],
               "Match started")
  expect_error(match_pbp(),
               "Enter valid contest ID as a character string")
  expect_error(match_pbp(contest = 585290),
               "Enter valid contest ID as a character string")
})
