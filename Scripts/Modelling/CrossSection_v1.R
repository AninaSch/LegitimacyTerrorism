install.packages("pscl")
install.packages("lme4")


# first try at regressions:

library(tidyverse)
library(pglm) # model panel data
library(pscl)

library(lme4) # models longitudinal data within a Generalized Linear Mixed Model (GLMM) framework,
# Note that glmer implements random, rather than fixed effects. 
# If you're attempting inference and want to control for all cross-sectional heterogeneity, glmer won't get you there. You'd need some implementation of the conditional logit model


my_data <- readRDS("../../Data/Data for Modelling/GTD_polity_PENN.rds")

# for now, just remove all the polity score larger than 10 (absolute value)
# (this should be done in tidy_Polity4.R)
my_data <- my_data %>% filter(abs(polity) < 11) # ! we go from 5282 row to 5088

# ---------------- Try a logistic regression

# Longitudinal Logits (https://data.princeton.edu/wws509/r/fixedRandom3)

## legitimacy measures
logit <- glm(had_events ~ exrec + exconst + polcomp, data = my_data, family = binomial)
summary(logit)

## legitimacy +controls
logit <- glm(had_events ~ exrec + exconst + polcomp + durable + GDP_expentiture + pop, data = my_data, family = binomial)
summary(logit)

## fixed effect
library(survival)
fe <- clogit(had_events ~ exrec + exconst + polcomp + durable + GDP_expentiture + pop + strata(year), data = my_data)
summary(fe)

## radom effects
library(glmer)
#re1  <- glmer(had_events ~ exrec + exconst + polcomp + durable + GDP_expentiture + pop, cluster = year, data = my_data)


# Panel Estimators For Generalized Linear Models (https://www.rdocumentation.org/packages/pglm/versions/0.2-1/topics/pglm)
## a binomial logit
data('my_data', package = 'pglm')

## legitimacy measures
anb <- pglm(had_events ~ exrec + exconst + polcomp, my_data, family = binomial('probit'),
            model = "pooling",  method = "bfgs", print.level = 3, R = 5)
summary(anb)

## legitimacy measures + controls. Once I add GDP 
anb <- pglm(had_events ~ exrec + exconst + polcomp + durable + GDP_expentiture + pop , my_data, family = binomial('logit'),
            model = "within",  method = "bfgs", print.level = 3, R = 5)
summary(anb)



# ----------------  negative binomial :
# Panel Estimators For Generalized Linear Models (https://www.rdocumentation.org/packages/pglm/versions/0.2-1/topics/pglm)

## some count data models
# data("my_data", package="pglm")

# legitimacy
la <- pglm(n_events ~ exrec + exconst + polcomp,  my_data,
           family = negbin, model = "within", print.level = 3, method = "nr",
           index = c('consolidated_country', 'year'))
summary(la)

# lagged legitimacy
la <- pglm(n_events ~ lag(exrec) + exconst + polcomp,  my_data,
           family = negbin, model = "within", print.level = 3, method = "nr",
           index = c('consolidated_country', 'year'))
summary(la)

#  legitimacy + controls

my_data <- my_data %>% filter(abs(polity) < 11) # ! we go from 5282 row to 5088


la <- pglm(n_events ~ polity + durable + log(GDP_expentiture) + log(pop),  my_data,
           family = negbin(link="log"), model = "within", print.level = 3, method = "nr",
           index = c('consolidated_country', 'year'))

la <- pglm(n_events ~ exrec + exconst + polcomp + durable + log(GDP_expentiture) + log(pop),  my_data,
           family = negbin(link="log"), model = "within", print.level = 3, method = "nr",
           index = c('consolidated_country', 'year'))
summary(la)




# la <- pglm(patents ~ lag(log(rd), 0:5) + scisect + log(capital72) + factor(year), PatentsRDUS,
           # family = negbin, model = "within", print.level = 3, method = "nr",
           # index = c('cusip', 'year'))




# how to model panel data?
#     country and time dimensions
#     https://en.wikipedia.org/wiki/Panel_data

# use plm (only for linear models)
# https://cran.r-project.org/web/packages/plm/plm.pdf
# https://www.youtube.com/watch?v=1pST2lUx6QM


# use pglm (generalized lm -> neg bin and logit)
# https://cran.r-project.org/web/packages/pglm/pglm.pdf



# library(lme4)
# https://cran.r-project.org/web/packages/lme4/index.html
# https://www.jaredknowles.com/journal/2013/11/25/getting-started-with-mixed-effect-models-in-r
# glmer(formula, data = , family = 'binomial')...

# https://data.princeton.edu/wws509/r/fixedRandom3
https://stats.idre.ucla.edu/r/dae/mixed-effects-logistic-regression/

