
# Tidy All the Necessary Data.

# This "main" script reads all the separate "Scripts to Tidy Data/Data_tidy.R" scripts used to tidy the data.
# Working Directory has to be set to this file's location.

# This file take a few minutes to run

#       0. setup
library(rio) # to import and export data
library(tidyverse) # data wrangling etc.

# --- 1. tidy GTD:
source("Functions to Tidy Data/tidy_GTD.R")
path_loadoriginal = "../../Data/Original Data/GTD/globalterrorismdb_0718dist.xlsx" # path to original data
path_savetidy = "../../Data/Processed Data/GTD_tidy.rds"
tidy_GTD(path_loadoriginal, path_savetidy) # import original, clean, tidy, save in processed data
# no need to worry about the warnings of rio::import

# --- 2. tidy PolityIV:
source("Functions to Tidy Data/tidy_Polity4.R")
path_loadoriginal = "../../Data/Original Data/SystemicPeace/p4v2017.xls"
path_savetidy = "../../Data/Processed Data/polity_tidy.rds"
tidy_GTD(path_loadoriginal, path_savetidy) # import original, clean, tidy, save in processed data





