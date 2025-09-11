# ncaavolleyballr (development version)

* The 2025 season has begun, and this version has updated the `current_season()` to 2025 to allow scraping this season's data.

* The [package website](https://jeffreyrstevens.github.io/ncaavolleyballr/) now includes a [data page](https://jeffreyrstevens.github.io/ncaavolleyballr/articles/data.html) that includes all data from 2020-2024 as separate files for each sport, data level, dividion, and year.

* Data output now includes contest ID or team ID columns to facilitate joining datasets.

* Most of NCAA's websites now using JavaScript with loading pages, so most functions now use `rvest::read_live_html()`. Unfortunately, this has resulted in much slower processing of data, and large-scale scraping triggers IP address bans.

## Package development

* Chromote sessions are now closed after scraping data.

* Unit testing is greatly expanded and improved to test the code better.

* Documentation uses inherited notes to simplify documentation changes.

* [Air](https://posit-dev.github.io/air/) is now used to format code.



# ncaavolleyballr 0.4.3

* NCAA's game-by-game website introduced a loading page that disrupted `team_season_stats()` and `team_match_stats()`. `team_season_stats()` now gets the info from a different page. `team_match_stats()` now uses the `rvest::read_live_html()` function, which requires the `{chromote}` package and access to Google Chrome.

* Catch contests with too many sets and return warning instead of error

# ncaavolleyballr 0.4.2

* Increase minimum R version to 4.2

* Wrap all URL requests in `tryCatch()` to ensure internet connection problems fail gracefully.

* Change examples to interactive only and note functions that require internet activity.

* Skip testing on CRAN for tests requiring internet connections.

* Switch vignette to pre-built Rmd file.


# ncaavolleyballr 0.4.1

* Remove examples from `division_stats()` and `get_teams()` documentation.

* Remove deprecated `group_player_stats()`.


# ncaavolleyballr 0.4.0

* Update status to active and lifecycle to stable.

* Create `team_season_info()`, `team_season_stats()`, and `team_match_stats()` functions to output team-related information.

* Create `division_stats()` and `conference_stats()` to aggregate season, match, and play-by-play statistics over divisions and conferences.

* Create vignette to help Get Started.

* Update logo.

* Remove duplication of match and play-by-play stats in `group_stats()`.

* Create more descriptive warnings when teams or matches are missing.

* Improve handling of seasons and matches with no data. These cases are skipped with a warning instead of stopping with an error.

* Create suite of functions to check argument input

* Skip all URL request tests on CRAN and CI


# ncaavolleyballr 0.3.0

* Improve output of `match_pbp()` to parse events and players.

* Improve output of `find_team_contests()` to include record, attendance, and canceled matches.

* Add match and play-by-play levels to `group_stats()`.

* Fix bug in `group_stats()` when matches are canceled.

* Replace term "visitor" with "away".

* **DEPRECATION**: 
  - `group_player_stats()` has been renamed `group_stats()`.
  - `conference_player_stats()` has been renamed `conference_season_stats()`.
  - `division_player_stats()` has been renamed `division_season_stats()`.
  

# ncaavolleyballr 0.2.0

* Add match-level functions `find_team_contests()`, `player_match_stats()`, and `test match_pbp()` for extracting match/contest IDs, player statistics, and play-by-play information.

* **DEPRECATION**: `team_player_stats()` has been renamed `player_season_stats()`.


# ncaavolleyballr 0.1.0

* Initial release.

* Add season-level statistics extraction `.

* Add conference, division, and custom group aggregation with `conference_player_stats()`, `division_player_stats()`, and `group_player_stats()`

* Create website and logo.
