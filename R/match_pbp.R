#' Extract play-by-play information for a particular match
#'
#' The NCAA's page for a match/contest includes a tab called
#' "Play By Play". This function extracts the tables of play-by-play information
#' for each set.
#'
#' @inheritParams player_match_stats
#'
#' @returns
#' Returns a data frame with a column for set number, events happening for each team, as well as a column for the score.
#'
#' @export
#'
#' @examples
#' \dontrun{
#' match_pbp(contest = "6080706")
#' }
match_pbp <- function(contest = NULL) {
  if (is.null(contest)) cli::cli_abort(paste0("Enter valid contest ID as a character string."))
  if (!is.character(contest)) cli::cli_abort("Enter valid contest ID as a character string.")

  url <- paste0("https://stats.ncaa.org/contests/", contest, "/play_by_play")

  pbp_all <- request_url(url) |>
    httr2::resp_body_html() |>
    rvest::html_elements("table") |>
    rvest::html_table()
  match_info <- pbp_all[[1]]

  num_sets <- match_info[1, which(match_info[1, ] == "S") - 1] |>
    dplyr::pull() |>
    as.numeric()
  sets <- 4:(3 + num_sets)

  purrr::lmap(sets, ~`[[`(pbp_all, .x)) |>
    purrr::set_names(nm = 1:num_sets) |>
    purrr::list_rbind(names_to = "Set")
}
