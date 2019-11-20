library(tidyverse)
library(pglm) # model panel data
library(pscl)
library(lme4) # models longitudinal data within a Generalized Linear Mixed Model (GLMM) framework,
# Note that glmer implements random, rather than fixed effects. 
# If you're attempting inference and want to control for all cross-sectional heterogeneity, glmer won't get you there. You'd need some implementation of the conditional logit model
library(robustHD) # data standardization
library(Hmisc)
library(stargazer) # Well-Formatted Regression and Summary Statistics Tables
library(lmtest) # for coefplot

library(sjPlot)
library(sjmisc)
library(sjlabelled)



my_data <- readRDS("../../Data/Data for Modelling/GTD_polity_PENN_PRIO_WGI_2000.rds")

# my_data_text <- my_data %>% select(year = year, ...)


# ----------------  negative binomial regression of terrorist events :
# Panel Estimators For Generalized Linear Models (https://www.rdocumentation.org/packages/pglm/versions/0.2-1/topics/pglm)

## some count data models
# data("my_data", package="pglm")

# VERSION 1 LEGITIMACY MEASURES FROM POLITY DATA BASE

cor(my_data %>% select(exrec, exconst, polcomp), use = "pairwise.complete.obs")


#  lagged legitimacy + lagged controls (NOT CONVERGING)

# pnb <- pglm(n_events ~ lag(exrec) + lag(exonst) + lag(polcomp) + lag(durable) + lag(log(GDP_expentiture)) + lag(log(pop)) + lag(any_conflict),  my_data,
#            family = negbin(link="log"), model = "within", print.level = 3, method = "nr",
#            index = c('consolidated_country', 'year'))



# VERSION 2 LEGITIMACY MEASURES FROM WGI DATA BASE
# political stability is excluded because it considers measures of terrorism

# correlation matrix
cor(my_data %>% select(-consolidated_country), use = "pairwise.complete.obs")

cor(my_data %>% select(accountability,corruption,effectiveness,quality,rule_of_law), use = "pairwise.complete.obs")

#  lagged (single) legitimacy + lagged controls

# ACCOUNTABILITY

my_data_std2 <- my_data %>% 
  mutate(accountability = (accountability - min(accountability, na.rm = TRUE)) / 
           (max(accountability, na.rm = TRUE) - min(accountability, na.rm = TRUE))
  )

pnbacc <- pglm(n_events ~ accountability +
              lag(log(GDP_expentiture)) + lag(log(pop)) + lag(any_conflict) + lag(durable),
            my_data_std2,
            family = negbin, model = "within", print.level = 3, method = "nr",
            index = c('consolidated_country', 'year'),
            start = NULL, R = 20 )

summary(pnbacc)


# pnc <- pglm(n_events ~ accountability +
#               log(GDP_expentiture) + log(pop) + any_conflict + durable,
#             my_data,
#             family = negbin, model = "within", print.level = 3, method = "nr",
#             index = c('consolidated_country', 'year'),
#             start = NULL , R = 20 )
# summary(pnc)


# start = c(1,2), R = 20 )

 # does not converge
# pnb <- pglm(n_events ~ lag(accountability) +
#               lag(log(GDP_expentiture)) + lag(log(pop)) + lag(any_conflict),
#             my_data,
#             family = negbin, model = "within", print.level = 3, method = "nr",
#             index = c('consolidated_country', 'year'),
#             start = c(1, 1), R = 20 )
# summary(pnb)

# CORRUPTION
pnbcorr <- pglm(n_events ~ lag(corruption) + 
              lag(log(GDP_expentiture)) + lag(log(pop)) + lag(any_conflict) + lag(durable),
            my_data,
            family = negbin, model = "within", print.level = 3, method = "nr",
            index = c('consolidated_country', 'year'),
            start = NULL, R = 20 )
summary(pnbcorr)



# model = glmer.nb(n_events~year+lag(corruption)+log(GDP_expentiture)+
#                    lag(log(GDP_expentiture)) + lag(log(pop)) + lag(any_conflict) +
#                    (1|consolidated_country), data=my_data)
# summary(model)

