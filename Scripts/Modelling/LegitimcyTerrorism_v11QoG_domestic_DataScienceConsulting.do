*** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***
* STATE LEGITIMACY AND TERRORISM: Negative Binomial Hybrid model
*** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***
sysdir set PERSONAL "../../../ados"


*** OPEN QUESTIONS


*1. LEGITIMACY MEASURES

* --> Freedom of house civil and political liberties
****** --> no variation of index for some countries, problem?

* -->  squared legitimacy measures ?

* --> Take all legitimacy measures together in a combined analysis ?



*2.  HYBRID MODEL

* --> incidental parameter bias?
*http://methods.johndavidpoe.com/2016/11/18/incidental-parameters-bias/
*https://www.statalist.org/forums/forum/general-stata-discussion/general/1323497-choosing-between-xtnbreg-fe-bootstrap-and-xtpoisson-fe-cluster-robust

* -->  how robus are analyses with negative binomial regression

* -->  do not look at individual level parameters


*3.  ADDITIONAL CONTROLS 
* --> do I have to control for ethnic, religious fractionalization in panel?

*4.  WHY DO I FIND EFFECTS IN TIME-SERIES BUT NOT IN CROSS SECTIONAL?




*** TO DO
* 1. check theory
* 2. look up current indicators
* 3. check whether new state legitimacy indicators are needed
* 4. compare with literature

clear*	
use "../../Data/Data for Modelling/LEGTER_ts_recode.dta" // relative path to data from where this script is
set more off  

*-------------- correlation matrix
corr n_events legitimacy logGDPexp_capita logpop any_conflict durable mean_trust_others mean_importance_politics accountability corruption effectiveness quality rule_of_law
corr n_events legitimacy logGDPexp_capita logpop lag1any_conflict durable mean_trust_others mean_importance_politics
corr  wbgi_cce wbgi_gee  wbgi_pve  wbgi_rle  wbgi_vae 
corr fh_pr fh_ipolity2 fh_ep fh_ppp fh_fog fh_cl 

corr vdem_dl_delib  vdem_edcomp_thick vdem_partip vdem_corr vdem_egal vdem_liberal

corr vdem_edcomp_thick vdem_partip vdem_corr vdem_egal fh_pr fh_cl


*--------------  FIXED EFFECTS MODEL WITH DV N_EVENTS
xtset consolidated_country year // Before using xtreg you need to set Stata to handle panel data by using the command xtset. 
// “country” represents the entities or panels (i) and “year” represents the time variable (t)
// strongly balanced)” refers to the fact that all countries have data for all years.



*** ACCOUNTABILITY
xtnbreg n_domtarg_events lag1vdem_partip  lag1logGDPexp_capita lag1logpop lag1any_conflict lag1durable i.year , fe irr 
est store A

xtnbreg n_domtarg_events lag1fh_pr lag1logGDPexp_capita lag1logpop lag1any_conflict lag1durable i.year , fe irr 
xtnbreg n_domtarg_events lag1fh_pr lag1fh_pr_sqd lag1logGDPexp_capita lag1logpop lag1any_conflict lag1durable i.year , fe irr 

*** EFFICIENCY
xtnbreg n_domtarg_events lag1vdem_corr lag1logGDPexp_capita lag1logpop lag1any_conflict lag1durable i.year , fe irr 
est store B

*** FAIRNESS (PROCEDURAL)
xtnbreg n_domtarg_events lag1vdem_liberal lag1logGDPexp_capita lag1logpop lag1any_conflict lag1durable i.year , fe irr 
est store C

xtnbreg n_domtarg_events lag1fh_cl lag1fh_cl_sqd lag1logGDPexp_capita lag1logpop lag1any_conflict lag1durable i.year , fe irr 
xtnbreg n_domtarg_events lag1fh_rol lag1logGDPexp_capita lag1logpop lag1any_conflict lag1durable i.year , fe irr 
xtnbreg n_events lag1vdem_dl_delib   lag1logGDPexp_capita lag1logpop lag1any_conflict lag1durable i.year , fe irr 

