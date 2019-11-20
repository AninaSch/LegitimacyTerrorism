
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
tidy_Polity4(path_loadoriginal, path_savetidy) # import original, clean, tidy, save in processed data


# --- 3. tidy WVS:
source("Functions to Tidy Data/tidy_WVS.R")
path_loadoriginal = "../../Data/Original Data/WorldValueSurvey/F00008390-WVS_Longitudinal_1981_2016_r_v20180912.rds"
path_savetidy = "../../Data/Processed Data/WVS_tidy_wave456.rds"
tidy_WVS(path_loadoriginal, path_savetidy) # import original, clean, tidy, save in processed data


# --- 4. tidy Penn:
source("Functions to Tidy Data/tidy_PENN.R")
path_loadoriginal = "../../Data/Original Data/PENNWorldTable/pwt91new.xlsx"
path_savetidy = "../../Data/Processed Data/PENN_tidy.rds"
tidy_PENN(path_loadoriginal, path_savetidy) # import original, clean, tidy, save in processed data


# --- 5. tidy WGI:
source("Functions to Tidy Data/tidy_WGI.R")
path_loadoriginal = "../../Data/Original Data/WorldBank/WorldGovIndex/" # path to folder only!
path_savetidy = "../../Data/Processed Data/WGI_tidy.rds"
tidy_WGI(path_loadoriginal, path_savetidy) # import original, clean, tidy, save in processed data


# --- 6. tidy PRIO:
source("Functions to Tidy Data/tidy_PRIO.R")
path_loadoriginal = "../../Data/Original Data/PRIO/ucdp-prio-acd-191.xlsx" # path to folder only!
path_savetidy = "../../Data/Processed Data/Prio_tidy.rds"
tidy_PRIO(path_loadoriginal, path_savetidy) # import original, clean, tidy, save in processed data

