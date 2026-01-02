# Extract date, opponent, and contest ID for team and season

NCAA datasets use a unique ID for each sport, team, season, and match.
This function returns a data frame of dates, opponent team names, and
contest IDs for each NCAA contest (volleyball match) for each team and
season.

## Usage

``` r
find_team_contests(team_id = NULL)
```

## Arguments

- team_id:

  Team ID determined by NCAA for season. To find ID, use
  [`find_team_id()`](https://jeffreyrstevens.github.io/ncaavolleyballr/reference/find_team_id.md).

## Value

Returns a data frame that includes date, team, opponent, and contest ID
for each season's contest.

## Note

This function **requires internet connectivity** as it checks the [NCAA
website](https://stats.ncaa.org) for information. It also uses the
[`{chromote}`](https://rstudio.github.io/chromote/) package and
**requires [Google Chrome](https://www.google.com/chrome/)** to be
installed.

## Examples

``` r
if (FALSE) { # interactive()
find_team_contests(team_id = "585290")
}
```