*** FAIRNESS (DISTRIBUTIVE)
xtnbreg n_domtarg_events lag1vdem_egal lag1logGDPexp_capita lag1logpop lag1any_conflict lag1durable i.year , fe irr 
est store D

*** COMBINED ANALYSIS
xtnbreg n_domtarg_events lag1vdem_partip lag1vdem_corr lag1vdem_liberal lag1vdem_egal lag1logGDPexp_capita lag1logpop lag1any_conflict lag1durable i.year , fe irr 

corr lag1vdem_partip lag1vdem_corr lag1vdem_liberal lag1vdem_egal



*--------------  WORLD VALUE SURVEY - HYBRID ANALYSIS WITH MANUAL CALCULATION
* Within each group, calculate the mean for each independent time-varying variable (the xij variables, or level 1 variables). The means will represent the between-group differences (i.e. group means will differ between clusters but not within them).
* Then, again within each group, subtract the mean for the group from each time-varying variable. These deviations from the group mean will represent the within-group variability.


tab year, gen(yr)

gen mysample = !missing(n_domtarg_events, lag1vdem_egal,  lag1logGDPexp_capita, lag1logpop, lag1any_conflict, lag1durable, consolidated_country, yr1-yr18, mean_trust_others)

foreach var of varlist lag1vdem_egal lag1logGDPexp_capita lag1logpop lag1any_conflict lag1durable yr1-yr18 {
       egen m`var' = mean(`var') if mysample, by (consolidated_country)
}
foreach var of varlist lag1vdem_egal lag1logGDPexp_capita lag1logpop lag1any_conflict lag1durable yr1-yr18 {
 gen d`var' = `var' - m`var' if mysample
}





xtset consolidated_country year // Before using xtreg you need to set Stata to handle panel data by using the command xtset. 



xtpoisson n_domtarg_events lag1vdem_egal lag1logGDPexp_capita lag1logpop lag1any_conflict lag1durable i.year mean_trust_others, fe 

xthybrid n_domtarg_events mean_trust_others, use(lag1vdem_egal lag1logGDPexp_capita lag1logpop lag1any_conflict lag1durable yr2-yr18) family(poisson) link(logit) clusterid(consolidated_country) star		

xtpoisson n_domtarg_events dlag1vdem_egal - dlag1durable ///
	mlag1vdem_egal- mlag1durable ///
	 i.year, re  


xtnbreg n_domtarg_events lag1vdem_egal lag1logGDPexp_capita lag1logpop lag1any_conflict lag1durable i.year mean_trust_others, fe 

xthybrid n_domtarg_events mean_trust_others, use(lag1vdem_egal lag1logGDPexp_capita lag1logpop lag1any_conflict lag1durable yr2-yr18) family(nbinomial) link(log) clusterid(consolidated_country) star		

xtnbreg n_domtarg_events dlag1vdem_egal - dlag1durable ///
	mlag1vdem_egal- mlag1durable ///
	mean_trust_others i.year, re  


		
	
*--------------  FIXED EFFECTS MODEL WITH DV TERRORISM INDEX
*** accountability
xtreg voh_gti lag1vdem_partip  lag1logGDPexp_capita lag1logpop lag1any_conflict lag1durable i.year , fe  


*--------------  ADDITIONAL CONTROLS
*** accountability
xtnbreg n_domtarg_events lag1vdem_partip lag1logGDPexp_capita lag1logpop lag1any_conflict lag1durable i.year polleg, fe irr 
xtnbreg n_domtarg_events lag1vdem_partip lag1logGDPexp_capita lag1logpop lag1any_conflict lag1durable i.year ecoleg, fe irr 
xtnbreg n_domtarg_events lag1vdem_partip lag1logGDPexp_capita lag1logpop lag1any_conflict lag1durable i.year socleg, fe irr 








