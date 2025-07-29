test_that("conference_stats() parameter validation works correctly", {
  # Test year parameter validation
  expect_error(conference_stats(), "Enter valid year between 2020-")
  expect_error(conference_stats(year = NULL), "Enter valid year between 2020-")
  expect_error(conference_stats(year = 2019), "Enter valid year between 2020-")
  expect_error(conference_stats(year = 2030), "Enter valid year between 2020-")
  expect_error(
    conference_stats(year = "2024"),
    "Enter valid year between 2020-"
  )
  expect_error(
    conference_stats(year = c(2019, 2024)),
    "Enter valid year between 2020-"
  )

  # Test conference parameter validation
  expect_error(
    conference_stats(year = 2024, level = "teammatch"),
    "Enter valid conference"
  )
  expect_error(
    conference_stats(year = 2024, conf = NULL, level = "teammatch"),
    "Enter valid conference"
  )
  expect_error(
    conference_stats(
      year = 2024,
      conf = "Invalid Conference",
      level = "teammatch"
    ),
    "Enter valid conference"
  )
  expect_error(
    conference_stats(year = 2024, conf = 123, level = "teammatch"),
    "Enter valid conference"
  )
  expect_error(
    conference_stats(
      year = 2024,
      conf = c("Big Ten", "Big 12"),
      level = "teammatch"
    ),
    "Enter single value for conf"
  )

  # Test level parameter validation
  expect_error(
    conference_stats(year = 2024, conf = "Big Ten", level = NULL),
    "Enter valid level"
  )
  expect_error(
    conference_stats(year = 2024, conf = "Big Ten", level = "invalid"),
    "Enter valid level"
  )
  expect_error(
    conference_stats(
      year = 2024,
      conf = "Big Ten",
      level = c("teamseason", "match")
    ),
    "Enter single value for level"
  )

  # Test sport parameter validation
  expect_error(
    conference_stats(
      year = 2024,
      conf = "Big Ten",
      level = "teammatch",
      sport = "VB"
    ),
    "Enter valid sport"
  )
  expect_error(
    conference_stats(
      year = 2024,
      conf = "Big Ten",
      level = "teammatch",
      sport = "WVB1"
    ),
    "Enter valid sport"
  )
  expect_error(
    conference_stats(
      year = 2024,
      conf = "Big Ten",
      level = "teammatch",
      sport = 123
    ),
    "Enter valid sport as a three-letter character string"
  )
  expect_error(
    conference_stats(
      year = 2024,
      conf = "Big Ten",
      level = "teammatch",
      sport = NULL
    ),
    "Enter valid `sport`"
  )

  # Test save parameter validation
  expect_error(
    conference_stats(
      year = 2024,
      conf = "Big Ten",
      level = "teammatch",
      save = "TRUE"
    ),
    "`save` must be a logical"
  )
  expect_error(
    conference_stats(
      year = 2024,
      conf = "Big Ten",
      level = "teammatch",
      save = 1
    ),
    "`save` must be a logical"
  )
  expect_error(
    conference_stats(
      year = 2024,
      conf = "Big Ten",
      level = "teammatch",
      save = NULL
    ),
    "Enter valid `save` value"
  )

  # Test path parameter validation
  expect_error(
    conference_stats(
      year = 2024,
      conf = "Big Ten",
      level = "teammatch",
      path = 123
    ),
    "Enter valid path as a character string"
  )
  expect_error(
    conference_stats(
      year = 2024,
      conf = "Big Ten",
      level = "teammatch",
      path = NULL
    ),
    "Enter valid path as a character string"
  )
  expect_error(
    conference_stats(
      year = 2024,
      conf = "Big Ten",
      level = "teammatch",
      path = c(".", "..")
    ),
    "Enter valid path as a character string"
  )
})
