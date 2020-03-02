
# Aim of this function:
#   read the Institute for Democracy and Electoral Assistance data, select the variables of interest, add new computed variables if needed, and,
#   save the output as IDEA_tidy.rds.

# note: this function is called from tidy_datasets.R

tidy_IDEA <- function(path_loadoriginal, path_savetidy){
  
  #       1. read IDEA Data
  print("importing IDEA data... ")
  IDEA  <- rio::import(path_loadoriginal)
  # IDEA  <- rio::import("../../../Data/Original Data/IDEA/idea_voterturnout.xlsx") # for debugging

  print("importing done")
  
  IDEA_tidy <- IDEA  %>%
    select(
      Year,
      Country,
      Voter_Turnout = `Voter Turnout`
    ) %>%
    filter(
      year >= 1970
    ) %>%
    mutate(
      country = as.factor(country)
      ) %>%
    arrange(country, year)
  # glimpse(penn_tidy)
  print("tidying done")
  
  
  saveRDS(IDEA_tidy, file = path_savetidy)
  # saveRDS(PENN_tidy, file = "../../../Data/Processed Data/IDEA_tidy.rds")
  
  print("processed IDEA data saved")
  
}
