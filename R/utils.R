

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
  response <- httr2::request(url) |>
    httr2::req_user_agent("Sample Company Name AdminContact@<sample company domain>.com") |>
    httr2::req_perform()
  # Check status of response and return if status is OK
  httr2::resp_check_status(response)
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


#' Gets year, team, and conference from team ID
#'
#' @param team_id Team ID
#'
#' @keywords internal
#'
get_team_info <- function(team_id = NULL) {
  teams <- dplyr::bind_rows(ncaavolleyballr::wvb_teams, ncaavolleyballr::mvb_teams)
  team <- teams[which(teams == team_id), ]$team_name
  conference <- teams[which(teams == team_id), ]$conference
  yr <- teams[which(teams == team_id), ]$yr
  c(Year = yr, Team = team, Conference = conference)
}

#' Assigns most recent season
#'
#' @keywords internal
#'
most_recent_season <- function() {
  2024
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

  ns <- xml2::xml_ns(x)
  rows <- xml2::xml_find_all(x, ".//tr", ns = ns)
  cells <- lapply(rows, xml2::xml_find_all, ".//td|.//th", ns = ns)
  cells <- rvest:::compact(cells)

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


#' Table filling algorithm
#'
#' Copied and modified from `{rvest}`
#' https://github.com/tidyverse/rvest/blob/main/R/table.R
#'
#' @keywords internal
#'
table_fill <- function(cells, trim = TRUE) {
  width <- 0
  height <- length(cells) # initial estimate
  values <- vector("list", height)

  # list of downward spanning cells
  dw <- rvest:::dw_init()

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
    text <- row #html_text(row)
    if (isTRUE(trim)) {
      text <- gsub("^[[:space:]\u00a0]+|[[:space:]\u00a0]+$", "", text)
    }

    vals <- rep(NA_character_, width)
    col <- 1
    j <- 1
    while(j <= length(row)) {
      if (col %in% dw$col) {
        cell <- rvest:::dw_find(dw, col)
        cell_text <- cell$text
        cell_colspan <- cell$colspan
      } else {
        cell_text <- text[[j]]
        cell_colspan <- colspan[[j]]

        if (rowspan[[j]] > 1) {
          dw <- rvest:::dw_add(dw, col, rowspan[[j]], colspan[[j]], text[[j]])
        }

        j <- j + 1
      }
      vals[col:(col + cell_colspan - 1L)] <- cell_text
      col <- col + cell_colspan
    }

    # Add any downward cells after last <td>
    for(j in seq(col - 1L, width)) {
      if (j %in% dw$col) {
        cell <- rvest:::dw_find(dw, j)
        vals[j:(j + cell$colspan - 1L)] <- cell$text
      }
    }

    dw <- rvest:::dw_prune(dw)
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
      cell <- rvest:::dw_find(dw, col)
      vals[col:(col + cell$colspan - 1L)] <- cell$text
    }
    values[[i]] <- vals
    i <- i + 1
    dw <- rvest:::dw_prune(dw)
  }

  values <- lapply(values, `[`, seq_len(width))
  matrix(unlist(values), ncol = width, byrow = TRUE)
}

#' Fix teams that change their names
#'
#'
#' @keywords internal
#'
fix_teams <- function(x) {
  sub("Tex. A&M-Commerce", "East Texas A&M", x)
}
