# NCAA Women's Volleyball Teams 2020-2024

This data frame includes all women's NCAA Division 1, 2, and 3 teams
from 2020-2024.

## Usage

``` r
wvb_teams
```

## Format

A data frame with 5,289 rows and 6 columns:

- team_id:

  Team ID for season/year

- team_name:

  Team name

- conference_id:

  Conference ID

- conference:

  Conference name

- div:

  NCAA division number (1, 2, or 3)

- yr:

  Year for fall of season

## Source

<https://stats.ncaa.org>

## See also

Other data sets:
[`mvb_teams`](https://jeffreyrstevens.github.io/ncaavolleyballr/reference/mvb_teams.md),
[`ncaa_conferences`](https://jeffreyrstevens.github.io/ncaavolleyballr/reference/ncaa_conferences.md),
[`ncaa_sports`](https://jeffreyrstevens.github.io/ncaavolleyballr/reference/ncaa_sports.md),
[`ncaa_teams`](https://jeffreyrstevens.github.io/ncaavolleyballr/reference/ncaa_teams.md)

## Examples

``` r
head(wvb_teams)
#>   team_id      team_name conference_id conference div   yr
#> 1  504371 Boston College           821        ACC   1 2020
#> 2  504401        Clemson           821        ACC   1 2020
#> 3  504420           Duke           821        ACC   1 2020
#> 4  504434    Florida St.           821        ACC   1 2020
#> 5  504443   Georgia Tech           821        ACC   1 2020
#> 6  504483     Louisville           821        ACC   1 2020
```
