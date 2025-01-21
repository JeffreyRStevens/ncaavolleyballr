

#' Assigns most recent season
#'
#' @keywords internal
#'
most_recent_season <- function() {
  2024
}


#' Checks if division or conference is valid
#'
#' @param group Character string for group ("div" or "conf").
#' @param value Character string for group's value (e.g., 1 or "Big Ten")
#'
#' @keywords internal
#'
check_confdiv <- function(group = NULL, value = NULL, teams = NULL) {
  if (is.null(group)) cli::cli_abort("Enter valid group: conf or div.")
  if (group == "conf") {
    if (is.null(value)) cli::cli_abort("Enter valid conference.  Check `ncaa_conferences` for conference names.")
    if (!value %in% teams$conference) cli::cli_abort("Enter valid conference.  Check `ncaa_conferences` for conference names.")
  } else if (group == "div") {
    if (is.null(value)) cli::cli_abort("Enter valid division as a number: 1, 2, 3.")
    if (!value %in% 1:3) cli::cli_abort("Enter valid division as a number: 1, 2, 3.")
  } else {
    cli::cli_abort("Enter valid group: div or conf")
  }
  if (is.null(teams)) cli::cli_abort("Enter valid `teams`.")
}


#' Checks if contest ID is valid
#'
#' @param contest Contest ID
#'
#' @keywords internal
#'
check_contest <- function(contest = NULL) {
  if (is.null(contest)) cli::cli_abort(paste0("Enter valid contest ID as a character string."))
  if (!is.character(contest)) cli::cli_abort("Enter valid contest ID as a character string.")
}


#' Checks if a logical input is valid
#'
#' @param name Argument name.
#' @param value Argument value.
#'
#' @keywords internal
#'
check_logical <- function(name = NULL, value = NULL) {
  if (is.null(name)) cli::cli_abort(paste0("Enter valid `name`."))
  if (is.null(value)) cli::cli_abort(paste0("Enter valid `value`."))
  if (!is.logical(value)) cli::cli_abort("`{name}` must be a logical (TRUE or FALSE).")
}


#' Checks if value is matched in vector
#'
#' @param name Argument name.
#' @param value Value.
#' @param vec Vector.
#'
#' @keywords internal
#'
check_match <- function(name = NULL, value = NULL, vec = NULL) {
  if (is.null(name)) cli::cli_abort(paste0("Enter valid `name`."))
  if (is.null(value)) cli::cli_abort(paste0("Enter valid `value`."))
  if (is.null(vec)) cli::cli_abort(paste0("Enter valid `vec`."))
  if (!value %in% vec) cli::cli_abort("Enter valid {name}: {vec}.")
}


#' Checks if sport is valid
#'
#' @param sport Sport code.
#' @param vb_only Logical indicating whether to check only for
#' volleyall sports (TRUE) or all sports (FALSE)
#'
#' @keywords internal
#'
check_sport <- function(sport, vb_only = TRUE) {
  if (!is.character(sport)) cli::cli_abort("Enter valid sport as a three-letter character string.")
  team_df <- NULL
  if (vb_only) {
    if (sport == "WVB") team_df <- ncaavolleyballr::wvb_teams
    else if (sport == "MVB") team_df <- ncaavolleyballr::mvb_teams
    else cli::cli_abort("Enter valid sport (\"WVB\" or \"MVB\").")
  } else {
    if (!sport %in% ncaavolleyballr::ncaa_sports$code) cli::cli_abort("Enter valid sport code from `ncaa_sports`.")
  }
  team_df
}


#' Checks if team ID is valid
#'
#' @param team_id Team ID
#'
#' @keywords internal
#'
check_team_id <- function(team_id = NULL) {
  teams <- dplyr::bind_rows(ncaavolleyballr::wvb_teams, ncaavolleyballr::mvb_teams)
  if (is.null(team_id)) cli::cli_abort(paste0("Enter valid team ID as a character string."))
  if (!is.character(team_id)) cli::cli_abort("Enter valid team ID as a character string.")
  if (!all(team_id %in% c(teams$team_id))) cli::cli_abort("Enter valid team ID. \"{team_id}\" was not found in the list of valid IDs.")
}


