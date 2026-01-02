# Aggregate player statistics for a NCAA conference and seasons

This is a wrapper around
[`group_stats()`](https://jeffreyrstevens.github.io/ncaavolleyballr/reference/group_stats.md)
that extracts season, match, or pbp data from players in all teams in
the chosen conference. For season stats, it aggregates all player data
and team data into separate data frames and combines them into a list.
For match and pbp stats, it aggregates into a data frame. Conferences
names can be found in
[ncaa_conferences](https://jeffreyrstevens.github.io/ncaavolleyballr/reference/ncaa_conferences.md).

## Usage

``` r
conference_stats(
  year = NULL,
  conf = NULL,
  level = NULL,
  sport = "WVB",
  save = FALSE,
  path = ".",
  delay = 2
)
```

## Arguments

- year:

  Numeric vector of years for fall of desired seasons.

- conf:

  NCAA conference name.

- level:

  Character string defining whether to aggregate "teamseason",
  "teammatch", "playermatch", or match play-by-play ("pbp") data.

- sport:

  Three letter abbreviation for NCAA sport (must be upper case; for
  example "WVB" for women's volleyball and "MVB" for men's volleyball).

- save:

  Logical for whether to save the statistics locally as CSVs (default
  FALSE).

- path:

  Character string of path to save statistics files.

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
[`division_stats()`](https://jeffreyrstevens.github.io/ncaavolleyballr/reference/division_stats.md),
[`group_stats()`](https://jeffreyrstevens.github.io/ncaavolleyballr/reference/group_stats.md)

## Examples

``` r
if (FALSE) { # interactive()
conference_stats(year = 2024, conf = "Peach Belt", level = "teamseason")
}
```
