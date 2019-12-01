
# This script merges the processed data together to create a dataset ready for PANEL ANALYSIS.

# duplicate Fragility & HIEF
# https://www.datanovia.com/en/lessons/identify-and-remove-duplicate-data-in-r/
# duplicated(), unique()
# (duplicated(isTRUE(Fragility)))


# --- 0. Setup

library(tidyverse)
# library(foreign) 

source("Other functions/clean_countries.R") # function to clean country names

# --- 1. Load Processed Datasets

GTD <- readRDS("../../Data/Processed Data/GTD_tidy.rds")
polity <- readRDS("../../Data/Processed Data/polity_tidy.rds")
PENN <- readRDS("../../Data/Processed Data/PENN_tidy.rds")
PRIO <- readRDS("../../Data/Processed Data/Prio_tidy.rds")
WGI <- readRDS("../../Data/Processed Data/WGI_tidy.rds")
WVS <- readRDS("../../Data/Processed Data/WVS_tidy_wave456.rds")
Fragility <- readRDS("../../Data/Processed Data/Fragility_tidy.rds")
HIEF <- readRDS("../../Data/Processed Data/HIEF_tidy.rds")
WDI <- readRDS("../../Data/Processed Data/WDI_tidy.rds")
Vdem <- readRDS("../../Data/Processed Data/Vdem_tidy.rds")

# --- 2. Clean Countries Before Merging

path_to_country_dictionary = "../../Data/Processed Data/To Clean Countries/countries.csv"
GTD <- clean_countries(GTD, path_to_country_dictionary)
polity <- clean_countries(polity, path_to_country_dictionary)
PENN <- clean_countries(PENN, path_to_country_dictionary)
PRIO <- clean_countries(PRIO, path_to_country_dictionary)
WGI <- clean_countries(WGI, path_to_country_dictionary)
WVS <- clean_countries(WVS, path_to_country_dictionary)

Fragility <- clean_countries(Fragility, path_to_country_dictionary)
WDI <- clean_countries(WDI, path_to_country_dictionary) # check conuntries labelling
HIEF <- clean_countries(HIEF, path_to_country_dictionary)

Vdem <- clean_countries(Vdem, path_to_country_dictionary)


# --- 3. Merging Datasets Polity_Penn_Prio

# --- we start by merging polity to GTD:
# we do an left join, as we do not want countries that are not in the GTD (true? we could also set n_events to 0 for those?)
GTD_polity <- left_join(GTD, polity, by = c("consolidated_country", "year")) %>%
  arrange(consolidated_country) # set order by country, for aesthetics and readability

# --- then we merge PENN to GTD_polity:
GTD_polity_PENN <- left_join(GTD_polity, PENN, by = c("consolidated_country", "year")) 

# --- then we merge PRIO to GTD_polity_PENN:
GTD_polity_PENN_PRIO <- left_join(GTD_polity_PENN, PRIO, by = c("consolidated_country", "year"))
# because PRIO has only countries in wars, we need to complete the missing values with 0:
GTD_polity_PENN_PRIO <- GTD_polity_PENN_PRIO %>% 
  replace_na(list(type_of_conflict_1=0, type_of_conflict_2=0,
                  type_of_conflict_3=0, type_of_conflict_4=0, any_conflict=0))

# --- then we merge WGI to GTD_polity_PENN_PRIO:
GTD_polity_PENN_PRIO_WGI <- left_join(GTD_polity_PENN_PRIO, WGI, by = c("consolidated_country", "year"))
# some duplicate were created, because in some datasets, some year-country combinations happen twice
GTD_polity_PENN_PRIO_WGI <- GTD_polity_PENN_PRIO_WGI %>% distinct()

# --- then we merge WVS to GTD_polity_PENN_PRIO_WGI:
GTD_polity_PENN_PRIO_WGI_WVS <- left_join(GTD_polity_PENN_PRIO_WGI, WVS, by = c("consolidated_country"))

