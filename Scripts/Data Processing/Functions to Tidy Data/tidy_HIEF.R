# Aim of this function:

tidy_HIEF <- function(path_loadoriginal, path_savetidy){
  
  print("This function has to be cleaned")
  
  library(sjlabelled) # to get labels of labelled data
  library(Hmisc) # the data labels (variable names)
  library(dbplyr)
  library(tidyverse)
  
  # read Fragility Data
  print("importing Fragility data... (1min) ")
  HIEF <- rio::import(path_loadoriginal)
  # HIEF <- rio::import("../../../Data/Original Data/HIEF/HIEF_data.csv") # for debugging
  # glimpse(Fragility)
  print("importing done")
  
  # HIEF_labels <- label(HIEF)
  # HIEF_labels[[1]] to access only the label.
  
  # as the data is encoded, we need to decode the variables that interest us.
  # e.g. country is a number and should be a name etc.
  # 1. COUNTRY - S003
  # https://cran.r-project.org/web/packages/sjlabelled/vignettes/labelleddata.html

  HIEF_tidy <- HIEF %>%
    select(
      country = Country,
      year = Year,
      EFindex = EFindex
    ) %>%
    filter(
      year >= 1970
      # remove missing values that are coded with negative numbers:
    ) %>%
    arrange(country, year) %>%
    mutate(country = as.factor(country))  

  
  saveRDS(HIEF_tidy, file = path_savetidy)
  # saveRDS(HIEF_tidy, file = "../../../Data/Processed Data/HIEF_tidy.rds")
  print("processed HIEF saved")
  

}




