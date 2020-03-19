#   1. read  Data

library(foreign)
library(VGAM)
library(tidyverse)

legter <- rio::import("../../Data/Data for Modelling/LEGTER_ts_recode.dta") # for debugging

# add dummies into the data for your countries and years (by creating factors) and then use the following syntax:
  
legter_pos <- legter %>%
  filter(n_domtarg_events>0)

# select all the columms that we want in the regression, so that we can use formula: Y~.
# great resource for dyplr::selec : https://www.r-bloggers.com/the-complete-catalog-of-argument-variations-of-select-in-dplyr/
legter_pos_selection <- legter_pos %>%
select(n_domtarg_events, lag1vdem_partip, lag1logGDPexp_capita, lag1logpop, lag1any_conflict, lag1durable, yr1, yr2, yr3,ctry1, ctry2, ctry3)
       # starts_with("ctry"),
       # starts_with("yr"))
  

# select(n_domtarg_events, lag1vdem_partip, lag1logGDPexp_capita, lag1logpop, lag1any_conflict, lag1durable,
#        starts_with("ctry"),
#        starts_with("yr"))



m1 <- vglm(n_domtarg_events ~ . , family = pospoisson(), data = legter_pos_selection)
susummary(m1)

m2 <- vglm(n_domtarg_events ~ lag1vdem_partip + lag1logGDPexp_capita + lag1logpop + lag1any_conflict + lag1durable + yr1 + yr2 + yr3, family = pospoisson(), data = legter_pos)
summary(m2)

# gives an error
# a full-rank matrix is one where all the columns are linearly independent

# A worked example is provided here: https://stats.idre.ucla.edu/r/dae/zero-truncated-poisson/