#' Checks if team name is valid
#'
#' @param team Team name
#' @param teams Data frame of team names
#'
#' @keywords internal
#'
check_team_name <- function(team = NULL, teams = NULL) {
  if (is.null(team)) cli::cli_abort("Enter valid team name.")
  if (!all(team %in% teams$team_name)) cli::cli_abort("Enter valid team name. Check `ncaa_teams` for names or search using `find_team_name()`.")
}


#' Checks if year is valid
#'
#' @param year Year.
#' @param single Logical for whether year should be a single element or can be
#' a vector of multiple years.
#'
#' @keywords internal
#'
check_year <- function(year = NULL, single = FALSE) {
  max_year <- most_recent_season()
  if (is.null(year)) cli::cli_abort(paste0("Enter valid year between 2020-", max_year, "."))
  if (!is.numeric(year)) cli::cli_abort(paste0("Enter valid year between 2020-", max_year, "."))
  if (!all(year %in% 2020:max_year)) cli::cli_abort(paste0("Enter valid year between 2020-", max_year, "."))
  if (single) {
    if (length(year) > 1) cli::cli_abort("Enter a single year.")
  }
}


#' Fix teams that change their names
#'
#'
#' @keywords internal
#'
fix_teams <- function(x) {
  sub("Tex. A&M-Commerce", "East Texas A&M", x) |>
    sub("Saint Francis \\(PA\\)", "Saint Francis", x = _) |>
    sub("1347", "Saint Rose", x = _) |>
    sub("1064", "Eastern Nazarene", x = _)
}


#' Gets year, team, and conference from team ID
#'
#' @param team_id Team ID
#'
#' @keywords internal
#'
get_team_info <- function(team_id = NULL) {
  teams <- dplyr::bind_rows(ncaavolleyballr::wvb_teams, ncaavolleyballr::mvb_teams)
  teams[which(teams$team_id %in% team_id), ] |>
    dplyr::mutate(season = paste0(.data$yr, "-", .data$yr + 1))
}


