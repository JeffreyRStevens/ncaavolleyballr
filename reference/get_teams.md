# Extract data frame of team names, IDs, conference, division, and season

NCAA datasets use a unique ID for each sport, team, and season. This
function extracts team names, IDs, and conferences for each NCAA team in
a division. However, you should not need to use this function for
volleyball data from 2020-2024, as it has been used to generate
[wvb_teams](https://jeffreyrstevens.github.io/ncaavolleyballr/reference/wvb_teams.md)
and
[mvb_teams](https://jeffreyrstevens.github.io/ncaavolleyballr/reference/mvb_teams.md).
However, it is available to use for other sports, using the appropriate
three letter sport code drawn from
[ncaa_sports](https://jeffreyrstevens.github.io/ncaavolleyballr/reference/ncaa_sports.md)
(e.g., men's baseball is "MBA").

## Usage

``` r
get_teams(year = NULL, division = 1, sport = "WVB")
```

## Arguments

- year:

  Single numeric year for fall of desired season.

- division:

  NCAA division (must be 1, 2, or 3).

- sport:

  Three letter abbreviation for NCAA sport (must be upper case; for
  example "WVB" for women's volleyball and "MVB" for men's volleyball).

## Value

Returns a data frame of all teams, their team ID, division, conference,
and season.

## Note

This function **requires internet connectivity** as it checks the [NCAA
website](https://stats.ncaa.org) for information.

This function is a modification of the
[`ncaa_teams()`](https://jeffreyrstevens.github.io/ncaavolleyballr/reference/ncaa_teams.md)
function from the
[`{baseballr}`](https://billpetti.github.io/baseballr/) package.

## Examples

``` r
if (FALSE) { # interactive()
get_teams(year = 2020, division = 1, sport = "WVB")
}
```
