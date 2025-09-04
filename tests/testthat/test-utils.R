test_that("request_url() and request_live_url() handle errors gracefully", {
  skip_on_cran()
  skip_on_ci()
  suppressMessages(expect_error(
    request_url(url = "http://httpbin.org/status/404"),
    "HTTP 404 Not Found."
  ))
  expect_silent(request_url(url = "http://httpbin.org/"))
  expect_silent(request_live_url(url = "http://httpbin.org/"))
})

test_that("check_confdiv() validates group parameter correctly", {
  # Test valid groups
  expect_silent(check_confdiv(
    group = "conf",
    value = "Big Ten",
    teams = wvb_teams
  ))
  expect_silent(check_confdiv(group = "division", value = 1, teams = wvb_teams))

  # Test invalid groups
  expect_error(
    check_confdiv(),
    "Enter valid group: conf or division"
  )
  expect_error(
    check_confdiv(group = NULL),
    "Enter valid group: conf or division"
  )
  expect_error(
    check_confdiv(group = "invalid"),
    "Enter valid group: division or conf"
  )
  expect_error(
    check_confdiv(group = "conference"),
    "Enter valid group: division or conf"
  )
  expect_error(
    check_confdiv(group = "div"),
    "Enter valid group: division or conf"
  )
  expect_error(
    check_confdiv(group = c("conf", "division")),
    "Enter single value for conf and division"
  )
  expect_error(
    check_confdiv(group = 123),
    "Enter valid group: division or conf"
  )
})

test_that("check_confdiv() validates conference values correctly", {
  # Test valid conferences (using known conferences from data)
  valid_conferences <- unique(wvb_teams$conference)[1:3] # Test first 3 conferences
  for (conf in valid_conferences) {
    if (!is.na(conf) && conf != "") {
      expect_silent(check_confdiv(
        group = "conf",
        value = conf,
        teams = wvb_teams
      ))
    }
  }

  # Test invalid conferences
  expect_error(
    check_confdiv(group = "conf", value = NULL),
    "Enter valid conference"
  )
  expect_error(
    check_confdiv(
      group = "conf",
      value = "Nonexistent Conference",
      teams = wvb_teams
    ),
    "Enter valid conference"
  )
  expect_error(
    check_confdiv(group = "conf", value = "", teams = wvb_teams),
    "Enter valid conference"
  )
  expect_error(
    check_confdiv(group = "conf", value = 123, teams = wvb_teams),
    "Enter valid conference"
  )
  expect_error(
    check_confdiv(
      group = "conf",
      value = c("Big Ten", "ACC"),
      teams = wvb_teams
    ),
    "Enter single value for conf"
  )
})

test_that("check_confdiv() validates division values correctly", {
  # Test valid divisions
  for (division in 1:3) {
    expect_silent(check_confdiv(
      group = "division",
      value = division,
      teams = wvb_teams
    ))
  }

  # Test invalid divisions
  expect_error(
    check_confdiv(group = "division", value = NULL),
    "Enter valid division as a number: 1, 2, 3"
  )
  expect_error(
    check_confdiv(group = "division", value = 0),
    "Enter valid division as a number: 1, 2, 3"
  )
  expect_error(
    check_confdiv(group = "division", value = 4),
    "Enter valid division as a number: 1, 2, 3"
  )
  expect_error(
    check_confdiv(group = "division", value = -1),
    "Enter valid division as a number: 1, 2, 3"
  )
  expect_error(
    check_confdiv(group = "division", value = c(1, 2)),
    "Enter single value for division"
  )
  expect_error(
    check_confdiv(group = "division", value = 1.5),
    "Enter valid division as a number: 1, 2, 3"
  )
})

test_that("check_confdiv() validates teams parameter correctly", {
  expect_error(
    check_confdiv(group = "division", value = 1, teams = NULL),
    "Enter valid `teams`"
  )
  expect_error(
    check_confdiv(group = "conf", value = "Big Ten", teams = NULL),
    "Enter valid conference"
  )
})