# EFFFECTIVENESS
pnbeff <- pglm(n_events ~ lag(effectiveness) + 
              lag(log(GDP_expentiture)) + lag(log(pop)) + lag(any_conflict) + lag(durable),
            my_data,
            family = negbin, model = "within", print.level = 3, method = "nr",
            index = c('consolidated_country', 'year'),
            start = NULL, R = 20 )
summary(pnbeff)

# QUALITY
pnbqual <- pglm(n_events ~ lag(quality) + 
              lag(log(GDP_expentiture)) + lag(log(pop)) + lag(any_conflict) + lag(durable),
            my_data,
            family = negbin, model = "within", print.level = 3, method = "nr",
            index = c('consolidated_country', 'year'),
            start = NULL, R = 20 )
summary(pnbqual)

# RULE OF LAW
pnbrul <- pglm(n_events ~ lag(rule_of_law) + 
              lag(log(GDP_expentiture)) + lag(log(pop)) + lag(any_conflict) + lag(durable),
            my_data,
            family = negbin, model = "within", print.level = 3, method = "nr",
            index = c('consolidated_country', 'year'),
            start = NULL, R = 20 )

summary(pnbrul)
exp(cbind(coef(pnbrul), confint(pnbrul)))

stargazer(coeftest(pnbrul), type="text")


# COMBINED MODEL
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

# https://stats.stackexchange.com/questions/146434/why-pglm-fails-for-within-model
# logit <- pglm(had_events ~ lag(accountability) + lag(effectiveness) + 
#               lag(log(GDP_expentiture)) + lag(log(pop)) + lag(any_conflict),  
#             my_data,
#             family = binomial, start=0, model = "within", print.level = 3, 
#             index = c('consolidated_country', 'year'))
# summary(logit)


# REPORT IRR
exp(cbind(coef(pnb), confint(pnb)))



#REPORTING

# TERRORIST EVENTS OVER THE YEARS
  # MAYBE TERRORIST EVENTS BY REGION?

sum_events_by_year <- my_data %>% group_by(year) %>% summarise(sum_n_events = sum(n_events))
ggplot(data = sum_events_by_year, aes(x = year, y = sum_n_events)) +
  geom_line() + geom_point() +
  labs(x = "Year", y = "Sum of events over the countries", title = NULL) +
  theme_minimal()

mean_acc <- my_data %>% group_by(n_events) %>% 
  summarise(mean_acc = mean(accountability, na.rm = TRUE))
ggplot(data = mean_acc, aes(x = n_events, y = mean_acc)) +
  geom_point() + geom_smooth() +
  labs(x = "Sum of events", y = "Average accountability", title = NULL) +
  theme_minimal()
mean_acc <- my_data %>% group_by(n_events) %>% 
  summarise(mean_acc = mean(effectiveness, na.rm = TRUE))
ggplot(data = mean_acc, aes(x = log(n_events), y = mean_acc)) +
  geom_point() + geom_smooth() +
  labs(x = "Sum of events", y = "Average accountability", title = NULL) +
  theme_minimal()

# by decile of number of events:
mean_acc <- my_data %>%
  filter(n_events > 0) %>% # only if more than 1 event
  mutate(decile_n_events = ntile(n_events, 10)) %>%
  group_by(decile_n_events) %>%
  summarise(mean_acc = mean(effectiveness, na.rm = TRUE))
ggplot(data = mean_acc, aes(x = decile_n_events, y = mean_acc)) +
  geom_point() + geom_smooth() +
  labs(x = "Number of events, decile", y = "Average accountability", title = NULL) +
  theme_minimal()

mean_acc <- my_data %>% group_by(n_events) %>% 
  summarise(mean_acc = mean(effectiveness, na.rm = TRUE), n_obs = n())
ggplot(data = head(mean_acc, 20), aes(x = n_events, y = mean_acc)) +
  geom_point() + geom_smooth() +
  labs(x = "Sum of events", y = "Average accountability", title = NULL) +
  theme_minimal()

mean_acc_sum_events_bycountry <- my_data %>% 
  group_by(consolidated_country) %>% 
  summarise(mean_acc = mean(accountability, na.rm = TRUE),
            sum_n_events = sum(n_events, na.rm = TRUE))
