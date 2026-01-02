# Extract arena, coach, record, and schedule information for a particular team and season

The NCAA's main page for a team includes a tab called
"Schedule/Results". This function extracts information about the team's
venue, coach, and records, as well as the table of the schedule and
results. This returns a list, so you can subset specific components with
`$` (e.g., for coach information from an object called `output`, use
`output$coach`).

## Usage

``` r
team_season_info(team_id = NULL)
```

## Arguments

- team_id:

  Team ID determined by NCAA for season. To find ID, use
  [`find_team_id()`](https://jeffreyrstevens.github.io/ncaavolleyballr/reference/find_team_id.md).

## Value

Returns a list that includes arena, coach, schedule, and record
information.

## Note

This function **requires internet connectivity** as it checks the [NCAA
website](https://stats.ncaa.org) for information. It also uses the
[`{chromote}`](https://rstudio.github.io/chromote/) package and
**requires [Google Chrome](https://www.google.com/chrome/)** to be
installed.

## See also

Other functions that extract team statistics:
[`team_match_stats()`](https://jeffreyrstevens.github.io/ncaavolleyballr/reference/team_match_stats.md),
[`team_season_stats()`](https://jeffreyrstevens.github.io/ncaavolleyballr/reference/team_season_stats.md)

## Examples

``` r
if (FALSE) { # interactive()
team_season_info(team_id = "585290")
}
```
