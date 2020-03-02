# Aim of this function:
#   read the ELRF data, select the variables of interest, add new computed variables if needed, and,
#   save the output as ELRF_tidy.rds.

tidy_ELRF <- function(path_loadoriginal, path_savetidy){
  
  print("This function has to be cleaned")
  
  library(sjlabelled) # to get labels of labelled data
  library(Hmisc) # the data labels (variable names)
  library(dbplyr)
  library(tidyverse)
  
  # read ELRF Data
  print("importing ELRF data... (1min) ")
  ELRF <- rio::import(path_loadoriginal)
  # ELRF <- rio::import("../../../Data/Original Data/ELRF/ELRFdata.xlsx") # for debugging
  # glimpse(WVS)
  print("importing done")
 
  ELRF_tidy <- ELRF %>%
    select(
      country = Country,
      ethnic = Ethnic,
      linguisitc = Linguistic,
      religious = Religious
    ) %>%
    arrange(country) %>%
    mutate(country = as.factor(country))  
  
  saveRDS(ELRF_tidy, file = path_savetidy)
  # saveRDS(ELRF_tidy, file = "../../../Data/Processed Data/ELRF_tidy.rds")
  print("processed ELRF data saved")
  
}
