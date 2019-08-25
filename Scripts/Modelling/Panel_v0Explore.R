library(tidyverse)
library(pglm) # model panel data
library(pscl)
library(lme4) # models longitudinal data within a Generalized Linear Mixed Model (GLMM) framework,
# Note that glmer implements random, rather than fixed effects. 
# If you're attempting inference and want to control for all cross-sectional heterogeneity, glmer won't get you there. You'd need some implementation of the conditional logit model
library(robustHD) # data standardization
library(Hmisc)
library(stargazer) # Well-Formatted Regression and Summary Statistics Tables

my_data <- readRDS("../../Data/Data for Modelling/GTD_polity_PENN_PRIO_WGI_2000.rds")

# scale only specific variable names
my_data.scl <- my_data %>% mutate_each_(funs(scale(.) %>% as.vector), 
                                        vars=c("accountability"))

# don't do that:
# my_data_lagged <- my_data %>%
#   select(year, n_events, accountability, GDP_expentiture, pop, any_conflict, durable) %>%
#   mutate(
#     accountability = dplyr::lag(accountability), 
#     GDP_expentiture = dplyr::lag(GDP_expentiture), 
#     pop = dplyr::lag(pop), 
#     any_conflict = dplyr::lag(any_conflict), 
#     durable = dplyr::lag(durable)
#   )

# TRYING TO STANDARDIZE:
my_data_std <- my_data %>% 
  mutate(GDP_expentiture = (GDP_expentiture - min(GDP_expentiture, na.rm = TRUE)) / 
           (max(GDP_expentiture, na.rm = TRUE) - min(GDP_expentiture, na.rm = TRUE)),
         pop = (pop - min(pop, na.rm = TRUE)) / 
           (max(pop, na.rm = TRUE) - min(pop, na.rm = TRUE))
  )

my_data_std2 <- my_data %>% 
  mutate(accountability = (accountability - min(accountability, na.rm = TRUE)) / 
           (max(accountability, na.rm = TRUE) - min(accountability, na.rm = TRUE))
  )



# ----------------  negative binomial regression of terrorist events :
# Panel Estimators For Generalized Linear Models (https://www.rdocumentation.org/packages/pglm/versions/0.2-1/topics/pglm)

## some count data models
# data("my_data", package="pglm")

# VERSION 1 LEGITIMACY MEASURES FROM POLITY DATA BASE

cor(my_data %>% select(exrec, exconst, polcomp), use = "pairwise.complete.obs")


# lagged legitimacy
pnb <- pglm(n_events ~ lag(exrec) + lag(exconst) + lag(polcomp),  my_data,
           family = negbin, model = "within", print.level = 3, method = "nr",
           index = c('consolidated_country', 'year'))
summary(pnb)

#  lagged legitimacy + lagged controls

pnb <- pglm(n_events ~ lag(exrec) + lag(exconst) + lag(polcomp) + lag(durable) + lag(log(GDP_expentiture)) + lag(log(pop)) + lag(any_conflict),  my_data,
           family = negbin(link="log"), model = "within", print.level = 3, method = "nr",
           index = c('consolidated_country', 'year'))
summary(pnb)

# VERSION 2 LEGITIMACY MEASURES FROM WGI DATA BASE

# correlation matrix
cor(my_data %>% select(-consolidated_country), use = "pairwise.complete.obs")

cor(my_data %>% select(accountability,corruption,effectiveness,quality,rule_of_law,stability), use = "pairwise.complete.obs")


#  lagged legitimacy + lagged controls


pnb <- pglm(n_events ~ (accountability) + 
              (log(GDP_expentiture)) + (log(pop)) + (any_conflict),  
            my_data %>% filter(year > 2001),
            family = negbin, model = "within", print.level = 3, method = "nr",
            index = c('consolidated_country', 'year'),
            start = NULL , R = 20 )
summary(pnb)

# start = c(1,2), R = 20 )


pnb <- pglm(n_events ~ lag(corruption) + 
              lag(log(GDP_expentiture)) + lag(log(pop)) + lag(any_conflict),  
            my_data,
            family = negbin, model = "within", print.level = 3, method = "nr",
            index = c('consolidated_country', 'year'),
            start = NULL, R = 20 )
summary(pnb)

model = glmer.nb(n_events~year+lag(corruption)+log(GDP_expentiture)+
                   lag(log(GDP_expentiture)) + lag(log(pop)) + lag(any_conflict) +
                   (1|consolidated_country), data=my_data)
summary(model)

pnb <- pglm(n_events ~ lag(effectiveness) + 
              lag(log(GDP_expentiture)) + lag(log(pop)) + lag(any_conflict),  
            my_data,
            family = negbin, model = "within", print.level = 3, method = "nr",
            index = c('consolidated_country', 'year'),
            start = NULL, R = 20 )
summary(pnb)

pnb <- pglm(n_events ~ lag(rule_of_law) + 
              lag(log(GDP_expentiture)) + lag(log(pop)) + lag(any_conflict),  
            my_data,
            family = negbin, model = "within", print.level = 3, method = "nr",
            index = c('consolidated_country', 'year'),
            start = NULL, R = 20 )
