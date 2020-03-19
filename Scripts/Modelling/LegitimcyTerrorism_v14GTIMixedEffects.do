*** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***
* STATE LEGITIMACY AND TERRORISM: Negative Binomial Fixed Effect
*** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***
sysdir set PERSONAL "../../../ados"

*https://www.stata.com/support/faqs/statistics/between-estimator/
*https://www.stata.com/features/overview/linear-fixed-and-random-effects-models/
*https://www.statalist.org/forums/forum/general-stata-discussion/general/1431557-negative-binomial-fixed-effects-model-with-panel-data-several-options

*https://www.statalist.org/forums/forum/general-stata-discussion/general/1376936-testing-whether-to-include-a-squared-term

* INCIDENTAL PARAMETER BIAS
*http://methods.johndavidpoe.com/2016/11/18/incidental-parameters-bias/

* WHY DO I FIND EFFECTS IN TIME-SERIES BUT NOT IN CROSS SECTIONAL?

*** TO DO
* 4. compare with literature

clear*	
use "../../Data/Data for Modelling/LEGTER_ts.dta" // relative path to data from where this script is
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

*accountability
foreach v of var wbgi_vae fh_pr fh_ipolity2 fh_ep fh_ppp fh_fog vdem_dl_delib  vdem_edcomp_thick vdem_partip vdem_partipdem cpds_vt ideavt_legvt ideavt_presvt {
	gen lag1`v'= `v'[_n-1]
}
* efficiency
foreach v of var wbgi_gee wbgi_cce bci_bci vdem_corr tax_revenue {
	gen lag1`v'= `v'[_n-1]
}
*fairness (procedural)
foreach v of var wbgi_rle fh_cl  fh_feb fh_aor fh_rol fh_pair vdem_liberal vdem_libdem   {
	gen lag1`v'= `v'[_n-1]
}
*fairness (distributive)
foreach v of var vdem_egal vdem_egaldem  nonviolent_protests violent_protests politcal_relaxations {
	gen lag1`v'= `v'[_n-1]
}
*world value survey
foreach v of var wvs_trust wvs_polint wvs_imppol wvs_confpol wvs_confcs wvs_confjs wvs_imprel {
	gen lag1`v'= `v'[_n-1]
}
* generate squared variables

gen lag1vdem_partip_sqd = lag1vdem_partip*lag1vdem_partip
gen lag1fh_cl_sqd = lag1fh_cl*lag1fh_cl
gen lag1fh_pr_sqd = lag1fh_pr*lag1fh_pr

*generate dummy n_domtarg_events

generate had_domtarg_events = 0
replace had_domtarg_events = 1 if n_domtarg_events>0

*generate dummies for years

*tab year, gen(yr)
*tab consolidated_country, gen(ctry)

*save  "../../Data/Data for Modelling/LEGTER_ts_recode.dta", replace

	
*--------------  FIXED EFFECTS MODEL WITH DV GLOBAL TERRORISM INDEX
*https://en.wikipedia.org/wiki/Global_Terrorism_Index
/*The Global Terrorism Index (GTI) is a comprehensive study which accounts for the direct and indirect
impact of terrorism in 162 countries in terms of its effect on lives lost, injuries, property damage and
the psychological after-effects of terrorism. This study covers 99.6 per cent of the world's population.
It aggregates the most authoritative data source on terrorism today, the Global Terrorism Database
(GTD) collated by the National Consortium for the Study of Terrorism and Responses to Terrorism
(START) into a composite score in order to provide an ordinal ranking of nations on the negative
impact of terrorism. The GTD is unique in that it consists of systematically and comprehensively
coded data on domestic as well as international terrorist incidents and now includes more than 140,000
cases.*/


*** accountability
xtset consolidated_country year 
xtreg voh_gti lag1vdem_partip  lag1logGDPexp_capita lag1logpop lag1any_conflict lag1durable i.year , fe  

*** efficiency
xtreg voh_gti lag1vdem_corr lag1logGDPexp_capita lag1logpop lag1any_conflict lag1durable i.year , fe  

*** fairness (procedural)
xtreg voh_gti lag1vdem_liberal lag1logGDPexp_capita lag1logpop lag1any_conflict lag1durable i.year , fe  

*** fairness (distributive)
xtreg voh_gti lag1vdem_egal lag1logGDPexp_capita lag1logpop lag1any_conflict lag1durable i.year , fe  


* aggregated individual-level variables
* wvs_confpar wvs_confpol wvs_confpr wvs_confun wvs_imppol wvs_imprel wvs_polint wvs_satlif wvs_trust wvs_confjs

xtset consolidated_country year 

xtreg voh_gti lag1wvs_trust lag1logGDPexp_capita lag1logpop lag1any_conflict lag1durable i.year , fe  

xtreg voh_gti lag1wvs_confpol lag1logGDPexp_capita lag1logpop lag1any_conflict lag1durable i.year , fe  

xtreg voh_gti lag1wvs_confjs lag1logGDPexp_capita lag1logpop lag1any_conflict lag1durable i.year , fe  

xtreg voh_gti lag1wvs_imppol lag1logGDPexp_capita lag1logpop lag1any_conflict lag1durable i.year , fe  

xtreg voh_gti lag1wvs_imprel lag1logGDPexp_capita lag1logpop lag1any_conflict lag1durable i.year , fe  


*--------------  MIXED EFFECTS MODEL WITH DV GLOBAL TERRORISM INDEX

tab year, gen(yr)

gen mysample = !missing(voh_gti, lag1vdem_partip, lag1vdem_corr, lag1vdem_liberal, lag1vdem_egal,  lag1logGDPexp_capita, lag1logpop, lag1any_conflict, lag1durable, consolidated_country, yr1-yr18, mean_trust_others)

foreach var of varlist lag1vdem_partip lag1vdem_corr lag1vdem_liberal lag1vdem_egal lag1logGDPexp_capita lag1logpop lag1any_conflict lag1durable yr1-yr18 {
       egen m`var' = mean(`var') if mysample, by (consolidated_country)
}
foreach var of varlist lag1vdem_partip lag1vdem_corr lag1vdem_liberal lag1vdem_egal lag1logGDPexp_capita lag1logpop lag1any_conflict lag1durable yr1-yr18 {
 gen d`var' = `var' - m`var' if mysample
}


xtset consolidated_country year // Before using xtreg you need to set Stata to handle panel data by using the command xtset. 

xtreg voh_gti dlag1vdem_partip - dyr18 ///
	mlag1vdem_partip- myr18 ///
	mean_trust_others, re  
	
xtreg voh_gti dlag1vdem_partip - dyr18 ///
	mlag1vdem_partip- myr18 ///
	mean_importance_politics, re  

xtreg voh_gti dlag1vdem_partip - dyr18 ///
	mlag1vdem_partip- myr18 ///
	mean_interest_politics, re  	
	
xthybrid voh_gti mean_trust_others, use(lag1vdem_egal lag1logGDPexp_capita lag1logpop lag1any_conflict lag1durable yr2-yr18) family(gaussian) link(identity) clusterid(lag1logpop) star		
* no observation ?
 

*terrorism and varieties of civil liberties

*https://www.sciencedirect.com/science/article/pii/S0378437117303357
*https://www.tandfonline.com/doi/abs/10.1080/09546553.2014.985378
*https://scholarworks.waldenu.edu/dissertations/7288/
*https://repository.library.georgetown.edu/handle/10822/558610
*https://www.jstor.org/stable/20031706?seq=1

*https://papers.ssrn.com/sol3/papers.cfm?abstract_id=3361330







