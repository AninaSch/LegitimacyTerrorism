# Aim of this function:
#   read the WVS data, select the variables of interest, add new computed variables if needed, and,
#   save the output as WVS_tidy.rds.

# note: this function is called from tidy_datasets.R

# WVS waves
# wave 1: 1981-1984
# wave 2: 1990-1994
# wave 3: 1995-1998
# wave 4: 1999-2004
# wave 5: 2005-2008
# wave 6: 2010-2012

# > table(WVS_tidy$year, WVS_tidy$wave)
# 1     2     3     4     5     6
# 1981  8551     0     0     0     0     0
# 1982  4030     0     0     0     0     0
# 1984  1005     0     0     0     0     0
# 1989     0  2338     0     0     0     0
# 1990     0 18512     0     0     0     0
# 1991     0  3708     0     0     0     0
# 1994     0     0   780     0     0     0
# 1995     0     0 16681     0     0     0
# 1996     0     0 32321     0     0     0
# 1997     0     0 14167     0     0     0
# 1998     0     0 12615     0     0     0
# 1999     0     0  1254  2480     0     0
# 2000     0     0     0 12991     0     0
# 2001     0     0     0 32387     0     0
# 2002     0     0     0  6302     0     0
# 2003     0     0     0  2545     0     0
# 2004     0     0     0  2325  1954     0
# 2005     0     0     0     0 17437     0
# 2006     0     0     0     0 36513     0
# 2007     0     0     0     0 22513     0
# 2008     0     0     0     0  3051     0
# 2009     0     0     0     0  2507     0
# 2010     0     0     0     0     0  5702
# 2011     0     0     0     0     0 23407
# 2012     0     0     0     0     0 32024
# 2013     0     0     0     0     0 15914
# 2014     0     0     0     0     0 10522
# 2016     0     0     0     0     0  1996


# --- Coding --- :

# A165	Most people can be trusted:
# 1:Most people can be trusted
# 2:Can´t be too careful
# -5:Missing; Unknown
# -4:Not asked in survey
# -3:Not applicable
# -2:No answer
# -1:Don´t know

# A168	Do you think most people try to take advantage of you (two waves, wave 5 missing)
# '1:Would take advantage
# 2:Try to be fair
# -5:Missing; Unknown
# -4:Not asked in survey
# -3:Not applicable
# -2:No answer
# -1:Don´t know

# A168A Do you think most people try to take advantage of you (ten point scale) (two waves, wave 4 missing)
# '1:Would take advantage
# 2:2
# 3:3
# 4:4
# 5:5
# 6:6
# 7:7
# 8:8
# 9:9
# 10:Try to be fair
# -5:Missing; Unknown
# -4:Not asked in survey
# -3:Not applicable
# -2:No answer
# -1:Don´t know

# A004	Important in life: Politics :
# 1:Very important
# 2:Rather important
# 3:Not very important
# 4:Not at all important
# -5:Missing; Unknown
# -4:Not asked in survey
# -3:Not applicable
# -2:No answer
# -1:Don´t know

# E023	Interest in politics:
# 1:Very interested
# 2:Somewhat interested
# 3:Not very interested
# 4:Not at all interested
# -5:Missing; Unknown
# -4:Not asked in survey
# -3:Not applicable
# -2:No answer
# -1:Don´t know

# TO ADD

# E124	"Respect for individual human rights nowadays 
# '1:There is a lot of respect for individual human rights
# 2:There is some respect
# 3:There is not much respect
# 4:There is no respect at all
# -5:Missing; Unknown
# -4:Not asked in survey
# -3:Not applicable
# -2:No answer
# -1:Don´t know

