test_that("connections to internet resources fail gracefully", {
  skip_on_cran()
  skip_on_ci()
  suppressMessages(expect_error(request_url("http://httpbin.org/status/404"), "HTTP 404 Not Found."))
  expect_silent(request_url("http://httpbin.org/"))
})

test_that("check_team_id() works", {
  expect_silent(check_team_id(team_id = "585290"))
  expect_error(check_team_id(),
               "Enter valid team ID as a character string")
  expect_error(check_team_id(team_id = 585290),
               "Enter valid team ID as a character string")
  expect_error(check_team_id(team_id = "Nebraska"),
               "Enter valid team ID. ")
})

test_that("get_team_info() works", {
  expect_silent(get_team_info(team_id = "585290"))
  expect_equal(get_team_info(team_id = "585290"),
               c(Year = "2024", Team = "Nebraska", Conference = "Big Ten", Season = "2024-2025"))
})

test_that("most_recent_season() works", {
  expect_equal(most_recent_season(),
               2024)
})

test_that("html_table_raw() works", {
  team_id <- "585290"
  url <- paste0("https://stats.ncaa.org/teams/", team_id)
  resp <- request_url(url)

  html_table <- resp |> httr2::resp_body_html() |>
    rvest::html_element("table")

  schedule <- html_table |> html_table_raw()
  expect_equal(schedule$Date[1],
               "<td>08/27/2024</td>")
})

test_that("fix_teams() works", {
  expect_equal(fix_teams("x"),
               "x")
  expect_equal(fix_teams("Tex. A&M-Commerce"),
               "East Texas A&M")
})

