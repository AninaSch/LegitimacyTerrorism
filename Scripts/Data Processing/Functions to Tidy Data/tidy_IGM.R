
# Aim of this function:
#   read the Intergenerational Mobility data, select the variables of interest, add new computed variables if needed, and,
#   save the output as IGM_tidy.rds.

# note: this function is called from tidy_datasets.R

tidy_IGM <- function(path_loadoriginal, path_savetidy){
  
### read IGM Data
  print("importing Intergenerational Mobility data... ")
  # IGM <- rio::import(path_loadoriginal)
  IGM <- rio::import("../../../Data/Original Data/WorldBank/InterGenerationalMobility/GDIMMay2018.csv") # for debugging

  print("importing done")
  
  IGM_sub <- IGM %>%
    select(
      year,
      country = countryname,
      cohort,
      parent,
      child,
      intergen_persistance = IGP
    ) %>%
    filter(
      year >= 1970 # decide where to put the treshold
    ) %>%
    mutate(
      country = as.factor(country)
      ) %>%
    arrange(country, year)
  # glimpse(penn_tidy)
  print("tidying done")
  
### keep only parent "average" and child "all"  (CHECK WHETHER THAT IS CORRECT)

  IGM_sub_filter <- IGM_sub  %>%  filter(`parent`== "avg" & `child`== "all")   %>%  
    select(-parent, -child, -year)
 
  IGM_tidy <- IGM_sub_filter  %>% 
    pivot_wider(names_from = cohort, values_from = intergen_persistance) %>%
    rename (IGP_1980_cohort = "1980", IGP_1970_cohort = "1970")
  
 
  # MATCH YEAR OF BIRTH WITH YEARS OF RELEVANCE
  
  # FILL IN MISSING YEARS SO IT CAN BE MATCHED TO MASTER DATAFRAME
  
  saveRDS(IGM_tidy, file = path_savetidy)
  # saveRDS(IGM_tidy, file = "../../../Data/Processed Data/IGM_tidy.rds")
  
  print("processed Intergenerational Mobility data saved")
  
}