# 
# E069_06	"Confidence: The Police 
# '1:A great deal
# 2:Quite a lot
# 3:Not very much
# 4:None at all
# -5:Missing; Unknown
# -4:Not asked in survey
# -3:Not applicable
# -2:No answer
# -1:Don´t know
# 
# E069_08	Confidence: The Civil Services
# '1:A great deal
# 2:Quite a lot
# 3:Not very much
# 4:None at all
# -5:Missing; Unknown
# -4:Not asked in survey
# -3:Not applicable
# -2:No answer
# -1:Don´t know
# 
# E110	"Satisfaction with the way democracy develops (only two waves, wave 5 and wave 6 missing)
# '1:Very satisfied
# 2:Rather satisfied
# 3:Not very satisfied
# 4:Not at all satisfied
# -5:Missing; Unknown
# -4:Not asked in survey
# -3:Not applicable
# -2:No answer
# -1:Don´t know
# 
# E111	"Rate political system for governing country (only two waves, wave 5 and wave 6 missing)
# V152 Where on this scale would you put the political system as it is today	
# v163a Rate Political system today	 	
# '1:Bad
# 2:2
# 3:3
# 4:4
# 5:5
# 6:6
# 7:7
# 8:8
# 9:9
# 10:Very good
# -5:Missing; Unknown
# -4:Not asked in survey
# -3:Not applicable
# -2:No answer
# -1:Don´t know

# 
# Theory: citizenship's trait (Weatherford 1992)
# political interest and involvement
# (psychological feeling that political involvement is worth the opportunity cost of trading off time and commitment from other occupants)
# belief about interpersonal and social relations relevant ot collective action (expectations about the intentions and turstworthiness of other people)

tidy_WVS <- function(path_loadoriginal, path_savetidy){
  
  print("This function has to be cleaned")
  
  library(sjlabelled) # to get labels of labelled data
  library(Hmisc) # the data labels (variable names)
  library(dbplyr)
  library(tidyverse)
  
  # read WVS Data
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
      wave = S002
    ) %>%
    select(
       trust_others	=	A165,	#	Most people can be trusted
       take_advantage = A168A, # people try to take advantage of you (only two questions)
      # general_trust_citizen	=	G007_01,	#	Trust: Other people in country
      # general_trust_people	=	G007_64,	#	Trust: People in general
      importance_politics	=	A004,	#	Important in life: Politics 
      interest_politics	=	E023	#	Interest in politics
      # follow_politics	=	E150	#	How often follows politics in the news
    ) %>%   
    select(
    respect_human_rights = E124, # Respect for individual human rights nowadays 
    confidence_police = E069_06, # confidence into the police
    confidence_civil_service = E069_08, # confidence in the civil system
    democratic_development = E110,	# Satisfaction with the way democracy develop
    evaluation_pol_system = E111	# Rate political system for governing country (only two questions)
    ) %>%
    filter(
      year >= 1970,
      # remove missing values that are coded with negative numbers:
      trust_others > 0,
      take_advantage > 0,
      importance_politics > 0,
      interest_politics > 0,
      respect_human_rights > 0, 
      confidence_police > 0,
      confidence_civil_service > 0,
      democratic_development >0,
      evaluation_pol_system > 0
    ) %>%
    arrange(country, year) %>%
    mutate(country = as.factor(country))  
  
  # table(WVS_tidy$trust_others, useNA="ifany")
  # table(WVS_tidy$importance_politics, useNA="ifany")
  # table(WVS_tidy$interest_politics1, useNA="ifany")


# recode variables so that higher values = better  

  WVS_tidy <-WVS_tidy  %>%
    mutate(trust_others_m=as.numeric(recode(trust_others, `1`="2", `2`="1"))) %>%
    mutate(take_advantage_m=as.numeric(recode(take_advantage, `1`="2", `2`="2",`3`="3",`4`="4",`5`="5",`6`="6",`7`="7",`8`="8",`9`="9",`10`="10")))
    mutate(importance_politics_m=as.numeric(recode(importance_politics, `1`="4", `2`="3",`3`="2",`4`="1"))) %>%
    mutate(interest_politics_m=as.numeric(recode(interest_politics, `1`="4", `2`="3",`3`="2",`4`="1"))) %>%
    mutate(respect_human_rights_m=as.numeric(recode(respect_human_rights, `1`="4", `2`="3",`3`="2",`4`="1"))) %>%
    mutate(confidence_police_m=as.numeric(recode(confidence_police, `1`="4", `2`="3",`3`="2",`4`="1"))) %>%
    mutate(confidence_civil_service_m=as.numeric(recode(confidence_civil_service, `1`="4", `2`="3",`3`="2",`4`="1"))) %>%
    mutate(democratic_development_m=as.numeric(recode(democratic_development, `1`="4", `2`="3",`3`="2",`4`="1"))) %>%
    mutate(evaluation_pol_system_m=as.numeric(recode(evaluation_pol_system, `1`="2", `2`="2",`3`="3",`4`="4",`5`="5",`6`="6",`7`="7",`8`="8",`9`="9",`10`="10"))) 
  
  # table(WVS_tidy$trust_others_m, useNA="ifany")
  # table(WVS_tidy$importance_politics_m, useNA="ifany")
  # table(WVS_tidy$interest_politics1_m, useNA="ifany")
  
  # Trust others
  # 1      		2 
  # 77852 	220933 
  # Importance politics
  # 1      	2     	 3      	4 
  # 42797  85028 102045  68915 
  # Interests in politics
  # 1      	2     	 3     		 4 
  # 37589 101520  91040  68636 
  # 
  # print("tidying done")
  