summary(pnb)

pnb <- pglm(n_events ~ lag(quality) + 
              lag(log(GDP_expentiture)) + lag(log(pop)) + lag(any_conflict),  
            my_data,
            family = negbin, model = "within", print.level = 3, method = "nr",
            index = c('consolidated_country', 'year'),
            start = NULL, R = 20 )
summary(pnb)







# pglm(formula, data, subset, na.action,
#      effect = c("individual", "time", "twoways"),
#      model = c("random", "pooling", "within", "between"),
#      family, other = NULL, index = NULL, start = NULL, R = 20,  ...)

# FINAL MODEL
pnb <- pglm(n_events ~ lag(accountability) + lag(effectiveness) + lag(durable) +
              lag(log(GDP_expentiture)) + lag(log(pop)) + lag(any_conflict),  
            my_data,
            family = negbin, model = "within", print.level = 3, method = "nr",
            index = c('consolidated_country', 'year'))
summary(pnb)

pnb <- pglm(n_events ~ lag(polity2) + lag(effectiveness) + lag(durable) +
              lag(log(GDP_expentiture)) + lag(log(pop)) + lag(any_conflict),  
            my_data,
            family = negbin, model = "within", print.level = 3, method = "nr",
            index = c('consolidated_country', 'year'))
summary(pnb)

# pnb <- pglm(n_events ~ lag(accountability) + lag(effectiveness) + stability +
#               lag(log(GDP_expentiture)) + lag(log(pop)) + lag(any_conflict),  
#             my_data,
#             family = negbin, model = "within", print.level = 3, method = "nr",
#             index = c('consolidated_country', 'year'))
# summary(pnb)

# https://stats.stackexchange.com/questions/146434/why-pglm-fails-for-within-model
# logit <- pglm(had_events ~ lag(accountability) + lag(effectiveness) + 
#               lag(log(GDP_expentiture)) + lag(log(pop)) + lag(any_conflict),  
#             my_data,
#             family = binomial, start=0, model = "within", print.level = 3, 
#             index = c('consolidated_country', 'year'))
# summary(logit)


# REPORT IRR
exp(cbind(coef(pnb), confint(pnb)))

# lag several years behid
pnb <- pglm(n_events ~ lag(accountability, n=2L) + lag(corruption, n=2L) + lag(effectiveness, n=2L) + lag(quality, n=2L) + lag(rule_of_law, n=2L) + lag(log(GDP_expentiture), n=2L) + lag(log(pop), n=2L) + lag(any_conflict, n=2L) +lag(stability, n=2L),  my_data,
            family = negbin, model = "within", print.level = 3, method = "nr",
            index = c('consolidated_country', 'year'))
summary(pnb)


# random effects
pnb <- pglm(n_events ~ lag(accountability, n=2L) + lag(corruption, n=2L) + lag(effectiveness, n=2L) + lag(quality, n=2L) + lag(rule_of_law, n=2L) + lag(log(GDP_expentiture), n=2L) + lag(log(pop), n=2L) + lag(any_conflict, n=2L) +lag(stability, n=2L),  my_data,
            family = negbin, model = "random", print.level = 3, method = "nr",
            index = c('consolidated_country', 'year'))
summary(pnb)


#REPORTING

# TERRORIST EVENTS OVER THE YEARS
  # MAYBE TERRORIST EVENTS BY REGION?

# DESCRIPTIVE STATISTICS

terrorism <- pglm(n_events ~ lag(polity2) + lag(effectiveness) + lag(durable) +
              lag(log(GDP_expentiture)) + lag(log(pop)) + lag(any_conflict),  
            my_data,
            family = negbin, model = "within", print.level = 3, method = "nr",
            index = c('consolidated_country', 'year'))
summary(terrorism)

stargazer(my_data)


# 
# CORRELATION MATRIX
# 
# NEGATIVE BINOMIAL REGRESSION
# 
#   -IRR
#   
#   -CONFIDENCE INTERVALS






# how to model panel data?
#     country and time dimensions
#     https://en.wikipedia.org/wiki/Panel_data

# use plm (only for linear models)
# https://cran.r-project.org/web/packages/plm/plm.pdf
# https://www.youtube.com/watch?v=1pST2lUx6QM


# use pglm (generalized lm -> neg bin and logit)
# https://cran.r-project.org/web/packages/pglm/pglm.pdf

# fixed and random effects in panel data
# https://datascienceplus.com/working-with-panel-data-in-r-fixed-vs-random-effects-plm/
# https://www.schmidheiny.name/teaching/panel2up.pdf
# https://www3.nd.edu/~rwilliam/stats3/Panel04-FixedVsRandom.pdf
# https://www.princeton.edu/~otorres/Panel101.pdf



# library(lme4)
# https://cran.r-project.org/web/packages/lme4/index.html
# https://www.jaredknowles.com/journal/2013/11/25/getting-started-with-mixed-effect-models-in-r
# glmer(formula, data = , family = 'binomial')...

# https://data.princeton.edu/wws509/r/fixedRandom3
https://stats.idre.ucla.edu/r/dae/mixed-effects-logistic-regression/

