
# Aim of this function:
#   read the FreedomHouse data, select the variables of interest, add new computed variables if needed, and,
#   save the output as IGM_tidy.rds.

# note: this function is called from tidy_datasets.R

tidy_FH <- function(path_loadoriginal, path_savetidy){
  
### read FH Data
  print("importing Freedom House data... ")
  FH <- rio::import(path_loadoriginal)
  # FH <- rio::import("../../../Data/Original Data/FreedomHouse/FreedomHouse_FreedomInTheWorld_FIW2013-2019.xls") # for debugging

  print("importing done")
  
# keep only countries and not territories
 
   FH_filter <- FH  %>%  filter(`CT`== "c" )   %>%  
    select(-Region, -CT)
   
# attention: two types of CL and PL !!   
  
  FH_sub <- FH_filter %>%
    mutate(
      year = Edition,
      all_civil_liberties = CL,
      all_political_rights = PL,
      electoral_process = A,
      political_participation = B,
      government_functioning = C,
      freedom_expression = D, 
      organisational_rights = E,
      rule_of_law = F,
      personal_rights = G
    ) %>%
    mutate(
      country = as.factor(country)
      ) %>%
    arrange(country, year)
  # glimpse(penn_tidy)
  print("tidying done")
  
### CHECK DIRECTION OF EFFECT (PROBABLY HAVE TO FLIP)

  WVS_tidy <-WVS_sub  %>%
    mutate(all_civil_liberties_m=as.numeric(recode(all_civil_liberties, `1`="7", `2`="6",`3`=5,`4`="4",`5`="3",`6`="2",`7`="1")))  %>%
    mutate(all_political_rights_m=as.numeric(recode(all_political_rights, `1`="7", `2`="6",`3`=5,`4`="4",`5`="3",`6`="2",`7`="1")))  %>%
    mutate(electoral_process_m=as.numeric(recode(electoral_process, 6-electoral_process)))  %>%
    mutate(political_participation_m=as.numeric(recode(political_participation, `1`="2", `2`="2",`3`="3",`4`="4",`5`="5",`6`="6",`7`="7",`8`="8",`9`="9",`10`="10")))  %>%
    mutate(government_functioning_m=as.numeric(recode(government_functioning, `1`="2", `2`="2",`3`="3",`4`="4",`5`="5",`6`="6",`7`="7",`8`="8",`9`="9",`10`="10")))  %>%
    mutate(freedom_expression_m=as.numeric(recode(freedom_expression, `1`="2", `2`="2",`3`="3",`4`="4",`5`="5",`6`="6",`7`="7",`8`="8",`9`="9",`10`="10")))  %>%
    mutate(organisational_rights_m=as.numeric(recode(organisational_rights, `1`="2", `2`="2",`3`="3",`4`="4",`5`="5",`6`="6",`7`="7",`8`="8",`9`="9",`10`="10")))  %>%
    mutate(rule_of_law_m=as.numeric(recode(rule_of_law, `1`="2", `2`="2",`3`="3",`4`="4",`5`="5",`6`="6",`7`="7",`8`="8",`9`="9",`10`="10")))  %>%
    mutate(personal_rights_m=as.numeric(recode(personal_rights, `1`="2", `2`="2",`3`="3",`4`="4",`5`="5",`6`="6",`7`="7",`8`="8",`9`="9",`10`="10"))) 
  
# reverse recoding: (1+ max)  - value. In this case 1+max = 6
#   data1[,c(2,4,5)] <- 7-data1[,c(2,4,5)]  

  saveRDS(FH_tidy, file = path_savetidy)
  # saveRDS(IGM_tidy, file = "../../../Data/Processed Data/FH_tidy.rds")
  
  print("processed Freedom House data saved")
  
}
