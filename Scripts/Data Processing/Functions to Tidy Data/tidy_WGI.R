# Aim of this function:
#   read the WGI data, select the variables of interest, add new computed variables if needed, and,
#   save the output as WGI_TIDY.rds.
# The Worldwide Governance Indicators (WGI) project constructs aggregate indicators of six broad dimensions of governance:
#   1. Voice and Accountability
#   2. Political Stability and Absence of Violence/Terrorism
#   3. Government Effectiveness
#   4. Regulatory Quality
#   5. Rule of Law
#   6. Control of Corruption
# The six aggregate indicators are based on  over 30 underlying data sources reporting the perceptions of governance of a large number of survey  respondents and expert assessments worldwide.  Details on the underlying data sources, the aggregation method, and the interpretation of the indicators, can be found in the WGI methodology paper:
#   Daniel Kaufmann, Aart Kraay and Massimo Mastruzzi (2010).  "The Worldwide Governance Indicators : A Summary of Methodology, Data and Analytical Issues". World Bank Policy Research  Working Paper No.  5430
# http://papers.ssrn.com/sol3/papers.cfm?abstract_id=1682130
# Full interactive access to the aggregate indicators, and the underlying source data, is available at www.govindicators.org.
# Note that this Worldwide Governance Indicators update incorporates revisions to data for previous years, and so this data release supersedes data from all previous releases.


# note: this function is called from tidy_datasets.R

# set working direcotry 

# setwd("/Users/schwarze/Documents/GitHub/LegitimacyTerrorism/Scripts/Data Processing/Functions to Tidy Data")
# getwd()

