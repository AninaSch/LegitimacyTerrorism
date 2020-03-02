
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

foreach v of var accountability corruption effectiveness quality rule_of_law stability legitimacy {
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

foreach v of var GINI_index logGINI_index youth_burden urbanization {
	gen lag1`v'= `v'[_n-1]
}
foreach v of var any_conflict durable exrec exconst polcomp polity2 {
	gen lag1`v'= `v'[_n-1]
}
gen lag1EFindex = EFindex[_n-1]



*-------------- correlation matrix
corr n_events legitimacy logGDPexp_capita logpop any_conflict durable mean_trust_others mean_importance_politics accountability corruption effectiveness quality rule_of_law

corr n_events legitimacy logGDPexp_capita logpop lag1any_conflict durable mean_trust_others mean_importance_politics




*-------------- summary statistics
generate y = uniform()
eststo: quietly regress y n_events legitimacy logGDPexp_capita logpop any_conflict durable mean_trust_others mean_importance_politics, noconstant

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

xtnbreg n_events lag1legitimacy lag1logGDPexp_capita lag1logpop lag1any_conflict lag1durable mean_trust_others, re irr

/*
* Systemic Peace: fragility effect legit seceff secleg poleff polleg ecoeff ecoleg soceff socleg
xtnbreg n_events lag1effect lag1logGDPexp_capita lag1logpop lag1any_conflict lag1durable mean_trust_others, re irr
xtnbreg n_events lag1legit lag1logGDPexp_capita lag1logpop lag1any_conflict lag1durable mean_trust_others, re irr

xtnbreg n_events lag1poleff lag1logGDPexp_capita lag1logpop lag1any_conflict lag1durable mean_trust_others, re irr
xtnbreg n_events lag1polleg lag1logGDPexp_capita lag1logpop lag1any_conflict lag1durable mean_trust_others, re irr

xtnbreg n_events lag1soceff lag1logGDPexp_capita lag1logpop lag1any_conflict lag1durable mean_trust_others, re irr
xtnbreg n_events lag1socleg lag1logGDPexp_capita lag1logpop lag1any_conflict lag1durable mean_trust_others, re irr

xtnbreg n_events lag1seceff lag1logGDPexp_capita lag1logpop lag1any_conflict lag1durable mean_trust_others, re irr
xtnbreg n_events lag1secleg lag1logGDPexp_capita lag1logpop lag1any_conflict lag1durable mean_trust_others, re irr
*/


* Citizen performance: mean_trust_others mean_importance_politics mean_interest_politics
xtnbreg n_events lag1legitimacy lag1logGDPexp_capita lag1logpop lag1any_conflict lag1durable mean_trust_others, re irr
xtnbreg n_events lag1legitimacy lag1logGDPexp_capita lag1logpop lag1any_conflict lag1durable mean_importance_politics, re irr


* FINAL RANDOM INTERCEPT
xtnbreg n_events lag1legitimacy lag1logGDPexp_capita lag1logpop lag1any_conflict lag1durable mean_trust_others mean_importance_politics, re irr 

xtnbreg n_events lag1legitimacy  lag1logpop lag1any_conflict lag1durable mean_trust_others mean_importance_politics, re irr 



*FINAL RANDOM SLOPE
*https://data.princeton.edu/pop510/pop510handouts.pdf
* https://www.stata.com/manuals13/memenbreg.pdf
menbreg n_events lag1legitimacy lag1logGDPexp_capita lag1logpop lag1any_conflict lag1durable mean_trust_others   ||  consolidated_country: lag1legitimacy , irr
menbreg n_events lag1legitimacy lag1logGDPexp_capita lag1logpop lag1any_conflict lag1durable mean_importance_politics   ||  consolidated_country: lag1legitimacy , irr
menbreg n_events lag1legitimacy lag1logGDPexp_capita lag1logpop lag1any_conflict lag1durable mean_interest_politics   ||  consolidated_country: lag1legitimacy , irr

menbreg n_events lag1legitimacy lag1logGDPexp_capita lag1logpop lag1any_conflict lag1durable mean_trust_others  mean_importance_politics ||  consolidated_country: lag1legitimacy, irr



* HYBRID MODEL
*https://statisticalhorizons.com/fe-nbreg
*https://www3.nd.edu/~rwilliam/Taiwan2018/Hybrid.pdf
*https://www.stata-journal.com/article.html?article=st0283

*http://fmwww.bc.edu/repec/msug2010/mex10sug_trivedi.pdf

*• Within each group, calculate the mean for each independent time-varying variable (the xij variables, or level 1 variables). The means will represent the between-group differences (i.e. group means will differ between clusters but not within them).
*• Then, again within each group, subtract the mean for the group from each time-varying variable. These deviations from the group mean will represent the within-group variability.
*• Estimate an RE (not FE) model that includes both the means of the variables and the difference-from-the-means variables.
*• Unlike a regular FE model, you can also include time-invariant/level 2 variables) variables (the ci variables) like gender and estimate their effects.
*https://www.stata-journal.com/article.html?article=st0468

