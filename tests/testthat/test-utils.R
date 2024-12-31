test_that("connections to internet resources fail gracefully", {
  skip_on_cran()
  skip_on_ci()
  suppressMessages(expect_error(request_url("http://httpbin.org/status/404"), "HTTP 404 Not Found."))
  expect_silent(request_url("http://httpbin.org/"))
})

test_that("check_team_id() works properly", {
  expect_silent(check_team_id("585290"))
  expect_error(check_team_id(585290),
               "Team ID must be a character string.")
  expect_error(check_team_id("Nebraska"),
               "Team ID was not found in the list of valid IDs.")
})
