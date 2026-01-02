# Match pattern to find team names

This is a convenience function to find NCAA team names in
[ncaa_teams](https://jeffreyrstevens.github.io/ncaavolleyballr/reference/ncaa_teams.md).
Once the proper team name is found, it can be passed to
[`find_team_id()`](https://jeffreyrstevens.github.io/ncaavolleyballr/reference/find_team_id.md)
or
[`group_stats()`](https://jeffreyrstevens.github.io/ncaavolleyballr/reference/group_stats.md).

## Usage

``` r
find_team_name(pattern = NULL)
```

## Arguments

- pattern:

  Character string of pattern you want to find in the vector of team
  names.

## Value

Returns a character vector of team names that include the submitted
pattern.

## Note

This function **requires internet connectivity** as it checks the [NCAA
website](https://stats.ncaa.org) for information.

## See also

Other search functions:
[`find_team_id()`](https://jeffreyrstevens.github.io/ncaavolleyballr/reference/find_team_id.md)

## Examples

``` r
if (FALSE) { # interactive()
find_team_name(pattern = "Neb")
}
```
