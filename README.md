
<!-- README.md is generated from README.Rmd. Please edit that file -->

# ncaavolleyballr <a href="https://jeffreyrstevens.github.io/ncaavolleyballr/"><img src="man/figures/logo.png" align="right" height="139" alt="ncaavolleyballr website" /></a>

<!-- badges: start -->

[![Project Status: WIP - Initial development is in progress, but there
has not yet been a stable, usable release suitable for the
public.](https://www.repostatus.org/badges/latest/wip.svg)](https://www.repostatus.org/#wip)
[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![Codecov test
coverage](https://codecov.io/gh/JeffreyRStevens/ncaavolleyballr/graph/badge.svg)](https://app.codecov.io/gh/JeffreyRStevens/ncaavolleyballr)
<!-- badges: end -->

Inspired by the NCAA data extraction functions from the
[`{baseballr}`](https://billpetti.github.io/baseballr/) package, the
goal of
[`{ncaavolleyballr}`](https://jeffreyrstevens.github.io/ncaavolleyballr/)
is to extract women's and men's volleyball information from the NCAA
website. The functions in this package can extract team
records/schedules and player statistics for the 2020-2024 NCAA women's
and men's divisions I, II, and III volleyball teams. Functions can
aggregate statistics for teams, conferences, divisions, or custom groups
of teams.

## Installation

You can install developmental versions from
[GitHub](https://github.com/) with:

``` r
# install.packages("remotes")
remotes::install_github("JeffreyRStevens/ncaavolleyballr")
```

## Usage

``` r
library(ncaavolleyballr)
```

A suite of functions can be used to extract season, match, and
play-by-play data for teams and players. See the [Getting Started
vignette](https://jeffreyrstevens.github.io/ncaavolleyballr/articles/ncaavolleyballr.html)
for a more thorough description of the functions.

### Season data

The NCAA uses a unique team ID for each women's and men's volleyball
team and season. So to access a team’s season data, first you will need
to get that ID with the `find_team_id()`. For instance, to find the ID
for Penn State's 2024 season:

``` r
find_team_id("Penn St.", 2024)
#> [1] "585406"
```

With this team ID, you can now extract overall season performance data
for the team’s players with the `player_season_stats()`.

``` r
find_team_id("Penn St.", 2024) |> 
  player_season_stats()
#> Warning: No website available for team ID 585406.
```

### Match data

The NCAA also uses a unique contest ID for each women's and men's
volleyball match. The easiest way to get that ID is with
`find_team_contest()`, which returns the contest ID for all matches in a
particular season (using the Team ID provided by `find_team_id()`). For
instance, to find the contest ID for 2024 National Championship match
between Louisville and Penn State:

``` r
find_team_id("Penn St.", 2024) |> 
  find_team_contests() |> 
  tail()
#> Warning: No website available for team ID 585406.
#> NULL
```

    #> Warning: No website available for team ID 585406.

From that, we can see that the contest ID is . If we pass this contest
ID to the `player_match_stats()` function, we’ll get a list with two
data frames—one for each team in the contest—that contain player
statistics for the match. If we want to get just the Penn State player
data, we can set `team = "Penn St."`.

``` r
player_match_stats(contest = "6080706", team = "Penn St.")
#> Warning: No website available for contest 6080706.
```

### Play-by-play data

Play-by-play data are also available with `match_pbp()`. This returns a
data frame with all events and players.

``` r
match_pbp(contest = "6080706") |> 
  head(10)
#> Warning: No website available for contest 6080706.
#> NULL
```

### Other functionality

By default, these functions return information on women's teams, but
they can be set to return men's information by setting `sport = "MVB"`.
You can also aggregate data across conferences, divisions, or custom
groups with `conference_stats()`, `division_stats()`, and
`group_stats()`.

## Citation

To cite
[`{ncaavolleyballr}`](https://jeffreyrstevens.github.io/ncaavolleyballr/),
use:

> Stevens, Jeffrey R. (2025). ncaavolleyballr: Extract data from NCAA
> women's volleyball website. (version 0.3.0)
> <https://github.com/JeffreyRStevens/ncaavolleyballr>

## Acknowledgments

Many thanks to [Bill Petti](https://github.com/BillPetti) for making the
code for NCAA stats extraction freely available in the
[`{baseballr}`](https://billpetti.github.io/baseballr/) package. And
thank you to [Tyler Widdison](https://github.com/widbuntu) for
[inspiring me to extract the play-by-play
data](https://github.com/JeffreyRStevens/ncaavolleyballr/issues/1)
(check out his
[`{ncaavolleyballR}`](https://github.com/tyler-widdison/ncaavolleyballR)
package for some similar functionality).

The volleyball background in the logo was designed by
[Freepik](https://www.freepik.com/free-vector/volleyball-grey-gradient_59539214.htm).
