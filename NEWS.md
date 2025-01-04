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
