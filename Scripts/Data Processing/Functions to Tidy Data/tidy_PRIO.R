# Aim of this function:
#   read the Prio data, select the variables of interest, add new computed variables if needed, and,
#   save the output as Prio_tidy.rds.

# note: this function is called from tidy_datasets.R

#tidy_GTD <- function(path_loadoriginal, path_savetidy){
  
  #       1. read prio Data
  #print("importing prio data... ")
  prio <- rio::import(path_loadoriginal)
  # prio <- rio::import("../../../Data/Original Data/PRIO/ucdp-prio-acd-191.xlsx") # for debugging
  
  glimpse(prio)
  print("importing done")
  
  # change location to country
  
  colnames(prio)[colnames(prio)=="location"] <- "country"
  
  prio_tidy <- prio %>%
    select(
      year,
      country,
      type_of_conflict,
    ) %>%
    filter(
      year >= 1970
    ) %>%
    mutate(country = as.factor(country)) %>%
    arrange(country, year) %>%
    separate(country, 
             into = c("ctry1", "ctry2", "ctry3", "ctry4"), 
             sep = ",") %>% # location = all countries involved. take them all into account (max=4)
    gather(key = location, value = country, c("ctry1", "ctry2", "ctry3", "ctry4"), na.rm = TRUE) %>%
    select(-location) %>%
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
  print("TO DO: HANDLE SPECIAL COUNTRIES (north/south Yemen, Zimbabwe (Rhodesia), ...)")
  
  
  
  saveRDS(prio_tidy, file = path_savetidy)
  print("processed Prio data saved")
  
  }
