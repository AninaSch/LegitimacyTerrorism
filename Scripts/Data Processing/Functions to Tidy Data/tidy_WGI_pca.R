# PRINCIPAL COMPONENT ANALYSIS

# pca of  "accountability", "corruption", "effectiveness", "quality", "rule_of_law"

# https://www.theanalysisfactor.com/the-fundamental-difference-between-principal-component-analysis-and-factor-analysis/
# https://www.statmethods.net/advstats/factor.html
# http://geog.uoregon.edu/bartlein/courses/geog495/lec16.html
# https://data-flair.training/blogs/principal-components-and-factor-analysis-in-r/

# https://uc-r.github.io/pca#selecting
# https://www.r-bloggers.com/computing-and-visualizing-pca-in-r/
# https://stackoverflow.com/questions/15680375/extracting-pca-axes-for-further-analysis
# https://www.gastonsanchez.com/visually-enforced/how-to/2012/06/17/PCA-in-R/
# https://www.statmethods.net/advstats/factor.html
# https://www.analyticsvidhya.com/blog/2016/03/practical-guide-principal-component-analysis-python/
# https://towardsdatascience.com/principal-component-analysis-pca-101-using-r-361f4c53a9ff


# https://www.youtube.com/watch?v=xKl4LJAXnEA

library(rio) # to import and export data
library(tidyverse) # data wrangling etc.
library(broom)
library(ggplot2)

WGI <- rio::import("../../../Data/Processed Data/WGI_tidy.rds")

# compute principal components
pca <-  prcomp(~ accountability + corruption + effectiveness + quality + rule_of_law, data=WGI, scale=TRUE, center = TRUE)
# pca <-  prcomp(~ ., data=WGI_tidy[,c(3:7)], na.action=na.omit, scale=TRUE, center = TRUE)
summary(pca) # print variance accounted for 

# sqrt of eigenvalues
pca$sdev

# loadings
head(pca$rotation)
(loadings <- pca$rotation)
# pca$rotation[,1:5] # rotating

# plot of observations
ggplot(data = scores, aes(x = PC1, y = PC2, label = rownames(scores))) +
  geom_hline(yintercept = 0, colour = "gray65") +
  geom_vline(xintercept = 0, colour = "gray65") +
  geom_text(colour = "tomato", alpha = 0.8, size = 4) +
  ggtitle("PCA plot of Legitimacy")

plot(pca,type="lines") # scree plot 
biplot(pca)

# PCs (aka scores)
head(pca$x)
pca$x[,1] # look at first PCA

# create data frame with scores
scores = as.data.frame(pca$x)

# merge
WGI_merge <-  merge(WGI, scores, by= "row.names", all = T)

WGI_tidy <- WGI_merge %>%
  select(-c("PC2","PC3", "PC4","PC5")) %>%
  arrange(country, year) %>%
  select(-"Row.names", legitimacy=PC1)

# alternative way to extract results
# axes <- predict(pca, newdata = WGI_tidy)
# head(axes, 4)
# WGI_bind <- cbind(WGI, axes) 


# with PSYC LIBRARY
# Varimax Rotated Principal Components
# retaining 1 components 
library(psych)
fit <- principal(WGI[, 3:7], nfactors=5, rotate="varimax")
fit # print results

fit$scores
fit$loadings

scores2 = as.data.frame(fit$scores)
WGI_merge2 <-  merge(WGI, scores2, by= "row.names", all = T)

saveRDS(WGI_tidy, file = "../../../Data/Processed Data/WGI_tidy.rds")
  
  
# check: correlation between legitimacy and accountability

cor(WGI_tidy$legitimacy, WGI_tidy$accountability, use="complete.obs", method="kendall") 
  
cor(WGI_merge2$RC1, WGI_tidy$accountability, use="complete.obs", method="kendall") 

