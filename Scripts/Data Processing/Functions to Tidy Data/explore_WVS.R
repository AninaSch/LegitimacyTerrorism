
library(tidyverse)
library(sjlabelled) # to get labels of labelled data
library(Hmisc) # the data labels (variable names)


setwd("~/Documents/GitHub/LegitimacyTerrorism/Scripts/Data Processing/Functions to Tidy Data")


WVS <- rio::import("../../../Data/Original Data/WorldValueSurvey/F00008390-WVS_Longitudinal_1981_2016_r_v20180912.rds") # for debugging

WVS <- WVS %>% mutate(S003_country = sjlabelled::as_label(WVS$S003))

WVS_tidy <- WVS %>%
  select(
    country = S003_country,
    wave = S002,
    year = S020,
    trust_others	=	A165,	#	Most people can be trusted
    importance_politics	=	A004,	#	Important in life: Politics 
    interest_politics1	=	E023,	#	Interest in politics
  ) %>%
  filter(
    year >= 1970
  ) %>%
  mutate(country = as.factor(country)) %>%
  arrange(country, year)


table(WVS_tidy$trust_others)
table(WVS_tidy$importance_politics)
table(WVS_tidy$interest_politics1)

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



# How does this distribution looks in a given year?

my_year = 2014
my_wave = 4
my_country = "Germany"

WVS_tidy %>%
  filter(country == my_country,
         wave > my_wave
         ) %>%
  # group_by(wave) %>%
  # summarise(trust_others_m = mean(trust_others, na.rm=TRUE),
  #           importance_politics_m = mean(importance_politics, na.rm=TRUE),
  #           interest_politics1_m = mean(interest_politics1, na.rm=TRUE)
  #           ) %>%
  View()

WVS_tidy_w56 <- WVS_tidy %>% filter(wave > 4)
table(WVS_tidy_w56$country, WVS_tidy_w56$wave)

WVS_tidy_w56 %>% #filter(country == "Germany") %>%
  group_by(wave, country) %>%
  summarise(trust_others_m = mean(trust_others, na.rm=TRUE),
            importance_politics_m = mean(importance_politics, na.rm=TRUE),
            interest_politics1_m = mean(interest_politics1, na.rm=TRUE)
            ) %>%
  arrange(country) %>%
  View()


# What would we left with only 6th wave:

WVS_tidy_wave6 <- WVS_tidy %>%
  filter(wave == 6) %>%
  group_by(country) %>%
  summarise(
    mean_trust_others = mean(trust_others, na.rm=TRUE),
    mean_importance_politics = mean(importance_politics, na.rm=TRUE),
    mean_interest_politics1 = mean(interest_politics1, na.rm=TRUE),
    std_trust_others = sd(trust_others, na.rm=TRUE),
    std_importance_politics = sd(importance_politics, na.rm=TRUE),
    std_interest_politics1 = sd(interest_politics1, na.rm=TRUE)
  )




  
