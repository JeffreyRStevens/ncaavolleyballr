
<!-- README.md is generated from README.Rmd. Please edit that file -->

# ncaavolleyballr <a href="https://jeffreyrstevens.github.io/ncaavolleyballr/"><img src="man/figures/logo.png" align="right" height="139" alt="ncaavolleyballr website" /></a>

<!-- badges: start -->

[![Project Status: Active – The project has reached a stable, usable
state and is being actively
developed.](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/#active)
[![Lifecycle:
stable](https://img.shields.io/badge/lifecycle-stable-brightgreen.svg)](https://lifecycle.r-lib.org/articles/stages.html#stable)
[![CRAN
status](https://www.r-pkg.org/badges/version/ncaavolleyballr)](https://CRAN.R-project.org/package=ncaavolleyballr)
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

You can install the stable released version of flashr from
[CRAN](https://cran.r-project.org/package=ncaavolleyballr) with:

``` r
install.packages("ncaavolleyballr")
```

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
team and season. So to access a team's season data, first you will need
to get that ID with the `find_team_id()`. For instance, to find the ID
for Penn State's 2024 season:

``` r
find_team_id("Penn St.", 2024)
#> [1] "585406"
```

With this team ID, you can now extract overall season performance data
for the team's players with the `player_season_stats()`.

``` r
find_team_id("Penn St.", 2024) |> 
  player_season_stats()
```

<div class="kable-table">

| Season | Team | Conference | Number | Player | Yr | Pos | Ht | Hometown | High School | GP | GS | S | Kills | Errors | Total Attacks | Hit Pct | Assists | Aces | SErr | Digs | RetAtt | RErr | Block Solos | Block Assists | BErr | PTS | BHE | Trpl Dbl |
|:---|:---|:---|---:|:---|:---|:---|:---|:---|:---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| 2024-2025 | Penn St. | Big Ten | 1 | Taylor Trammell | Sr | MB | 6-2 | Lexington, KY | Henry Clay | 37 | 37 | 130 | 260 | 48 | 480 | 0.442 | 3 | 1 | 5 | 25 | 14 | 4 | 11 | 124 | 7 | 334.0 | NA | NA |
| 2024-2025 | Penn St. | Big Ten | 2 | Ava Falduto | Fr | L/DS | 5-7 | Elmhurst, IL | IC Catholic Prep | 37 | 3 | 135 | 0 | 0 | 7 | 0.000 | 70 | 39 | 43 | 310 | 543 | 21 | NA | NA | NA | 39.0 | NA | NA |
| 2024-2025 | Penn St. | Big Ten | 3 | Gillian Grimes | Jr | L/DS | 5-6 | Westchester, IL | Nazareth Academy | 37 | 0 | 135 | 4 | 0 | 11 | 0.364 | 163 | 38 | 55 | 529 | 551 | 29 | NA | NA | NA | 42.0 | NA | NA |
| 2024-2025 | Penn St. | Big Ten | 4 | Karis Willow | So | OH | 6-4 | Arlington, OH | Liberty Benton | 2 | 0 | 2 | 2 | 2 | 6 | 0.000 | NA | NA | NA | NA | 5 | NA | NA | NA | NA | 2.0 | NA | NA |
| 2024-2025 | Penn St. | Big Ten | 5 | Jordan Hopp | Sr | MB | 6-2 | Alliance, NE | Alliance | 10 | 0 | 19 | 12 | 7 | 31 | 0.161 | NA | NA | NA | 2 | 1 | NA | 2 | 18 | NA | 23.0 | NA | NA |
| 2024-2025 | Penn St. | Big Ten | 6 | Kate Lally | So | DS | 5-9 | State College, PA | State College | 3 | 0 | 3 | 0 | 0 | 0 | NA | NA | NA | NA | NA | NA | NA | NA | NA | NA | NA | NA | NA |
| 2024-2025 | Penn St. | Big Ten | 8 | Camryn Hannah | Sr | OH | 6-2 | Lansing, IL | Marist | 37 | 4 | 133 | 480 | 179 | 1052 | 0.286 | 4 | 28 | 67 | 113 | 129 | 9 | 9 | 31 | 3 | 532.5 | NA | NA |
| 2024-2025 | Penn St. | Big Ten | 9 | Jess Mruzik | Sr | OH | 6-1 | Livonia, MI | Farmington Hills Mercy | 37 | 37 | 130 | 565 | 178 | 1497 | 0.259 | 51 | 32 | 55 | 313 | 693 | 35 | 17 | 51 | 5 | 639.5 | 1 | NA |
| 2024-2025 | Penn St. | Big Ten | 10 | Anjelina Starck | Sr | OH | 6-2 | Colorado Springs, CO | Rampart | 29 | 24 | 92 | 24 | 15 | 94 | 0.096 | 19 | 7 | 1 | 146 | 293 | 18 | NA | 6 | NA | 34.0 | NA | NA |
| 2024-2025 | Penn St. | Big Ten | 11 | Jocelyn Nathan | So | L/DS | 5-6 | Wilmington, DE | Wilmington Friends School | 22 | 10 | 59 | 0 | 0 | 0 | NA | 10 | 7 | 7 | 69 | 146 | 10 | NA | NA | NA | 7.0 | NA | NA |
| 2024-2025 | Penn St. | Big Ten | 14 | Caroline Jurevicius | Fr | RS | 6-2 | Cleveland, OH | Notre Dame-Cathedral Latin | 36 | 31 | 123 | 248 | 105 | 580 | 0.247 | 6 | NA | 4 | 54 | NA | NA | 3 | 78 | 2 | 290.0 | NA | NA |
| 2024-2025 | Penn St. | Big Ten | 19 | Alexa Markley | Jr | OH | 6-2 | Peachtree City, GA | McIntosh | 11 | 2 | 21 | 23 | 8 | 61 | 0.246 | NA | NA | 1 | 7 | 4 | 1 | 1 | 9 | 1 | 28.5 | NA | NA |
| 2024-2025 | Penn St. | Big Ten | 21 | Izzy Starck | Fr | S | 6-1 | Viera, FL | Viera | 37 | 37 | 135 | 112 | 37 | 280 | 0.268 | 1483 | 19 | 43 | 342 | 5 | 1 | 1 | 98 | 5 | 181.0 | 3 | NA |
| 2024-2025 | Penn St. | Big Ten | 23 | Catherine Burke | So | MB | 6-3 | Glenview, IL | Loyola Academy | 4 | 0 | 4 | 0 | 0 | 4 | 0.000 | NA | NA | 1 | NA | NA | NA | NA | 2 | NA | 1.0 | NA | NA |
| 2024-2025 | Penn St. | Big Ten | 24 | Quinn Menger | Sr | DS | 5-9 | Powhatan, VA | St. Catherine's School | 37 | 1 | 122 | 0 | 0 | 2 | 0.000 | 17 | 28 | 27 | 38 | NA | NA | NA | NA | NA | 28.0 | NA | NA |
| 2024-2025 | Penn St. | Big Ten | 44 | Maggie Mendelson | Jr | MB | 6-5 | North Ogden, UT | Fremont | 37 | 36 | 127 | 242 | 69 | 568 | 0.305 | 15 | 4 | 15 | 46 | 25 | 1 | 18 | 128 | 7 | 328.0 | NA | NA |
| 2024-2025 | Penn St. | Big Ten | NA | TEAM | \- | \- | \- | NA | NA | NA | NA | NA | NA | NA | NA | NA | NA | NA | NA | NA | NA | 11 | NA | NA | NA | NA | NA | NA |
| 2024-2025 | Penn St. | Big Ten | NA | Totals | \- | \- | \- | NA | NA | NA | NA | 135 | 1972 | 648 | 4673 | 0.283 | 1841 | 203 | 324 | 1994 | 2420 | 140 | 62 | 545 | 30 | 2509.5 | 4 | 37 |
| 2024-2025 | Penn St. | Big Ten | NA | Opponent Totals | \- | \- | \- | NA | NA | NA | NA | 135 | 1535 | 710 | 4593 | 0.180 | 1458 | 140 | 281 | 1716 | 2853 | 203 | 52 | 449 | 68 | 1951.5 | 5 | 37 |

</div>

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
```

<div class="kable-table">

| date       | team     | opponent       | result | attendance | contest |
|:-----------|:---------|:---------------|:-------|-----------:|:--------|
| 12/06/2024 | Penn St. | Delaware St.   | W 3-0  |       2516 | 6080734 |
| 12/07/2024 | Penn St. | North Carolina | W 3-1  |       2470 | 6080733 |
| 12/13/2024 | Penn St. | Marquette      | W 3-1  |       2914 | 6081048 |
| 12/15/2024 | Penn St. | Creighton      | W 3-2  |       3558 | 6081042 |
| 12/19/2024 | Penn St. | Nebraska       | W 3-2  |      21726 | 6080708 |
| 12/22/2024 | Penn St. | Louisville     | W 3-1  |      21860 | 6080706 |

</div>

From that, we can see that the contest ID is 6080706. If we pass this
contest ID to the `player_match_stats()` function, we'll get a list with
two data frames (one for each team in the contest) that contain player
statistics for the match. If we want to get just the Penn State player
data, we can set `team = "Penn St."`.

``` r
player_match_stats(contest = "6080706", team = "Penn St.")
```

<div class="kable-table">

| Season | Date | Team | Conference | Opponent Team | Opponent Conference | Location | Number | Player | P | S | Kills | Errors | TotalAttacks | HitPct | Assists | Aces | SErr | Digs | RetAtt | RErr | BlockSolos | BlockAssists | BErr | PTS | BHE |
|:---|:---|:---|:---|:---|:---|:---|---:|:---|:---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| 2024-2025 | 2024-12-22 | Penn St. | Big Ten | Louisville | ACC | Home | 2 | Ava Falduto | L/DS | 4 | 0 | 0 | 0 | 0.000 | 2 | 2 | 1 | 14 | 24 | 0 | 0 | 0 | 0 | 2.0 | 0 |
| 2024-2025 | 2024-12-22 | Penn St. | Big Ten | Louisville | ACC | Home | 3 | Gillian Grimes | L/DS | 4 | 0 | 0 | 0 | 0.000 | 7 | 1 | 3 | 16 | 23 | 1 | 0 | 0 | 0 | 1.0 | 0 |
| 2024-2025 | 2024-12-22 | Penn St. | Big Ten | Louisville | ACC | Home | 8 | Camryn Hannah | OH | 4 | 19 | 9 | 42 | 0.238 | 0 | 1 | 4 | 3 | 9 | 2 | 1 | 1 | 0 | 21.5 | 0 |
| 2024-2025 | 2024-12-22 | Penn St. | Big Ten | Louisville | ACC | Home | 14 | Caroline Jurevicius | OH | 4 | 10 | 4 | 26 | 0.231 | 0 | 0 | 0 | 3 | 0 | 0 | 0 | 2 | 0 | 11.0 | 0 |
| 2024-2025 | 2024-12-22 | Penn St. | Big Ten | Louisville | ACC | Home | 44 | Maggie Mendelson | MB | 4 | 6 | 1 | 14 | 0.357 | 1 | 0 | 0 | 1 | 0 | 0 | 1 | 5 | 0 | 9.5 | 0 |
| 2024-2025 | 2024-12-22 | Penn St. | Big Ten | Louisville | ACC | Home | 24 | Quinn Menger | DS | 4 | 0 | 0 | 0 | 0.000 | 0 | 0 | 1 | 4 | 0 | 0 | 0 | 0 | 0 | 0.0 | 0 |
| 2024-2025 | 2024-12-22 | Penn St. | Big Ten | Louisville | ACC | Home | 9 | Jess Mruzik | OH | 4 | 29 | 6 | 73 | 0.315 | 1 | 1 | 1 | 14 | 22 | 1 | 1 | 4 | 2 | 33.0 | 1 |
| 2024-2025 | 2024-12-22 | Penn St. | Big Ten | Louisville | ACC | Home | 11 | Jocelyn Nathan | L/DS | 4 | 0 | 0 | 0 | 0.000 | 3 | 1 | 0 | 10 | 10 | 0 | 0 | 0 | 0 | 1.0 | 0 |
| 2024-2025 | 2024-12-22 | Penn St. | Big Ten | Louisville | ACC | Home | 21 | Izzy Starck | S | 4 | 0 | 2 | 7 | -0.286 | 55 | 1 | 3 | 13 | 0 | 0 | 0 | 1 | 0 | 1.5 | 0 |
| 2024-2025 | 2024-12-22 | Penn St. | Big Ten | Louisville | ACC | Home | 1 | Taylor Trammell | MB | 4 | 8 | 1 | 15 | 0.467 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 3 | 0 | 9.5 | 0 |
| 2024-2025 | 2024-12-22 | Penn St. | Big Ten | Louisville | ACC | Home | NA | TEAM |  | 0 | 0 | 0 | 0 | 0.000 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0.0 | 0 |
| 2024-2025 | 2024-12-22 | Penn St. | Big Ten | Louisville | ACC | Home | NA | Penn St. |  | 4 | 72 | 23 | 177 | 0.277 | 69 | 7 | 13 | 78 | 88 | 4 | 3 | 16 | 2 | 90.0 | 1 |

</div>

### Play-by-play data

Play-by-play data are also available with `match_pbp()`. This returns a
data frame with all events and players.

``` r
match_pbp(contest = "6080706") |> 
  head(10)
```

<div class="kable-table">

| set | away_team | home_team | score | team | event | player | description |
|:---|:---|:---|:---|:---|:---|:---|:---|
| 1 | Louisville | Penn St. | 0-0 | Louisville | Serve | Payton Petersen | Payton Petersen serves |
| 1 | Louisville | Penn St. | 0-0 | Penn St. | Reception | Jocelyn Nathan | Reception by Jocelyn Nathan |
| 1 | Louisville | Penn St. | 0-0 | Penn St. | Set | Izzy Starck | Set by Izzy Starck |
| 1 | Louisville | Penn St. | 0-0 | Penn St. | Attack | Taylor Trammell | Attack by Taylor Trammell |
| 1 | Louisville | Penn St. | 0-1 | Penn St. | First ball kill | Taylor Trammell | First ball kill by Taylor Trammell |
| 1 | Louisville | Penn St. | 0-1 | Penn St. | Serve | Gillian Grimes | Gillian Grimes serves |
| 1 | Louisville | Penn St. | 0-1 | Louisville | Reception | Payton Petersen | Reception by Payton Petersen |
| 1 | Louisville | Penn St. | 0-1 | Louisville | Set | Elle Glock | Set by Elle Glock |
| 1 | Louisville | Penn St. | 0-1 | Louisville | Attack | Cara Cresse | Attack by Cara Cresse |
| 1 | Louisville | Penn St. | 1-1 | Louisville | First ball kill | Cara Cresse | First ball kill by Cara Cresse |

</div>

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

Stevens JR (2025). *Extract Data from NCAA Women’s and Men’s Volleyball
Website*. R package version 0.4.2,
<https://github.com/JeffreyRStevens/ncaavolleyballr>.

## Acknowledgments

Many thanks to [Bill Petti](https://github.com/BillPetti) for making the
code for NCAA stats extraction freely available in the
[`{baseballr}`](https://billpetti.github.io/baseballr/) package. And
thank you to [Tyler Widdison](https://github.com/widbuntu) for
[inspiring me to extract the play-by-play
data](https://github.com/JeffreyRStevens/ncaavolleyballr/issues/1)
(check out his
[`{ncaavolleyballR}`](https://github.com/tyler-widdison/ncaavolleyballR)
package for some similar functionality). Code from
[`{baseballr}`](https://billpetti.github.io/baseballr/) and
[`{rvest}`](https://rvest.tidyverse.org/) (both licensed under an MIT
license) have been incorporated and modified in this package.

The volleyball background in the logo was designed by
[Freepik](https://www.freepik.com/free-vector/volleyball-grey-gradient_59539214.htm).
