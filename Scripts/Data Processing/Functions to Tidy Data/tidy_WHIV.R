
# Aim of this function:
#   read the PENN data, select the variables of interest, add new computed variables if needed, and,
#   save the output as PENN_tidy.rds.

# note: this function is called from tidy_datasets.R

tidy_WHIV <- function(path_loadoriginal, path_savetidy){
  
  #       1. read WHIV Data
  print("importing WHIV data... ")
  # WHIV <- rio::import(path_loadoriginal)
  WHIV <- rio::import("../../../Data/Original Data/WHIV/WHIV.csv") # for debugging
  
# output variable = use of violence in civil protests
  # PDEM Protest demonstration, All protest demonstrations not otherwise specified
  # POBS Protest obstruction Sit-ins and other non-military occupation protests
  # PMAR Protest procession Picketing and other parading protests
  # PPRO Protest defacement Damage, sabotage and the use of graffiti to desecrate property and symbols
  # PALT Protest altruism Protest demonstrations that place the actor (protestor) at risk for the sake of unity with the target
  # SRAL Rally support Gatherings to express or demonstrate support for an existing government or institution. Includes celebrations, public displays of confidence, commemorations, and vigils
  # STRI Strikes & boycotts Labor and professional sanctions reported as strikes, general strikes, walkouts, lockouts, or withholding of goods/services
  # RIOT Riot Civil or political unrest explicitly characterized as riots, as well as behavior presented as tumultuous or mob-like. Includes looting, prison uprisings, crowds setting things on fire, general fighting with police (typically by protestors), lynch mob assemblies, ransacking, football riots, and stampedes
  # counterargument: 
  #   Political Relaxations
  

  print("importing done")
  
  WHIV_sub <- WHIV %>%
    select(
      year,
      country = countryname,
      actor,
      violence,
      protest,
      pobs,
      pmar,
      ppro,
      palt,
      sral,
      stri,
      riot
    ) %>%
    filter(
      year >= 1970
    ) %>%
    mutate(
      country = as.factor(country)
      ) %>%
    arrange(country, year)
  
  # create a new variable with total counts from protests (only for civil actors!)
  
  WHIV_tidy <- WHIV_sub %>%
    filter (actor == "civil") %>%
    group_by(country) %>% 
    mutate(nonviolent_protests = pobs + pmar) %>%
    mutate(violent_protests =ppro + palt + riot) %>%
    mutate(politcal_relaxations = sral)
  
  # glimpse(penn_tidy)
  print("tidying done")
  
  saveRDS(WHIV_tidy, file = path_savetidy)
  saveRDS(WHIV_tidy, file = "../../../Data/Processed Data/WHIV_tidy.rds")
  
  print("processed WHIV data saved")
  
}