test_that("check_contest() validates contest parameter correctly", {
  # Test valid contest IDs
  expect_silent(check_contest(contest = "123456"))
  expect_silent(check_contest(contest = "585290"))
  expect_silent(check_contest(contest = "abc123"))

  # Test invalid contest IDs
  expect_error(check_contest(), "Enter valid contest ID as a character string")
  expect_error(
    check_contest(contest = NULL),
    "Enter valid contest ID as a character string"
  )
  expect_error(
    check_contest(contest = 123456),
    "Enter valid contest ID as a character string"
  )
  expect_error(
    check_contest(contest = TRUE),
    "Enter valid contest ID as a character string"
  )
})

test_that("check_logical() validates parameters correctly", {
  # Test valid inputs
  expect_silent(check_logical(name = "test", value = TRUE))
  expect_silent(check_logical(name = "test", value = FALSE))
  expect_silent(check_logical(name = "save", value = TRUE))
  expect_silent(check_logical(name = "unique", value = FALSE))

  # Test invalid name parameter
  expect_error(check_logical(name = NULL, value = TRUE), "Enter valid `name`")
  expect_error(check_logical(value = TRUE), "Enter valid `name`")

  # Test invalid value parameter
  expect_error(
    check_logical(),
    "Enter valid `name`"
  )
  expect_error(
    check_logical(name = "test", value = NULL),
    "Enter valid `test` value"
  )
  expect_error(check_logical(name = "test"), "Enter valid `test` value")
  expect_error(
    check_logical(name = "test", value = "TRUE"),
    "`test` must be a logical"
  )
  expect_error(
    check_logical(name = "test", value = 1),
    "`test` must be a logical"
  )
  expect_error(
    check_logical(name = "save", value = "false"),
    "`save` must be a logical"
  )
})

test_that("check_match() validates parameters correctly", {
  # Test valid inputs
  expect_silent(check_match(
    name = "level",
    value = "season",
    vec = c("season", "match", "pbp")
  ))
  expect_silent(check_match(
    name = "sport",
    value = "WVB",
    vec = c("WVB", "MVB")
  ))
  expect_silent(check_match(name = "division", value = 1, vec = 1:3))

  # Test invalid name parameter
  expect_error(
    check_match(),
    "Enter valid `name`"
  )
  expect_error(
    check_match(name = NULL),
    "Enter valid `name`"
  )

  # Test invalid value parameter
  expect_error(
    check_match(name = "level", value = NULL, vec = c("season", "match")),
    "Enter valid level"
  )
  expect_error(
    check_match(name = "level", vec = c("season", "match")),
    "Enter valid level"
  )

  # Test invalid vec parameter
  expect_error(
    check_match(name = "level", value = "season", vec = NULL),
    "Enter valid `vec`"
  )
  expect_error(
    check_match(name = "level", value = "season"),
    "Enter valid `vec`"
  )

  # Test value not in vector
  expect_error(
    check_match(name = "level", value = "invalid", vec = c("season", "match")),
    "Enter valid level:"
  )
  expect_error(
    check_match(name = "sport", value = "XYZ", vec = c("WVB", "MVB")),
    "Enter valid sport:"
  )
  expect_error(
    check_match(name = "division", value = 4, vec = 1:3),
    "Enter valid division:"
  )
})

