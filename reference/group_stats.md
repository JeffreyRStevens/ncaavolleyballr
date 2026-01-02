# Aggregate player statistics and play-by-play information

This function aggregates player statistics and play-by-play information
within a season by applying
[`team_match_stats()`](https://jeffreyrstevens.github.io/ncaavolleyballr/reference/team_match_stats.md),
[`player_season_stats()`](https://jeffreyrstevens.github.io/ncaavolleyballr/reference/player_season_stats.md),
[`player_match_stats()`](https://jeffreyrstevens.github.io/ncaavolleyballr/reference/player_match_stats.md),
or
[`match_pbp()`](https://jeffreyrstevens.github.io/ncaavolleyballr/reference/match_pbp.md)
across groups of teams (for
[`player_season_stats()`](https://jeffreyrstevens.github.io/ncaavolleyballr/reference/player_season_stats.md))
or across contests within a season (for
[`team_match_stats()`](https://jeffreyrstevens.github.io/ncaavolleyballr/reference/team_match_stats.md),
[`player_match_stats()`](https://jeffreyrstevens.github.io/ncaavolleyballr/reference/player_match_stats.md)
and
[`match_pbp()`](https://jeffreyrstevens.github.io/ncaavolleyballr/reference/match_pbp.md)).
For season stats, it aggregates all player data and team data into
separate data frames and combines them into a list. For instance, if you
want to extract the data from the teams in the women's 2024 Final Four,
pass a vector of
`c("Louisville", "Nebraska", "Penn State", "Pittsburgh")` to the
function. For match or play-by-play data for a team, pass a single team
name and year. Team names can be found in
[ncaa_teams](https://jeffreyrstevens.github.io/ncaavolleyballr/reference/ncaa_teams.md)
or by using
[`find_team_name()`](https://jeffreyrstevens.github.io/ncaavolleyballr/reference/find_team_name.md).

## Usage

``` r
group_stats(
  teams = NULL,
  year = NULL,
  level = "teamseason",
  unique = TRUE,
  sport = "WVB",
  delay = 2
)
```

## Arguments

- teams:

  Character vector of team names to aggregate.

- year:

  Numeric vector of years for fall of desired seasons.

- level:

  Character string defining whether to aggregate "teamseason",
  "teammatch", "playermatch", or match play-by-play ("pbp") data.

- unique:

  Logical indicating whether to only process unique contests (TRUE) or
  whether to process duplicated contests (FALSE). Default is TRUE.

- sport:

  Three letter abbreviation for NCAA sport (must be upper case; for
  example "WVB" for women's volleyball and "MVB" for men's volleyball).

- delay:

  Numeric for time delay between teams/contests in seconds.

## Value

For season level, returns list with data frames of player statistics and
team statistics. For match and pbp levels, returns data frame of player
statistics and play-by-play information respectively.

## Note

This function **requires internet connectivity** as it checks the [NCAA
website](https://stats.ncaa.org) for information. It also uses the
[`{chromote}`](https://rstudio.github.io/chromote/) package and
**requires [Google Chrome](https://www.google.com/chrome/)** to be
installed.

## See also

Other functions that aggregate statistics:
[`conference_stats()`](https://jeffreyrstevens.github.io/ncaavolleyballr/reference/conference_stats.md),
[`division_stats()`](https://jeffreyrstevens.github.io/ncaavolleyballr/reference/division_stats.md)

## Examples

``` r
if (FALSE) { # interactive()
group_stats(teams = c("Louisville", "Nebraska", "Penn St.", "Pittsburgh"),
year = 2024, level = "teamseason")
}
```
