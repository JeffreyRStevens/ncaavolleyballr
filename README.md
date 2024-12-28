
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
find_team_id("Long Beach St.", 2023, sport = "MVB") |> 
  player_stats() |> 
  knitr::kable()
#> Warning: There was 1 warning in `dplyr::mutate()`.
#> ℹ In argument: `Number = as.numeric(.data$Number)`.
#> Caused by warning:
#> ! NAs introduced by coercion
```

| Number | Player | Yr | Pos | Ht | Hometown | High School | GP | GS | S | MS | Kills | Errors | Total Attacks | Hit Pct | Assists | Aces | SErr | Digs | RErr | Block Solos | Block Assists | BErr | Tripl Dbl | PTS | BHE |
|---:|:---|:---|:---|:---|:---|:---|:---|:---|---:|:---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| 2 | Sebastian Rodriguez | Jr | OH | 6-5 | Hermosa Beach, CA | Redondo Union HS | 8 | 0 | 14 | NA | 4 | NA | 5 | 0.800 | NA | 3 | 3 | 3 | NA | NA | NA | NA | NA | 7.0 | 1 |
| 3 | Mason Briggs | Sr | L | 6-0 | Valencia, CA | Bishop Alemany HS | 30 | 0 | 107 | NA | 1 | NA | 2 | 0.500 | 60 | NA | NA | 239 | 25 | NA | NA | NA | NA | 1.0 | NA |
| 4 | Skyler Varga | Jr | OH | 6-7 |  | Muenster Public HS | 27 | 27 | 95 | NA | 283 | 116 | 636 | 0.263 | 17 | 33 | 71 | 128 | 7 | 2 | 80 | 9 | NA | 358.0 | NA |
| 5 | Aidan Knipe | Sr | S | 6-3 | Huntington Beach, CA | Huntington Beach HS | 27 | 27 | 98 | NA | 12 | 7 | 35 | 0.143 | 1007 | 5 | 18 | 153 | NA | 4 | 63 | 4 | NA | 52.5 | 2 |
| 6 | Ben Braun | So | MB | 6-11 | Rancho Mirage, CA | Palm Desert HS | 4 | 1 | 7 | NA | 3 | NA | 6 | 0.500 | NA | 2 | 7 | NA | NA | 2 | 8 | NA | NA | 11.0 | NA |
| 8 | Sotiris Siapanis | Jr | OH | 6-3 | Limassol, Cyprus | The Grammar School | 27 | 27 | 97 | NA | 308 | 83 | 658 | 0.342 | 41 | 29 | 53 | 139 | 22 | 2 | 59 | 14 | NA | 368.5 | NA |
| 9 | Nathan Harlan | Sr | OH | 6-4 | Ladera Ranch, CA | Tesoro HS | 29 | 10 | 103 | NA | 109 | 32 | 244 | 0.316 | 21 | 26 | 61 | 60 | 11 | 6 | 21 | 2 | NA | 151.5 | NA |
| 10 | Connor Bloom | So | OH | 6-5 | Huntington Beach, CA | Orange Lutheran HS | 26 | 1 | 71 | NA | 8 | 4 | 18 | 0.222 | NA | 7 | 24 | 11 | NA | NA | 8 | NA | NA | 19.0 | NA |
| 11 | Simon Torwie | Sr | MB | 6-10 |  |  | 26 | 26 | 94 | NA | 129 | 24 | 246 | 0.427 | 3 | 33 | 75 | 29 | NA | 15 | 111 | 15 | NA | 232.5 | 1 |
| 12 | Clarke Godbold | Sr | OPP | 6-5 | San Pedro, CA | Palos Verdes Peninsula HS | 22 | 19 | 74 | NA | 239 | 67 | 511 | 0.337 | 11 | 20 | 59 | 52 | 16 | 6 | 58 | 3 | NA | 294.0 | NA |
| 13 | Island Doty | So | S | 6-5 | Colorado Springs, CO | Doherty HS | 4 | 3 | 10 | NA | 4 | NA | 4 | 1.000 | 62 | 2 | 3 | 12 | NA | 1 | 3 | NA | NA | 8.5 | 1 |
| 17 | Dane Hillis | So | OH | 6-3 | San Clemente, CA | San Clemente HS | 14 | 0 | 26 | NA | 3 | NA | 9 | 0.333 | 2 | 2 | 9 | 3 | 2 | NA | 2 | NA | NA | 6.0 | NA |
| 18 | Nato Dickinson | Jr | OPP | 6-7 | Corona Del Mar, CA | Corona Del Mar HS | 26 | 1 | 59 | NA | 13 | 2 | 21 | 0.524 | 7 | 3 | 7 | 11 | NA | NA | 9 | 1 | NA | 20.5 | NA |
| 19 | DiAeris McRaven | Jr | MB | 6-5 | Honolulu, HI | Moanalua HS | 20 | 16 | 58 | NA | 75 | 21 | 124 | 0.435 | 3 | 1 | 15 | 13 | 1 | 5 | 53 | 9 | NA | 107.5 | NA |
| 20 | Aidan Grosz | Sr | MB | 6-6 | Long Beach, CA | St. Anthony HS | 2 | 1 | 4 | NA | 7 | NA | 7 | 1.000 | NA | 1 | NA | 4 | NA | 1 | 4 | NA | NA | 11.0 | NA |
| 21 | Sebastiano Sani | Fr | OH | 6-8 | Bethesda, MD | Walter Johnson HS | 12 | 2 | 21 | NA | 23 | 7 | 38 | 0.421 | 2 | 5 | 14 | 8 | NA | 1 | 5 | NA | NA | 31.5 | 1 |
| 22 | Caden Jackson | Jr | L | 6-0 | Laguna Niguel, CA | Dana Hills HS | 2 | 0 | 4 | NA | NA | NA | NA | NA | NA | 1 | NA | NA | NA | NA | NA | NA | NA | 1.0 | NA |
| 23 | Derek Owens | Sr | MB | 6-7 | Minneapolis, MN | Andover HS | 1 | 0 | 2 | NA | 5 | NA | 9 | 0.556 | NA | NA | 1 | NA | NA | NA | 1 | NA | NA | 5.5 | NA |
| 24 | Noah Robin | Jr | MB | 6-7 | Huntington Beach, CA | Huntington Beach HS | 1 | 1 | 3 | NA | 2 | 1 | 5 | 0.200 | NA | NA | 1 | NA | NA | NA | 4 | NA | NA | 4.0 | NA |
| 26 | Eric Beebe | Sr | S | 6-0 | Anthem, AZ | Boulder Creek HS | 4 | 0 | 10 | NA | NA | NA | NA | NA | 23 | NA | NA | 6 | NA | NA | 1 | NA | NA | 0.5 | NA |
| 27 | Lazar Bouchkov | Fr | MB | 6-6 | Sofia, Bulgaria | Vasil Levski Sport School | 17 | 15 | 56 | NA | 70 | 13 | 122 | 0.467 | 4 | NA | 18 | 8 | NA | 6 | 68 | 6 | NA | 110.0 | NA |
| 28 | Chris Connelly | Fr | L | 5-10 | Naples, FL | Gulf Coast HS | 22 | 0 | 76 | NA | NA | NA | NA | NA | NA | NA | NA | 3 | NA | NA | NA | NA | NA | NA | NA |
| 29 | Josh Weyerhaeuser | Fr | MB | 6-7 | Gurnee, IL | Warren Township HS | 2 | 0 | 2 | NA | 1 | 1 | 2 | 0.000 | NA | NA | NA | 2 | NA | NA | 1 | NA | NA | 1.5 | NA |
| 31 | Daniil Hershtynovich | Fr | OPP | 6-9 | Toronto, Canada | Hodan Nalayeh | 9 | 3 | 15 | NA | 26 | 7 | 43 | 0.442 | 3 | 4 | 8 | 5 | 1 | 1 | 7 | 1 | NA | 34.5 | NA |
| NA | TEAM | \- | \- | \- | NA | NA | \- | \- | NA | NA | NA | NA | NA | NA | NA | NA | NA | NA | 8 | NA | NA | NA | NA | NA | NA |
| NA | Totals | \- | \- | \- | NA | NA | \- | \- | 107 | NA | 1325 | 385 | 2745 | 0.342 | 1266 | 177 | 447 | 889 | 93 | 52 | 566 | 64 | 30 | 1837.0 | 6 |
| NA | Opponent Totals | \- | \- | \- | NA | NA | \- | \- | 107 | NA | 1157 | 593 | 2906 | 0.194 | 1111 | 93 | 467 | 852 | 177 | 21 | 292 | 52 | 29 | 1417.0 | 8 |

## Citation

To cite `{volleyballr}`, use:

> Stevens, Jeffrey R. (2024). volleyballr: Extract data from NCAA
> women’s volleyball website. (version 0.1.0)
> <https://github.com/JeffreyRStevens/volleyballr>
