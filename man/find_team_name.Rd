% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/find_team_name.R
\name{find_team_name}
\alias{find_team_name}
\title{Match pattern to find team names}
\usage{
find_team_name(pattern = NULL)
}
\arguments{
\item{pattern}{Character string of pattern you want to find in the vector
of team names.}
}
\value{
Returns a character vector of team names that include the submitted pattern.
}
\description{
This is a convenience function to find NCAA team names in
\link{ncaa_teams}. Once the proper team name is found, it can be
passed to \code{\link[=find_team_id]{find_team_id()}} or \code{\link[=group_stats]{group_stats()}}.
}
\note{
This function \strong{requires internet connectivity} as it checks the
\href{https://stats.ncaa.org}{NCAA website} for information.
}
\examples{
\dontshow{if (interactive()) (if (getRversion() >= "3.4") withAutoprint else force)(\{ # examplesIf}
find_team_name(pattern = "Neb")
\dontshow{\}) # examplesIf}
}
\seealso{
Other search functions: 
\code{\link{find_team_id}()}
}
\concept{search functions}
