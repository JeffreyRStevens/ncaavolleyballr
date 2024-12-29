
<!-- README.md is generated from README.Rmd. Please edit that file -->

# volleyballr

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
<!-- badges: end -->

The goal of `{volleyballr}` is to extract women’s and men’s volleyball
information from the NCAA website.

## Installation

You can install developmental versions from
[GitHub](https://github.com/) with:

``` r
# install.packages("remotes")
remotes::install_github("JeffreyRStevens/volleyballr")
```

## Usage

``` r
library(volleyballr)
```

The NCAA uses a unique team ID for each women’s and men’s volleyball
team and each season. So first you will need to get that ID with the
`find_team_id()`. For instance, to find the ID for University of
Nebraska’s 2024 season:

``` r
find_team_id("Nebraska", 2024)
#> [1] "585290"
```

With this team ID, you can now extract team information about the arena,
coach, record, and schedule.

``` r
team_info <- find_team_id("Nebraska", 2024) |> 
  team_season()
team_info$arena
#>                  Arena name                    Capacity 
#> "Bob Devaney Sports Center"                     "7,907" 
#>                  Year built 
#>                      "1975"
team_info$coach
#>               Name         Alma mater            Seasons             Record 
#>        "John Cook" "San Diego - 1979"               "32"          "883-176"
team_info$record
#>      Overall record      Overall streak   Conference record   Conference streak 
#>      "33-3 (0.917)"        "Streak: L1"      "19-1 (0.950)"        "Streak: L1" 
#>         Home record         Home streak         Road record         Road streak 
#>      "22-0 (1.000)"       "Streak: W45"      "10-2 (0.833)"        "Streak: W1" 
#>      Neutral record      Neutral streak Non-division record Non-division streak 
#>       "1-1 (0.500)"        "Streak: L1"       "0-0 (0.000)"         "Streak: 0"
team_info$schedule
#> # A tibble: 36 × 4
#>    Date       Opponent                 Result Attendance
#>    <chr>      <chr>                    <chr>  <chr>     
#>  1 08/27/2024 Kentucky @Louisville, KY W 3-1  9,280     
#>  2 08/30/2024 A&M-Corpus Christi       W 3-0  8,956     
#>  3 08/31/2024 TCU                      W 3-1  8,695     
#>  4 09/03/2024 @ SMU                    L 0-3  6,773     
#>  5 09/05/2024 The Citadel              W 3-0  8,607     
#>  6 09/07/2024 Montana St.              W 3-0  8,456     
#>  7 09/10/2024 Creighton                W 3-2  8,924     
#>  8 09/13/2024 Arizona St.              W 3-0  8,772     
#>  9 09/14/2024 Wichita St.              W 3-0  8,541     
#> 10 09/18/2024 Stanford                 W 3-0  8,952     
#> # ℹ 26 more rows
```

There is also roster and overall season performance data on individual
players.

``` r
find_team_id("Nebraska", 2024) |> 
  player_stats() |> 
  knitr::kable()
#> Warning: There was 1 warning in `dplyr::mutate()`.
#> ℹ In argument: `Number = as.numeric(.data$Number)`.
#> Caused by warning:
#> ! NAs introduced by coercion
```

| Number | Player | Yr | Pos | Ht | Hometown | High School | GP | GS | S | Kills | Errors | Total Attacks | Hit Pct | Assists | Aces | SErr | Digs | RetAtt | RErr | Block Solos | Block Assists | BErr | PTS | BHE | Trpl Dbl |
|---:|:---|:---|:---|:---|:---|:---|:---|:---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| 2 | Bergen Reilly | So | S | 6-1 | Sioux Falls, SD | O’Gorman | 36 | 36 | 122 | 81 | 14 | 175 | 0.383 | 1352 | 21 | 37 | 348 | 4 | NA | 3 | 59 | 8 | 134.5 | NA | NA |
| 5 | Rebekah Allick | Jr | MB | 6-4 | Lincoln, NE | Waverly | 35 | 34 | 109 | 198 | 57 | 395 | 0.357 | 9 | NA | NA | 34 | 5 | 1 | 19 | 137 | 13 | 285.5 | NA | NA |
| 6 | Laney Choboy | So | L/DS | 5-3 | Raleigh, NC | Leesville Road | 36 | 0 | 121 | 0 | 0 | 3 | 0.000 | 36 | NA | 1 | 185 | 311 | 10 | NA | NA | NA | NA | NA | NA |
| 7 | Maisie Boesiger | Jr | L/DS | 5-6 | Firth, NE | Norris | 9 | 0 | 13 | 0 | 0 | 0 | NA | NA | NA | NA | 6 | 1 | NA | NA | NA | NA | NA | NA | NA |
| 8 | Lexi Rodriguez | Sr | L/DS | 5-5 | Sterling, IL | Sterling | 36 | 0 | 122 | 0 | 0 | 8 | 0.000 | 127 | 17 | 23 | 473 | 431 | 16 | NA | NA | NA | 17.0 | NA | NA |
| 9 | Kennedi Orr | Sr | S | 6-0 | Eagan, MN | Eagan | 35 | 0 | 112 | 0 | 0 | 1 | 0.000 | 2 | 10 | 23 | 63 | NA | NA | NA | NA | NA | 10.0 | NA | NA |
| 10 | Olivia Mauch | Fr | L/DS | 5-6 | Bennington, NE | Bennington | 36 | 4 | 122 | 0 | 0 | 0 | NA | 13 | 21 | 18 | 196 | 412 | 17 | NA | NA | NA | 21.0 | NA | NA |
| 11 | Leyla Blackwell | Sr | MB | 6-4 | San Diego, CA | La Jolla | 13 | 4 | 23 | 54 | 11 | 103 | 0.417 | 4 | NA | NA | 4 | 5 | NA | 2 | 27 | 1 | 69.5 | NA | NA |
| 12 | Taylor Landfair | Sr | OH | 6-5 | Plainfield, IL | Plainfield Central | 33 | 20 | 88 | 219 | 90 | 600 | 0.215 | 3 | 1 | 3 | 44 | 73 | 3 | 1 | 49 | 3 | 245.5 | 1 | NA |
| 13 | Merritt Beason | Sr | OH | 6-4 | Gardendale, AL | Gardendale | 36 | 36 | 122 | 339 | 133 | 883 | 0.233 | 16 | 30 | 37 | 150 | 17 | 1 | 6 | 104 | 8 | 427.0 | NA | NA |
| 15 | Andi Jackson | So | MB | 6-3 | Brighton, CO | Brighton | 34 | 34 | 114 | 299 | 73 | 515 | 0.439 | 2 | 1 | 5 | 26 | 2 | NA | 12 | 122 | 4 | 373.0 | NA | NA |
| 22 | Lindsay Krause | Sr | OH | 6-4 | Papillion, NE | Skutt Catholic | 24 | 12 | 50 | 120 | 43 | 336 | 0.229 | 2 | 15 | 12 | 33 | 54 | 3 | 3 | 23 | 3 | 149.5 | NA | NA |
| 27 | Harper Murray | So | OH | 6-2 | Ann Arbor, MI | Skyline | 36 | 36 | 121 | 411 | 130 | 1095 | 0.257 | 30 | 39 | 34 | 294 | 598 | 23 | 5 | 60 | 10 | 485.0 | NA | NA |
| NA | TEAM | \- | \- | \- | NA | NA | \- | \- | NA | NA | NA | NA | NA | NA | NA | NA | NA | NA | 7 | NA | NA | NA | NA | NA | NA |
| NA | Totals | \- | \- | \- | NA | NA | \- | \- | 122 | 1721 | 551 | 4114 | 0.284 | 1596 | 155 | 193 | 1856 | 1920 | 81 | 51 | 581 | 50 | 2217.5 | 1 | 36 |
| NA | Opponent Totals | \- | \- | \- | NA | NA | \- | \- | 122 | 1376 | 749 | 4377 | 0.143 | 1321 | 81 | 342 | 1539 | 2748 | 155 | 34 | 375 | 49 | 1678.5 | 1 | 36 |

By default, these functions return information on women’s teams, but
they can be set to return men’s information.

``` r
find_team_id("UCLA", 2023, sport = "MVB") |> 
  player_stats() |> 
  knitr::kable()
#> Warning: There was 1 warning in `dplyr::mutate()`.
#> ℹ In argument: `Number = as.numeric(.data$Number)`.
#> Caused by warning:
#> ! NAs introduced by coercion
```

| Number | Player | Yr | Pos | Ht | GP | GS | S | MS | Kills | Errors | Total Attacks | Hit Pct | Assists | Aces | SErr | Digs | RErr | Block Solos | Block Assists | BErr | Tripl Dbl | PTS | BHE |
|---:|:---|:---|:---|:---|:---|:---|---:|:---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| 1 | Hideharu Nakamura | Jr | L | 5-10 | 5 | 0 | 20 | NA | NA | NA | NA | NA | 1 | NA | NA | 21 | 2 | NA | NA | NA | NA | NA | NA |
| 3 | Luca Curci | Fr | OH | 6-3 | 17 | 0 | 46 | NA | 9 | 5 | 18 | 0.222 | 5 | 2 | 12 | 27 | 6 | NA | NA | NA | NA | 11.0 | NA |
| 7 | Andrew Rowan | So | S | 6-6 | 30 | 30 | 115 | NA | 52 | 13 | 100 | 0.390 | 1157 | 40 | 123 | 134 | 2 | 1 | 62 | 6 | NA | 124.0 | 1 |
| 8 | Micah Wong Diallo | Fr | MB | 6-9 | 1 | 1 | 3 | NA | 6 | NA | 8 | 0.750 | NA | NA | 1 | 1 | NA | NA | 4 | NA | NA | 8.0 | NA |
| 9 | Guy Genis | Jr | MB | 6-5 | 20 | 16 | 69 | NA | 86 | 16 | 156 | 0.449 | 8 | 2 | 20 | 25 | 1 | 3 | 67 | 8 | NA | 124.5 | NA |
| 10 | Sean McQuiggan | Jr | MB | 6-9 | 17 | 14 | 53 | NA | 72 | 15 | 116 | 0.491 | 2 | 8 | 19 | 15 | NA | 7 | 51 | 5 | NA | 112.5 | 1 |
| 11 | Cooper Robinson | Jr | OH | 6-7 | 28 | 25 | 95 | NA | 250 | 82 | 506 | 0.332 | 39 | 35 | 86 | 73 | 26 | 5 | 59 | 6 | NA | 319.5 | NA |
| 12 | Alex Knight | Sr | OH | 6-5 | 27 | 8 | 91 | NA | 89 | 25 | 183 | 0.350 | 25 | 8 | 19 | 70 | 25 | NA | 24 | 2 | NA | 109.0 | NA |
| 13 | Merrick McHenry | Sr | OH | 6-7 | 30 | 30 | 115 | NA | 217 | 27 | 325 | 0.585 | 9 | 38 | 98 | 68 | 2 | 7 | 107 | 6 | NA | 315.5 | NA |
| 14 | Matthew Aziz | Jr | L | 6-1 | 13 | 0 | 48 | NA | NA | NA | NA | NA | 5 | NA | NA | 71 | NA | NA | NA | NA | NA | NA | NA |
| 16 | Ido David | Jr | OPP | 6-7 | 28 | 18 | 87 | NA | 165 | 62 | 379 | 0.272 | 11 | 35 | 60 | 96 | 1 | 4 | 40 | 2 | NA | 224.0 | 1 |
| 17 | David Flores | Sr | S | 6-2 | 22 | 1 | 39 | NA | NA | NA | NA | NA | 76 | NA | 1 | 10 | NA | NA | 2 | NA | NA | 1.0 | NA |
| 18 | Grant Sloane | Sr | OH | 6-8 | 25 | 13 | 76 | NA | 137 | 47 | 295 | 0.305 | 8 | 21 | 36 | 66 | 1 | 3 | 32 | 3 | NA | 177.0 | 2 |
| 19 | David Decker | So | OPP | 6-8 | 5 | 0 | 6 | NA | 3 | NA | 3 | 1.000 | NA | 1 | 1 | 2 | NA | NA | 2 | NA | NA | 5.0 | NA |
| 20 | Ethan Champlin | Sr | OH | 6-3 | 30 | 24 | 112 | NA | 270 | 80 | 561 | 0.339 | 48 | 21 | 71 | 167 | 23 | 3 | 45 | 5 | NA | 316.5 | NA |
| 21 | Zach Rama | So | OH | 6-8 | 25 | 5 | 64 | NA | 140 | 40 | 272 | 0.368 | 17 | 13 | 40 | 49 | 16 | 4 | 25 | 4 | NA | 169.5 | 2 |
| 22 | Matthew Edwards | Jr | MB | 6-9 | 3 | 1 | 4 | NA | 4 | NA | 4 | 1.000 | NA | NA | 1 | NA | NA | NA | NA | NA | NA | 4.0 | NA |
| 23 | Coleman McDonough | So | L | 5-11 | 15 | 0 | 43 | NA | NA | NA | NA | NA | 2 | NA | 4 | 22 | 4 | NA | NA | NA | NA | NA | NA |
| NA | TEAM | \- | \- | \- | \- | \- | NA | NA | NA | NA | NA | NA | NA | NA | NA | NA | 14 | NA | NA | NA | NA | NA | NA |
| NA | Totals | \- | \- | \- | \- | \- | 118 | NA | 1500 | 412 | 2926 | 0.372 | 1413 | 224 | 592 | 917 | 123 | 37 | 520 | 47 | 31 | 2021.0 | 7 |
| NA | Opponent Totals | \- | \- | \- | \- | \- | 118 | NA | 1224 | 546 | 2925 | 0.232 | 1136 | 122 | 489 | 809 | 224 | 39 | 289 | 41 | 30 | 1529.5 | 5 |

## Citation

To cite `{volleyballr}`, use:

> Stevens, Jeffrey R. (2024). volleyballr: Extract data from NCAA
> women’s volleyball website. (version 0.1.0)
> <https://github.com/JeffreyRStevens/volleyballr>
