# Extract teams statistics for season statistics from 2020-2024

The NCAA's main page for a team includes a tab called "Game By Game" and
a section called "Career Totals". This function extracts season summary
stats.

## Usage

``` r
team_season_stats(team = NULL, opponent = FALSE, sport = "WVB")
```

## Arguments

- team:

  Name of school. Must match name used by NCAA. Find exact team name
  with
  [`find_team_name()`](https://jeffreyrstevens.github.io/ncaavolleyballr/reference/find_team_name.md).

- opponent:

  Logical indicating whether to include team's stats (FALSE) or
  opponent's stats (TRUE). Default is set to FALSE, returning team
  stats.

- sport:

  Three letter abbreviation for NCAA sport (must be upper case; for
  example "WVB" for women's volleyball and "MVB" for men's volleyball).

## Value

Returns a data frame of summary team statistics for each season.

## Note

This function **requires internet connectivity** as it checks the [NCAA
website](https://stats.ncaa.org) for information. It also uses the
[`{chromote}`](https://rstudio.github.io/chromote/) package and
**requires [Google Chrome](https://www.google.com/chrome/)** to be
installed.

## See also

Other functions that extract team statistics:
[`team_match_stats()`](https://jeffreyrstevens.github.io/ncaavolleyballr/reference/team_match_stats.md),
[`team_season_info()`](https://jeffreyrstevens.github.io/ncaavolleyballr/reference/team_season_info.md)

## Examples

``` r
if (FALSE) { # interactive()
team_season_stats(team = "Nebraska")
}
```
