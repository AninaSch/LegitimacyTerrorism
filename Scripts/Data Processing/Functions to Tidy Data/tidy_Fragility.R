# Aim of this function:

tidy_Fragility <- function(path_loadoriginal, path_savetidy){
  
  print("This function has to be cleaned")
  
  library(sjlabelled) # to get labels of labelled data
  library(Hmisc) # the data labels (variable names)
  library(dbplyr)
  library(tidyverse)
  
  # read Fragility Data
  print("importing Fragility data... (1min) ")
  Fragility <- rio::import(path_loadoriginal)
  # Fragility <- rio::import("../../../Data/Original Data/SystemicPeace/StateFragility/SFIv2017.xls") # for debugging
  # glimpse(Fragility)
  print("importing done")
  
  # Fragility_labels <- label(Fragility)
  # Fragility_labels[[1]] to access only the label.
  
  # as the data is encoded, we need to decode the variables that interest us.
  # e.g. country is a number and should be a name etc.
  # 1. COUNTRY - S003
  # https://cran.r-project.org/web/packages/sjlabelled/vignettes/labelleddata.html

  Fragility_tidy <- Fragility %>%
    select(
      country = country,
      year = year,
      fragility = sfi,
      effect = effect,
      legit = legit, 
      seceff = seceff, 
      secleg = secleg, 
      poleff = poleff, 
      polleg = polleg, 
      ecoeff = ecoeff, 
      ecoleg = ecoleg, 
      soceff = soceff, 
      socleg = socleg
    ) %>%
    filter(
      year >= 1970
      # remove missing values that are coded with negative numbers:
    ) %>%
    arrange(country, year) %>%
    mutate(country = as.factor(country))  
  
  # table(WVS_tidy$trust_others, useNA="ifany")
  # table(WVS_tidy$importance_politics, useNA="ifany")
  # table(WVS_tidy$interest_politics1, useNA="ifany")

# recode variables so that higher values = better  
  
  
  saveRDS(Fragility_tidy, file = path_savetidy)
  # saveRDS(Fragility_tidy, file = "../../../Data/Processed Data/Fragility_tidy.rds")
  print("processed Fragility saved")
  

}


# res <- Fragility_tidy %>% group_by(country,year) %>% summarise(Freq=n())


