
# Aim of this script:
#   read the GTD data, select the variables of interest, add new computed variables if needed, and,
#   save the output as GTD_tidy.rds.

# Note: this script is called from tidy_datasets.R
# THUS, THE PATH TO READ THE GTD BELOW IS NOT MEANT TO BE READ FROM HERE.


#       0. setup
library(rio) # to import and export data
library(dplyr)  # for data wrangling
library(tidyverse) # (else cannot use replace_na() (?))


#       1. read GTD
GTD <- rio::import("../../Data/Original Data/GTD/globalterrorismdb_0718dist.xlsx")



#       2. data selection

# quick ways to have a look at the data:
# GTD %$% iyear %>% unique() # look at all unique values of a column
# glimpse(GTD) # list all columns, what type of element they contain and the first values as examples
# table(GTD$attacktype1_txt) # table of occurrences. only for non-continuous data (typically factors)
# table(GTD_tidy$nkill, useNA = "ifany") # use this option to show if they are NAs in the column.

# Selected, filtered and renamed data is saved as GTD_clean:
GTD_clean <- GTD %>% 
  select(
    eventid, 
    year = iyear, 
    country = country_txt,
    # region = region_txt,
    # success, # unsure yet if we should keep only successful attacks or not.
    # attacktype1_txt, 
    # gname, # GTD %$% gname %>% unique() %>% length() ==> 1364 different organisation. Could invest time classify them (e.g. far-left, far-right, islamist)
    # nkill # we could dichotomize it in the mutate below: with and without victims.
    # targtype1_txt,
  ) %>% 
  filter( 
    # no filter on years ==. years: 1970-2017
    # NOTE do not filter on year here, but later. Else adding years without events below is not working
    # no filter on country. it will depend on what we have in the other datasets that we join to GTD.
  ) %>%
  mutate(
    # didkill = as.factor(ifelse(nkill > 0, "yes", "no")), # note: keeps NA's as NA's (that's good)
    # didwound = ifelse(nwound > 0, "yes", "no") # note: keeps NA's as NA's (that's good)
    # year = as.factor(year),
    country = as.factor(country),
    # region = as.factor(region)
  ) %>% # we sort by country and year (aesthetic):
  arrange(country, year) %>% # we sum the number of event by country and year:
  count(year, country) %>%
  group_by(year, country) %>%
  summarise(n_events = sum(n, na.rm = TRUE)) %>%
  arrange(country, year)
  
# we have now a dataset from the GTD with country, year and region, with:
#     - n_events: the sum of the number of terrorist events by year and country

# BUT this data set contains only the events. We want the years without events too
# note that this assumes that there were no event in this country in this year, and not that no data was collected...
# (note also: the countries without any terrorism event in the given years are not included (and not in GTD))


#     3. Fill the dataset with years without events

# create "structure" data frame with all the year and country combinations:
countries = GTD_clean$country %>% unique() %>% rep(48)
years = rep(c(1970:2017), 205) %>% sort()
GTD_struct <- data.frame(
  year = years,
  country = countries
) 

# We merge GTD_clean and GTD_tidy to get the number of events:
# It is a left join, to get n_events only where and when there were events:
GTD_tidy <- left_join(GTD_struct, GTD_clean) %>%
  arrange(country, year) %>% # just easier to read
  replace_na(list("n_events" = 0)) # replace missing values in year/coutry for n_events by 0.


#     4. Add binary variable if there was any event (one or more) in a given country/year
GTD_tidy <- GTD_tidy %>%
  mutate(had_events = ifelse(n_events != 0, 1, 0))
# n_events can be used in a negative binomial regression
# had_events can be used in a logistic regression

saveRDS(GTD_tidy, file = "../../../Data/Processed Data/GTD_tidy.rds")

