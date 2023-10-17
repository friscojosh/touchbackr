#' Get kickoff play-level data
#'
#' @param season An NFL season from 2009-2023
#'
#' @return A tibble of play level kickoff data
#' @export
#'
#' @import nflreadr
#' @import dplyr
#' @import stringr
#'
#' @examples
#' # kickoffs <- get_kickoffs(2023)
get_kickoffs <- function(season) {

  pbp <- nflreadr::load_pbp(seasons = season)

  kickoffs <- pbp |>
    dplyr::filter(play_type == "kickoff") |>
    dplyr::select(desc, # play description
                  posteam, # team receiving the KO, not the kicking team
                  kickoff_in_endzone, # binary indicator
                  touchback, # binary indicator
                  return_yards, # unused. includes depth of KO in EZ
                  return_team, # should be the same as posteam. a sanity check
                  penalty, # binary indicator
                  penalty_yards,
                  epa,
                  wpa) |>
    # create features via regex-ing the play description
    dplyr::mutate(onside_kick = stringr::str_detect(desc, "onside"), # logical indicator
                  muff = ifelse(stringr::str_detect(desc, "MUFFS"), 1, 0), # binary so we can summarize later
                  extracted_text = ifelse(muff == 0, # exclude muffs
                                          stringr::str_extract(desc, "\\d+\\s+for\\s+\\d+\\s+yards"),
                                          stringr::str_extract(desc, "at (\\w+) \\d+")),
                  # return yards includes depth of the kick in the end zone.
                  # We don't care about that, so use the yardline from desc.
                  yardline = as.numeric(stringr::str_extract(extracted_text, "\\d+")),
                  # replace NA with 0 yards
                  penalty_yards = ifelse(!is.na(penalty_yards), penalty_yards, 0),
                  # net yards when accounting for penalty yards
                  yardline_less_penalty = yardline - penalty_yards)
}

#' Get returns taken out of the end zone, by team
#'
#' @param season An NFL season from 2009-2023
#'
#' @return A tibble kickoff data aggregated to the team-level
#' @export
#'
#' @import dplyr
#'
#' @examples
#' # teams <- get_ez_returns_by_team(2023)
get_ez_returns_by_team <- function(season) {

  kickoffs <- get_kickoffs(season)

  all_kickoffs <- kickoffs |>
    dplyr::filter(onside_kick == FALSE) |>
    dplyr::group_by(return_team) |>
    dplyr::summarise(kickoffs = dplyr::n())

  ez_returns_by_team <- kickoffs |>
    dplyr::filter(onside_kick == FALSE,
                  kickoff_in_endzone == 1) |>
    dplyr::group_by(return_team) |>
    dplyr::summarise(ez_kickoffs_returned = sum(kickoff_in_endzone),
                     return_yards = sum(yardline_less_penalty),
                     hypothetical_touchback_yards = ez_kickoffs_returned * 25,
                     penalty_yards = sum(penalty_yards),
                     muffs = sum(muff),
                     net_yards = return_yards - hypothetical_touchback_yards,
                     avg_net_yards = round(net_yards / ez_kickoffs_returned, 1),
                     epa = round(sum(epa), 1))

  joined <- all_kickoffs |>
    dplyr::left_join(ez_returns_by_team, dplyr::join_by(return_team)) |>
    dplyr::mutate(ez_return_share = round(ez_kickoffs_returned / kickoffs, 3) * 100) |>
    dplyr::arrange(-ez_kickoffs_returned)

}

#' Get season-to-date summary stats of returns taken out of the end zone at
#' the league-level
#'
#' @param season An NFL season from 2009-2023
#'
#' @return A tibble kickoff data aggregated to the league-level
#' @export
#'
#' @examples
#' # leagie <- get_ez_kickoff_league_summary(2023)
get_ez_kickoff_league_summary <- function(season) {

  kickoffs <- get_kickoffs(season)

  ez_return_league <- kickoffs |>
    dplyr::filter(onside_kick == FALSE,
                  kickoff_in_endzone == 1) |>
    dplyr::summarise(ez_kickoffs_returned = sum(kickoff_in_endzone),
                     return_yards = sum(yardline_less_penalty),
                     hypothetical_touchback_yards = ez_kickoffs_returned * 25,
                     penalty_yards = sum(penalty_yards),
                     muffs = sum(muff),
                     net_yards = return_yards - hypothetical_touchback_yards,
                     avg_net_yards = round(net_yards / ez_kickoffs_returned, 1),
                     epa = round(sum(epa), 1))
}
