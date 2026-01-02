# Extract player statistics for a particular match

The NCAA's page for a match/contest includes a tab called "Individual
Statistics". This function extracts the tables of player match
statistics for both home and away teams, as well as team statistics
(though these can be omitted). If a particular team is specified, only
that team's statistics will be returned.

## Usage

``` r
player_match_stats(
  contest = NULL,
  team = NULL,
  team_stats = TRUE,
  sport = "WVB"
)
```

## Arguments

- contest:

  Contest ID determined by NCAA for match. To find ID, use
  [`find_team_contests()`](https://jeffreyrstevens.github.io/ncaavolleyballr/reference/find_team_contests.md)
  for a team and season.

- team:

  Name of school. Must match name used by NCAA. Find exact team name
  with
  [`find_team_name()`](https://jeffreyrstevens.github.io/ncaavolleyballr/reference/find_team_name.md).

- team_stats:

  Logical indicating whether to include (TRUE) or exclude (FALSE) team
  statistics. Default includes team statistics with player statistics.

- sport:

  Three letter abbreviation for NCAA sport (must be upper case; for
  example "WVB" for women's volleyball and "MVB" for men's volleyball).

## Value

By default, returns data frame that includes both home and away team
match statistics. If team is specified, only that team's data are
returned.

## Note

This function **requires internet connectivity** as it checks the [NCAA
website](https://stats.ncaa.org) for information. It also uses the
[`{chromote}`](https://rstudio.github.io/chromote/) package and
**requires [Google Chrome](https://www.google.com/chrome/)** to be
installed.

## See also

Other functions that extract player statistics:
[`player_season_stats()`](https://jeffreyrstevens.github.io/ncaavolleyballr/reference/player_season_stats.md)

## Examples

``` r
if (FALSE) { # interactive()
player_match_stats(contest = "6080706")
}
```
