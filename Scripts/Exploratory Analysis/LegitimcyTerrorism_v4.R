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

my_data <- readRDS("../../Data/Data for Modelling/GTD_polity_PENN_PRIO_WGI_WVS_Fragility_WDI_HIEF_Vdem_ELRF_Gallup_2000.rds")

# my_data_text <- my_data %>% select(year = year, ...)


data_to_plot <- my_data %>%
  group_by(consolidated_country) %>%
  summarise(
    avg_n_events = mean(n_events),
    sum_n_events = sum(n_events),
    avg_effectiveness = mean(effectiveness, na.rm = TRUE)
  ) %>%
  drop_na() %>%
  filter(sum_n_events < 1000)


ggplot(data = data_to_plot, aes(x = avg_effectiveness, y = sum_n_events)) + # log(sum_n_events)
  geom_point() +
  geom_smooth() +
  theme_minimal()


ggplot(data = my_data, aes(x = effectiveness, y = log(n_events))) + 
  geom_point() +
  geom_smooth() +
  theme_minimal()




# ----------------  plots :

# TERRORIST EVENTS OVER THE YEARS
# MAYBE TERRORIST EVENTS BY REGION?

# FINAL
sum_events_by_year <- my_data %>% group_by(year) %>% summarise(sum_n_events = sum(n_events))
plot_events_year <- ggplot(data = sum_events_by_year, aes(x = year, y = sum_n_events)) +
  geom_line() + geom_point() +
  labs(x = "Year", y = "Sum of events over the countries", title = NULL, size=18) +
  theme_minimal() + 
  theme(axis.text=element_text(size=12), axis.title=element_text(size=14,face="bold")) + 
  ggsave("plot_events_year.pdf")

sum_targevents_by_year <- my_data %>% group_by(year) %>% summarise(sum_n_domtarg_events = sum(n_domtarg_events))
plot_events_year <- ggplot(data = sum_targevents_by_year, aes(x = year, y = sum_n_domtarg_events)) +
  geom_line() + geom_point() +
  labs(x = "Year", y = "Sum of events over the countries", title = NULL, size=18) +
  theme_minimal() + 
  theme(axis.text=element_text(size=12), axis.title=element_text(size=14,face="bold")) 
plot_events_year
# + ggsave("plot_targevents_year.pdf")


mean_acc <- my_data %>% group_by(n_events) %>% 
  summarise(mean_acc = mean(accountability, na.rm = TRUE))
ggplot(data = mean_acc, aes(x = n_events, y = mean_acc)) +
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

# 
# ----------------  correlation matrix :
corrleg <- cor(my_data %>% select(accountability,corruption,effectiveness,quality,rule_of_law, polity2), use = "pairwise.complete.obs")
stargazer(corrleg,type="html", out="correlation_matrix.htm")

# ----------------  summary statistics :
stargazer(my_data, type="text") # To create a summary statistics table (select variables?)
stargazer(my_data, type="html", out="descriptives.htm") # To create a summary statistics table (select variables?)

# ----------------  fixed negative binomial regression of terrorist events pglm  :

# political stability is excluded because it considers measures of terrorism
# 
# ACCOUNTABILITY (does not converge)
 # my_data_std2 <- my_data %>%
 #   mutate(accountability = (accountability - min(accountability, na.rm = TRUE)) /
 #            (max(accountability, na.rm = TRUE) - min(accountability, na.rm = TRUE))
 #   )

pnbacc <- pglm(n_events ~ accountability +
               lag(log(GDP_expentiture)) + lag(log(pop)) + lag(any_conflict) + lag(durable),
            my_data,
             family = negbin, model = "within", print.level = 3, method = "nr",
             index = c('consolidated_country', 'year'),
             start = NULL, R = 20 )

summary(pnbacc)
hist(my_data_std2$n_events, breaks =100)
summary(my_data$accountability)
plot(density(na.omit(my_data$accountability)))

# start = c(1,2), R = 20 )

 # does not converge
# pnbacc <- pglm(n_events ~ lag(accountability) +
#               lag(log(GDP_expentiture)) + lag(log(pop)) + lag(any_conflict),
#             my_data,
#             family = negbin, model = "within", print.level = 3, method = "nr",
#             index = c('consolidated_country', 'year'),
#             start = c(1, 1), R = 20 )
# summary(pnbacc)

# CORRUPTION
pnbcorr <- pglm(n_events ~ lag(corruption) + 
              lag(log(GDP_expentiture)) + lag(log(pop)) + lag(any_conflict) + lag(durable),
            my_data,
            family = negbin, model = "within", print.level = 3, method = "nr",
            index = c('consolidated_country', 'year'),
            start = NULL, R = 20 )
summary(pnbcorr)
AIC(pnbcorr)
length(pnbcorr$gradientObs[, 1])

pnbexpcorr <- exp(cbind(coef(pnbcorr), confint(pnbcorr)))

# EFFFECTIVENESS
pnbeff <- pglm(n_events ~ lag(effectiveness) + 
              lag(log(GDP_expentiture)) + lag(log(pop)) + lag(any_conflict) + lag(durable),
            my_data,
            family = negbin, model = "within", print.level = 3, method = "nr",
            index = c('consolidated_country', 'year'),
            start = NULL, R = 20 )
summary(pnbeff)
AIC(pnbeff)

length(pnbeff$gradientObs[, 1])


pnbexpeff <- exp(cbind(coef(pnbeff), confint(pnbeff)))


