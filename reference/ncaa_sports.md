# NCAA Sports and Sport Codes

This data frame includes all NCAA women's and men's sports and the codes
used to refer to the sports.

## Usage

``` r
ncaa_sports
```

## Format

A data frame with 100 rows and 2 columns:

- code:

  Sport code

- sport:

  Sport name

## Source

<https://ncaaorg.s3.amazonaws.com/championships/resources/common/NCAA_SportCodes.pdf>

## See also

Other data sets:
[`mvb_teams`](https://jeffreyrstevens.github.io/ncaavolleyballr/reference/mvb_teams.md),
[`ncaa_conferences`](https://jeffreyrstevens.github.io/ncaavolleyballr/reference/ncaa_conferences.md),
[`ncaa_teams`](https://jeffreyrstevens.github.io/ncaavolleyballr/reference/ncaa_teams.md),
[`wvb_teams`](https://jeffreyrstevens.github.io/ncaavolleyballr/reference/wvb_teams.md)

## Examples

``` r
head(ncaa_sports)
#>   code            sport
#> 1  MBA         Baseball
#> 2  WFH     Field Hockey
#> 3  MFB         Football
#> 4  MAR    Men's Archery
#> 5  MBM  Men's Badminton
#> 6  MBB Men's Basketball
```
