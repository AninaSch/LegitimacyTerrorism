# Aim of this function:
#   read the WVS data, select the variables of interest, add new computed variables if needed, and,
#   save the output as WVS_tidy.rds.

# note: this function is called from tidy_datasets.R

tidy_WVS <- function(path_loadoriginal, path_savetidy){
  
  library(sjlabelled) # to get labels of labelled data
  library(Hmisc) # the data labels (variable names)
  
  #       1. read Polity Data
  print("importing WVS data... (1min) ")
  WVS <- rio::import(path_loadoriginal)
  # WVS <- rio::import("../../../Data/Original Data/WorldValueSurvey/F00008390-WVS_Longitudinal_1981_2016_r_v20180912.rds") # for debugging
  # glimpse(WVS)
  print("importing done")
  
  # wws_labels <- label(WVS)
  # wws_labels[[1]] to access only the label.
  
  # as the data is encoded, we need to decode the variables that interest us.
  # e.g. country is a number and should be a name etc.
  # 1. COUNTRY - S003
  # https://cran.r-project.org/web/packages/sjlabelled/vignettes/labelleddata.html
  WVS <- WVS %>% mutate(S003_country = sjlabelled::as_label(WVS$S003))
  
  WVS_tidy <- WVS %>%
    select(
      country = S003_country,
      year = S020,
      # A165, # Most people can be trusted 
      interpersonal_trust = G007_64, # Trust: People in general 
      # A004, # Important in life: Politics 
      # A0C04_CO, # Politics important 
      political_interest = E023, # Interest in politics 
      # E150, # How often follows politics in the news 
      # A062 # How often discusses political matters with friends 
    ) %>%
    filter(
      year >= 1970
    ) %>%
    mutate(country = as.factor(country)) %>%
    arrange(country, year)
  
    wws_political_interest <- WVS_tidy %>% 
      select(year, country, political_interest) %>%
      # no missing data
      group_by(year, country) %>%
      # group_by(country) %>%
      summarise(avg_political_interest = mean(political_interest)) %>%
      arrange(country, year)
  
  # group by year, average score.

    print("tidying done")
  
  # TO DO:
  print("TO DO: FIND RIGHT MEASURE! for interpersonal_trust as mostly -4")
  
  print("TO DO: HOW TO DEAL WITH THE SCARCITY OVER THE YEARS?")
  

  saveRDS(wws_political_interest, file = path_savetidy)
  print("processed WVS data saved")
  
}
