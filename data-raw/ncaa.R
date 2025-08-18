## prepare `wvb_teams` dataset

years <- 2020:2025

wvb_teams <- purrr::map2(
  rep(years, times = 3),
  rep(1:3, each = length(years)),
  ~ get_teams(year = .x, division = .y)
) |>
  purrr::list_rbind() |>
  dplyr::mutate(team_name = stringr::str_trim(team_name)) #|>

usethis::use_data(wvb_teams, overwrite = TRUE)


## prepare `mvb_teams` dataset

mvb_teams <- purrr::map2(
  rep(years, times = 2),
  rep(c(1, 3), each = length(years)),
  ~ get_teams(year = .x, division = .y, sport = "MVB")
) |>
  purrr::list_rbind() |>
  dplyr::mutate(team_name = stringr::str_trim(team_name))

usethis::use_data(mvb_teams, overwrite = TRUE)


## prepare `ncaa_teams` dataset

ncaa_teams <- rbind(wvb_teams, mvb_teams) |>
  dplyr::arrange(team_name) |>
  dplyr::pull(team_name) |>
  unique()

usethis::use_data(ncaa_teams, overwrite = TRUE)


## prepare `ncaa_conferences` dataset

ncaa_conferences <- rbind(wvb_teams, mvb_teams) |>
  dplyr::arrange(conference) |>
  dplyr::pull(conference) |>
  unique()

usethis::use_data(ncaa_conferences, overwrite = TRUE)


## prepare `ncaa_sports` dataset

sport_code <- c(
  "MBA",
  "WFH",
  "MFB",
  "MAR",
  "MBM",
  "MBB",
  "MBO",
  "MCH",
  "MCR",
  "MCK",
  "MCC",
  "MEQ",
  "MFE",
  "MGO",
  "MGY",
  "MHB",
  "MIH",
  "MJU",
  "MLA",
  "MLC",
  "MLF",
  "MPS",
  "MPO",
  "MRI",
  "MRD",
  "MRU",
  "MSL",
  "MSK",
  "MSP",
  "MSO",
  "MSQ",
  "MSW",
  "MTE",
  "MTI",
  "MTO",
  "MTL",
  "MVB",
  "MWP",
  "MWS",
  "MWR",
  "XAR",
  "XBM",
  "XBO",
  "XCH",
  "XCR",
  "XCK",
  "XCC",
  "XEQ",
  "XFE",
  "XGO",
  "XGY",
  "XHB",
  "XJU",
  "XPS",
  "XPO",
  "XRI",
  "XSL",
  "XSK",
  "XSP",
  "XSQ",
  "XSW",
  "XTE",
  "XTI",
  "XTO",
  "XWS",
  "XWR",
  "WSB",
  "WBB",
  "WBW",
  "WCH",
  "WCK",
  "WCC",
  "WEQ",
  "WFE",
  "WGO",
  "WGY",
  "WIH",
  "WIS",
  "WJU",
  "WLA",
  "WPS",
  "WPO",
  "WRI",
  "WCR",
  "WRU",
  "WSL",
  "WSV",
  "WSK",
  "WSP",
  "WSO",
  "WSQ",
  "WSW",
  "WTE",
  "WTI",
  "WTL",
  "WTO",
  "WVB",
  "WWP",
  "WWS",
  "WWR"
)
sport <- c(
  "Baseball",
  "Field Hockey",
  "Football",
  "Men's Archery",
  "Men's Badminton",
  "Men's Basketball",
  "Men's Bowling",
  "Men's Cheerleading",
  "Men's Crew",
  "Men's Cricket",
  "Men's Cross Country",
  "Men's Equestrian",
  "Men's Fencing",
  "Men's Golf",
  "Men's Gymnastics",
  "Men's Handball",
  "Men's Ice Hockey",
  "Men's Judo",
  "Men's Lacrosse",
  "Men's Lightweight Crew",
  "Men's Lightweight Football",
  "Men's Pistol",
  "Men's Polo",
  "Men's Rifle",
  "Men's Rodeo",
  "Men's Rugby",
  "Men's Sailing",
  "Men's Skiing",
  "Men's Slow Pitch Softball",
  "Men's Soccer",
  "Men's Squash",
  "Men's Swimming",
  "Men's Tennis",
  "Men's Track, Indoor",
  "Men's Track, Outdoor",
  "Men's Triathlon",
  "Men's Volleyball",
  "Men's Water Polo",
  "Men's Water Skiing",
  "Men's Wrestling",
  "Mixed Archery",
  "Mixed Badminton",
  "Mixed Bowling",
  "Mixed Cheerleading",
  "Mixed Crew",
  "Mixed Cricket",
  "Mixed Cross Country",
  "Mixed Equestrian",
  "Mixed Fencing",
  "Mixed Golf",
  "Mixed Gymnastics",
  "Mixed Handball",
  "Mixed Judo",
  "Mixed Pistol",
  "Mixed Polo",
  "Mixed Rifle",
  "Mixed Sailing",
  "Mixed Skiing",
  "Mixed Slow Pitch Softball",
  "Mixed Squash",
  "Mixed Swimming",
  "Mixed Tennis",
  "Mixed Track, Indoor",
  "Mixed Track, Outdoor",
  "Mixed Water Skiing",
  "Mixed Wrestling",
  "Softball",
  "Women's Basketball",
  "Women's Bowling",
  "Women's Cheerleading",
  "Women's Cricket",
  "Women's Cross Country",
  "Women's Equestrian",
  "Women's Fencing",
  "Women's Golf",
  "Women's Gymnastics",
  "Women's Ice Hockey",
  "Women's Ice Skating",
  "Women's Judo",
  "Women's Lacrosse",
  "Women's Pistol",
  "Women's Polo",
  "Women's Rifle",
  "Women's Rowing",
  "Women's Rugby",
  "Women's Sailing",
  "Women's Sand Volleyball",
  "Women's Skiing",
  "Women's Slow Pitch Softball",
  "Women's Soccer",
  "Women's Squash",
  "Women's Swimming",
  "Women's Tennis",
  "Women's Track, Indoor",
  "Women's Triathlon",
  "Women's Track, Outdoor",
  "Women's Volleyball",
  "Women's Water Polo",
  "Women's Water Skiing",
  "Women's Wrestling"
)

ncaa_sports <- data.frame(code = sport_code, sport = sport)

usethis::use_data(ncaa_sports, overwrite = TRUE)