ggplot(data = mean_acc_sum_events_bycountry, aes(x = mean_acc, y = sum_n_events)) +
  geom_point() + geom_smooth() +
  labs(x = "Average accountability over the years", y = "Sum of events over the years and countries", title = NULL) +
  theme_minimal()

mean_acc_sum_events_bycountry <- my_data %>% 
  group_by(consolidated_country) %>% 
  summarise(mean_acc = mean(accountability, na.rm = TRUE),
            sum_n_events = sum(n_events, na.rm = TRUE))
ggplot(data = mean_acc_sum_events_bycountry, aes(x = mean_acc, y = sum_n_events)) +
  geom_point() + geom_smooth() +
  labs(x = "Average accountability over the years", y = "Sum of events over the years by country", title = NULL) +
  theme_minimal()

mean_acc_sum_events_bycountry <- my_data %>% 
  group_by(consolidated_country) %>% 
  summarise(mean_acc = mean(effectiveness, na.rm = TRUE),
            sum_n_events = sum(n_events, na.rm = TRUE))
ggplot(data = mean_acc_sum_events_bycountry, aes(x = mean_acc, y = log(sum_n_events))) +
  geom_point() + geom_smooth() +
  labs(x = "Average effectivenss over the years", y = "Sum of events over the years by country", title = NULL) +
  theme_minimal()


mean_acc <- my_data %>% group_by(year) %>% summarise(mean_acc = mean(accountability, na.rm = TRUE))
ggplot(data = mean_acc, aes(x = year, y = mean_acc)) +
  geom_point() + geom_smooth() +
  labs(x = "year", y = "mean accountability", title = NULL) +
  theme_minimal()

# 
# CORRELATION MATRIX

corrleg <- cor(my_data %>% select(accountability,corruption,effectiveness,quality,rule_of_law), use = "pairwise.complete.obs")

stargazer(corrleg, type="text")


# 

# SUMMARY STATISTICS
stargazer(my_data, type="text") # To create a summary statistics table (select variables?)


# NEGATIVE BINOMIAL REGRESSION

# reporting

stargazer(coeftest(pnbrul), title="Results", align=TRUE)
stargazer(exp(cbind(coef(pnbrul), confint(pnbrul))), title="Results", align=TRUE)

stargazer(exp(cbind(coef(pnbrul), confint(pnbrul))),  type="text", title="Results", 
          dep.var.labels=c("Number of Terrorist Events"),
          omit.stat=c("LL","ser","f"), ci=TRUE, ci.level=0.90, single.row=TRUE)

# REPORTING COMBINED (rule of law and quality)

stargazer(exp(cbind(coef(pnbqual), confint(pnbqual))),
          exp(cbind(coef(pnbrul), confint(pnbrul))),  type="text", title="Results", 
          omit.stat=c("LL","ser","f"), ci=TRUE, ci.level=0.90, single.row=TRUE)

# REPORTING ASCII text output

stargazer(exp(cbind(coef(pnbqual), confint(pnbqual))),
          exp(cbind(coef(pnbrul), confint(pnbrul))),  type="text", title="Results", 
          dep.var.labels=c("Number of Terrorism Events","Number of Terrorism Events"),
          covariate.labels=c("Rule of Law","Quality", "GDP (log)","Population (log)","Any Conflict","Durable"),
          omit.stat=c("LL","ser","f"), ci=TRUE, ci.level=0.90, single.row=TRUE)

# REPORTING Word  output

stargazer(exp(cbind(coef(pnbqual), confint(pnbqual))),
          exp(cbind(coef(pnbrul), confint(pnbrul))),  type="html", title="Results", 
          omit.stat=c("LL","ser","f"), ci=TRUE, ci.level=0.90, single.row=TRUE, out="models.htm")





# LINKS

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
# https://stats.idre.ucla.edu/r/dae/mixed-effects-logistic-regression/

# REGRESSION OUTPUT TABLE
# https://cran.r-project.org/web/packages/sjPlot/vignettes/tab_model_estimates.html
# https://cran.r-project.org/web/packages/stargazer/vignettes/stargazer.pdf
# https://www.rdocumentation.org/packages/stargazer/versions/5.2.2/topics/stargazer
# https://www.princeton.edu/~otorres/NiceOutputR.pdf