test_that("check_sport() validates sport parameter correctly", {
  # Test valid sports with vb_only = TRUE
  expect_silent(check_sport("WVB", vb_only = TRUE))
  expect_silent(check_sport("MVB", vb_only = TRUE))

  # Test invalid sports with vb_only = TRUE
  expect_error(check_sport(), "Enter valid `sport`")
  expect_error(check_sport("VB", vb_only = TRUE), "Enter valid sport")
  expect_error(check_sport("WVBALL", vb_only = TRUE), "Enter valid sport")
  expect_error(check_sport("wvb", vb_only = TRUE), "Enter valid sport")
  expect_error(check_sport("", vb_only = TRUE), "Enter valid sport")

  # Test non-character input
  expect_error(
    check_sport(123, vb_only = TRUE),
    "Enter valid sport as a three-letter character string"
  )
  expect_error(
    check_sport(c("WVB", "MVB"), vb_only = TRUE),
    "Enter single value for `sport`"
  )
  expect_error(
    check_sport(TRUE, vb_only = TRUE),
    "Enter valid sport as a three-letter character string"
  )
})

test_that("check_sport() returns correct team data frames", {
  # Test WVB returns wvb_teams
  wvb_result <- check_sport("WVB", vb_only = TRUE)
  expect_equal(wvb_result, ncaavolleyballr::wvb_teams)
  expect_true(is.data.frame(wvb_result))
  expect_true("team_name" %in% colnames(wvb_result))

  # Test MVB returns mvb_teams
  mvb_result <- check_sport("MVB", vb_only = TRUE)
  expect_equal(mvb_result, ncaavolleyballr::mvb_teams)
  expect_true(is.data.frame(mvb_result))
  expect_true("team_name" %in% colnames(mvb_result))

  # Verify they are different datasets
  expect_false(identical(wvb_result, mvb_result))
})

test_that("check_team_id() validates team ID correctly", {
  # Get valid team IDs from the data
  valid_wvb_ids <- head(wvb_teams$team_id, 3)
  valid_mvb_ids <- head(mvb_teams$team_id, 3)

  # Test valid team IDs
  for (id in valid_wvb_ids) {
    if (!is.na(id)) {
      expect_silent(check_team_id(id))
    }
  }

  for (id in valid_mvb_ids) {
    if (!is.na(id)) {
      expect_silent(check_team_id(id))
    }
  }

  # Test invalid team IDs
  expect_error(check_team_id(), "Enter valid team ID as a character string")
  expect_error(
    check_team_id(team_id = NULL),
    "Enter valid team ID as a character string"
  )
  expect_error(
    check_team_id(team_id = 123456),
    "Enter valid team ID as a character string"
  )
  expect_error(check_team_id(team_id = "invalid_id"), "Enter valid team ID")
  expect_error(check_team_id(team_id = ""), "Enter valid team ID")
  expect_error(
    check_team_id(team_id = c("123", "456")),
    'Enter valid team ID. "123 and 456" was not found'
  )
})

test_that("check_team_name() validates team names correctly", {
  # Get valid team names from the data
  valid_wvb_names <- head(unique(wvb_teams$team_name), 3)
  valid_mvb_names <- head(unique(mvb_teams$team_name), 3)

  # Test valid team names
  for (name in valid_wvb_names) {
    if (!is.na(name) && name != "") {
      expect_silent(check_team_name(name, teams = wvb_teams))
    }
  }

  # Test multiple valid team names
  if (length(valid_wvb_names) > 1) {
    expect_silent(check_team_name(valid_wvb_names[1:2], teams = wvb_teams))
  }

  # Test invalid team names
  expect_error(check_team_name(), "Enter valid team name")
  expect_error(check_team_name(team = NULL), "Enter valid team name")
  expect_error(
    check_team_name(team = "Invalid Team", teams = wvb_teams),
    "Enter valid team name"
  )
  expect_error(
    check_team_name(team = "", teams = wvb_teams),
    "Enter valid team name"
  )
  expect_error(
    check_team_name(team = 123, teams = wvb_teams),
    "Enter valid team name"
  )

  # Test with invalid teams parameter
  expect_error(check_team_name(team = "Nebraska"), "Enter valid team name")
})