#' Creates table of raw HTML
#'
#' Copied and modified from `{rvest}`
#' https://github.com/tidyverse/rvest/blob/main/R/table.R
#'
#' @keywords internal
#'
html_table_raw <- function(x,
                           header = NA,
                           trim = TRUE,
                           dec = ".",
                           na.strings = "NA",
                           convert = TRUE) {
  compact <- function(.x) {
    Filter(length, .x)
  }
  dw_find <- function(dw, col) {
    match <- col == dw$col
    list(
      col = dw$col[match],
      rowspan = dw$rowspan[match],
      colspan = dw$colspan[match],
      text = dw$text[match]
    )
  }
  dw_init <- function() {
    list(
      col = integer(),
      rowspan = integer(),
      colspan = integer(),
      text = character()
    )
  }

  dw_add <- function(dw, col, rowspan, colspan, text) {
    dw$col <-     c(dw$col, col)
    dw$text <-    c(dw$text, text)
    dw$rowspan <- c(dw$rowspan, rowspan)
    dw$colspan <- c(dw$colspan, colspan)
    dw
  }

  dw_prune <- function(dw) {
    dw$rowspan <- dw$rowspan - 1L
    keep <- dw$rowspan > 0L

    dw$col <-     dw$col[keep]
    dw$text <-    dw$text[keep]
    dw$rowspan <- dw$rowspan[keep]
    dw$colspan <- dw$colspan[keep]
    dw
  }
  table_fill <- function(cells, trim = TRUE) {
    width <- 0
    height <- length(cells) # initial estimate
    values <- vector("list", height)

    # list of downward spanning cells
    dw <- dw_init()

    # https://html.spec.whatwg.org/multipage/tables.html#algorithm-for-processing-rows
    for (i in seq_along(cells)) {
      row <- cells[[i]]
      if (length(row) == 0) {
        next
      }

      rowspan <- as.integer(rvest::html_attr(row, "rowspan", default = NA_character_))
      rowspan[is.na(rowspan)] <- 1
      colspan <- as.integer(rvest::html_attr(row, "colspan", default = NA_character_))
      colspan[is.na(colspan)] <- 1
      text <- row
      if (isTRUE(trim)) {
        text <- gsub("^[[:space:]\u00a0]+|[[:space:]\u00a0]+$", "", text)
      }

      vals <- rep(NA_character_, width)
      col <- 1
      j <- 1
      while(j <= length(row)) {
        if (col %in% dw$col) {
          cell <- dw_find(dw, col)
          cell_text <- cell$text
          cell_colspan <- cell$colspan
        } else {
          cell_text <- text[[j]]
          cell_colspan <- colspan[[j]]

          if (rowspan[[j]] > 1) {
            dw <- dw_add(dw, col, rowspan[[j]], colspan[[j]], text[[j]])
          }

          j <- j + 1
        }
        vals[col:(col + cell_colspan - 1L)] <- cell_text
        col <- col + cell_colspan
      }

      # Add any downward cells after last <td>
      for(j in seq(col - 1L, width)) {
        if (j %in% dw$col) {
          cell <- dw_find(dw, j)
          vals[j:(j + cell$colspan - 1L)] <- cell$text
        }
      }

      dw <- dw_prune(dw)
      values[[i]] <- vals

      height <- max(height, i + max(rowspan) - 1L)
      width <- max(width, col - 1L)
    }

    # Add any downward cells after <tr>
    i <- length(values) + 1
    length(values) <- height
    while (length(dw$col) > 0) {
      vals <- rep(NA_character_, width)
      for (col in dw$col) {
        cell <- dw_find(dw, col)
        vals[col:(col + cell$colspan - 1L)] <- cell$text
      }
      values[[i]] <- vals
      i <- i + 1
      dw <- dw_prune(dw)
    }

    values <- lapply(values, `[`, seq_len(width))
    matrix(unlist(values), ncol = width, byrow = TRUE)
  }


  ns <- xml2::xml_ns(x)
  rows <- xml2::xml_find_all(x, ".//tr", ns = ns)
  cells <- lapply(rows, xml2::xml_find_all, ".//td|.//th", ns = ns)
  cells <- compact(cells)

  if (length(cells) == 0) {
    return(tibble::tibble())
  }

  out <- table_fill(cells, trim = trim)

  if (is.na(header)) {
    header <- all(rvest::html_name(cells[[1]]) == "th")
  }
  if (header) {
    col_names <- out[1, , drop = FALSE]
    out <- out[-1, , drop = FALSE]
  } else {
    col_names <- paste0("X", seq_len(ncol(out)))
  }

  colnames(out) <- col_names
  df <- tibble::as_tibble(out, .name_repair = "minimal")
  colnames(df) <- colnames(df) |>
    sub("<th>", "", x = _) |>
    sub("</th>", "", x = _) |>
    sub(".*>", "", x = _)

  df |>
    dplyr::filter(!grepl("><", .data$Date))
}


#' Submit URL request, check, and return response
#'
#' @param url URL for request.
#' @param timeout Numeric of maximum number of seconds to wait for timeout.
#'
#' @keywords internal
#'
request_url <- function(url, timeout = 5) {
  # First check internet connection
  if (!curl::has_internet()) {
    message("No internet connection.")
    return(invisible(NULL))
  }
  # Perform request and record response
  company <- sample(c(0:9, LETTERS),
                    size = sample(6:12, size = 1),
                    replace = TRUE) |>
    paste0(collapse = "")
  user <- sample(c(0:9, LETTERS),
                    size = sample(6:15, size = 1),
                    replace = TRUE) |>
    paste0(collapse = "")

  response <- httr2::request(url) |>
    httr2::req_user_agent(paste0(company, " ", tolower(user), "@", tolower(company), ".com")) |>
    httr2::req_perform()
  # Check status of response and return if status is OK
  httr2::resp_check_status(response)
}


#' Save data frames
#'
#' @keywords internal
#'
save_df <- function(x, label, group, year, division, conf, sport, path) {
  # save_df <- function(...) {
  if (length(year) > 1) year <- paste0(min(year), "-", max(year))
  if (group == "conf") confdiv <- tolower(gsub(" ", "", conf))
  if (group == "div") confdiv <- paste0(group, division)
  utils::write.csv(x,
                   paste0(path, tolower(sport), "_", label, "_", confdiv, "_", year, ".csv"), row.names = FALSE)
}




#' Table filling algorithm
#'
#' Copied and modified from `{rvest}`
#' https://github.com/tidyverse/rvest/blob/main/R/table.R
#'
#' @keywords internal
#'
