
# first try at regressions:

library(tidyverse)
library(pglm) # model panel data

my_data <- readRDS("../../Data/Data for Modelling/GTD_polity_PENN.rds")

# for now, just remove all the polity score larger than 10 (absolute value)
# (this should be done in tidy_Polity4.R)
my_data <- my_data %>% filter(abs(polity) < 11) # ! we go from 5282 row to 5088

# ---------------- Try a logistic regression

# # the fixed effects:
# Y <- cbind(my_data$had_events) # dependent variable
# X <- my_data %>% select(polity) %>% cbind() # independent variables (add more vars in the select)

# set my data as panel data
pdata <- pdata.frame(my_data, index = c("consolidated_country", "year")) # not necessary, could also probably be done when calling pglm
# TODO: handle the warning of pdata.frame

# # summary statistics:
# summary(Y)
# summary(X)


# NEED STANDARDIZATION


# random effect estimator (CORRECT ONE?)
log_reg <- pglm(formula = had_events ~ exrec + exconst + polcomp + durable + GDP_expentiture + pop, 
                data = pdata, estimator = "random", family = 'binomial')
summary(log_reg)
# TO DO: handle the warning of pglm
# TO DO: choose correct estimator/model: "pooling", "within", "between", "random"



# ----------------  negative binomial :
# for negbin: family = negbin. and Y=n_events
neg_bin <- pglm(formula = n_events ~ polity, data = pdata, estimator = "random", family = 'negbin')
summary(neg_bin)




# how to model panel data?
#     country and time dimensions
#     https://en.wikipedia.org/wiki/Panel_data

# use plm (only for linear models)
# https://cran.r-project.org/web/packages/plm/plm.pdf
# https://www.youtube.com/watch?v=1pST2lUx6QM


# use pglm (generalized lm -> neg bin and logit)
# https://cran.r-project.org/web/packages/pglm/pglm.pdf



library(lme4)
# https://cran.r-project.org/web/packages/lme4/index.html
# https://www.jaredknowles.com/journal/2013/11/25/getting-started-with-mixed-effect-models-in-r
# glmer(formula, data = , family = 'binomial')...



