# save data for modelling in Stata format:

library(foreign)

GTD_polity_PENN_PRIO_WGI <- readRDS("../../Data/Data for Modelling/GTD_polity_PENN_PRIO_WGI_2000.rds")
write.dta(GTD_polity_PENN_PRIO_WGI,  file = "../../Data/Data for Modelling/GTD_polity_PENN_PRIO_WGI_2000.dta") 

GTD_polity_PENN_PRIO_WGI_WVS <- readRDS("../../Data/Data for Modelling/GTD_polity_PENN_PRIO_WGI_WVS_2000.rds")
write.dta(GTD_polity_PENN_PRIO_WGI_WVS,  file = "../../Data/Data for Modelling/GTD_polity_PENN_PRIO_WGI_WVS_2000.dta") 

GTD_polity_PENN_PRIO_WGI_WVS_Fragility_WDI_HIEF <- readRDS("../../Data/Data for Modelling/GTD_polity_PENN_PRIO_WGI_WVS_Fragility_WDI_HIEF_2000.rds")
write.dta(GTD_polity_PENN_PRIO_WGI_WVS_Fragility_WDI_HIEF,  file = "../../Data/Data for Modelling/GTD_polity_PENN_PRIO_WGI_WVS_Fragility_WDI_HIEF_2000.dta") 

GTD_polity_PENN_PRIO_WGI_WVS_Fragility_WDI_HIEF_Vdem <- readRDS("../../Data/Data for Modelling/GTD_polity_PENN_PRIO_WGI_WVS_Fragility_WDI_HIEF_Vdem_2000.rds")
write.dta(GTD_polity_PENN_PRIO_WGI_WVS_Fragility_WDI_HIEF_Vdem,  file = "../../Data/Data for Modelling/GTD_polity_PENN_PRIO_WGI_WVS_Fragility_WDI_HIEF_Vdem_2000.dta") 


GTD_polity_PENN_PRIO_WGI_WVS_Fragility_WDI_HIEF_Vdem_ELRF_Gallup <- readRDS("../../Data/Data for Modelling/GTD_polity_PENN_PRIO_WGI_WVS_Fragility_WDI_HIEF_Vdem_ELRF_Gallup_2000.rds")
write.dta(GTD_polity_PENN_PRIO_WGI_WVS_Fragility_WDI_HIEF_Vdem_ELRF_Gallup,  file = "../../Data/Data for Modelling/GTD_polity_PENN_PRIO_WGI_WVS_Fragility_WDI_HIEF_Vdem_ELRF_Gallup_2000.dta") 

LEGTER_ts <-  readRDS("../../Data/Data for Modelling/LEGTER_ts.rds")
write.dta(LEGTER_ts, file = "../../Data/Data for Modelling/LEGTER_ts.dta" )

LEGTER_cs <-  readRDS("../../Data/Data for Modelling/LEGTER_cs.rds")
write.dta(LEGTER_cs, file = "../../Data/Data for Modelling/LEGTER_cs.dta" )