* calculate mean and deviance from mean for family(binomial) link(logit) clusterid(id) star

tab year, gen(yr)

gen mysample = !missing(n_events, lag1legitimacy, lag1logGDPexp_capita, lag1logpop, lag1any_conflict, lag1durable, mean_trust_others,  mean_importance_politics, yr2-yr18, consolidated_country)

foreach var of varlist lag1legitimacy lag1logGDPexp_capita lag1logpop lag1any_conflict lag1durable yr2-yr18 {
       egen m`var' = mean(`var') if mysample, by (consolidated_country)
}

foreach var of varlist lag1legitimacy lag1logGDPexp_capita lag1logpop lag1any_conflict lag1durable yr2-yr18  {
 gen d`var' = `var' - m`var' if mysample
}

foreach var of varlist  lag1seceff lag1secleg lag1poleff lag1polleg lag1ecoeff lag1ecoleg lag1soceff lag1socleg { 
       egen m`var' = mean(`var') if mysample, by (consolidated_country)
}

foreach var of varlist lag1seceff lag1secleg lag1poleff lag1polleg lag1ecoeff lag1ecoleg lag1soceff lag1socleg  {
 gen d`var' = `var' - m`var' if mysample
}



xtset consolidated_country year 


xtnbreg n_events lag1legitimacy lag1logGDPexp_capita lag1logpop lag1any_conflict lag1durable mean_trust_others , re irr 

xtnbreg n_events dlag1legitimacy - dlag1durable mlag1legitimacy - mlag1durable mean_trust_others , re irr 

xtnbreg n_events  dlag1logGDPexp_capita - dlag1durable  mlag1logGDPexp_capita - mlag1durable mean_trust_others , re irr 



menbreg n_events dlag1legitimacy - dlag1durable mlag1legitimacy - mlag1durable mean_trust_others  mean_importance_politics  ||  consolidated_country: lag1legitimacy, irr 
menbreg n_events dlag1legitimacy dlag1logGDPexp_capita dlag1logpop dlag1durable mlag1legitimacy mlag1logGDPexp_capita mlag1logpop mlag1durable mean_trust_others mean_importance_politics  ||  consolidated_country: lag1legitimacy, irr cov() vce() 


*mean_trust_others  mean_importance_politics
menbreg n_events dlag1legitimacy - dlag1durable mlag1legitimacy - mlag1durable   ||  consolidated_country: mean_trust_others mean_importance_politics, irr 

menbreg n_events dlag1legitimacy - dlag1durable mlag1legitimacy - mlag1durable  mean_trust_others  ||  consolidated_country:  , irr 



*cov(ind) vce(robust) ml pw(bsw) pwscale(effective)

* additional variable: ethnic hereogenity (HIEF)
*xtnbreg n_events lag1legitimacy lag1logGDPexp_capita lag1logpop lag1any_conflict  lag1durable mean_trust_others mean_importance_politics lag1EFindex, re irr

**menbreg n_events dlag1legitimacy dlag1logGDPexp_capita dlag1logpop dlag1durable mlag1legitimacy mlag1logGDPexp_capita mlag1logpop mlag1durable mean_trust_others mean_importance_politics lag1EFindex ||  consolidated_country: lag1legitimacy, irr cov() vce() 


* GINI index instead of GDP per capita
*xtnbreg n_events lag1legitimacy lag1GINI_index lag1logpop lag1any_conflict lag1durable mean_trust_others mean_importance_politics, re irr

menbreg n_events dlag1legitimacy lag1GINI_index dlag1logpop dlag1durable mlag1legitimacy mlag1logGDPexp_capita mlag1logpop mlag1durable mean_trust_others mean_importance_politics  ||  consolidated_country: lag1legitimacy, irr cov() vce() 


