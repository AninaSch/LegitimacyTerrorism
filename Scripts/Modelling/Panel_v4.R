library(tidyverse)
library(pglm) # model panel data
library(pscl)
library(lme4) # models longitudinal data within a Generalized Linear Mixed Model (GLMM) framework,
# Note that glmer implements random, rather than fixed effects. 
# If you're attempting inference and want to control for all cross-sectional heterogeneity, glmer won't get you there. You'd need some implementation of the conditional logit model
library(robustHD) # data standardization

my_data <- readRDS("../../Data/Data for Modelling/GTD_polity_PENN_PRIO_WGI_2000.rds")

# scale only specific variable names
my_data.scl <- my_data %>% mutate_each_(funs(scale(.) %>% as.vector), 
                                        vars=c("GDP_expentiture","pop"))



# ----------------  negative binomial regression of terrorist events :
# Panel Estimators For Generalized Linear Models (https://www.rdocumentation.org/packages/pglm/versions/0.2-1/topics/pglm)

## some count data models
# data("my_data", package="pglm")

# VERSION 1 LEGITIMACY MEASURES FROM POLITY DATA BASE

# legitimacy 
pnb <- pglm(n_events ~ exrec + exconst + polcomp,  my_data,
           family = negbin, model = "within", print.level = 3, method = "nr",
           index = c('consolidated_country', 'year'))
summary(pnb)

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

# Does not converge with GDP output
pnb <- pglm(n_events ~ lag(exrec) + lag(exconst) + lag(polcomp) + lag(durable) + lag(log(GDP_output)) + lag(log(pop)) + lag(any_conflict),  my_data,
           family = negbin(link="log"), model = "within", print.level = 3, method = "nr",
           index = c('consolidated_country', 'year'))
summary(pnb)

# nb <- pglm(n_events ~ lag(exrec) + lag(exconst) + lag(polcomp) + lag(durable) + lag(GDP_output) + lag(pop) + lag(any_conflict),  my_data.scl,
#            family = negbin(link="log"), model = "within", print.level = 3, method = "nr",
#            index = c('consolidated_country', 'year'))
# summary(nb)

# VERSION 2 LEGITIMACY MEASURES FROM WGI DATA BASE

# correlation matrix
cor(my_data %>% select(-consolidated_country), use = "pairwise.complete.obs")


# legitimacy 
pnb <- pglm(n_events ~ accountability + corruption + effectiveness + quality + rule_of_law,  my_data,
           family = negbin, model = "within", print.level = 3, method = "nr",
           index = c('consolidated_country', 'year'))
summary(pnb)

# lagged legitimacy
pnb <- pglm(n_events ~ lag(accountability) + lag(corruption) + lag(effectiveness) + lag(quality) + lag(rule_of_law),  my_data,
           family = negbin, model = "within", print.level = 3, method = "nr",
           index = c('consolidated_country', 'year'))
summary(pnb)

#  lagged legitimacy + lagged controls
# FINAL MODEL

pnb <- pglm(n_events ~ lag(accountability) + lag(corruption) + lag(effectiveness) + lag(quality) + 
              lag(rule_of_law) ,  my_data,
            family = negbin, model = "within", print.level = 3, method = "nr",
            index = c('consolidated_country', 'year'))
summary(pnb)

pnb <- pglm(n_events ~ lag(accountability) + lag(corruption) + lag(effectiveness) + lag(quality) + 
              lag(rule_of_law) + lag(any_conflict),  my_data,
            family = negbin, model = "within", print.level = 3, method = "nr",
            index = c('consolidated_country', 'year'))
summary(pnb)

pnb <- pglm(n_events ~ lag(accountability) + lag(corruption) + lag(effectiveness) + lag(quality) + 
              lag(rule_of_law) + lag(any_conflict) + lag(stability),  my_data,
            family = negbin, model = "within", print.level = 3, method = "nr",
            index = c('consolidated_country', 'year'))
summary(pnb)

pnb <- pglm(n_events ~ lag(accountability) + lag(corruption) + lag(effectiveness) + lag(quality) + 
              lag(rule_of_law) + lag(log(GDP_expentiture)) + lag(log(pop)) + lag(any_conflict),  
            my_data,
            family = negbin, model = "within", print.level = 3, method = "nr",
            index = c('consolidated_country', 'year'))
summary(pnb)



pnb <- pglm(n_events ~ lag(accountability) + lag(corruption) + lag(effectiveness) + lag(quality) + 
              lag(rule_of_law) + lag(log(GDP_expentiture)) + lag(log(pop)) + lag(any_conflict) +lag(stability),  my_data,
           family = negbin, model = "within", print.level = 3, method = "nr",
           index = c('consolidated_country', 'year'))
summary(pnb)

pnb <- pglm(n_events ~ lag(accountability) + lag(corruption) + lag(effectiveness) + lag(quality) + 
              lag(rule_of_law) + lag(GDP_expentiture) + lag(pop) + lag(any_conflict) +lag(stability),  
            my_data.scl,
            family = negbin, model = "within", print.level = 3, method = "nr",
            index = c('consolidated_country', 'year'))
summary(pnb)

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

