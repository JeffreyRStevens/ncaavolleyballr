## Resubmission
This is a resubmission. In this version, I have:

* Provided a link to the <https://stats.ncaa.org> webservices to the description field
of the DESCRIPTION file.

* Removed the group_player_stats() function, so it no longer requires a \value in the .Rd file because it has been removed.

* Removed examples from division_stats.Rd and get_teams.Rd to avoid having to use \dontrun{}.

* Removed set.seed() from R/utils.R.


## R CMD check results

0 errors | 0 warnings | 1 note

* The URL https://www.freepik.com/free-vector/volleyball-grey-gradient_59539214.htm is sometimes flagged as possibly invalid (403: Forbidden). This only occurs in checks, not if you enter the URL directly into a browser.