# # take years after 2000: (quick dirty fix for the temporary countries):
# GTD_polity_PENN_PRIO_WGI <- GTD_polity_PENN_PRIO_WGI %>%
#   filter(year > 1999)
# GTD_polity_PENN_PRIO_WGI_WVS <- GTD_polity_PENN_PRIO_WGI_WVS %>%
#   filter(year > 1999)


# --- then we merge Fragility to GTD_polity_PENN_PRIO_WGI_WVS:
GTD_polity_PENN_PRIO_WGI_WVS_Fragility <- left_join(GTD_polity_PENN_PRIO_WGI_WVS, Fragility, by = c("consolidated_country", "year"))

# --- then we merge WDI to GTD_polity_PENN_PRIO_WGI_WVS_Fragility:
GTD_polity_PENN_PRIO_WGI_WVS_Fragility_WDI <- left_join(GTD_polity_PENN_PRIO_WGI_WVS_Fragility, WDI, by = c("consolidated_country", "year"))

# --- then we merge HIEF to GTD_polity_PENN_PRIO_WGI_WVS_Fragility_WDI:
GTD_polity_PENN_PRIO_WGI_WVS_Fragility_WDI_HIEF <- left_join(GTD_polity_PENN_PRIO_WGI_WVS_Fragility_WDI, HIEF, by = c("consolidated_country", "year"))
GTD_polity_PENN_PRIO_WGI_WVS_Fragility_WDI_HIEF <- GTD_polity_PENN_PRIO_WGI_WVS_Fragility_WDI_HIEF %>% distinct()

# --- then we merge Vdem to GTD_polity_PENN_PRIO_WGI_WVS_Fragility_WDI_HIEF_Vdem:
GTD_polity_PENN_PRIO_WGI_WVS_Fragility_WDI_HIEF_Vdem <- left_join(GTD_polity_PENN_PRIO_WGI_WVS_Fragility_WDI_HIEF, Vdem, by = c("consolidated_country", "year"))


# my_dataset <- GTD_polity # until we get our final dataset.

# --- 4. Controls

# we did a left join, matching to GTD countries and year, so it is probable that we miss data from the other dataset.
# TODO: show extend of missing data here, decide how to handle.

# View(GTD_polity %>% group_by(consolidated_country) %>% summarise(polity_na_count = sum(is.na(polity))))
# View(GTD_polity_PENN %>% group_by(consolidated_country) %>% summarise(n_GDP_exp = sum(is.na(GDP_expentiture))))

# NOT DONE, as done while fitting the regression automatically:
# # remove countries with missing or not complete polity data:
# # we do not want countries absent of polity, as polity is our independent variable of interest.
# countries_with_missing_data <- GTD_polity_PENN %>% 
#   group_by(consolidated_country) %>% 
#   summarise(polity_na_count = sum(is.na(polity)), 
#             GDP_exp_na_count = sum(is.na(GDP_expentiture))) %>%
#       filter(polity_na_count > 0 | GDP_exp_na_count > 0) %>%
#       .$consolidated_country

# GTD_polity_PENN <- GTD_polity_PENN %>% filter(!consolidated_country %in% countries_with_missing_data)
#     ### !!!! we removed here important countries, like Germany !!!!!!!!!!!!!!!!!!!!! (because West/East)
# ### !!!! TODO: consolidate their country names when tidying the datasets

# --- 5. Saving 
saveRDS(GTD_polity_PENN_PRIO_WGI, file = "../../Data/Data for Modelling/GTD_polity_PENN_PRIO_WGI_2000.rds")
saveRDS(GTD_polity_PENN_PRIO_WGI_WVS, file = "../../Data/Data for Modelling/GTD_polity_PENN_PRIO_WGI_WVS_2000.rds")
saveRDS(GTD_polity_PENN_PRIO_WGI_WVS_Fragility_WDI_HIEF, file = "../../Data/Data for Modelling/GTD_polity_PENN_PRIO_WGI_WVS_Fragility_WDI_HIEF_2000.rds")
saveRDS(GTD_polity_PENN_PRIO_WGI_WVS_Fragility_WDI_HIEF_Vdem, file = "../../Data/Data for Modelling/GTD_polity_PENN_PRIO_WGI_WVS_Fragility_WDI_HIEF_Vdem_2000.rds")

