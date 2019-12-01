
# Aim of this function:
#   read the Vdem data, select the variables of interest, add new computed variables if needed, and,
#   save the output as Vdem_tidy.rds.

# Note: this function is called from tidy_datasets.R

# V-dem codebook, pg. 343
# 
# V-Dem Democracy Indices
# V-Dem High-Level Democracy Indices
# Electoral democracy index (D) (v2x_polyarchy)
# Liberal democracy index (D) (v2x_libdem)
# Participatory democracy index (D) (v2x_partipdem)
# Deliberative democracy index (D) (v2x_delibdem)
# Egalitarian democracy index (D) (v2x_egaldem)
# 

tidy_Vdem <- function(path_loadoriginal, path_savetidy){
  
  #       1. read GTD
  print("importing GTD data... (30sec.)")
  Vdem <- rio::import(path_loadoriginal)
  # Vdem <- rio::import("../../../Data/Original Data/Vdem/Country_Year_V-Dem_Core_CSV_v9/V-Dem-CY-Core-v9.csv")
  print("importing done")

  glimpse(Vdem[,1:10])
  
  
  library(sjlabelled) # to get labels of labelled data
  library(Hmisc) # the data labels (variable names)
  library(dbplyr)
  library(tidyverse)
  
  glimpse(Vdem[,1:10])
  
  # Selected, filtered and renamed data is saved as GTD_clean:
  Vdem_tidy <- Vdem %>% 
    select(
      year = year, 
      country = country_name,
      electoral_democracy = v2x_polyarchy,
      liberal_democracy = v2x_libdem,
      participatory_democracy = v2x_partipdem,
      deliberative_democracy = v2x_delibdem,
      egalitarian_democracy = v2x_egaldem
    ) %>% 
    filter(year > 1999) %>%
    mutate(
      country = as.factor(country)
    ) %>% # we sort by country and year (aesthetic):
    arrange(country, year)
  
  #     5. save output dataset:
  saveRDS(Vdem_tidy, file = path_savetidy)
  # saveRDS(Vdem_tidy, file = "../../../Data/Processed Data/Vdem_tidy.rds")
  
  print("saving processed data Vdem done")
  
}




