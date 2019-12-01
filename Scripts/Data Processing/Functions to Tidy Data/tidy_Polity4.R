
#NOTE
# ADD: 
# variables: DURABLE ; SF


# Aim of this function:
#   read the Polity IV data, select the variables of interest, add new computed variables if needed, and,
#   save the output as PolityIV_tidy.rds.

# note: this function is called from tidy_datasets.R

tidy_Polity4 <- function(path_loadoriginal, path_savetidy){
  
  #       1. read Polity Data
  print("importing Polity data... ")
  polity <- rio::import(path_loadoriginal)
  # polity <- rio::import("../../../Data/Original Data/SystemicPeace/p4v2017.xls") # for debugging
  # glimpse(polity)
  print("importing done")
  
  polity_tidy <- polity %>%
    select(
      year,
      country,
      polity, polity2,
      # democ, autoc,
      # xrreg, xrcomp, xropen, xconst, parreg, parcomp, # component variables
      exrec, exconst, polcomp, # concept variables
      durable #  regime durability
      # sf # state failure
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


# Cleaning of missing values
  
  # summary(polity_tidy)
  # describe(polity_tidy)
  # 
  polity_tidy[polity_tidy == -88] <- NA
  polity_tidy[polity_tidy == -77] <- NA
  polity_tidy[polity_tidy == -66] <- NA
  
  # Note
  # HANDLEd HERE THE SPECIAL CASES, WHEN THE SCORES ARE -77, -66 etc.
  # Revised Combined Polity Score: This variable is a modified version of the POLITY variable added
  # in order to facilitate the use of the POLITY regime measure in time-series analyses. It modifies the
  # combined annual POLITY score by applying a simple treatment, or ““fix,” to convert instances of
  # “standardized authority scores” (i.e., -66, -77, and -88) to conventional polity scores (i.e., within the
  #                                                                                          range, -10 to +10). The values have been converted according to the following rule set:
  #     -66 Cases of foreign “interruption” are treated as “system missing.”
  #     -77 Cases of “interregnum,” or anarchy, are converted to a “neutral” Polity score of “0.”
  #     -88 Cases of “transition” are prorated across the span of the transition.
  # For example, country X has a POLITY score of -7 in 1957, followed
  # by three years of -88 and, finally, a score of +5 in 1961. The change
  # (+12) would be prorated over the intervening three years at a rate of
  # per year, so that the converted scores would be as follows: 1957 -7;
  # 1958 -4; 1959 -1; 1960 +2; and 1961 +5.
  # Note: Ongoing (-88) transitions in the most recent year (2006) are converted to “system
  # missing” values. Transitions (-88) following a year of independence, interruption (-66),
  # or interregnum (-77) are prorated from the value “0.”

  
  saveRDS(polity_tidy, file = path_savetidy)
  # saveRDS(polity_tidy, file = "../../../Data/Processed Data/polity_tidy.rds")
  
  print("processed Polity data saved")
  
}


