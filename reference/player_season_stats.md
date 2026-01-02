# Extract player statistics from a particular team and season

The NCAA's main page for a team includes a tab called "Team Statistics".
This function extracts the table of player statistics for the season, as
well as team and opponent statistics (though these can be omitted).

## Usage

``` r
player_season_stats(team_id, team_stats = TRUE)
```

## Arguments

- team_id:

  Team ID determined by NCAA for season. To find ID, use
  [`find_team_id()`](https://jeffreyrstevens.github.io/ncaavolleyballr/reference/find_team_id.md).

- team_stats:

  Logical indicating whether to include (TRUE) or exclude (FALSE) team
  statistics. Default includes team statistics with player statistics.

## Value

Returns a data frame of player statistics. Note that hometown and high
school were added in 2024.

## Note

This function **requires internet connectivity** as it checks the [NCAA
website](https://stats.ncaa.org) for information. It also uses the
[`{chromote}`](https://rstudio.github.io/chromote/) package and
**requires [Google Chrome](https://www.google.com/chrome/)** to be
installed.

## See also

Other functions that extract player statistics:
[`player_match_stats()`](https://jeffreyrstevens.github.io/ncaavolleyballr/reference/player_match_stats.md)

## Examples

``` r
if (FALSE) { # interactive()
player_season_stats(team_id = "585290")
}
```
