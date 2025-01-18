test_that("connections to internet resources fail gracefully", {
  skip_on_cran()
  skip_on_ci()
  suppressMessages(expect_error(request_url("http://httpbin.org/status/404"),
                                "HTTP 404 Not Found."))
  expect_silent(request_url("http://httpbin.org/"))
})

test_that("check_confdiv() works", {
  expect_silent(check_confdiv(group = "conf", value = "Big Ten",
                              teams = wvb_teams))
  expect_silent(check_confdiv(group = "div", value = 1, teams = wvb_teams))
  expect_error(check_confdiv(),
               "Enter valid group")
  expect_error(check_confdiv(group = "conf"),
               "Enter valid conference")
  expect_error(check_confdiv(group = "div"),
               "Enter valid division")
  expect_error(check_confdiv(group = "xxx"),
               "Enter valid group:")
  expect_error(check_confdiv(group = "conf", value = "xxx"),
               "Enter valid conference")
  expect_error(check_confdiv(group = "div", value = "xxx"),
               "Enter valid division")
  expect_error(check_confdiv(group = "div", value = 1),
               "Enter valid `teams`")
})

test_that("check_contest() works", {
  expect_silent(check_contest(contest = "585290"))
  expect_error(check_contest(),
               "Enter valid contest ID as a character string")
  expect_error(check_contest(contest = 585290),
               "Enter valid contest ID as a character string")
})

test_that("check_logical() works", {
  expect_silent(check_logical(name = "test", value = TRUE))
  expect_error(check_logical(),
               "Enter valid `name`")
  expect_error(check_logical(name = "test"),
               "Enter valid `value`")
  expect_error(check_logical(name = "test", value = 1),
               "`test` must be a logical")
})

test_that("check_match() works", {
  expect_silent(check_match(name = "test", value = 1, vec = 1:2))
  expect_error(check_match(),
               "Enter valid `name`")
  expect_error(check_match(name = "test"),
               "Enter valid `value`")
  expect_error(check_match(name = "test", value = 1),
               "Enter valid `vec`")
  expect_error(check_match(name = "test", value = 1, vec = 2:3),
               "Enter valid ")
})

test_that("check_sport() works", {
  expect_silent(check_team_id(team_id = "585290"))
  expect_error(check_team_id(),
               "Enter valid team ID as a character string")
  expect_error(check_team_id(team_id = 585290),
               "Enter valid team ID as a character string")
  expect_error(check_team_id(team_id = "Nebraska"),
               "Enter valid team ID. ")
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

test_that("check_team_name() works", {
  expect_silent(check_team_name(team = "Nebraska", teams = wvb_teams))
  expect_error(check_team_name(),
               "Enter valid team name")
  expect_error(check_team_name(team = "Nebraska"),
               "Enter valid team name")
  expect_error(check_team_name(team = "Neb", teams = wvb_teams),
               "Enter valid team name")
})

test_that("check_year() works", {
  expect_silent(check_year(year = 2024))
  expect_silent(check_year(year = 2023:2024))
  expect_error(check_year(),
               "Enter valid year between")
  expect_error(check_year(year = "x"),
               "Enter valid year between")
  expect_error(check_year(year = 1999),
               "Enter valid year between")
  expect_error(check_year(year = 2023:2024, single = TRUE),
               "Enter a single year")
})

test_that("get_team_info() works", {
  expect_silent(nebteam <- get_team_info(team_id = "585290"))
  expect_equal(nebteam$team_name[1],
               "Nebraska")
  expect_equal(nebteam$season[1],
               "2024-2025")
})

test_that("most_recent_season() works", {
  expect_equal(most_recent_season(),
               2024)
})

test_that("html_table_raw() works", {
  skip_on_cran()
  skip_on_ci()
  team_id <- "585290"
  url <- paste0("https://stats.ncaa.org/teams/", team_id)
  resp <- request_url(url)

  html_table <- resp |>
    httr2::resp_body_html() |>
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
