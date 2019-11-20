# save data for modelling in Stata format:

library(foreign)

GTD_polity_PENN_PRIO_WGI <- readRDS("../../Data/Data for Modelling/GTD_polity_PENN_PRIO_WGI_2000.rds")

write.dta(GTD_polity_PENN_PRIO_WGI,  file = "../../Data/Data for Modelling/GTD_polity_PENN_PRIO_WGI_2000.dta") 

GTD_polity_PENN_PRIO_WGI_WVS <- readRDS("../../Data/Data for Modelling/GTD_polity_PENN_PRIO_WGI_WVS_2000.rds")

write.dta(GTD_polity_PENN_PRIO_WGI_WVS,  file = "../../Data/Data for Modelling/GTD_polity_PENN_PRIO_WGI_WVS_2000.dta") 

