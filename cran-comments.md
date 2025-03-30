## Update
This update is in response to an email that CRAN checks produced errors and notes. To address this issues, I have done the following:

* Updated the minimum R version dependency to 4.2

* Wrapped all URL requests with tryCatch() to produce messages instead of errors if there is a problem with the website.

These changes have resulted in the package passing the Win Builder check.


## R CMD check results

0 errors | 0 warnings | 1 note

* The URL https://www.freepik.com/free-vector/volleyball-grey-gradient_59539214.htm is sometimes flagged as possibly invalid (403: Forbidden). This only occurs in checks, not if you enter the URL directly into a browser.
