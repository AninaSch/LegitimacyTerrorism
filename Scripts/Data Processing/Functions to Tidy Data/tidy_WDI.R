# Aim of this function:
#   read the WDI data, select the variables of interest, add new computed variables if needed, and,
#   save the output as WDI_TIDY.rds.
# note: this function is called from tidy_datasets.R
# set working direcotry 

# variables of interest

# Country Name
# Year = 1E- 1 BL (1960-2019)

# Indicator Name & Indicator Code

# a) Population ages 0-14 (% of total population)
# SP.POP.0014.TO.ZS
# 
# b) GINI index (World Bank estimate)
# SI.POV.GINI
# 
# c)
# Urban population growth (annual %)
# SP.URB.GROW


tidy_WDI <- function(path_loadoriginal, path_savetidy){
  
  library(sjlabelled) # to get labels of labelled data
  library(Hmisc) # the data labels (variable names)
  library(dbplyr)
  library(tidyverse)
  
  
  #   read WDI Data
  print("importing WDI data... ")
  # WDI <- rio::import(path_loadoriginal)
  WDI <- rio::import("../../../Data/Original Data/WorldBank/WDI/WDIEXCEL.xlsx") 

  glimpse(WDI)
  print("importing done")
  
  
  # extract columns "Country Name", "Indicator Code" and year (1970-2019)
  WDI_sub <- WDI %>% select(1, 4, 15:64)
  
  # label first colum: country
  names(WDI_sub)[1]<-"country"
  names(WDI_sub)[2]<-"indicator"
  
  table(WDI_sub$country)
  
  # exclude some countries
  WDI_subsub <- WDI_sub  %>%
    filter(!country %in% c("East Asia & Pacific", "Euro area", "Europe & Central Asia", "High income",
                           "Arab World", "Central Europe and the Baltics", 
                           "British Virgin Islands",  "Caribbean small states", "Curacao", "Early-demographic dividend", "East Asia & Pacific (excluding high income)", "East Asia & Pacific (IDA & IBRD countries)", "Eswatini",
                           "Europe & Central Asia (excluding high income)", "Europe & Central Asia (IDA & IBRD countries)", "European Union", "Fragile and conflict affected situations", "Faroe Islands", "Gibraltar",
                           "Heavily indebted poor countries (HIPC)",
                            "IBRD only", "IDA & IBRD total", "IDA blend", "IDA only", "IDA total", "Isle of Man",
                            "Late-demographic dividend", "Latin America & Caribbean",
                            "Latin America & Caribbean (excluding high income)",
                            "Latin America & the Caribbean (IDA & IBRD countries)",
                            "Least developed countries: UN classification",
                            "Low & middle income", "Low income", "Lower middle income",
                            "Micronesia, Fed. Sts.", "Middle East & North Africa",
                            "Middle East & North Africa (excluding high income)",
                            "Middle East & North Africa (IDA & IBRD countries)", "Middle income", "New Caledonia",
                            "Northern Mariana Islands", "Not classified", "North America",
                            "OECD members", "Other small states", "Pacific island small states",
                            "Post-demographic dividend", "Pre-demographic dividend", "Small states", "South Asia",
                            "South Asia (IDA & IBRD)", "Sub-Saharan Africa", "South Africa",
                            "Sub-Saharan Africa (excluding high income)", "Sub-Saharan Africa (IDA & IBRD countries)",
                            "Sint Maarten (Dutch part)", "St. Martin (French part)",
                            "Turks and Caicos Islands", "Tuvalu", "Upper middle income", "Vanuatu", "World"))
  table(WDI_subsub$country)
  
  # keep only observations of interest
  WDI_subsubsub <- WDI_subsub  %>%
    filter(indicator %in% c("SI.POV.GINI", "SP.POP.0014.TO.ZS","SP.URB.GROW")) 

 # reshape data 1970 - 2019
  WDI_tidy_temp <- WDI_subsubsub %>% 
    gather("year", "indicator" , 3:52) %>%
    arrange(country, year) 
  
  # add column
  list <- 1:10100
  
  WDI_tidy <- WDI_tidy_temp %>%
    mutate(temp = rep(c(1:3), length(list))) %>%
    spread("temp", "indicator") %>%
    rename( `GINI_index` = "1", `youth_burden` = "2", urbanization = "3") %>%
    mutate(year = as.numeric(year))
  
  print("WDI_tidy")

  saveRDS(WDI_tidy, file = path_savetidy)
  # saveRDS(WDI_tidy, file = "../../../Data/Processed Data/WDI_tidy.rds")
  
  print("processed WDI data saved")
}
