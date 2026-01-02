# Submit URL request via live browser

Submit URL request via live browser

## Usage

``` r
request_live_url(url)
```

## Arguments

- url:

  URL for request.

## Note

This function **requires internet connectivity** as it checks the [NCAA
website](https://stats.ncaa.org) for information. It also uses the
[`{chromote}`](https://rstudio.github.io/chromote/) package and
**requires [Google Chrome](https://www.google.com/chrome/)** to be
installed.
