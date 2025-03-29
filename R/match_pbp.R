#' Extract play-by-play information for a particular match
#'
#' The NCAA's page for a match/contest includes a tab called
#' "Play By Play". This function extracts the tables of play-by-play information
#' for each set.
#'
#' @inheritParams player_match_stats
#'
#' @returns
#' Returns a data frame of set number, teams, score, event, and player responsible
#' for the event.
#'
#' @export
#'
#' @note
#' This function **requires internet connectivity** as it checks the
#' [NCAA website](https://stats.ncaa.org) for information.
#'
#' @examplesIf interactive()
#' match_pbp(contest = "6080706")
match_pbp <- function(contest = NULL) {
  # check input
  check_contest(contest)

  # get URL
  url <- paste0("https://stats.ncaa.org/contests/", contest, "/play_by_play")

  ## get pbp HTML table
  pbp_all <- tryCatch(
    error = function(cnd) {
      cli::cli_warn("No website available for contest {contest}.")
    },
    request_url(url = url) |>
      httr2::resp_body_html() |>
      rvest::html_elements("table") |>
      rvest::html_table()
  )
  if (length(pbp_all) == 1) {
    if (grepl(pattern = "No website available for contest", pbp_all)) return(invisible())
  } else if (length(pbp_all) < 6) {
    cli::cli_warn("Set information not available for contest {contest}.")
    return(invisible())
  }

  match_info <- pbp_all[[1]]

  # calculate number of sets
  num_sets <- match_info[1, which(match_info[1, ] == "S") - 1] |>
    dplyr::pull() |>
    as.numeric()
  sets <- 4:(3 + num_sets)

  # process pbp information for all sets
  purrr::lmap(sets, ~ `[[`(pbp_all, .x) |> process_set()) |>
    purrr::set_names(nm = 1:num_sets) |>
    purrr::list_rbind(names_to = "set")
}

# process set information in pbp table
process_set <- function(set_data) {
  ignore_entries <- c("Match started", "Set started", "Facultative timeout",
                      "Media timeout", "Set ended", "Match ended")
  away_name <- names(set_data)[1]
  home_name <- names(set_data)[3]
  set_data$Score[1] <- "0-0"
  set_data |>
    dplyr::mutate(dplyr::across(dplyr::everything(), ~ dplyr::na_if(.x, "")),
                  away_team = away_name,
                  home_team = home_name) |>
    tidyr::fill("Score") |>
    dplyr::rename("away" = 1, "home" = 3) |>
    dplyr::mutate(team = ifelse(!is.na(.data$home), home_name, away_name),
                  description = dplyr::coalesce(.data$away, .data$home),
                  description = stringr::str_replace(.data$description, "\\+\n", ""),
                  description = sub("\n.*", "", .data$description),
                  description = stringr::str_squish(.data$description),
                  description = sub(".*Kill by ", "Kill by ", .data$description),
                  event = get_event(.data$description),
                  player = get_player(.data$description)
    ) |>
    dplyr::filter(!.data$event %in% ignore_entries
                  & !grepl("^Sub", .data$event)
                  & !is.na(.data$event) & !grepl("^Team", .data$event)
                  & !grepl("^End of", .data$event)
                  & !grepl("challengeOutcome", .data$event)) |>
    dplyr::select("away_team", "home_team", score = "Score", "team", "event",
                  "player", "description")
}

# extract event information from description
get_event <- function(event) {
  dplyr::case_when(grepl("serves an ace", event) ~
                     "Ace",
                   grepl("service error", event) ~
                     "Service error",
                   grepl("serves", event) ~
                     "Serve",
                   grepl("block\\(over", event) ~
                     "Block error",
                   grepl("block\\(error", event) ~
                     "Block error",
                   grepl("reception\\(", event) ~
                     "Reception",
                   grepl("attack\\(", event) ~
                     "Attack",
                   grepl("dig\\(in", event) ~
                     "Dig",
                   grepl("set\\(in", event) ~
                     "Set",
                   grepl("sanction\\(", event) ~
                     "Sanction",
                   grepl("ballHandlingError", event) ~
                     "Ball handling error",
                   grepl("challengeRequest", event) ~
                     "Challenge request",
                   .default = stringr::str_split_fixed(event, n = 2, pattern = " by ")[, 1]
  )
}

# extract player information from description
get_player <- function(event) {
  dplyr::case_when(grepl("serves an ace", event) ~
                     stringr::str_replace(event, " serves an ace", ""),
                   grepl("service error", event) ~
                     stringr::str_replace(event, " service error", ""),
                   grepl("serves", event) ~
                     stringr::str_replace(event, " serves", ""),
                   grepl("block\\(over", event) ~
                     sub("\\(.*", "", event),
                   grepl("block\\(error", event) ~
                     sub("\\(.*", "", event),
                   grepl(" reception\\(", event) ~
                     sub("\\(.*", "", event),
                   grepl("attack\\(", event) ~
                     sub("\\(.*", "", event),
                   grepl("dig\\(in", event) ~
                     sub("\\(.*", "", event),
                   grepl("set\\(in", event) ~
                     sub("\\(.*", "", event),
                   grepl("sanction\\(", event) ~
                     sub("\\(.*", "", event),
                   grepl("ballHandlingError", event) ~
                     sub("\\(.*", "", event),
                   grepl("challengeRequest", event) ~
                     NA,
                   .default =
                     stringr::str_split_fixed(event, n = 2, pattern = " by ")[, 2]
  )
}
