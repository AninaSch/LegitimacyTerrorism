
# first try at regressions:

library(tidyverse)
library(pglm) # model panel data

my_data <- readRDS("../../Data/Data for Modelling/first_dataset_to_try.rds")

# for now, just remove all the polity score larger than 10 (absolute value)
# (this should be done in tidy_Polity4.R)
my_data <- my_data %>% filter(abs(polity) < 11) # ! we go from 9841 row to 6999


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

# random effect estimator (CORRECT ONE?)
log_reg <- pglm(formula = had_events ~ polity, data = pdata, estimator = "random", family = 'binomial')
summary(log_reg)
# TO DO: handle the warning of pglm



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


