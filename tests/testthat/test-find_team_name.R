test_that("find_team_name() works", {
  skip_on_cran()
  skip_on_ci()
  expect_equal(find_team_name(pattern = "Neb")[1],
               "Neb. Wesleyan")
})

test_that("find_team_name() errors trigger correctly", {
  expect_error(find_team_name(),
               "Enter valid pattern as a character string")
  expect_error(find_team_name(pattern = 2024),
               "Enter valid pattern as a character string")
})
