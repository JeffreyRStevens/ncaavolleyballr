# Extract play-by-play information for a particular match

The NCAA's page for a match/contest includes a tab called "Play By
Play". This function extracts the tables of play-by-play information for
each set.

## Usage

``` r
match_pbp(contest = NULL)
```

## Arguments

- contest:

  Contest ID determined by NCAA for match. To find ID, use
  [`find_team_contests()`](https://jeffreyrstevens.github.io/ncaavolleyballr/reference/find_team_contests.md)
  for a team and season.

## Value

Returns a data frame of set number, teams, score, event, and player
responsible for the event.

## Note

This function **requires internet connectivity** as it checks the [NCAA
website](https://stats.ncaa.org) for information. It also uses the
[`{chromote}`](https://rstudio.github.io/chromote/) package and
**requires [Google Chrome](https://www.google.com/chrome/)** to be
installed.

## Examples

``` r
if (FALSE) { # interactive()
match_pbp(contest = "6080706")
}
```
