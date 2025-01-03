test_that("find_team_name() works", {
  expect_equal(find_team_name(pattern = "Neb")[1],
               "Neb. Wesleyan")
  expect_error(find_team_name(),
               "Enter valid pattern as a character string")
  expect_error(find_team_name(pattern = 2024),
               "Enter valid pattern as a character string")
})
