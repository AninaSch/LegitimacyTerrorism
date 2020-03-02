# Aim of this function:
#   read the IMF data, select the variables of interest, add new computed variables if needed, and,
#   save the output as IMF_TIDY.rds.

# note: this function is called from tidy_datasets.R

# set working direcotry 

# setwd("/Users/schwarze/Documents/GitHub/LegitimacyTerrorism/Scripts/Data Processing/Functions to Tidy Data")
# getwd()

library(tidyverse) # data wrangling etc.
library(rio)

tidy_WGI <- function(path_loadoriginal, path_savetidy){
  
  #   read IMF account Data
  print("importing WGI account data... ")
  # IMF <- rio::import(path_loadoriginal)
  # IMF <- rio::import("/Users/schwarze/Documents/GitHub/LegitimacyTerrorism/Data/Original Data/InternationalMonetaryFund/GovernanceFinanceStatistics/GFSMAB_02-18-2020 17-58-46-09_timeSeries.csv") # for debugging
  IMF <- rio::import(paste0(path_loadoriginal, "GFSMAB_02-18-2020 17-58-46-09_timeSeries.csv")) # for debugging
  
  glimpse(IMF)
  print("importing done")
  
  # extract columns "Country Names", "Classification Name", "Unit Name", and years 2000-2018 as a data table
  IMF_sub <- IMF %>% select(1:9, 38:57)
  
  # label first colum: country
  names(IMF_sub)[1]<-"country"
  
  # keep only tax revenues (CHECK WHETHER THAT IS CORRECT)
  IMF_sub_tax <- IMF_sub  %>%  filter(`Classification_Name`== "Tax revenue" & `Unit_Name`== "Percent of GDP" & `Attribute`== "Value" & `Sector_Name`== "General government")
  
  
  # reshape data with pivot()
  # https://tidyr.tidyverse.org/reference/pivot_longer.html
  
  IMF_tidy <- IMF_sub_tax %>% 
    select(1, 10:28)  %>% 
    pivot_longer(-country, names_to = "year", values_to = "tax_revenue") %>%
    arrange(country, year) %>%
    mutate(
      # year = str_sub(year, start = 1, end = 4),
      country = as.factor(country)
    )

  print("IMF_tidy done")
  
  saveRDS(IMF_tidy, file = path_savetidy)
  # saveRDS(IMF_tidy, file = "../../../Data/Processed Data/IMF_tidy.rds")
  
  print("processed WGI data saved")
  
}

# TO DO
# Look up countries
  # WGI_tidy$country %>% unique
