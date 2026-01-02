# Extract team summary statistics for all matches in a particular season

The NCAA's main page for a team includes a tab called "Game By Game" and
a section called "Game by Game Stats". This function extracts the team's
summary statistics for each match of the season.

## Usage

``` r
team_match_stats(team_id = NULL, sport = "WVB")
```

## Arguments

- team_id:

  Team ID determined by NCAA for season. To find ID, use
  [`find_team_id()`](https://jeffreyrstevens.github.io/ncaavolleyballr/reference/find_team_id.md).

- sport:

  Three letter abbreviation for NCAA sport (must be upper case; for
  example "WVB" for women's volleyball and "MVB" for men's volleyball).

## Value

Returns a data frame of summary team statistics for each match of the
season.

## Note

This function **requires internet connectivity** as it checks the [NCAA
website](https://stats.ncaa.org) for information. It also uses the
[`{chromote}`](https://rstudio.github.io/chromote/) package and
**requires [Google Chrome](https://www.google.com/chrome/)** to be
installed.

## See also

Other functions that extract team statistics:
[`team_season_info()`](https://jeffreyrstevens.github.io/ncaavolleyballr/reference/team_season_info.md),
[`team_season_stats()`](https://jeffreyrstevens.github.io/ncaavolleyballr/reference/team_season_stats.md)

## Examples

``` r
if (FALSE) { # interactive()
team_match_stats(team_id = "585290")
}
```
