# Aggregate player statistics for a NCAA division and seasons

This is a wrapper around
[`group_stats()`](https://jeffreyrstevens.github.io/ncaavolleyballr/reference/group_stats.md)
that extracts season, match, or pbp data from players in all teams in
the chosen division. For season stats, it aggregates all player data and
team data into separate data frames and combines them into a list. For
match and pbp stats, it aggregates into a data frame.

## Usage

``` r
division_stats(
  year = NULL,
  division = 1,
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

- division:

  NCAA division (must be 1, 2, or 3).

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

## Details

Note: Changes to the NCAA website have made large-scale scraping
unstable, and can trigger IP address blocks when there are lots of
requests. This function seems to trigger these blocks frequently now, so
use caution when scraping large amounts of data.

## Note

This function **requires internet connectivity** as it checks the [NCAA
website](https://stats.ncaa.org) for information. It also uses the
[`{chromote}`](https://rstudio.github.io/chromote/) package and
**requires [Google Chrome](https://www.google.com/chrome/)** to be
installed.

## See also

Other functions that aggregate statistics:
[`conference_stats()`](https://jeffreyrstevens.github.io/ncaavolleyballr/reference/conference_stats.md),
[`group_stats()`](https://jeffreyrstevens.github.io/ncaavolleyballr/reference/group_stats.md)

## Examples

``` r
if (FALSE) { # interactive()
division_stats(year = 2024, division = 1, level = "teamseason")
}
```
