# Aim of this function:
#   read the Prio data, select the variables of interest, add new computed variables if needed, and,
#   save the output as Prio_tidy.rds.

# note: this function is called from tidy_datasets.R


# 1 = extrasystemic (between a state and a non-state group outside its own territory, where the government side is fighting to retain control of a territory outside the state system)
# 2 = interstate (both sides are states in the Gleditsch and
#                 Ward membership system).
# 3 = internal (side A is always a government; side B is
#               always one or more rebel groups; there is no
#               involvement of foreign governments with troops, i.e.
#               there is no side_a_2nd or side_b_2nd coded)
# 4 = internationalized internal (side A is always a
#                                 government; side B is always one or more rebel
#                                 groups; there is involvement of foreign
#                                 governments with troops, i.e. there is at least ONE
#                                 side_a_2nd or side_b_2nd coded)


tidy_PRIO <- function(path_loadoriginal, path_savetidy){
  
  library(fastDummies)
  
  #       1. read prio Data
  #print("importing prio data... ")
  prio <- rio::import(path_loadoriginal)
  # prio <- rio::import("../../../Data/Original Data/PRIO/ucdp-prio-acd-191.xlsx") # for debugging
  
  # glimpse(prio)
  print("importing done")
  
  # change location to country
  
  colnames(prio)[colnames(prio)=="location"] <- "country"
  
  prio_tidy <- prio %>%
    select(
      year,
      country,
      type_of_conflict
    ) %>%
    filter(
      year >= 1970
    ) %>%
    separate(country, 
             into = c("ctry1", "ctry2", "ctry3", "ctry4"), 
             sep = ",") %>% # location = all countries involved. take them all into account (max=4)
    gather(key = location, value = country, c("ctry1", "ctry2", "ctry3", "ctry4"), na.rm = TRUE) %>%
    mutate(country = as.factor(str_trim(country, side = "left"))) %>%
    select(-location) %>%
    arrange(country, year)
  # glimpse(prio_tidy)
  
  
  # create dummy for type of conflict:
  prio_tidy <- fastDummies::dummy_cols(prio_tidy, select_columns = "type_of_conflict")

    # Handle issue of more than 1 conflict per country:
  prio_tidy <- prio_tidy %>% distinct()
  
  # concatenate cases with several types of conflicts per year
  prio_tidy <- prio_tidy %>%
    group_by(year, country) %>%
    summarise(type_of_conflict_1 = sum(type_of_conflict_1),
           type_of_conflict_2 = sum(type_of_conflict_2),
           type_of_conflict_3 = sum(type_of_conflict_3),
           type_of_conflict_4 = sum(type_of_conflict_4)) %>%
    mutate(any_conflict = type_of_conflict_1 + type_of_conflict_2 + 
             type_of_conflict_3 + type_of_conflict_4) %>%
    mutate(any_conflict = ifelse(any_conflict >= 1, 1, 0)) %>%
    arrange(country)
  
  
  print("tidying done")
  

  saveRDS(prio_tidy, file = path_savetidy)
  # saveRDS(prio_tidy, file = "../../../Data/Processed Data/prio_tidy.rds")
  
  print("processed Prio data saved")
  
  }
  

  # Look up countries
  # prio_tidy$country %>% unique
 