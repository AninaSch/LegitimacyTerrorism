
*** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***
* STATE LEGITIMACY AND TERRORISM: Negative Binomial Fixed Effects Model with Panel Data, output as IRR
*** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***
sysdir set PERSONAL "../../../ados"


*CHECK
*- other measures for trust: systemic peace
*- other measures for poverty: gini index
*- additional variable: world development index (youth burden, urbanization)
*- additional variable: ethnic hereogenity (HIEF)


clear*	
use "../../Data/Data for Modelling/GTD_polity_PENN_PRIO_WGI_WVS_Fragility_WDI_HIEF_Vdem_2000.dta" // relative path to data from where this script is
set more off  

*-------------- generate log variables
*https://stats.stackexchange.com/questions/298/in-linear-regression-when-is-it-appropriate-to-use-the-log-of-an-independent-va
*http://econbrowser.com/archives/2014/02/use-of-logarithms-in-economics

gen logGDP_expentiture = log(GDP_expentiture)
gen logGDPexp_capita = log(GDPexp_capita)
gen logpop = log(pop)

gen logGINI_index = log(GINI_index)


// is this reasonable?

*-------------- generate lagged variables

foreach v of var accountability corruption effectiveness quality rule_of_law stability {
	gen lag1`v'= `v'[_n-1]
}

foreach v of var fragility effect legit seceff secleg poleff polleg ecoeff ecoleg soceff socleg {
	gen lag1`v'= `v'[_n-1]
}
foreach v of var electoral_democracy liberal_democracy participatory_democracy deliberative_democracy egalitarian_democracy {
	gen lag1`v'= `v'[_n-1]
}

foreach v of var logGDP_expentiture GDP_expentiture logGDPexp_capita logpop pop {
	gen lag1`v'= `v'[_n-1]
}

foreach v of var logGINI_index youth_burden urbanization {
	gen lag1`v'= `v'[_n-1]
}
foreach v of var any_conflict durable exrec exconst polcomp polity2 {
	gen lag1`v'= `v'[_n-1]
}
gen lag1EFindex = EFindex[_n-1]


*-------------- correlation matrix
corr n_events accountability corruption effectiveness quality rule_of_law polity2

*-------------- summary statistics
generate y = uniform()
eststo: quietly regress y n_events accountability corruption effectiveness quality rule_of_law polity2 GDPexp_capita pop any_conflict durable mean_trust_others mean_importance_politics mean_interest_politics, noconstant

estadd summ : *	
esttab using "../../Findings/SummaryStataWVS.rtf", ///
	cells("mean(fmt(a2) label(Mean)) sd(fmt(a2)label(SD)) min(fmt(a2)label(Min)) max(fmt(a2)label(Max))") nodepvar nostar nonote ///
	replace compress rtf label
	eststo clear

*--------------  Before using xtreg you need to set Stata to handle panel data by using the command xtset. 
xtset consolidated_country year 
// “country” represents the entities or panels (i) and “year” represents the time variable (t)
// strongly balanced)” refers to the fact that all countries have data for all years.


*-------------- Regression with different legitimacy measures

* World Governance Index: accountability corruption effectiveness quality rule_of_law stability (check which one is linked to terrorist events)
xtnbreg n_events lag1accountability lag1logGDPexp_capita lag1logpop lag1any_conflict lag1durable mean_trust_others, re irr
xtnbreg n_events lag1corruption lag1logGDPexp_capita lag1logpop lag1any_conflict lag1durable mean_trust_others, re irr
xtnbreg n_events lag1effectiveness lag1logGDPexp_capita lag1logpop lag1any_conflict lag1durable mean_trust_others, re irr
xtnbreg n_events lag1quality lag1logGDPexp_capita lag1logpop lag1any_conflict lag1durable mean_trust_others, re irr
xtnbreg n_events lag1rule_of_law lag1logGDPexp_capita lag1logpop lag1any_conflict lag1durable mean_trust_others, re irr
xtnbreg n_events lag1stability lag1logGDPexp_capita lag1logpop lag1any_conflict lag1durable mean_trust_others, re irr


* Systemic Peace: fragility effect legit seceff secleg poleff polleg ecoeff ecoleg soceff socleg
xtnbreg n_events lag1fragility lag1logGDPexp_capita lag1logpop lag1any_conflict lag1durable mean_trust_others, re irr
xtnbreg n_events lag1effect lag1logGDPexp_capita lag1logpop lag1any_conflict lag1durable mean_trust_others, re irr
xtnbreg n_events lag1legit lag1logGDPexp_capita lag1logpop lag1any_conflict lag1durable mean_trust_others, re irr

xtnbreg n_events lag1poleff lag1logGDPexp_capita lag1logpop lag1any_conflict lag1durable mean_trust_others, re irr
xtnbreg n_events lag1polleg lag1logGDPexp_capita lag1logpop lag1any_conflict lag1durable mean_trust_others, re irr

xtnbreg n_events lag1soceff lag1logGDPexp_capita lag1logpop lag1any_conflict lag1durable mean_trust_others, re irr
xtnbreg n_events lag1socleg lag1logGDPexp_capita lag1logpop lag1any_conflict lag1durable mean_trust_others, re irr

* Variety of democracy index: electoral_democracy liberal_democracy_index participatory_democracy_index deliberative_democracy_index egalitarian_democracy_index
xtnbreg n_events lag1electoral_democracy lag1logGDPexp_capita lag1logpop lag1any_conflict lag1durable mean_trust_others, re irr
xtnbreg n_events lag1liberal_democracy lag1logGDPexp_capita lag1logpop lag1any_conflict lag1durable mean_trust_others, re irr
xtnbreg n_events lag1participatory_democracy lag1logGDPexp_capita lag1logpop lag1any_conflict lag1durable mean_trust_others, re irr
xtnbreg n_events lag1deliberative_democracy lag1logGDPexp_capita lag1logpop lag1any_conflict lag1durable mean_trust_others, re irr
xtnbreg n_events lag1egalitarian_democracy lag1logGDPexp_capita lag1logpop lag1any_conflict lag1durable mean_trust_others, re irr


* Citizen performance: mean_trust_others mean_importance_politics mean_interest_politics
xtnbreg n_events lag1effectiveness lag1logGDPexp_capita lag1logpop lag1any_conflict lag1durable mean_trust_others, re irr
xtnbreg n_events lag1effectiveness lag1logGDPexp_capita lag1logpop lag1any_conflict lag1durable mean_importance_politics, re irr
xtnbreg n_events lag1effectiveness lag1logGDPexp_capita lag1logpop lag1any_conflict lag1durable mean_interest_politics, re irr

xtnbreg n_events lag1effectiveness lag1logGDPexp_capita lag1logpop lag1any_conflict lag1durable mean_trust_others mean_importance_politics mean_interest_politics, re irr



* WDI: GINI index
xtnbreg n_events lag1effectiveness lag1logGINI_index lag1logpop lag1any_conflict lag1durable mean_trust_others, re irr

* additional variable: world development index (youth burden, urbanization)

xtnbreg n_events lag1effectiveness lag1logGDPexp_capita lag1logpop lag1any_conflict  lag1durable mean_trust_others lag1youth_burden lag1urbanization, re irr

* additional variable: ethnic hereogenity (HIEF)

xtnbreg n_events lag1effectiveness lag1logGDPexp_capita lag1logpop lag1any_conflict lag1durable mean_trust_others lag1EFindex, re irr


