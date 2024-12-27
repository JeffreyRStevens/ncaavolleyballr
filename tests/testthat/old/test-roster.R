test_that("roster works properly", {
  expect_silent(neb2024 <- roster("585290"))
  expect_equal(neb2024$Name[1], "Lexi Rodriguez")
  expect_error(roster(585290), "Team ID must be a character string.")
  expect_error(roster("Nebraska"), "Team ID was not found in the list of acceptiable IDs.")
})
