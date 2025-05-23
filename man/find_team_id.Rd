% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/find_team_id.R
\name{find_team_id}
\alias{find_team_id}
\title{Find team ID for season}
\usage{
find_team_id(team = NULL, year = NULL, sport = "WVB")
}
\arguments{
\item{team}{Name of school. Must match name used by NCAA. Find exact team
name with \code{\link[=find_team_name]{find_team_name()}}.}

\item{year}{Numeric vector of years for fall of desired seasons.}

\item{sport}{Three letter abbreviation for NCAA sport (must be upper case;
for example "WVB" for women's volleyball and "MVB" for men's volleyball).}
}
\value{
Returns a character string of team ID.
}
\description{
NCAA datasets use a unique ID for each team and season. To access a team's
data, we must know the volleyball team ID. This function looks up the team ID
from \link{wvb_teams} or \link{mvb_teams} using the team name.
Team names can be found in \link{ncaa_teams} or searched with
\code{\link[=find_team_name]{find_team_name()}}.
}
\note{
This function \strong{requires internet connectivity} as it checks the
\href{https://stats.ncaa.org}{NCAA website} for information.
}
\examples{
\dontshow{if (interactive()) (if (getRversion() >= "3.4") withAutoprint else force)(\{ # examplesIf}
find_team_id(team = "Nebraska", year = 2024)
find_team_id(team = "UCLA", year = 2023, sport = "MVB")
\dontshow{\}) # examplesIf}
}
\seealso{
Other search functions: 
\code{\link{find_team_name}()}
}
\concept{search functions}
