#' NCAA Women's Volleyball Teams 2020-2024
#'
#' This data frame includes all women's NCAA Division 1, 2, and 3 teams from
#' 2020-2024.
#'
#' @format
#' A data frame with 5,289 rows and 6 columns:
#' \describe{
#'   \item{team_id}{Team ID for season/year}
#'   \item{team_name}{Team name}
#'   \item{conference_id}{Conference ID}
#'   \item{conference}{Conference name}
#'   \item{div}{NCAA division number (1, 2, or 3)}
#'   \item{yr}{Year for fall of season}
#' }
#' @source <https://stats.ncaa.org>
#' @family data sets
#' @examples
#' head(wvb_teams)
"wvb_teams"

#' NCAA Men's Volleyball Teams 2020-2024
#'
#' This data frame includes all men's NCAA Division 1 and 3 teams from
#' 2020-2024.
#'
#' @format
#' A data frame with 873 rows and 6 columns:
#' \describe{
#'   \item{team_id}{Team ID for season/year}
#'   \item{team_name}{Team name}
#'   \item{conference_id}{Conference ID}
#'   \item{conference}{Conference name}
#'   \item{div}{NCAA division number (1 or 3)}
#'   \item{yr}{Year for fall of season}
#' }
#' @source <https://stats.ncaa.org>
#' @family data sets
#' @examples
#' head(mvb_teams)
"mvb_teams"

#' NCAA Team Names
#'
#' This vector includes names for all NCAA volleyball teams.
#'
#' @format
#' A character vector with 1,089 team names.
#' @source <https://stats.ncaa.org>
#' @family data sets
#' @examples
#' head(ncaa_teams)
"ncaa_teams"

#' NCAA Conference Names
#'
#' This vector includes names for all NCAA volleyball conferences.
#'
#' @format
#' A character vector with 111 conference names.
#' @source <https://stats.ncaa.org>
#' @family data sets
#' @examples
#' head(ncaa_conferences)
"ncaa_conferences"

#' NCAA Sports and Sport Codes
#'
#' This data frame includes all NCAA women's and men's sports and the codes
#' used to refer to the sports.
#'
#' @format
#' A data frame with 100 rows and 2 columns:
#' \describe{
#'   \item{code}{Sport code}
#'   \item{sport}{Sport name}
#' }
#' @source <https://ncaaorg.s3.amazonaws.com/championships/resources/common/NCAA_SportCodes.pdf>
#' @family data sets
#' @examples
#' head(ncaa_sports)
"ncaa_sports"
