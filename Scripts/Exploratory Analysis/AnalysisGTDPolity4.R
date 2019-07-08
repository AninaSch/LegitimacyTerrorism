## script outline

library(visdat)
library(tidyverse)
library(ggrepel)



getwd()
setwd()


GTD <- readRDS("../data/GTD/GTD_tidy_n_and_nkill.rds")
polity <- readRDS("../data/SystemicPeace/polity_tidy.rds")


# clean countries in both dataset:
# load country dictionary:
country_dic <- read.csv("countries.csv")
# write here a function that changes name of country in GTD and polity according to country_dic.

clean_ctrys <- function(df) {
  # argument is a dataframe, retunrs a dataframe, with a clean country name
  return(
    left_join(df, country_dic, by = "country") %>%
      select(-country) 
  )
}

GTD <- clean_ctrys(GTD)
polity <- clean_ctrys(polity)



# 1. merge tidy_polity4 and tidy_GTD

GTD_polity <- inner_join(GTD, polity, by = c("new_country", "year")) %>%
  arrange(new_country)


# 2. correlation between number of terrorist events and tidy_polity4 variables
# polity, polity2,
# democ, autoc,
# xrreg, xrcomp, xropen, xconst, parreg, parcomp, # component variables
# exrec, exconst, polcomp # concept variables

GTD_polity %>%
  group_by(new_country) %>% 
  select("n_events", "polity2") %>%
  View()
  #vis_cor()

vis_cor(GTD_polity[, c("n_events", "polity","polity2", "xrreg","xrcomp", "xropen", "xconst", "parreg","parcomp", "exrec", "exconst", "polcomp" ) , by=new_country], cor_method = "pearson",
        na_action = "pairwise.complete.obs")
cor(GTD_polity[, c("n_events", "polity","polity2", "xrreg","xrcomp", "xropen", "xconst", "parreg","parcomp", "exrec", "exconst", "polcomp" )],
    use="complete.obs")

vis_cor(GTD_polity[, c("n_events", "polity2")], cor_method = "pearson",
        na_action = "pairwise.complete.obs")
cor(GTD_polity[, c("n_events", "polity2")], use="complete.obs")

Germany <- filter(GTD_polity, new_country == "Afghanistan")
cor(Germany[, c("n_events", "polity2")], use="complete.obs")


vis_cor(VE[5:length(colnames(VE))])



p <- GTD_polity %>% 
  filter(year == 2017) %>%
  # filter(Region == "EU, EFTA & North America") %>%
  ggplot(aes(x=log(n_events+1), y=polity2, label=new_country))+
  geom_point(alpha=0.6) + 
  geom_text_repel() +
  geom_smooth() +
  theme_minimal()
p  

hist(GTD_polity$n_events, breaks = 30)


library(MASS)
to_fit <- GTD_polity #%>% filter(year == 2017)
nbGLM <- glm.nb(n_events ~ polity2, data=to_fit)
summary(nbGLM)


# 
# 3. negative binomial regression of GTD and
# polity2
# 
# control variables: 
# - GDP
# - Population size
# - civil war
# - regime stability
# - military spending
# - muslim population
