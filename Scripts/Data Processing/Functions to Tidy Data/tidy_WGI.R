# TO DO 
# DROP COLUMS
# CANCEL SECOND ROW
# TRANSPOSE ROW INTO COLUMS


# Aim of this function:
#   read the WGI data, select the variables of interest, add new computed variables if needed, and,
#   save the output as WGI_TIDY.rds.

# note: this function is called from tidy_datasets.R

# tidy_GTD <- function(path_loadoriginal, path_savetidy){
  
  #       1. read Polity Data
  print("importing WGI data... ")
  WGI <- rio::import(path_loadoriginal)
  # WGI <- rio::import("../../../Data/Original Data/WorldBank/WorldGovIndex/wgidataset_account.xls") # for debugging
  # glimpse(polity)
  print("importing done")
  
  WGI_tidy <- WGI %>%
    select(
      year,
      country,
      polity, polity2,
      democ, autoc,
      xrreg, xrcomp, xropen, xconst, parreg, parcomp, # component variables
      exrec, exconst, polcomp # concept variables
    ) %>%
    filter(
      year >= 1970
    ) %>%
    mutate(country = as.factor(country)) %>%
    arrange(country, year)
  # glimpse(polity_tidy)
  print("tidying done")
  
  # handle special countries:
  # as we match to GTD, we should have the same countries as there.
  # this is not about spelling, spelling is handled in Data/Processed Data/To Clean Countries/countries.csv
  # but about the different splits of the countries.
  
  # e.g. GTD has no distinction btw north and south Yemem. Polity does before 1990
  # so we cuold average Yemen scores by year in Polity before 1990 and rename country as Yemen

  # TO DO:
  # NEED TO HANDLE SPECIAL COUNTRIES. currentloy those are dropped when merging with GTD...
  print("TO DO: HANDLE SPECIAL COUNTRIES (north/south Yemen, Vietnam, Soudan...)")
  
  # TO DO:
  # NEED TO HANDLE HERE THE SPECIAL CASES, WHEN THE SCORES ARE -77, -66 etc.
  print("TO DO: HANDLE SPECIAL SCORES (-66, -77, -99...)")

  saveRDS(WGI_tidy, file = path_savetidy)
  print("processed WGI data saved")
  
}
