test_that("find_team_contests() works", {
  expect_equal(find_team_contests(team_id = "585290")$contest[1],
               "5362360")
  expect_error(find_team_contests(),
               "Enter valid team ID as a character string")
  expect_error(find_team_contests(team_id = 585290),
               "Enter valid team ID as a character string")
  expect_error(find_team_contests(team_id = "Nebraska"),
               "Enter valid team ID. ")
})
