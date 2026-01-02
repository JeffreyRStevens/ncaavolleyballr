# Find team ID for season

NCAA datasets use a unique ID for each team and season. To access a
team's data, we must know the volleyball team ID. This function looks up
the team ID from
[wvb_teams](https://jeffreyrstevens.github.io/ncaavolleyballr/reference/wvb_teams.md)
or
[mvb_teams](https://jeffreyrstevens.github.io/ncaavolleyballr/reference/mvb_teams.md)
using the team name. Team names can be found in
[ncaa_teams](https://jeffreyrstevens.github.io/ncaavolleyballr/reference/ncaa_teams.md)
or searched with
[`find_team_name()`](https://jeffreyrstevens.github.io/ncaavolleyballr/reference/find_team_name.md).

## Usage

``` r
find_team_id(team = NULL, year = NULL, sport = "WVB")
```

## Arguments

- team:

  Name of school. Must match name used by NCAA. Find exact team name
  with
  [`find_team_name()`](https://jeffreyrstevens.github.io/ncaavolleyballr/reference/find_team_name.md).

- year:

  Numeric vector of years for fall of desired seasons.

- sport:

  Three letter abbreviation for NCAA sport (must be upper case; for
  example "WVB" for women's volleyball and "MVB" for men's volleyball).

## Value

Returns a character string of team ID.

## Note

This function **requires internet connectivity** as it checks the [NCAA
website](https://stats.ncaa.org) for information.

## See also

Other search functions:
[`find_team_name()`](https://jeffreyrstevens.github.io/ncaavolleyballr/reference/find_team_name.md)

## Examples

``` r
if (FALSE) { # interactive()
find_team_id(team = "Nebraska", year = 2024)
find_team_id(team = "UCLA", year = 2023, sport = "MVB")
}
```