test_that("check_year() validates year parameter correctly", {
  current_max <- most_recent_season()

  # Test valid years
  expect_silent(check_year(2020)) # minimum
  expect_silent(check_year(current_max)) # maximum
  expect_silent(check_year(2021:2023)) # range
  expect_silent(check_year(c(2020, 2022, 2024))) # non-consecutive

  # Test invalid years
  expect_error(
    check_year(year = NULL),
    paste0("Enter valid year between 2020-", current_max)
  )
  expect_error(
    check_year(year = 2019),
    paste0("Enter valid year between 2020-", current_max)
  )
  expect_error(
    check_year(year = current_max + 1),
    paste0("Enter valid year between 2020-", current_max)
  )
  expect_error(
    check_year(year = "2024"),
    paste0("Enter valid year between 2020-", current_max)
  )
  expect_error(
    check_year(year = c(2019, 2024)),
    paste0("Enter valid year between 2020-", current_max)
  )
  expect_error(
    check_year(year = c(2024, current_max + 1)),
    paste0("Enter valid year between 2020-", current_max)
  )
  expect_error(
    check_year(),
    paste0("Enter valid year between 2020-", current_max)
  )

  # Test single parameter
  expect_silent(check_year(2024, single = FALSE))
  expect_silent(check_year(2024, single = TRUE))
  expect_error(check_year(c(2023, 2024), single = TRUE), "Enter a single year")
  expect_error(check_year(2021:2023, single = TRUE), "Enter a single year")
})

test_that("fix_teams() performs correct substitutions", {
  # Test specific team name fixes
  expect_equal(fix_teams("Tex. A&M-Commerce"), "East Texas A&M")
  expect_equal(fix_teams("Saint Francis (PA)"), "Saint Francis")
  expect_equal(fix_teams("1347"), "Saint Rose")
  expect_equal(fix_teams("1064"), "Eastern Nazarene")
  expect_equal(fix_teams("UAH"), "Alabama Huntsville")
  expect_equal(fix_teams("UT Permian Basin"), "Tex. Permian Basin")

  # Test that other team names are unchanged
  expect_equal(fix_teams("Nebraska"), "Nebraska")
  expect_equal(fix_teams("UCLA"), "UCLA")
  expect_equal(fix_teams("Random Team Name"), "Random Team Name")
  expect_equal(fix_teams(""), "")

  # Test with vector of team names
  input_teams <- c("Nebraska", "Tex. A&M-Commerce", "UCLA", "UAH")
  expected_teams <- c(
    "Nebraska",
    "East Texas A&M",
    "UCLA",
    "Alabama Huntsville"
  )
  expect_equal(fix_teams(input_teams), expected_teams)
})

test_that("get_team_info() works correctly", {
  # Get a valid team ID from the data
  if (nrow(wvb_teams) > 0) {
    valid_id <- wvb_teams$team_id[1]

    if (!is.na(valid_id)) {
      result <- get_team_info(valid_id)

      expect_true(is.data.frame(result))
      expect_true("team_id" %in% colnames(result))
      expect_true("team_name" %in% colnames(result))
      expect_true("conference" %in% colnames(result))
      expect_true("div" %in% colnames(result))
      expect_true("yr" %in% colnames(result))
      expect_true("season" %in% colnames(result))

      # Check season format
      expect_true(grepl("\\d{4}-\\d{4}", result$season[1]))

      # Check that the returned team_id matches input
      expect_true(valid_id %in% result$team_id)
    }
  }

  # Test with multiple team IDs
  if (nrow(wvb_teams) > 1) {
    valid_ids <- wvb_teams$team_id[1:2]
    valid_ids <- valid_ids[!is.na(valid_ids)]

    if (length(valid_ids) > 0) {
      result <- get_team_info(valid_ids)
      expect_true(is.data.frame(result))
      expect_equal(nrow(result), length(valid_ids))
    }
  }
})

test_that("html_table_raw() works", {
  skip_on_cran()
  skip_on_ci()
  schedule <- find_team_contests(team_id = "585290")
  expect_equal(schedule$date[1], "08/27/2024")
})
