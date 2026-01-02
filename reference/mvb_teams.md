# NCAA Men's Volleyball Teams 2020-2024

This data frame includes all men's NCAA Division 1 and 3 teams from
2020-2024.

## Usage

``` r
mvb_teams
```

## Format

A data frame with 873 rows and 6 columns:

- team_id:

  Team ID for season/year

- team_name:

  Team name

- conference_id:

  Conference ID

- conference:

  Conference name

- div:

  NCAA division number (1 or 3)

- yr:

  Year for fall of season

## Source

<https://stats.ncaa.org>

## See also

Other data sets:
[`ncaa_conferences`](https://jeffreyrstevens.github.io/ncaavolleyballr/reference/ncaa_conferences.md),
[`ncaa_sports`](https://jeffreyrstevens.github.io/ncaavolleyballr/reference/ncaa_sports.md),
[`ncaa_teams`](https://jeffreyrstevens.github.io/ncaavolleyballr/reference/ncaa_teams.md),
[`wvb_teams`](https://jeffreyrstevens.github.io/ncaavolleyballr/reference/wvb_teams.md)

## Examples

``` r
head(mvb_teams)
#>   team_id        team_name conference_id conference div   yr
#> 1  508241             CSUN           904   Big West   1 2020
#> 2  508254           Hawaii           904   Big West   1 2020
#> 3  508239   Long Beach St.           904   Big West   1 2020
#> 4  508245        UC Irvine           904   Big West   1 2020
#> 5  508249     UC San Diego           904   Big West   1 2020
#> 6  508243 UC Santa Barbara           904   Big West   1 2020
```