# QUALITY
pnbqua <- pglm(n_events ~ lag(quality) + 
              lag(log(GDP_expentiture)) + lag(log(pop)) + lag(any_conflict) + lag(durable),
            my_data,
            family = negbin, model = "within", print.level = 3, method = "nr",
            index = c('consolidated_country', 'year'),
            start = NULL, R = 20 )
summary(pnbqua)
length(pnbqua$gradientObs[, 1])
AIC(pnbqua)


pnbexpqua <- exp(cbind(coef(pnbqua), confint(pnbqua)))

# RULE OF LAW
pnbrul <- pglm(n_events ~ lag(rule_of_law) + 
              lag(log(GDP_expentiture)) + lag(log(pop)) + lag(any_conflict) + lag(durable),
            my_data,
            family = negbin, model = "within", print.level = 3, method = "nr",
            index = c('consolidated_country', 'year'),
            start = NULL, R = 20 )

summary(pnbrul)
length(pnbrul$gradientObs[, 1])
AIC(pnbrul)


pnbexprul <- exp(cbind(coef(pnbrul), confint(pnbrul)))



# ----------------  fixed negative binomial regression of terrorist events lme4  :
https://stackoverflow.com/questions/37336510/how-to-extract-fixed-effects-part-of-summary-from-lme4
https://rdrr.io/cran/lme4/man/fixef.html

https://strengejacke.github.io/mixed-models-snippets/random-effects-within-between-effects-model.html

https://www.r-bloggers.com/why-i-use-panelmultilevel-methods/

https://www.ls3.soziologie.uni-muenchen.de/studium-lehre/archiv/teaching-marterials/panel-analysis_april-2019.pdf
https://www.stata.com/meeting/germany17/slides/Germany17_Kripfganz.pdf
https://blog.stata.com/2015/10/29/fixed-effects-or-random-effects-the-mundlak-approach/



# ----------------  reporting negative binomial regression of terrorist events :

stargazer(coeftest(pnbcorr), coeftest(pnbeff), coeftest(pnbqua), coeftest(pnbrul),
          type="text", title="Results", align=TRUE,
          ci.level=0.90, single.row=TRUE)

stargazer(coeftest(pnbcorr), coeftest(pnbeff), coeftest(pnbqua), coeftest(pnbrul),
          type="html", title="Results", align=TRUE,
          ci.level=0.90, single.row=TRUE, out="nbr_leg_terrorism.htm")



# REPORT IRR
# exp(cbind(coef(pnb), confint(pnb)))


stargazer(pnbexpcorr, pnbexpeff,pnbexpqua, pnbexprul,  type="text", title="Results", align=TRUE,
          ci.level=0.90, single.row=TRUE, nobs = TRUE)

stargazer(coeftest(pnbeff),pnbexpeff,  type="html", title="Results", 
          ci.level=0.90, single.row=TRUE, out="nbrirr_leg_terrorism.htm")


# COMBINED MODEL

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



# ----------------  WGI scale :
# running factor analysis
# https://www.statmethods.net/advstats/factor.html
# https://www.r-bloggers.com/exploratory-factor-analysis-in-r/
#  http://www.di.fc.ul.pt/~jpn/r/factoranalysis/factoranalysis.html
# http://www.sthda.com/english/articles/31-principal-component-methods-in-r-practical-guide/112-pca-principal-component-analysis-essentials/
# https://www.gastonsanchez.com/visually-enforced/how-to/2012/06/17/PCA-in-R/
# https://cran.r-project.org/web/packages/FactoMineR/FactoMineR.pdf
# http://factominer.free.fr/course/FactoTuto.html


# saving factor scores
# https://stackoverflow.com/questions/6842216/adding-factor-scores-to-the-original-dataset

my_dataWGI <- my_data %>%
  select(accountability,corruption,effectiveness,quality,rule_of_law)

#na.omit(USArrests)

# 
# Exploratory Factor Analysis

# Maximum Likelihood Factor Analysis
# entering raw data and extracting 3 factors, 
# with varimax rotation 
fit <- factanal(na.omit(my_dataWGI), 2, rotation="varimax") # omit na
print(fit, digits=2, cutoff=.3, sort=TRUE)
# plot factor 1 by factor 2 
load <- fit$loadings[,1:2] 
plot(load,type="n") # set up plot 
text(load,labels=names(mydata),cex=.7) # add variable names

# Principal Axis Factor Analysis
library(psych)
fit <- factor.pa(my_dataWGI, nfactors=3, rotation="promax")
fit # print results

# Determine Number of Factors to Extract
library(nFactors)
ev <- eigen(cor(my_dataWGI, use = "complete.obs")) # get eigenvalues, use only complete obserbation
ap <- parallel(subject=nrow(my_dataWGI),var=ncol(my_dataWGI),
               rep=100,cent=.05)
nS <- nScree(x=ev$values, aparallel=ap$eigen$qevpea)
plotnScree(nS)



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

# NEGATIVE BINOMIAL REGRESSION SPECIFICATION
# I think it makes no sense to calculate an ICC following a negative binomial 2-level model. 
# The ICC is defined as var_u/(var_u + var_e), where var_u is the variance of the intercepts at the higher level and var_e is the variance of the residuals 
# at the bottom level. After linear regression, var_e is estimated from the data; its existence is a presumption of the model. 
# After logit or probit estimation, var_e is a constant attribute of the logistic or normal distribution ((pi^2)/3 or 1, respectively) 
# that characterizes the latent variable. In the case of the Poisson or negative binomial regression, there is no latent-variable formulation of the model, 
# and there is no variance to estimate from the data because it is an assumption of these models that the variance of the error term is a function 
# of the predicted value (e.g. in Poisson variance = mean). Since there is no such thing as var_e for these models, there is nothing from which to calculate ICC.


