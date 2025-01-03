% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/division_season_stats.R
\name{division_season_stats}
\alias{division_season_stats}
\title{Aggregate player statistics from a particular division and season}
\usage{
division_season_stats(
  year = NULL,
  division = 1,
  sport = "WVB",
  save = FALSE,
  path = ""
)
}
\arguments{
\item{year}{Year for fall of desired season.}

\item{division}{NCAA division (must be 1, 2, or 3).}

\item{sport}{Three letter abbreviation for NCAA sport (must be upper case;
for example "WVB" for women's volleyball and "MVB" for men's volleyball).}

\item{save}{Logical for whether to save the statistics locally as CSVs
(default FALSE).}

\item{path}{Character string of path to save statistics files.}
}
\value{
Returns data frame of player statistics
}
\description{
This is a wrapper around \code{\link[=group_stats]{group_stats()}} that extracts
all season data from players in all teams from the chosen division.
It aggregates all player data and team data into separate data frames and
combines them into a list.
}
\examples{
\dontrun{
division_season_stats(year = 2024)
division_season_stats(year = 2023, division = 3, sport = "MVB")
division_season_stats(year = 2024, save = TRUE, path = "data/")
}
}
\seealso{
Other functions that aggregate statistics: 
\code{\link{conference_season_stats}()},
\code{\link{group_stats}()}
}
\concept{functions that aggregate statistics}
