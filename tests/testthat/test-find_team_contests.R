test_that("find_team_contests() works", {
  skip_on_cran()
  skip_on_ci()
  expect_equal(find_team_contests(team_id = "585290")$contest[1], "5362360")
})

test_that("find_team_contests() errors trigger correctly", {
  expect_error(
    find_team_contests(),
    "Enter valid team ID as a character string"
  )
  expect_null(find_team_contests(character(0)))
  expect_error(
    find_team_contests(team_id = 585290),
    "Enter valid team ID as a character string"
  )
  expect_error(
    find_team_contests(team_id = "Nebraska"),
    "Enter valid team ID. "
  )
  expect_error(
    find_team_contests(team_id = NULL),
    "Enter valid team ID as a character string"
  )
  expect_error(
    find_team_contests(team_id = 585290),
    "Enter valid team ID as a character string"
  )
  expect_error(
    find_team_contests(team_id = TRUE),
    "Enter valid team ID as a character string"
  )
  expect_error(
    find_team_contests(team_id = c("585290", "123456")),
    'Enter valid team ID. "585290 and 123456"'
  )
  expect_error(
    find_team_contests(team_id = list("585290")),
    "Enter valid team ID as a character string"
  )
})