tidy_WGI <- function(path_loadoriginal, path_savetidy){
  
  
  # 1. ACCOUNTABILITY  
  #   read WGI account Data
  print("importing WGI account data... ")
  # WGI_account <- rio::import(path_loadoriginal)
  # WGI_account <- rio::import("/Users/schwarze/Documents/GitHub/LegitimacyTerrorism/Data/Original Data/WorldBank/WorldGovIndex/wgidataset_account.xlsx") # for debugging
  WGI_account <- rio::import(paste0(path_loadoriginal, "wgidataset_account.xlsx")) # for debugging
  
  glimpse(WGI_account)
  print("importing done")
  
  # extract columns "estimates" as a data table
  WGI_accountsub <- WGI_account %>% select(1, 2, 8, 14, 20, 26, 32, 38, 44, 50, 56, 62, 68, 74, 80, 86, 92, 98, 104, 110)
  
  # delete first row
  WGI_accountsub = WGI_accountsub[-1,]
  
  # label first colum: country
  names(WGI_accountsub)[1]<-"country"
  
  # reshape data
  WGI_accounttidy <- WGI_accountsub %>% 
    gather("year", "accountability", 2:20) %>%
    arrange(country, year) %>%
    mutate(
      year = str_sub(year, start = 1, end = 4),
      country = as.factor(country)
    )
  
  print("WGI_accounttidy done")
  
  
  # 2. POLITICAL STABILITY  
  #  read WGI political stability data
  print("importing WGI stability data... ")
  # WGI_stability <- rio::import(path_loadoriginal)
  # WGI_stability <- rio::import("/Users/schwarze/Documents/GitHub/LegitimacyTerrorism/Data/Original Data/WorldBank/WorldGovIndex/wgidataset_stability.xlsx") # for debugging
  WGI_stability <- rio::import(paste0(path_loadoriginal, "wgidataset_stability.xlsx")) # for debugging
  
  glimpse(WGI_stability)
  print("importing done")
  
  # extract columns "estimates" as a data table
  WGI_stabilitysub <- WGI_stability %>% select(1, 2, 8, 14, 20, 26, 32, 38, 44, 50, 56, 62, 68, 74, 80, 86, 92, 98, 104, 110)
  
  # delete first row
  WGI_stabilitysub = WGI_stabilitysub[-1,]
  
  # label first colum: country
  names(WGI_stabilitysub)[1]<-"country"
  
  # reshape data
  WGI_stabilitytidy <- WGI_stabilitysub %>% 
    gather("year", "stability", 2:20) %>%
    arrange(country, year) %>%
    mutate(
      year = str_sub(year, start = 1, end = 4),
      country = as.factor(country)
    )
  
  print("WGI_stabilitytidy done")
  
  
  # 3. GOVERNMENT EFFECTIVENESS
  #  read WGI government effectiveness data
  print("importing WGI stability data... ")
  # WGI_effect <- rio::import(path_loadoriginal)
  # WGI_effect <- rio::import("/Users/schwarze/Documents/GitHub/LegitimacyTerrorism/Data/Original Data/WorldBank/WorldGovIndex/wgidataset_effect.xlsx") # for debugging
  WGI_effect <- rio::import(paste0(path_loadoriginal, "wgidataset_effect.xlsx")) # for debugging
  
  glimpse(WGI_effect)
  print("importing done")
  
  # extract columns "estimates" as a data table
  WGI_effectsub <- WGI_effect %>% select(1, 2, 8, 14, 20, 26, 32, 38, 44, 50, 56, 62, 68, 74, 80, 86, 92, 98, 104, 110)
  
  # delete first row
  WGI_effectsub = WGI_effectsub[-1,]
  
  # label first colum: country
  names(WGI_effectsub)[1]<-"country"
  
  # reshape data
  WGI_effecttidy <- WGI_effectsub %>% 
    gather("year", "effectiveness", 2:20) %>%
    arrange(country, year) %>%
    mutate(
      year = str_sub(year, start = 1, end = 4),
      country = as.factor(country)
    )
  
  print("WGI_effecttidy done")
  
  # 4. REGULATORY QUALITY
  #  read WGI regulatory quality data data
  print("importing WGI regulatory quality data... ")
  # WGI_quality <- rio::import(path_loadoriginal)
  # WGI_quality <- rio::import("/Users/schwarze/Documents/GitHub/LegitimacyTerrorism/Data/Original Data/WorldBank/WorldGovIndex/wgidataset_quality.xlsx") # for debugging
  WGI_quality <- rio::import(paste0(path_loadoriginal, "wgidataset_quality.xlsx")) # for debugging
  
  glimpse(WGI_quality)
  print("importing done")
  
  # extract columns "estimates" as a data table
  WGI_qualitysub <- WGI_quality %>% select(1, 2, 8, 14, 20, 26, 32, 38, 44, 50, 56, 62, 68, 74, 80, 86, 92, 98, 104, 110)
  
  # delete first row
  WGI_qualitysub = WGI_qualitysub[-1,]
  
  # label first colum: country
  names(WGI_qualitysub)[1]<-"country"
  
  # reshape data
  WGI_qualitytidy <- WGI_qualitysub %>% 
    gather("year", "quality", 2:20) %>%
    arrange(country, year) %>%
    mutate(
      year = str_sub(year, start = 1, end = 4),
      country = as.factor(country)
    )
  
  print("WGI_qualitytidy done")
  
  # 5. RULE OF LAW
  #  read WGI rule of law data data
  print("importing WGI rule of law data... ")
  # WGI_rulelaw <- rio::import(path_loadoriginal)
  # WGI_rulelaw <- rio::import("/Users/schwarze/Documents/GitHub/LegitimacyTerrorism/Data/Original Data/WorldBank/WorldGovIndex/wgidataset_rulelaw.xlsx") # for debugging
  WGI_rulelaw <- rio::import(paste0(path_loadoriginal, "wgidataset_rulelaw.xlsx")) # for debugging
  
  glimpse(WGI_rulelaw)
  print("importing done")
  
  # extract columns "estimates" as a data table
  WGI_rulelawsub <- WGI_rulelaw %>% select(1, 2, 8, 14, 20, 26, 32, 38, 44, 50, 56, 62, 68, 74, 80, 86, 92, 98, 104, 110)
  
  # delete first row
  WGI_rulelawsub = WGI_rulelawsub[-1,]
  
  # label first colum: country
  names(WGI_rulelawsub)[1]<-"country"
  
  # reshape data
  WGI_rulelawtidy <- WGI_rulelawsub %>% 
    gather("year", "rule_of_law", 2:20) %>%
    arrange(country, year) %>%
    mutate(
      year = str_sub(year, start = 1, end = 4),
      country = as.factor(country)
    )
  
  print("WGI_rulelawtidy done")
  
  
  # 5. CONTROL OF CORRUPTION
  #  read WGI control of corruption data data
  print("importing WGI control of corruption data... ")
  # WGI_corruption <- rio::import(path_loadoriginal)
  # WGI_rcorruption <- rio::import("/Users/schwarze/Documents/GitHub/LegitimacyTerrorism/Data/Original Data/WorldBank/WorldGovIndex/wgidataset_corruption.xlsx") # for debugging
  WGI_corruption <- rio::import(paste0(path_loadoriginal, "wgidataset_corruption.xlsx")) # for debugging
  
  glimpse(WGI_corruption)
  print("importing done")
  
  # extract columns "estimates" as a data table
  WGI_corruptionsub <- WGI_corruption %>% select(1, 2, 8, 14, 20, 26, 32, 38, 44, 50, 56, 62, 68, 74, 80, 86, 92, 98, 104, 110)
  
  # delete first row
  WGI_corruptionsub = WGI_corruptionsub[-1,]
  
  # label first colum: country
  names(WGI_corruptionsub)[1]<-"country"
  
  # reshape data
  WGI_corruptiontidy <- WGI_corruptionsub %>% 
    gather("year", "corruption", 2:20) %>%
    arrange(country, year) %>%
    mutate(
      year = str_sub(year, start = 1, end = 4),
      country = as.factor(country)
    )
  
  print("WGI_corruptiontidy done")  
  
  # Merge all WGI estimates together:
  WGI_tidy <- full_join(WGI_accounttidy, WGI_corruptiontidy) %>%
    full_join(., WGI_effecttidy) %>%
    full_join(., WGI_qualitytidy) %>%
    full_join(., WGI_rulelawtidy) %>%
    full_join(., WGI_stabilitytidy)
  
  # replace all character NA by true NA:
  WGI_tidy[WGI_tidy=="#N/A"] <- NA
  
  # set the estimates as numeric instead of characters:
  WGI_tidy <- WGI_tidy %>%
    mutate_at(c("year", "accountability", "corruption", "effectiveness", 
                "quality", "rule_of_law", "stability"), as.numeric)
  
  
  # factoranalysis of  "accountability", "corruption", "effectiveness", "quality", "rule_of_law"
  # https://community.rstudio.com/t/tidyverse-solutions-for-factor-analysis-principal-component-analysis/4504/2
  
  
  
    
  saveRDS(WGI_tidy, file = path_savetidy)
  # saveRDS(WGI_tidy, file = "../../../Data/Processed Data/WGI_tidy.rds")
  
  print("processed WGI data saved")
  
}

# Look up countries
  # WGI_tidy$country %>% unique
