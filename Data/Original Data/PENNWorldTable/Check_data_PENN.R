
# Aim of this script: check if the data and data processing from the PENN tables are correct.

# Variables of interest in the PENN table:
    # year,
    # country,
    # GDP_expentiture = rgdpe, 
    # GDP_output = rgdpo,
    # pop

library(rio)
library(tidyverse)

penn_raw <- rio::import("../../../Data/Original Data/PENNWorldTable/pwt91new.xlsx") # our raw data



# questions:
# - difference btw pwt91new.xlsx and pwt91.xlsx ? -> consider deleting pwt91.xlsx to avoid confusion.
# - exact source (URL) of the data? 


# a function to compare if two values are equal:
compare_two_values <- function(valueA, valueB){
  if ( valueA != valueB ) {
    print("!!! ISSUE HERE !!!")
  } else {print("OK")}
}


# --- TEST 1 : similarity btw new online PENN data and our raw data (pwt91new.xlsx) ---

# new data for the check downloaded from there: https://www.rug.nl/ggdc/docs/pwt91.xlsx 
# version 9.1 downloaded 26 August 2019
# (follow DOI: https://doi.org/10.15141/S50T0R)
penn_new_raw_data <- rio::import(
  file = "../../../Data/Original Data/PENNWorldTable/pwt91_datacheck.xlsx",
  which = "Data" # select the sheet where the data is
)

# OK: same size
compare_two_values(dim(penn_raw)[1], dim(penn_new_raw_data)[1])
compare_two_values(dim(penn_raw)[2], dim(penn_new_raw_data)[2])

# Ok: same total pop
compare_two_values(penn_raw$pop %>% sum(na.rm = TRUE), 
                   penn_new_raw_data$pop %>% sum(na.rm = TRUE))

# Ok: same total rgdpe
compare_two_values(penn_raw$rgdpe %>% sum(na.rm = TRUE), 
                   penn_new_raw_data$rgdpe %>% sum(na.rm = TRUE))

# Ok: same total rgdpo
compare_two_values(penn_raw$rgdpo %>% sum(na.rm = TRUE), 
                   penn_new_raw_data$rgdpo %>% sum(na.rm = TRUE))

# Ok: same total number of missing values
compare_two_values(sum(is.na(penn_raw)), 
                   sum(is.na(penn_new_raw_data)))




# --- TEST 2 : comparison btw our raw data (pwt91new.xlsx) and the processed data (PENN_tidy.rds)

# the tidying was done with:
# /Users/dla/Documents/Data Science and Viz/Legitimacy_and_ViolentExtremism/LegitimacyTerrorism/Scripts/Data Processing/Functions to Tidy Data/tidy_PENN.R
PENN_tidy <- rio::import("../../../Data/Processed Data/PENN_tidy.rds") # our processed data

# the only thing that were done is selecting the variables of interest and filter for year >= 1970

penn_new_raw_data_1970 = penn_new_raw_data %>% filter(year >= 1970)

# OK: same size
compare_two_values(dim(PENN_tidy)[1], dim(penn_new_raw_data_1970)[1]) # same number of rows

# Ok: same total pop
compare_two_values(PENN_tidy$pop %>% sum(na.rm = TRUE), 
                   penn_new_raw_data_1970$pop %>% sum(na.rm = TRUE))

# Ok: same total rgdpe
compare_two_values(PENN_tidy$GDP_expentiture %>% sum(na.rm = TRUE), 
                   penn_new_raw_data_1970$rgdpe %>% sum(na.rm = TRUE))

# Ok: same total rgdpo
compare_two_values(PENN_tidy$GDP_output %>% sum(na.rm = TRUE), 
                   penn_new_raw_data_1970$rgdpo %>% sum(na.rm = TRUE))

# Ok: same total number of missing values
compare_two_values(sum(is.na(PENN_tidy)), 
                   sum(is.na(penn_new_raw_data_1970 %>% select(country, year, pop, rgdpe, rgdpo))))


# If there were a lot of missing years, the filtering by year could be an issue:
# OK, no missing years
sum(is.na(penn_raw$year)) 
table(penn_raw$year, useNA = "ifany") # a beautiful 182 country per year




# --- TEST 3 : comparison btw our processed data (PENN_tidy.rds) and the data used for modelling that is
#               merged with the GTD and other datasets (GTD_polity_PENN_PRIO_WGI_2000.rds)



# --- TEST 4 : careful proofreading of our code, focusing on PENN.




# --- TEST 5 : comparison of modelling results with other papers.


