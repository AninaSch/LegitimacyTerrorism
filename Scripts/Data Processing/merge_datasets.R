
# This script merges the processed data together to create a dataset ready for the modelling.

# --- 0. Setup

library(tidyverse)
source("Other functions/clean_countries.R") # function to clean country names


# --- 1. Load Processed Datasets

GTD <- readRDS("../../Data/Processed Data/GTD_tidy.rds")
polity <- readRDS("../../Data/Processed Data/polity_tidy.rds")
PENN <- readRDS("../../Data/Processed Data/PENN_tidy.rds")


# --- 2. Clean Countries Before Merging

path_to_country_dictionary = "../../Data/Processed Data/To Clean Countries/countries.csv"
GTD <- clean_countries(GTD, path_to_country_dictionary)
polity <- clean_countries(polity, path_to_country_dictionary)
PENN <- clean_countries(PENN, path_to_country_dictionary)


# --- 3. Merging Datasets

# --- we start by merging polity to GTD:
# we do an left join, as we do not want countries that are not in the GTD (true? we could also set n_events to 0 for those?)
GTD_polity <- left_join(GTD, polity, by = c("consolidated_country", "year")) %>%
  arrange(consolidated_country) # set order by country, for aesthetics and readability

# --- then we merge PENN to GTD_polity:
GTD_polity_PENN <- left_join(GTD_polity, PENN, by = c("consolidated_country", "year")) %>%
  arrange(consolidated_country)



# etc.

# my_dataset <- GTD_polity # until we get our final dataset.

# --- 4. Controls

# we did a left join, matching to GTD countries and year, so it is probable that we miss data from the other dataset.
# TODO: show extend of missing data here, decide how to handle.

View(GTD_polity %>% group_by(consolidated_country) %>% summarise(polity_na_count = sum(is.na(polity))))
View(GTD_polity_PENN %>% group_by(consolidated_country) %>% summarise(n_GDP_exp = sum(is.na(GDP_expentiture))))

# remove countries with missing or not complete polity data:
# we do not want countries absent of polity, as polity is our independent variable of interest.
countries_with_missing_data <- GTD_polity_PENN %>% 
  group_by(consolidated_country) %>% 
  summarise(polity_na_count = sum(is.na(polity)), 
            GDP_exp_na_count = sum(is.na(GDP_expentiture))) %>%
      filter(polity_na_count > 0 | GDP_exp_na_count > 0) %>%
      .$consolidated_country

GTD_polity_PENN <- GTD_polity_PENN %>% filter(!consolidated_country %in% countries_with_missing_data)
    ### !!!! we removed here important countries, like Germany !!!!!!!!!!!!!!!!!!!!! (because West/East)
### !!!! TODO: consolidate their country names when tidying the datasets


# --- 5. Saving 

saveRDS(GTD_polity_PENN, file = "../../Data/Data for Modelling/GTD_polity_PENN.rds")


