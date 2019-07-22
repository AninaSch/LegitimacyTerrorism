
# Aim of this function:
#   read the GTD data, select the variables of interest, add new computed variables if needed, and,
#   save the output as GTD_tidy.rds.

# Note: this function is called from tidy_datasets.R

library(tidyverse)


  
  #       1. read GTD
  GTD <- rio::import("../../../Data/Original Data/GTD/globalterrorismdb_0718dist.xlsx")

  
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
      country = country_txt) %>%
    mutate(
      country = as.factor(country)
    ) %>% # we sort by country and year (aesthetic):
    arrange(country, year) %>% # we sum the number of event by country and year:
    count(year, country) %>%
    group_by(year, country) %>%
    summarise(n_events = sum(n, na.rm = TRUE)) %>%
    arrange(country, year)
  
  print("cleaning done")
  
   
  #       3. rename countries that do not exist any longer
  




  
  
  #     3. Fill the dataset with years without events
  
  
  # we have now a dataset from the GTD with country, year and region, with:
  #     - n_events: the sum of the number of terrorist events by year and country
  
  # BUT this data set contains only the events. We want the years without events too
  # note that this assumes that there were no event in this country in this year, and not that no data was collected...
  # (note also: the countries without any terrorism event in the given years are not included (and not in GTD))
  
  # 2000 - 2017
  
  # create "structure" data frame with all the year and country combinations:
  # GTD_clean$country %>% unique() %>% length()
  # countries = GTD_clean %>% .$country %>% unique() %>% rep(48)
  # years = rep(c(1970:2017), 205) %>% sort()
  # GTD_struct <- data.frame(
  #   year = years,
  #   country = countries
  # ) 
  
  countries = GTD_clean %>% filter(year > 1999) %>% .$country %>% unique() %>% rep(18)
  years = rep(c(2000:2017), 167) %>% sort()
  GTD_struct <- data.frame(
    year = years,
    country = countries
  ) 
  
  # add n_events to GTD_struct to see when and where there were events
  GTD_control <- GTD_clean %>% right_join(GTD_struct, GTD_clean, by = c("year", "country")) %>%
    arrange(country, year) 
  
  # list occurrences in GTD:
  tmp <- GTD_clean %>% filter(year > 1999) %>% group_by(country) %>% tally()
  
  
  
  
  # countries = GTD_clean %>% filter(year > 1999) %>% .$country %>% unique() %>% rep(18)
  # years = rep(c(2000:2017), 167) %>% sort()
  # GTD_struct <- data.frame(
  #   year = years,
  #   country = countries
  # ) 
  
  # We merge GTD_clean and GTD_tidy to get the number of events:
  # It is a left join, to get n_events only where and when there were events:
  GTD_tidy <- left_join(GTD_struct, GTD_clean, by = c("year", "country")) %>%
    arrange(country, year) %>% # just easier to read
    replace_na(list("n_events" = 0)) # replace missing values in year/coutry for n_events by 0.
  print("tidy and merging done")
  
  #     4. Add binary variable if there was any event (one or more) in a given country/year
  GTD_tidy <- GTD_tidy %>%
    mutate(had_events = ifelse(n_events != 0, 1, 0))
  # n_events can be used in a negative binomial regression
  # had_events can be used in a logistic regression
  print("replace NA done")
  
  # TO DO: REMOVE 1993
  
  
  print("TO DO: HANDLE TEMPORARY COUNTRIES. currently they are included and it is not correct!")
  
  # countries_to_erase = c("West Germany (FRG)", "Soviet Union", "South Sudan", "South Vietnam",
  #                        "South Yemen", "People's Republic of the Congo", ...)
  






