
*** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***
* STATE LEGITIMACY AND TERRORISM
*** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***

clear*	
use "../../Data/Data for Modelling/GTD_polity_PENN_PRIO_WGI_WVS_2000.dta" // relative path to data from where this script is
set more off  

*-------------- generate log variables
*https://stats.stackexchange.com/questions/298/in-linear-regression-when-is-it-appropriate-to-use-the-log-of-an-independent-va
*http://econbrowser.com/archives/2014/02/use-of-logarithms-in-economics

gen logGDP_expentiture = log(GDP_expentiture)
gen logGDPexp_capita = log(GDPexp_capita)
gen logpop = log(pop)
// is this reasonable?

*-------------- generate lagged variables
gen lag1accountability = accountability[_n-1]
gen lag1corruption = corruption[_n-1]
gen lag1effectiveness = effectiveness[_n-1]
gen lag1quality = quality[_n-1]
gen lag1rule_of_law = rule_of_law[_n-1]

gen lag1logGDP_expentiture = logGDP_expentiture[_n-1]
gen lag1GDP_expentiture = GDP_expentiture[_n-1]
gen lag1logGDPexp_capita = logGDPexp_capita[_n-1]


gen lag1logpop = logpop[_n-1]
gen lag1pop = pop[_n-1]

gen lag1any_conflict = any_conflict[_n-1]

gen lag1durable = durable[_n-1]

gen lag1exrec = exrec[_n-1]
gen lag1exconst = exconst[_n-1]
gen lag1polcomp = polcomp[_n-1]

gen lag1polity2 = polity2[_n-1]


*-------------- correlation matrix
corr n_events accountability corruption effectiveness quality rule_of_law polity2

*-------------- Negative Binomial Random Effects Model with Panel Data, output as IRR
*Before using xtreg you need to set Stata to handle panel data by using the command xtset. 
xtset consolidated_country year 
// “country” represents the entities or panels (i) and “year” represents the time variable (t)
// strongly balanced)” refers to the fact that all countries have data for all years.


*EFFECTIVENESS: NBR of counts of terrorist events, 
**IV = effectiveness of governments & trust in others, effectiveness of governments & importance of politics, effectiveness of  mean_interest_politics
**controls = GDP per capita, pop, involvement in civil war and international conflict, regime stability

xtnbreg n_events lag1effectiveness lag1logGDPexp_capita lag1logpop lag1any_conflict lag1durable mean_trust_others, re irr
xtnbreg n_events lag1effectiveness lag1logGDPexp_capita lag1logpop lag1any_conflict lag1durable mean_importance_politics, re irr
xtnbreg n_events lag1effectiveness lag1logGDPexp_capita lag1logpop lag1any_conflict lag1durable mean_interest_politics, re irr

xtnbreg n_events lag1effectiveness lag1logGDPexp_capita lag1logpop lag1any_conflict lag1durable mean_trust_others mean_importance_politics mean_interest_politics, re irr


*ACCOUNTABILITY 
**IV = effectiveness of governments & trust in others, 
**controls = GDP per capita, pop, involvement in civil war and international conflict, regime stability
xtnbreg n_events lag1accountability lag1logGDPexp_capita lag1logpop lag1any_conflict lag1durable mean_trust_others, re irr

*CORRUPTION 
**IV = corruption of governments & trust in others, 
**controls = GDP per capita, pop, involvement in civil war and international conflict, regime stability
xtnbreg n_events lag1corruption lag1logGDPexp_capita lag1logpop lag1any_conflict lag1durable mean_trust_others, re irr

*QUALITY 
**IV = quality of governments & trust in others, 
**controls = GDP per capita, pop, involvement in civil war and international conflict, regime stability
xtnbreg n_events lag1quality lag1logGDPexp_capita lag1logpop lag1any_conflict lag1durable mean_trust_others, re irr

*RULE OF LAW
**IV = rule of law & trust in others, 
**controls = GDP per capita, pop, involvement in civil war and international conflict, regime stability
xtnbreg n_events lag1rule_of_law lag1logGDPexp_capita lag1logpop lag1any_conflict lag1durable mean_trust_others, re irr
		   

	
	

*-------------- Hausman test
*https://www.princeton.edu/~otorres/Panel101.pdf
xtset consolidated_country year 
xtnbreg n_events lag1accountability lag1logGDP_expentiture lag1logpop lag1any_conflict lag1durable, fe 
estimates store fixed 

xtnbreg n_events lag1accountability lag1logGDP_expentiture lag1logpop lag1any_conflict lag1durable, re 
estimates store random 

hausman fixed random
		   
	
*POLITY IV: exrec 
xtnbreg n_events lag1exrec lag1logGDP_expentiture lag1logpop lag1any_conflict lag1durable, fe irr
* n_domperp_events
xtnbreg n_domperp_events lag1exrec lag1logGDP_expentiture lag1logpop lag1any_conflict lag1durable, fe irr
* n_domtarg_events
xtnbreg n_domtarg_events lag1exrec lag1logGDP_expentiture lag1logpop lag1any_conflict lag1durable, fe irr

*POLITY IV: exconst 
xtnbreg n_events lag1exconst lag1logGDP_expentiture lag1logpop lag1any_conflict lag1durable, fe irr
* n_domperp_events
xtnbreg n_domperp_events lag1exrec lag1logGDP_expentiture lag1logpop lag1any_conflict lag1durable, fe irr
* n_domtarg_events
xtnbreg n_domtarg_events lag1exrec lag1logGDP_expentiture lag1logpop lag1any_conflict lag1durable, fe irr

*POLITY IV: polcomp
xtnbreg n_events lag1polcomp lag1logGDP_expentiture lag1logpop lag1any_conflict lag1durable, fe irr
* n_domperp_events
xtnbreg n_domperp_events lag1exrec lag1logGDP_expentiture lag1logpop lag1any_conflict lag1durable, fe irr
* n_domtarg_events
xtnbreg n_domtarg_events lag1exrec lag1logGDP_expentiture lag1logpop lag1any_conflict lag1durable, fe irr			  
			  
			  			  
/*			  
