# Aim of this function:
#   read the ELRF data, select the variables of interest, add new computed variables if needed, and,
#   save the output as ELRF_tidy.rds.

tidy_Gallup <- function(path_loadoriginal, path_savetidy){
  
  print("This function has to be cleaned")
  
  library(sjlabelled) # to get labels of labelled data
  library(Hmisc) # the data labels (variable names)
  library(dbplyr)
  library(tidyverse)
  
  # read Gallup Data
  print("importing Gallup data... (1min) ")
  Gallup <- rio::import(path_loadoriginal)
  # Gallup <- rio::import("../../../Data/Original Data/Gallup/GallupAnalytics_Export_ConfidenceGovernment.xlsx") # for debugging
  # glimpse(Gallup)
  print("importing done")
 
  Gallup_select <- Gallup %>%
    select(
      country = Geography,
      year = Time,
      government_confidence = Yes
    ) %>%
    arrange(country, year) %>%
    mutate(country = as.factor(country))  
  
  # calculate mean confidence
  
  Gallup_tidy <- Gallup_select %>%
    group_by(country) %>% # we average by individual !
    summarise(
      mean_government_confidence = mean(government_confidence, na.rm=TRUE)
    ) %>%
    arrange()
  print("tidying done")
  
  saveRDS(Gallup_tidy, file = path_savetidy)
  # saveRDS(Gallup_tidy, file = "../../../Data/Processed Data/Gallup_tidy.rds")
  print("processed Gallup data saved")
  
}
