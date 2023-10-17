
<!-- README.md is generated from README.Rmd. Please edit that file -->

# touchbackr

<!-- badges: start -->
<!-- badges: end -->

The touchbackr package exists to quickly aggregate data on kickoffs that
are returned out of the end zone in NFL games.

A rule change instituted by the NFL prior to the 2023 season which
allows for the receiving team to signal a fair catch at any spot on the
field before the 25 yard line and to get the ball at the 25.

The rationale for this change was player safety, and the league office
predicted that there would be a [15 percent drop in
concussions](https://twitter.com/judybattista/status/1661036967599960068?s=20)
due to the rule change.

The data this package delivers is in a sense conservative. It looks at
kickoffs that travel into the end zone and calculates the resulting
yardage lost or gained on plays where teams decide to return the ball
out of the end zone. These are situations where it is extremely
difficult to rationalize a positive expected value for returning the
football out of the end zone. These are also situations where players
could easily be coached simply take the yards (“if your feet are in the
end zone, fair catch it”).

## Installation

You can install the development version of touchbackr from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("friscojosh/touchbackr")
```

## Example

``` r
library(touchbackr)
library(knitr)
team_end_zone_returns <- touchbackr::get_ez_returns_by_team(2023)
knitr::kable(team_end_zone_returns)
```

| return_team | kickoffs | ez_kickoffs_returned | return_yards | hypothetical_touchback_yards | penalty_yards | muffs | net_yards | avg_net_yards |  epa | ez_return_share |
|:------------|---------:|---------------------:|-------------:|-----------------------------:|--------------:|------:|----------:|--------------:|-----:|----------------:|
| GB          |       26 |                   10 |          187 |                          250 |            35 |     0 |       -63 |          -6.3 | -4.3 |             0.4 |
| NO          |       26 |                    5 |           95 |                          125 |             0 |     0 |       -30 |          -6.0 | -1.9 |             0.2 |
| BAL         |       26 |                    4 |           87 |                          100 |             8 |     0 |       -13 |          -3.2 | -2.0 |             0.2 |
| CAR         |       37 |                    4 |           94 |                          100 |             0 |     0 |        -6 |          -1.5 | -0.7 |             0.1 |
| DEN         |       39 |                    4 |           65 |                          100 |            10 |     1 |       -35 |          -8.8 | -2.6 |             0.1 |
| CHI         |       34 |                    3 |           72 |                           75 |             0 |     0 |        -3 |          -1.0 | -0.3 |             0.1 |
| HOU         |       26 |                    3 |           55 |                           75 |             8 |     0 |       -20 |          -6.7 | -1.7 |             0.1 |
| JAX         |       25 |                    3 |           72 |                           75 |             0 |     0 |        -3 |          -1.0 | -0.4 |             0.1 |
| NE          |       37 |                    3 |           57 |                           75 |             0 |     0 |       -18 |          -6.0 | -1.4 |             0.1 |
| PIT         |       26 |                    3 |           72 |                           75 |             0 |     0 |        -3 |          -1.0 | -0.3 |             0.1 |
| WAS         |       38 |                    3 |           63 |                           75 |             0 |     0 |       -12 |          -4.0 | -0.9 |             0.1 |
| CLE         |       19 |                    2 |           39 |                           50 |             0 |     0 |       -11 |          -5.5 | -1.0 |             0.1 |
| DET         |       25 |                    2 |           46 |                           50 |             0 |     0 |        -4 |          -2.0 | -0.3 |             0.1 |
| LV          |       29 |                    2 |           65 |                           50 |             0 |     0 |        15 |           7.5 |  0.8 |             0.1 |
| MIA         |       33 |                    2 |           48 |                           50 |             0 |     0 |        -2 |          -1.0 | -0.3 |             0.1 |
| NYJ         |       33 |                    2 |           47 |                           50 |             0 |     0 |        -3 |          -1.5 | -0.4 |             0.1 |
| SF          |       24 |                    2 |           29 |                           50 |             0 |     0 |       -21 |         -10.5 | -1.6 |             0.1 |
| TB          |       22 |                    2 |           30 |                           50 |             8 |     0 |       -20 |         -10.0 | -1.7 |             0.1 |
| ARI         |       35 |                    1 |           24 |                           25 |             0 |     0 |        -1 |          -1.0 | -0.2 |             0.0 |
| ATL         |       30 |                    1 |           17 |                           25 |             0 |     0 |        -8 |          -8.0 | -0.5 |             0.0 |
| BUF         |       24 |                    1 |           20 |                           25 |             0 |     0 |        -5 |          -5.0 | -0.5 |             0.0 |
| CIN         |       29 |                    1 |           17 |                           25 |             0 |     0 |        -8 |          -8.0 | -0.6 |             0.0 |
| LAC         |       25 |                    1 |           14 |                           25 |             0 |     0 |       -11 |         -11.0 | -0.8 |             0.0 |
| NYG         |       34 |                    1 |           16 |                           25 |            10 |     0 |        -9 |          -9.0 | -1.0 |             0.0 |
| PHI         |       25 |                    1 |           16 |                           25 |             0 |     0 |        -9 |          -9.0 | -0.7 |             0.0 |
| SEA         |       24 |                    1 |           28 |                           25 |             0 |     0 |         3 |           3.0 |  0.1 |             0.0 |
| TEN         |       31 |                    1 |           20 |                           25 |             0 |     0 |        -5 |          -5.0 | -0.4 |             0.0 |
| DAL         |       23 |                   NA |           NA |                           NA |            NA |    NA |        NA |            NA |   NA |              NA |
| IND         |       35 |                   NA |           NA |                           NA |            NA |    NA |        NA |            NA |   NA |              NA |
| KC          |       21 |                   NA |           NA |                           NA |            NA |    NA |        NA |            NA |   NA |              NA |
| LA          |       29 |                   NA |           NA |                           NA |            NA |    NA |        NA |            NA |   NA |              NA |
| MIN         |       28 |                   NA |           NA |                           NA |            NA |    NA |        NA |            NA |   NA |              NA |

``` r
league_ez_stats <- touchbackr::get_ez_kickoff_league_summary(2023)
knitr::kable(league_ez_stats)
```

| ez_kickoffs_returned | return_yards | hypothetical_touchback_yards | penalty_yards | muffs | net_yards | avg_net_yards |   epa |
|---------------------:|-------------:|-----------------------------:|--------------:|------:|----------:|--------------:|------:|
|                   68 |         1395 |                         1700 |            79 |     1 |      -305 |          -4.5 | -25.4 |
