#' Match pattern to find team names
#'
#' This is a convenience function to find NCAA team names in
#' [ncaa_teams]. Once the proper team name is found, it can be
#' passed to [find_team_id()] or [group_stats()].
#'
#' @param pattern Character string of pattern you want to find in the vector
#' of team names.
#'
#' @returns
#' Returns a character vector of team names that include the submitted pattern.
#'
#' @export
#'
#' @family search functions
#'
#' @examples
#' find_team_name(pattern = "Neb")
find_team_name <- function(pattern = NULL) {
  if (is.null(pattern)) cli::cli_abort("Enter valid pattern as a character string.")
  if (!is.character(pattern)) cli::cli_abort("Enter valid pattern as a character string.")

  ncaavolleyballr::ncaa_teams[grep(pattern, ncaavolleyballr::ncaa_teams)]
}
