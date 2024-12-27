suppressWarnings(neb2024 <- player_stats("585290"))

test_that("player_stats works properly", {
  # expect_silent()
  expect_equal(neb2024$Player[1], "Bergen Reilly")
  expect_equal(neb2024$Assists[1], 1352)
  expect_error(player_stats(585290), "Team ID must be a character string.")
  expect_error(player_stats("Nebraska"), "Team ID was not found in the list of acceptiable IDs.")
})
