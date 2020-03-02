*** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***
* STATE LEGITIMACY AND TERRORISM: Negative Binomial Hybrid model
*** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***
sysdir set PERSONAL "../../../ados"

*DECISIONS

* log number of events
*	-> NO
* level of events (multinomial, low- middle and high events)
* -> NO
* logit model
* ->  NO
* i.year ? 
* -> YES
* mean_trust_others as a time-variant model
* -> NO



*- RE COMPARED TO HYBRID MODEL: 
	*- why is trust significant in RE and not in HYBRID?
	*- include a random slope?
	

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


*https://www.stata.com/statalist/archive/2013-08/msg00132.html
*sysuse auto

*-------------- generate split variable on median for logGDPexp_capita
su logGDPexp_capita, detail
gen byte mysplit = cond(missing(logGDPexp_capita), ., (logGDPexp_capita >= r(p50)))
*Mysplit is equal to 1 if the median value of weight is equal or above the p50

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
eststo: quietly regress y n_events legitimacy logGDPexp_capita logpop any_conflict durable mean_trust_others, noconstant

estadd summ : *	
esttab using "../../Findings/SummaryStataWVS.rtf", ///
	cells("mean(fmt(a2) label(Mean)) sd(fmt(a2)label(SD)) min(fmt(a2)label(Min)) max(fmt(a2)label(Max))") nodepvar nostar nonote ///
	replace compress rtf label
	eststo clear

*--------------  calculate mean and deviations from mean
* Within each group, calculate the mean for each independent time-varying variable (the xij variables, or level 1 variables). The means will represent the between-group differences (i.e. group means will differ between clusters but not within them).
* Then, again within each group, subtract the mean for the group from each time-varying variable. These deviations from the group mean will represent the within-group variability.

gen mysample = !missing(n_events, lag1legitimacy, lag1logGDPexp_capita, lag1logpop, lag1any_conflict, lag1durable, consolidated_country)

foreach var of varlist lag1legitimacy lag1logGDPexp_capita lag1logpop lag1any_conflict lag1durable {
       egen m`var' = mean(`var') if mysample, by (consolidated_country)
}
foreach var of varlist lag1legitimacy lag1logGDPexp_capita lag1logpop lag1any_conflict lag1durable {
 gen d`var' = `var' - m`var' if mysample
}
foreach var of varlist  lag1seceff lag1secleg lag1poleff lag1polleg lag1ecoeff lag1ecoleg lag1soceff lag1socleg { 
       egen m`var' = mean(`var') if mysample, by (consolidated_country)
}
foreach var of varlist lag1seceff lag1secleg lag1poleff lag1polleg lag1ecoeff lag1ecoleg lag1soceff lag1socleg  {
 gen d`var' = `var' - m`var' if mysample
}


*--------------  FIXED EFFECTS MODEL WITH DV N_EVENTS
xtset consolidated_country year // Before using xtreg you need to set Stata to handle panel data by using the command xtset. 
// “country” represents the entities or panels (i) and “year” represents the time variable (t)
// strongly balanced)” refers to the fact that all countries have data for all years.


xtnbreg n_events lag1legitimacy lag1logGDPexp_capita lag1logpop lag1any_conflict lag1durable , fe irr 


xtnbreg n_events lag1legitimacy lag1logGDPexp_capita lag1logpop lag1any_conflict lag1durable  i.year, fe irr 

xtnbreg n_events lag1legitimacy lag1logGDPexp_capita lag1logpop lag1any_conflict lag1durable  i.year, fe irr 
xtlogit n_events lag1legitimacy lag1logGDPexp_capita lag1logpop lag1any_conflict lag1durable  i.year, fe  


xtnbreg n_events lag1accountability lag1logGDPexp_capita lag1logpop lag1any_conflict lag1durable  i.year, fe irr 
xtnbreg n_events lag1corruption lag1logGDPexp_capita lag1logpop lag1any_conflict lag1durable  i.year, fe irr 
xtnbreg n_events lag1effectiveness lag1logGDPexp_capita lag1logpop lag1any_conflict lag1durable  i.year, fe irr 
xtnbreg n_events lag1quality lag1logGDPexp_capita lag1logpop lag1any_conflict lag1durable  i.year, fe irr 
xtnbreg n_events lag1rule_of_law lag1logGDPexp_capita lag1logpop lag1any_conflict lag1durable  i.year, fe irr 
xtnbreg n_events lag1polleg lag1logGDPexp_capita lag1logpop lag1any_conflict lag1durable  i.year, fe irr 





*--------------  RANDOM EFFECTS MODEL WITH DV N_EVENTS
xtset consolidated_country year // Before using xtreg you need to set Stata to handle panel data by using the command xtset. 
// “country” represents the entities or panels (i) and “year” represents the time variable (t)
// strongly balanced)” refers to the fact that all countries have data for all years.

xtnbreg n_events lag1legitimacy lag1logGDPexp_capita lag1logpop lag1any_conflict lag1durable mean_trust_others , re irr 

*--------------  HYBRID MODEL WITH DV N_EVENTS
*• Estimate an RE (not FE) model that includes both the means of the variables and the difference-from-the-means variables.
*• Unlike a regular FE model, you can also include time-invariant/level 2 variables) variables (the ci variables) like gender and estimate their effects.
* calculate mean and deviance from mean for family(binomial) link(logit) clusterid(id) star

xtset consolidated_country year
xtnbreg n_events dlag1legitimacy  dlag1logGDPexp_capita dlag1logpop dlag1any_conflict dlag1durable ///
	mlag1legitimacy mlag1logGDPexp_capita mlag1logpop mlag1any_conflict mlag1durable ///
	mean_trust_others i.year, re irr 
	
	
xtnbreg n_events dlag1legitimacy dlag1logGDPexp_capita dlag1logpop dlag1any_conflict dlag1durable ///
	mlag1legitimacy mlag1logGDPexp_capita mlag1logpop mlag1any_conflict mlag1durable, re irr 	
	
xtset consolidated_country year
xtnbreg n_events lag1legitimacy lag1logGDPexp_capita lag1logpop lag1any_conflict lag1durable,  fe irr 
	
	
* interpretation of mean trust?	

*--------------  HYBRID MODEL WITH DV N_EVENTS AND RANDOM SLOPE
xtset consolidated_country year
menbreg n_events dlag1legitimacy dlag1logGDPexp_capita dlag1logpop dlag1any_conflict dlag1durable ///
	mlag1legitimacy mlag1logGDPexp_capita mlag1logpop mlag1any_conflict mlag1durable ///
	mean_trust_others||  consolidated_country: mean_trust_others,  irr 
	

*--------------  HYBRID MODEL WITH DV N_DOMTARGET EVENTS 
xtset consolidated_country year
xtnbreg n_domtarg_events dlag1legitimacy dlag1logGDPexp_capita dlag1logpop dlag1any_conflict dlag1durable ///
	mlag1legitimacy mlag1logGDPexp_capita mlag1logpop mlag1any_conflict mlag1durable ///
	mean_trust_others, re irr 


*--------------  LINKS

*https://statisticalhorizons.com/fe-nbreg
*https://www3.nd.edu/~rwilliam/Taiwan2018/Hybrid.pdf
*https://www.stata-journal.com/article.html?article=st0283

*http://fmwww.bc.edu/repec/msug2010/mex10sug_trivedi.pdf

*https://www.stata-journal.com/article.html?article=st0468