# table(WVS_tidy$country, WVS_tidy$year) %>% tail(100)
# run this to see the levels and if there are missing values:
# table(WVS_tidy$trust_others, useNA="ifany")
# 

  WVS_tidy_wave456 <- WVS_tidy %>%
    filter(wave >= 4) %>%
    group_by(country) %>% # we average by individual !
    summarise(
      mean_trust_others = mean(trust_others_m, na.rm=TRUE),
      mean_take_advantage_ = mean(take_advantage_m, na.rm=TRUE), 
      mean_importance_politics = mean(importance_politics_m, na.rm=TRUE),
      mean_interest_politics = mean(interest_politics_m, na.rm=TRUE), 
      mean_respect_human_rights = mean(respect_human_rights_m, na.rm=TRUE), 
      mean_confidence_police = mean(confidence_police_m, na.rm=TRUE), 
      mean_confidence_civil_service = mean(confidence_civil_service_m, na.rm=TRUE), 
      mean_democratic_development = mean(democratic_development_m, na.rm=TRUE), 
      mean_evaluation_pol_system = mean(evaluation_pol_system_m, na.rm=TRUE)
      ) %>% 
    summarise(
      std_trust_others = sd(trust_others_m, na.rm=TRUE),
      std_take_advantage_ = sd(take_advantage_m, na.rm=TRUE), 
      std_importance_politics = sd(importance_politics_m, na.rm=TRUE),
      std_interest_politics1 = sd(interest_politics_m, na.rm=TRUE),
      std_respect_human_rights = sd(respect_human_rights_m, na.rm=TRUE), 
      std_confidence_police = sd(confidence_police_m, na.rm=TRUE), 
      std_confidence_civil_service = sd(confidence_civil_service_m, na.rm=TRUE), 
      std_democratic_development = sd(democratic_development_m, na.rm=TRUE), 
      std_evaluation_pol_system = sd(evaluation_pol_system_m, na.rm=TRUE)
    ) %>%
    arrange()
    print("tidying done")
    

  saveRDS(WVS_tidy_wave456, file = path_savetidy)
  # saveRDS(WVS_tidy_wave456, file = "../../../Data/Processed Data/WVS_tidy_wave456.rds")
  print("processed WVS wave 4 5 6 data saved")
  
}

# Look up countries
# WVS_tidy$country %>% unique


# ----------------------------------------------------------------------------------------

# AGGREGATE VARIABLES OVER ALL YEARS AT COUNTRY LEVEL ??
WVS_tidy_aggregate <- WVS_tidy %>%
  group_by(country, year) %>%
  summarise(
    mean_trust_others = mean(trust_others, na.rm=TRUE),
    mean_importance_politics = mean(importance_politics, na.rm=TRUE),
    mean_interest_politics = mean(interest_politics, na.rm=TRUE)
  ) %>%
  arrange(country, year)
# control:
# WVS_tidy %>% filter(country == "Albania", year == 1998) %>% .$trust_others %>% mean()
# WVS_tidy %>% filter(country == "Albania", year == 1998) %>% .$trust_others %>% median()
# 

# PLOT
WVS_agg_subset = WVS_tidy_aggregate %>% filter(
  country %in% c("Russia", "Poland", "Peru", "Nigeria", "Norway", "Mexico")
)

ggplot(data=WVS_agg_subset, aes(x=year, y=mean_trust_others, group=country)) +
  geom_line() +
  geom_point()  + theme_bw()   

# ----------------------------------------------------------------------------------------

# BUILD COMBINED INDICATOR


