# Get started

``` r
library(ncaavolleyballr)
```

The NCAA has a lot of sports stats available at
<https://stats.ncaa.org>. This package focuses on volleyball, though
some of the functions can be used for other sports (e.g.,
[`get_teams()`](https://jeffreyrstevens.github.io/ncaavolleyballr/reference/get_teams.md)).
The sport code for selecting women’s volleyball is “WVB” and men’s is
“MVB”. Once you pick one of those, you can access season, match, and
play-by-play stats for players and teams.

## Finding teams

The NCAA uses a unique team ID for each women's and men's volleyball
team and each season. So first you will need to get that ID with the
[`find_team_id()`](https://jeffreyrstevens.github.io/ncaavolleyballr/reference/find_team_id.md).
I'll use Nebraska to illustrate the functions in
[`{ncaavolleyballr}`](https://jeffreyrstevens.github.io/ncaavolleyballr/).

However, before we find the team ID, we first have to know the exact
team name that the NCAA uses to reference each team. Is Nebraska’s team
name Nebraska, Neb., University of Nebraska-Lincoln, UNL, or something
else? We can use
[`find_team_name()`](https://jeffreyrstevens.github.io/ncaavolleyballr/reference/find_team_name.md)
to get a vector of teams that match a pattern.

``` r
find_team_name("Neb")
#> [1] "Neb. Wesleyan" "Neb.-Kearney"  "Nebraska"
```

Looks like it’s “Nebraska”. So now we can pass that to
[`find_team_id()`](https://jeffreyrstevens.github.io/ncaavolleyballr/reference/find_team_id.md)
along with the year that we’re interested in. This function queries two
data sets that ship with this package: `wvb_teams` and `mvb_teams`.
These two data sets are simply the output of the
[`get_teams()`](https://jeffreyrstevens.github.io/ncaavolleyballr/reference/get_teams.md)
function being applied to sports “WVB” and “MVB” respectively. The
[`get_teams()`](https://jeffreyrstevens.github.io/ncaavolleyballr/reference/get_teams.md)
function can be applied to other sports to get the list of all of their
team IDs. But since we’ve already done that for men’s and women’s
volleyball, you won’t need to use
[`get_teams()`](https://jeffreyrstevens.github.io/ncaavolleyballr/reference/get_teams.md).

OK, let’s find Nebraska’s team ID for 2024.

``` r
find_team_id("Nebraska", 2024)
#> [1] "585290"
```

We’ll need this team ID to access all of the team’s statistics. You can
either assign the output to an object or just add it to the top of your
pipeline.

You can also pass vectors of team names and years to find team IDs for
multiple teams and years.

``` r
find_team_id("Nebraska", 2020:2024)
#> [1] "504517" "523117" "538902" "558878" "585290"
find_team_id(c("Nebraska", "Wisconsin"), 2024)
#> [1] "585290" "585357"
find_team_id(c("Nebraska", "Wisconsin"), 2020:2024)
#>  [1] "504517" "504318" "523117" "522809" "538902" "538704" "558878" "559025" "585290" "585357"
```

Note these are processed per year, so the last example are the teams
ID’s for Nebraska and Wisconsin in 2020 then 2021, etc.

## Season stats

Now that we have the team ID, we can use it to access season summary
statistics for a particular team and year (e.g., [Nebraska
2024](https://stats.ncaa.org/teams/585290/)).

### Team season information

Before we get to stats, we can extract information about a team’s season
with
[`team_season_info()`](https://jeffreyrstevens.github.io/ncaavolleyballr/reference/team_season_info.md),
The NCAA’s main page for a team and year includes a tab called
“Schedule/Results”. The
[`team_season_stats()`](https://jeffreyrstevens.github.io/ncaavolleyballr/reference/team_season_stats.md)
function extracts information about the team’s venue, coach, and
records, as well as the table of the schedule and results.

``` r
(neb2024team <- find_team_id("Nebraska", 2024) |>
   team_season_info())
#> $team_info
#>      team_id team_name conference_id conference div   yr    season
#> 1466  585290  Nebraska           827    Big Ten   1 2024 2024-2025
#> 
#> $arena
#>                  Arena name                    Capacity                  Year built 
#> "Bob Devaney Sports Center"                     "7,907"                      "1975" 
#> 
#> $coach
#>               Name         Alma mater            Seasons             Record 
#>        "John Cook" "San Diego - 1979"               "32"          "883-176" 
#> 
#> $record
#>      Overall record      Overall streak   Conference record   Conference streak         Home record 
#>      "33-3 (0.917)"        "Streak: L1"      "19-1 (0.950)"        "Streak: L1"      "22-0 (1.000)" 
#>         Home streak         Road record         Road streak      Neutral record      Neutral streak 
#>       "Streak: W45"      "10-2 (0.833)"        "Streak: W1"       "1-1 (0.500)"        "Streak: L1" 
#> Non-division record Non-division streak 
#>       "0-0 (0.000)"         "Streak: 0" 
#> 
#> $schedule
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

This returns a list, so you can subset specific components with `$`. For
instance, if we wanted to calculate average attendance per game:

``` r
neb2024team$schedule |>
  dplyr::pull(Attendance) |>
  sub(",", "", x = _) |>
  as.numeric() |>
  mean()
#> [1] 8765.333
```

Wow, Nebraska volleyball attracted more attendees per game than the
[2021 Oakland Athletics professional baseball
team](https://www.baseball-reference.com/teams/OAK/2021.shtml)!

### Team season stats

The NCAA makes team season summary stats available since. We have
included the conference starting with 2020 (conference data for previous
seasons is not currently available).

``` r
team_season_stats(team = "Nebraska")
#>    Season     Team Conference   S MS Kills Errors Total Attacks Hit Pct Assists
#> 1 2020-21 Nebraska    Big Ten  66 NA   925    323          2229   0.270     847
#> 2 2021-22 Nebraska    Big Ten 121 NA  1677    667          4551   0.222    1548
#> 3 2022-23 Nebraska    Big Ten 109 NA  1461    519          3866   0.244    1331
#> 4 2023-24 Nebraska    Big Ten 121 NA  1676    597          3959   0.273    1553
#> 5 2024-25 Nebraska    Big Ten 122 NA  1721    551          4114   0.284    1596
#>   Aces SErr Digs RErr Block Solos Block Assists BErr    TB    PTS BHE Trpl Dbl
#> 1  104  131  957   71          21           269   40 155.5 1184.5  12       19
#> 2  181  241 2054  105          38           530   54    NA 2161.0   8       34
#> 3  128  261 1721   77          33           537   47 301.5 1890.5  25       32
#> 4  143  309 1666  104          39           574   43    NA 2145.0  15       35
#> 5  155  193 1856   81          51           581   50    NA 2217.5   1       36
#>   SrvAtt RetAtt Dbl Dbl
#> 1     NA     NA      NA
#> 2   2836     NA      NA
#> 3     NA   1824      NA
#> 4     NA   2018      35
#> 5     NA   1920      NA
```

By default, the teams’s stats are returned. To return the opposing teams
stats, set `opponents = TRUE`.

``` r
team_season_stats(team = "Nebraska", opponent = TRUE)
#>    Season               Team   S MS Kills Errors Total Attacks Hit Pct Assists
#> 1 2020-21 Nebraska Opponents  66 NA   739    365          2226   0.168     679
#> 2 2021-22 Nebraska Opponents 121 NA  1349    693          4418   0.148    1269
#> 3 2022-23 Nebraska Opponents 109 NA  1198    689          3988   0.128    1114
#> 4 2023-24 Nebraska Opponents 121 NA  1264    713          4009   0.137    1188
#> 5 2024-25 Nebraska Opponents 122 NA  1376    749          4377   0.143    1321
#>   Aces SErr Digs RErr Block Solos Block Assists BErr  TB    PTS BHE Trpl Dbl
#> 1   71  160  831  104          16           236   26 134  944.0   6       19
#> 2  105  267 1886  181          49           503   52  NA 1754.5  16       34
#> 3   77  297 1575  128          29           370   51 214 1489.0  24       32
#> 4  104  325 1402  143          42           430   58  NA 1625.0  17       35
#> 5   81  342 1539  155          34           375   49  NA 1678.5   1       36
#>   SrvAtt RetAtt Dbl Dbl
#> 1     NA     NA      NA
#> 2   2431     NA      NA
#> 3     NA   2337      NA
#> 4     NA   2552      35
#> 5     NA   2748      NA
```

Here’s a table describing the different team statistics returned.

``` r
data.frame(Stat = colnames(team_season_stats(team = "Nebraska"))[4:20],
           Description = c("Sets played", "Kills", "Attack errors", "Attacks",
                           "Hit percentage [(kills-errors)/attacks]", "Assists",
                           "Ace serves", "Service errors", "Digs",
                           "Reception attempts", "Reception errors",
                           "Solo blocks", "Block assists", "Block errors",
                           "Points", "Ball handling errors", "Triple doubles"))
#>             Stat                             Description
#> 1              S                             Sets played
#> 2          Kills                                   Kills
#> 3         Errors                           Attack errors
#> 4  Total Attacks                                 Attacks
#> 5        Hit Pct Hit percentage [(kills-errors)/attacks]
#> 6        Assists                                 Assists
#> 7           Aces                              Ace serves
#> 8           SErr                          Service errors
#> 9           Digs                                    Digs
#> 10        RetAtt                      Reception attempts
#> 11          RErr                        Reception errors
#> 12   Block Solos                             Solo blocks
#> 13 Block Assists                           Block assists
#> 14          BErr                            Block errors
#> 15           PTS                                  Points
#> 16           BHE                    Ball handling errors
#> 17      Trpl Dbl                          Triple doubles
```

### Player season stats

The NCAA’s main page for a team includes a tab called “Team Statistics”
(e.g., [Nebraska
2024](https://stats.ncaa.org/teams/585290/season_to_date_stats)). The
[`player_season_stats()`](https://jeffreyrstevens.github.io/ncaavolleyballr/reference/player_season_stats.md)
function extracts the table of player summary statistics for a
particular season, as well as team and opponent statistics (though these
can be omitted).

``` r
find_team_id("Nebraska", 2024) |>
  player_season_stats()
#> # A tibble: 16 × 29
#>    Season    Team  Conference Number Player Yr    Pos   Ht    Hometown `High School`    GP    GS     S
#>    <chr>     <chr> <chr>       <dbl> <chr>  <chr> <chr> <chr> <chr>    <chr>         <dbl> <dbl> <dbl>
#>  1 2024-2025 Nebr… Big Ten         2 Berge… So    S     6-1   Sioux F… O'Gorman         36    36   122
#>  2 2024-2025 Nebr… Big Ten         5 Rebek… Jr    MB    6-4   Lincoln… Waverly          35    34   109
#>  3 2024-2025 Nebr… Big Ten         6 Laney… So    L/DS  5-3   Raleigh… Leesville Ro…    36     0   121
#>  4 2024-2025 Nebr… Big Ten         7 Maisi… Jr    L/DS  5-6   Firth, … Norris            9     0    13
#>  5 2024-2025 Nebr… Big Ten         8 Lexi … Sr    L/DS  5-5   Sterlin… Sterling         36     0   122
#>  6 2024-2025 Nebr… Big Ten         9 Kenne… Sr    S     6-0   Eagan, … Eagan            35     0   112
#>  7 2024-2025 Nebr… Big Ten        10 Olivi… Fr    L/DS  5-6   Benning… Bennington       36     4   122
#>  8 2024-2025 Nebr… Big Ten        11 Leyla… Sr    MB    6-4   San Die… La Jolla         13     4    23
#>  9 2024-2025 Nebr… Big Ten        12 Taylo… Sr    OH    6-5   Plainfi… Plainfield C…    33    20    88
#> 10 2024-2025 Nebr… Big Ten        13 Merri… Sr    OH    6-4   Gardend… Gardendale       36    36   122
#> 11 2024-2025 Nebr… Big Ten        15 Andi … So    MB    6-3   Brighto… Brighton         34    34   114
#> 12 2024-2025 Nebr… Big Ten        22 Linds… Sr    OH    6-4   Papilli… Skutt Cathol…    24    12    50
#> 13 2024-2025 Nebr… Big Ten        27 Harpe… So    OH    6-2   Ann Arb… Skyline          36    36   121
#> 14 2024-2025 Nebr… Big Ten        NA TEAM   -     -     -     <NA>     <NA>             NA    NA    NA
#> 15 2024-2025 Nebr… Big Ten        NA Totals -     -     -     <NA>     <NA>             NA    NA   122
#> 16 2024-2025 Nebr… Big Ten        NA Oppon… -     -     -     <NA>     <NA>             NA    NA   122
#> # ℹ 16 more variables: Kills <dbl>, Errors <dbl>, `Total Attacks` <dbl>, `Hit Pct` <dbl>,
#> #   Assists <dbl>, Aces <dbl>, SErr <dbl>, Digs <dbl>, RetAtt <dbl>, RErr <dbl>, `Block Solos` <dbl>,
#> #   `Block Assists` <dbl>, BErr <dbl>, PTS <dbl>, BHE <dbl>, `Trpl Dbl` <dbl>
```

This returns all players, along with TEAM, opponent, and overall team
summaries. To only include player stats, set `team_stats = FALSE`.

``` r
find_team_id("Nebraska", 2024) |>
  player_season_stats(team_stats = FALSE)
#> # A tibble: 13 × 29
#>    Season    Team  Conference Number Player Yr    Pos   Ht    Hometown `High School`    GP    GS     S
#>    <chr>     <chr> <chr>       <dbl> <chr>  <chr> <chr> <chr> <chr>    <chr>         <dbl> <dbl> <dbl>
#>  1 2024-2025 Nebr… Big Ten         2 Berge… So    S     6-1   Sioux F… O'Gorman         36    36   122
#>  2 2024-2025 Nebr… Big Ten         5 Rebek… Jr    MB    6-4   Lincoln… Waverly          35    34   109
#>  3 2024-2025 Nebr… Big Ten         6 Laney… So    L/DS  5-3   Raleigh… Leesville Ro…    36     0   121
#>  4 2024-2025 Nebr… Big Ten         7 Maisi… Jr    L/DS  5-6   Firth, … Norris            9     0    13
#>  5 2024-2025 Nebr… Big Ten         8 Lexi … Sr    L/DS  5-5   Sterlin… Sterling         36     0   122
#>  6 2024-2025 Nebr… Big Ten         9 Kenne… Sr    S     6-0   Eagan, … Eagan            35     0   112
#>  7 2024-2025 Nebr… Big Ten        10 Olivi… Fr    L/DS  5-6   Benning… Bennington       36     4   122
#>  8 2024-2025 Nebr… Big Ten        11 Leyla… Sr    MB    6-4   San Die… La Jolla         13     4    23
#>  9 2024-2025 Nebr… Big Ten        12 Taylo… Sr    OH    6-5   Plainfi… Plainfield C…    33    20    88
#> 10 2024-2025 Nebr… Big Ten        13 Merri… Sr    OH    6-4   Gardend… Gardendale       36    36   122
#> 11 2024-2025 Nebr… Big Ten        15 Andi … So    MB    6-3   Brighto… Brighton         34    34   114
#> 12 2024-2025 Nebr… Big Ten        22 Linds… Sr    OH    6-4   Papilli… Skutt Cathol…    24    12    50
#> 13 2024-2025 Nebr… Big Ten        27 Harpe… So    OH    6-2   Ann Arb… Skyline          36    36   121
#> # ℹ 16 more variables: Kills <dbl>, Errors <dbl>, `Total Attacks` <dbl>, `Hit Pct` <dbl>,
#> #   Assists <dbl>, Aces <dbl>, SErr <dbl>, Digs <dbl>, RetAtt <dbl>, RErr <dbl>, `Block Solos` <dbl>,
#> #   `Block Assists` <dbl>, BErr <dbl>, PTS <dbl>, BHE <dbl>, `Trpl Dbl` <dbl>
```

This returns all of the stats included by
[`team_season_stats()`](https://jeffreyrstevens.github.io/ncaavolleyballr/reference/team_season_stats.md),
plus GP and GS, which are Games Played and Games Started, respectively.

## Match stats

In addition to overall season summary stats, the NCAA provides
match-level data for both teams and individual players.

### Team match stats

To get overall match stats for a team in a particular season, use
[`team_match_stats()`](https://jeffreyrstevens.github.io/ncaavolleyballr/reference/team_match_stats.md).
Note that to run this function relies on the
[`{chromote}`](https://rstudio.github.io/chromote/) package, so you must
have Google Chrome installed on your computer.

``` r
find_team_id(team = "Nebraska", year = 2024) |>
  team_match_stats()
#> # A tibble: 36 × 22
#>    Season    Date       Team     Conference Opponent   Result     S Kills Errors
#>    <chr>     <chr>      <chr>    <chr>      <chr>      <chr>  <dbl> <dbl>  <dbl>
#>  1 2024-2025 08/27/2024 Nebraska Big Ten    Kentucky … W 3-1      4    47     16
#>  2 2024-2025 08/30/2024 Nebraska Big Ten    A&M-Corpu… W 3-0      3    48      7
#>  3 2024-2025 08/31/2024 Nebraska Big Ten    TCU        W 3-1      4    55     25
#>  4 2024-2025 09/03/2024 Nebraska Big Ten    @ SMU      L 0-3      3    36     18
#>  5 2024-2025 09/05/2024 Nebraska Big Ten    The Citad… W 3-0      3    43      7
#>  6 2024-2025 09/07/2024 Nebraska Big Ten    Montana S… W 3-0      3    47     11
#>  7 2024-2025 09/10/2024 Nebraska Big Ten    Creighton  W 3-2      5    73     27
#>  8 2024-2025 09/13/2024 Nebraska Big Ten    Arizona S… W 3-0      3    48     12
#>  9 2024-2025 09/14/2024 Nebraska Big Ten    Wichita S… W 3-0      3    50      8
#> 10 2024-2025 09/18/2024 Nebraska Big Ten    Stanford   W 3-0      3    38     13
#> # ℹ 26 more rows
#> # ℹ 13 more variables: `Total Attacks` <dbl>, `Hit Pct` <dbl>, Assists <dbl>,
#> #   Aces <dbl>, SErr <dbl>, Digs <dbl>, RetAtt <dbl>, RErr <dbl>,
#> #   `Block Solos` <dbl>, `Block Assists` <dbl>, BErr <dbl>, PTS <dbl>,
#> #   BHE <dbl>
```

### Player match stats

Similarly, you can get match stats for each player in a single match.
But to do this, you must know the NCAA’s contest ID for the particular
match or matches that you’re interested in. Use the
[`find_team_contests()`](https://jeffreyrstevens.github.io/ncaavolleyballr/reference/find_team_contests.md)
function to return a data frame of all of the matches for a particular
team and season, along with the contest IDs.

``` r
(neb2024contests <- find_team_id(team = "Nebraska", year = 2024) |>
  find_team_contests())
#> # A tibble: 36 × 6
#>    date       team     opponent           result attendance contest
#>    <chr>      <chr>    <chr>              <chr>       <dbl> <chr>  
#>  1 08/27/2024 Nebraska Kentucky           W 3-1        9280 5362360
#>  2 08/30/2024 Nebraska A&M-Corpus Christi W 3-0        8956 5362361
#>  3 08/31/2024 Nebraska TCU                W 3-1        8695 5362362
#>  4 09/03/2024 Nebraska SMU                L 0-3        6773 5362363
#>  5 09/05/2024 Nebraska The Citadel        W 3-0        8607 5362364
#>  6 09/07/2024 Nebraska Montana St.        W 3-0        8456 5362365
#>  7 09/10/2024 Nebraska Creighton          W 3-2        8924 5362366
#>  8 09/13/2024 Nebraska Arizona St.        W 3-0        8772 5362367
#>  9 09/14/2024 Nebraska Wichita St.        W 3-0        8541 5362368
#> 10 09/18/2024 Nebraska Stanford           W 3-0        8952 5362369
#> # ℹ 26 more rows
```

Once we have the contest IDs, we can grab one and pass it to
[`player_match_stats()`](https://jeffreyrstevens.github.io/ncaavolleyballr/reference/player_match_stats.md).

``` r
player_match_stats(contest = "6080708")
#> # A tibble: 25 × 26
#>    Season    Date       Team   Conference `Opponent Team` `Opponent Conference` Location Number Player
#>    <chr>     <date>     <chr>  <chr>      <chr>           <chr>                 <chr>     <dbl> <chr> 
#>  1 2024-2025 2024-12-19 Penn … Big Ten    Nebraska        Big Ten               Away          2 Ava F…
#>  2 2024-2025 2024-12-19 Penn … Big Ten    Nebraska        Big Ten               Away          3 Gilli…
#>  3 2024-2025 2024-12-19 Penn … Big Ten    Nebraska        Big Ten               Away          8 Camry…
#>  4 2024-2025 2024-12-19 Penn … Big Ten    Nebraska        Big Ten               Away          5 Jorda…
#>  5 2024-2025 2024-12-19 Penn … Big Ten    Nebraska        Big Ten               Away         14 Carol…
#>  6 2024-2025 2024-12-19 Penn … Big Ten    Nebraska        Big Ten               Away         44 Maggi…
#>  7 2024-2025 2024-12-19 Penn … Big Ten    Nebraska        Big Ten               Away         24 Quinn…
#>  8 2024-2025 2024-12-19 Penn … Big Ten    Nebraska        Big Ten               Away          9 Jess …
#>  9 2024-2025 2024-12-19 Penn … Big Ten    Nebraska        Big Ten               Away         11 Jocel…
#> 10 2024-2025 2024-12-19 Penn … Big Ten    Nebraska        Big Ten               Away         21 Izzy …
#> # ℹ 15 more rows
#> # ℹ 17 more variables: P <chr>, S <int>, Kills <int>, Errors <int>, TotalAttacks <int>, HitPct <dbl>,
#> #   Assists <int>, Aces <int>, SErr <int>, Digs <int>, RetAtt <int>, RErr <int>, BlockSolos <int>,
#> #   BlockAssists <int>, BErr <int>, PTS <dbl>, BHE <int>
```

This returns a list with two elements—one for each team. If we just want
to return a single team’s match stats, we can specify this with the
`team` argument. Also, by default, the team stats are included in the
output, but we can remove these with `team_stats = FALSE`.

``` r
player_match_stats(contest = "6080708", team = "Nebraska", team_stats = FALSE)
#> # A tibble: 10 × 26
#>    Season    Date       Team   Conference `Opponent Team` `Opponent Conference` Location Number Player
#>    <chr>     <date>     <chr>  <chr>      <chr>           <chr>                 <chr>     <dbl> <chr> 
#>  1 2024-2025 2024-12-19 Nebra… Big Ten    Penn St.        Big Ten               Home          5 Rebek…
#>  2 2024-2025 2024-12-19 Nebra… Big Ten    Penn St.        Big Ten               Home         13 Merri…
#>  3 2024-2025 2024-12-19 Nebra… Big Ten    Penn St.        Big Ten               Home          6 Laney…
#>  4 2024-2025 2024-12-19 Nebra… Big Ten    Penn St.        Big Ten               Home         15 Andi …
#>  5 2024-2025 2024-12-19 Nebra… Big Ten    Penn St.        Big Ten               Home         12 Taylo…
#>  6 2024-2025 2024-12-19 Nebra… Big Ten    Penn St.        Big Ten               Home         10 Olivi…
#>  7 2024-2025 2024-12-19 Nebra… Big Ten    Penn St.        Big Ten               Home         27 Harpe…
#>  8 2024-2025 2024-12-19 Nebra… Big Ten    Penn St.        Big Ten               Home          9 Kenne…
#>  9 2024-2025 2024-12-19 Nebra… Big Ten    Penn St.        Big Ten               Home          2 Berge…
#> 10 2024-2025 2024-12-19 Nebra… Big Ten    Penn St.        Big Ten               Home          8 Lexi …
#> # ℹ 17 more variables: P <chr>, S <int>, Kills <int>, Errors <int>, TotalAttacks <int>, HitPct <dbl>,
#> #   Assists <int>, Aces <int>, SErr <int>, Digs <int>, RetAtt <int>, RErr <int>, BlockSolos <int>,
#> #   BlockAssists <int>, BErr <int>, PTS <dbl>, BHE <int>
```

## Play-by-play data

Play-by-play data for matches are also available on the NCAA’s website,
if you know the contest ID. The
[`match_pbp()`](https://jeffreyrstevens.github.io/ncaavolleyballr/reference/match_pbp.md)
function extracts relevant events within a match.

``` r
match_pbp(contest = "6080708") |>
  head(20) # cut this off, because it has 1525 rows!
#> # A tibble: 20 × 8
#>    set   away_team home_team score team     event     player              description                 
#>    <chr> <chr>     <chr>     <chr> <chr>    <chr>     <chr>               <chr>                       
#>  1 1     Penn St.  Nebraska  0-0   Penn St. Serve     Jocelyn Nathan      Jocelyn Nathan serves       
#>  2 1     Penn St.  Nebraska  0-0   Nebraska Reception Bergen Reilly       Reception by Bergen Reilly  
#>  3 1     Penn St.  Nebraska  0-0   Nebraska Set       Lexi Rodriguez      Set by Lexi Rodriguez       
#>  4 1     Penn St.  Nebraska  0-0   Nebraska Attack    Merritt Beason      Attack by Merritt Beason    
#>  5 1     Penn St.  Nebraska  0-0   Nebraska Set       Bergen Reilly       Set by Bergen Reilly        
#>  6 1     Penn St.  Nebraska  0-0   Nebraska Attack    Harper Murray       Attack by Harper Murray     
#>  7 1     Penn St.  Nebraska  0-0   Penn St. Dig       Gillian Grimes      Dig by Gillian Grimes       
#>  8 1     Penn St.  Nebraska  0-0   Penn St. Set       Izzy Starck         Set by Izzy Starck          
#>  9 1     Penn St.  Nebraska  0-0   Penn St. Attack    Taylor Trammell     Attack by Taylor Trammell   
#> 10 1     Penn St.  Nebraska  0-0   Nebraska Block     Rebekah Allick      Block by Rebekah Allick     
#> 11 1     Penn St.  Nebraska  0-1   Nebraska Block     Rebekah Allick      Block by Rebekah Allick     
#> 12 1     Penn St.  Nebraska  0-1   Nebraska Serve     Lexi Rodriguez      Lexi Rodriguez serves       
#> 13 1     Penn St.  Nebraska  0-1   Penn St. Reception Jess Mruzik         Reception by Jess Mruzik    
#> 14 1     Penn St.  Nebraska  0-1   Penn St. Set       Izzy Starck         Set by Izzy Starck          
#> 15 1     Penn St.  Nebraska  0-1   Penn St. Attack    Jess Mruzik         Attack by Jess Mruzik       
#> 16 1     Penn St.  Nebraska  0-1   Nebraska Dig       Harper Murray       Dig by Harper Murray        
#> 17 1     Penn St.  Nebraska  0-1   Penn St. Set       Izzy Starck         Set by Izzy Starck          
#> 18 1     Penn St.  Nebraska  0-1   Penn St. Attack    Caroline Jurevicius Attack by Caroline Jurevici…
#> 19 1     Penn St.  Nebraska  1-1   Penn St. Kill      Caroline Jurevicius Kill by Caroline Jurevicius 
#> 20 1     Penn St.  Nebraska  1-1   Penn St. Serve     Gillian Grimes      Gillian Grimes serves
```

## Aggregating data

Though the season, match, and play-by-play data are useful at the
individual level, they can be more useful when aggregated. The
[`group_stats()`](https://jeffreyrstevens.github.io/ncaavolleyballr/reference/group_stats.md)
function aggregates season, match, and play-by-play data over multiple
teams and/or years by applying the
[`player_season_stats()`](https://jeffreyrstevens.github.io/ncaavolleyballr/reference/player_season_stats.md),
[`player_match_stats()`](https://jeffreyrstevens.github.io/ncaavolleyballr/reference/player_match_stats.md),
or
[`match_pbp()`](https://jeffreyrstevens.github.io/ncaavolleyballr/reference/match_pbp.md)
across teams and years.

``` r
group_stats(teams = c("Nebraska", "Wisconsin"), year = 2023:2024, level = "season")
#> $playerdata
#> # A tibble: 54 × 30
#>    Season    Team     Conference Number Player        Yr    Pos   Ht       GP    GS     S Kills Errors
#>    <chr>     <chr>    <chr>       <dbl> <chr>         <chr> <chr> <chr> <dbl> <dbl> <dbl> <dbl>  <dbl>
#>  1 2023-2024 Nebraska Big Ten         2 Bergen Reilly Fr    S     6-1      35    35   121    70     19
#>  2 2023-2024 Nebraska Big Ten         5 Rebekah Alli… So    MB    6-4      32    31   105   185     61
#>  3 2023-2024 Nebraska Big Ten         6 Laney Choboy  Fr    L/DS  5-3      34    33   117     0      1
#>  4 2023-2024 Nebraska Big Ten         7 Maisie Boesi… So    L/DS  5-6      18     0    36     0      0
#>  5 2023-2024 Nebraska Big Ten         8 Lexi Rodrigu… Jr    L/DS  5-5      35     0   121     1      0
#>  6 2023-2024 Nebraska Big Ten         9 Kennedi Orr   Jr    S     6-0      29     0    96     1      0
#>  7 2023-2024 Nebraska Big Ten        11 Hayden Kubik  So    OH    6-2       9     0    10     3      7
#>  8 2023-2024 Nebraska Big Ten        13 Merritt Beas… Jr    OH    6-4      35    35   121   455    153
#>  9 2023-2024 Nebraska Big Ten        14 Ally Batenho… Jr    OH    6-5      30     2    87   196     91
#> 10 2023-2024 Nebraska Big Ten        15 Andi Jackson  Fr    MB    6-3      34    34   118   237     67
#> # ℹ 44 more rows
#> # ℹ 17 more variables: `Total Attacks` <dbl>, `Hit Pct` <dbl>, Assists <dbl>, Aces <dbl>, SErr <dbl>,
#> #   Digs <dbl>, RetAtt <dbl>, RErr <dbl>, `Block Solos` <dbl>, `Block Assists` <dbl>, BErr <dbl>,
#> #   PTS <dbl>, BHE <dbl>, `Trpl Dbl` <dbl>, `Dbl Dbl` <dbl>, Hometown <chr>, `High School` <chr>
#> 
#> $teamdata
#> # A tibble: 4 × 23
#>   Season    Team     Conference     S Kills Errors `Total Attacks` `Hit Pct` Assists  Aces  SErr  Digs
#>   <chr>     <chr>    <chr>      <dbl> <dbl>  <dbl>           <dbl>     <dbl>   <dbl> <dbl> <dbl> <dbl>
#> 1 2023-2024 Nebraska Big Ten      121  1676    597            3959     0.273    1553   143   309  1666
#> 2 2024-2025 Nebraska Big Ten      122  1721    551            4114     0.284    1596   155   193  1856
#> 3 2023-2024 Wiscons… Big Ten      119  1654    428            3950     0.31     1552   184   270  1741
#> 4 2024-2025 Wiscons… Big Ten      120  1657    486            4090     0.286    1562   183   280  1785
#> # ℹ 11 more variables: RetAtt <dbl>, RErr <dbl>, `Block Solos` <dbl>, `Block Assists` <dbl>,
#> #   BErr <dbl>, PTS <dbl>, BHE <dbl>, `Trpl Dbl` <dbl>, `Dbl Dbl` <dbl>, Hometown <chr>,
#> #   `High School` <chr>
```

We don’t have other examples, because these take a while to run.

There are also convenience functions
[`conference_stats()`](https://jeffreyrstevens.github.io/ncaavolleyballr/reference/conference_stats.md)
and
[`division_stats()`](https://jeffreyrstevens.github.io/ncaavolleyballr/reference/division_stats.md)
that automatically extract data for a particular conference or NCAA
division.

``` r
conference_stats(year = 2024, conf = "Big Ten", level = "season")
#> $playerdata
#> # A tibble: 274 × 29
#>    Season    Team  Conference Number Player Yr    Pos   Ht    Hometown `High School`    GP    GS     S
#>    <chr>     <chr> <chr>       <dbl> <chr>  <chr> <chr> <chr> <chr>    <chr>         <dbl> <dbl> <dbl>
#>  1 2024-2025 Illi… Big Ten         2 Raege… Sr    S     5-10  Sioux F… O'Gorman         31     0   108
#>  2 2024-2025 Illi… Big Ten         3 Lily … So    L/DS  5-6   Emden, … University       26     1    85
#>  3 2024-2025 Illi… Big Ten         4 Bianc… So    S     5-8   Orland … Carl Sandburg     9     0    21
#>  4 2024-2025 Illi… Big Ten         5 Taylo… Fr    OH    6-4   Kelowna… Okanagan Mis…    11     0    16
#>  5 2024-2025 Illi… Big Ten         8 Averi… Jr    OH    6-2   Bloomin… Normal Commu…    31    31   114
#>  6 2024-2025 Illi… Big Ten        10 Carol… Sr    L/DS  5-11  Napervi… Benet Academy     8     0    31
#>  7 2024-2025 Illi… Big Ten        11 Cari … So    MB    6-4   Ann Arb… Skyline          31    31   114
#>  8 2024-2025 Illi… Big Ten        12 Raina… Sr    OH    6-1   Marengo… Highland         31    31   114
#>  9 2024-2025 Illi… Big Ten        13 Kenzi… Fr    L/DS  5-7   Cincinn… Mount Notre …     2     0     2
#> 10 2024-2025 Illi… Big Ten        16 Ashly… Fr    MB    6-4   Greenvi… DH Conley        31    31   114
#> # ℹ 264 more rows
#> # ℹ 16 more variables: Kills <dbl>, Errors <dbl>, `Total Attacks` <dbl>, `Hit Pct` <dbl>,
#> #   Assists <dbl>, Aces <dbl>, SErr <dbl>, Digs <dbl>, RetAtt <dbl>, RErr <dbl>, `Block Solos` <dbl>,
#> #   `Block Assists` <dbl>, BErr <dbl>, PTS <dbl>, BHE <dbl>, `Trpl Dbl` <dbl>
#> 
#> $teamdata
#> # A tibble: 18 × 20
#>    Season    Team    Conference     S Kills Errors `Total Attacks` `Hit Pct` Assists  Aces  SErr  Digs
#>    <chr>     <chr>   <chr>      <dbl> <dbl>  <dbl>           <dbl>     <dbl>   <dbl> <dbl> <dbl> <dbl>
#>  1 2024-2025 Illino… Big Ten      114  1432    559            3793     0.23     1311   183   275  1411
#>  2 2024-2025 Indiana Big Ten      108  1384    595            3774     0.209    1283   171   311  1393
#>  3 2024-2025 Iowa    Big Ten      119  1440    678            4024     0.189    1313   178   268  1573
#>  4 2024-2025 Maryla… Big Ten      112  1322    566            3722     0.203    1197   223   276  1465
#>  5 2024-2025 Michig… Big Ten      117  1535    628            4081     0.222    1436   181   284  1633
#>  6 2024-2025 Michig… Big Ten      114  1399    604            3877     0.205    1275   157   265  1595
#>  7 2024-2025 Minnes… Big Ten      122  1581    560            4226     0.242    1441   181   262  1869
#>  8 2024-2025 Nebras… Big Ten      122  1721    551            4114     0.284    1596   155   193  1856
#>  9 2024-2025 Northw… Big Ten      106  1202    601            3488     0.172    1103   146   232  1343
#> 10 2024-2025 Ohio S… Big Ten      117  1476    641            4086     0.204    1383   177   249  1665
#> 11 2024-2025 Oregon  Big Ten      117  1554    531            3915     0.261    1442   202   270  1637
#> 12 2024-2025 Penn S… Big Ten      135  1972    648            4673     0.283    1841   203   324  1994
#> 13 2024-2025 Purdue  Big Ten      118  1683    509            4191     0.28     1568   146   262  1841
#> 14 2024-2025 Rutgers Big Ten      104  1145    540            3441     0.176    1080   142   294  1243
#> 15 2024-2025 Southe… Big Ten      122  1597    622            4091     0.238    1469   184   363  1586
#> 16 2024-2025 UCLA    Big Ten      109  1474    544            3766     0.247    1373   125   265  1513
#> 17 2024-2025 Washin… Big Ten      117  1494    601            3970     0.225    1400   190   283  1612
#> 18 2024-2025 Wiscon… Big Ten      120  1657    486            4090     0.286    1562   183   280  1785
#> # ℹ 8 more variables: RetAtt <dbl>, RErr <dbl>, `Block Solos` <dbl>, `Block Assists` <dbl>,
#> #   BErr <dbl>, PTS <dbl>, BHE <dbl>, `Trpl Dbl` <dbl>
```

Well, that covers most of the functionality of
[`{ncaavolleyballr}`](https://jeffreyrstevens.github.io/ncaavolleyballr/).
If you find any bugs or have any questions, please reach out.
