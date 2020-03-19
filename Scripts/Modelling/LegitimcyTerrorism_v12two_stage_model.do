*** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***
* STATE LEGITIMACY AND TERRORISM: Two stage models
*** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***
sysdir set PERSONAL "../../../ados"


*** TO DO
* 1. check theory
* 2. look up current indicators
* 3. check whether new state legitimacy indicators are needed
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
foreach v of var wvs_trust wvs_polint wvs_imppol wvs_confpol wvs_confcs {
	gen lag1`v'= `v'[_n-1]
}

* generate squared variables

gen lag1vdem_partip_sqd = lag1vdem_partip*lag1vdem_partip

gen lag1fh_cl_sqd = lag1fh_cl*lag1fh_cl

gen lag1fh_pr_sqd = lag1fh_pr*lag1fh_pr


*generate dummy n_domtarg_events

generate had_domtarg_events = 0
replace had_domtarg_events = 1 if n_domtarg_events>0



*-------------- correlation matrix
corr n_events legitimacy logGDPexp_capita logpop any_conflict durable mean_trust_others mean_importance_politics accountability corruption effectiveness quality rule_of_law
corr n_events legitimacy logGDPexp_capita logpop lag1any_conflict durable mean_trust_others mean_importance_politics
corr Êwbgi_cce wbgi_gee Êwbgi_pve Êwbgi_rle Êwbgi_vae 
corr fh_pr fh_ipolity2 fh_ep fh_ppp fh_fog fh_cl 

corr vdem_dl_delib  vdem_edcomp_thick vdem_partip vdem_corr vdem_egal vdem_liberal

corr vdem_edcomp_thick vdem_partip vdem_corr vdem_egal fh_pr fh_cl


*-------------- summary statistics
generate y = uniform()
eststo: quietly regress y n_events legitimacy logGDPexp_capita logpop any_conflict durable mean_trust_others, noconstant

estadd summ : *	
esttab using "../../Findings/SummaryStataWVS.rtf", ///
	cells("mean(fmt(a2) label(Mean)) sd(fmt(a2)label(SD)) min(fmt(a2)label(Min)) max(fmt(a2)label(Max))") nodepvar nostar nonote ///
	replace compress rtf label
	eststo clear
	
	
	
	
	
*--------------  CONDITIONAL LOGIT MODEL DV n_events for accountability
*https://www3.nd.edu/~rwilliam/stats3/Panel03-FixedEffects.pdf

xtset consolidated_country year	

*accountability	
xtlogit had_domtarg_events lag1vdem_partip  lag1logGDPexp_capita lag1logpop lag1any_conflict lag1durable i.year , fe nolog	
xtlogit, or

xtset, clear
clogit had_domtarg_events lag1vdem_partip  lag1logGDPexp_capita lag1logpop lag1any_conflict lag1durable i.year, group(consolidated_country) nolog

*efficiency
xtlogit had_domtarg_events lag1vdem_corr  lag1logGDPexp_capita lag1logpop lag1any_conflict lag1durable i.year , fe nolog	

*procedural justice
xtlogit had_domtarg_events lag1vdem_liberal  lag1logGDPexp_capita lag1logpop lag1any_conflict lag1durable i.year , fe nolog	

*distributive justice
xtlogit had_domtarg_events lag1vdem_egal  lag1logGDPexp_capita lag1logpop lag1any_conflict lag1durable i.year , fe nolog	

*other relevant measures
xtlogit had_domtarg_events lag1vdem_dl_delib  lag1logGDPexp_capita lag1logpop lag1any_conflict lag1durable i.year , fe nolog	

xtlogit had_domtarg_events lag1vdem_edcomp_thick  lag1logGDPexp_capita lag1logpop lag1any_conflict lag1durable i.year , fe nolog	




*--------------  TRUNCATED POISSON DV n_events for accountability
*https://stats.idre.ucla.edu/stata/dae/zero-truncated-poisson-regression/
*https://www.ncbi.nlm.nih.gov/pmc/articles/PMC3513584/
*https://www.sciencedirect.com/science/article/pii/S0301479717312707
*https://www.stata.com/manuals13/rtpoisson.pdf
*https://www.stata.com/statalist/archive/2010-08/msg00652.html
*https://data.princeton.edu/wws509/stata/overdispersion
*https://data.library.virginia.edu/getting-started-with-hurdle-models/
*https://www.rdocumentation.org/packages/pscl/versions/1.5.2/topics/hurdle
*https://en.wikipedia.org/wiki/Zero-truncated_Poisson_distribution

*https://www.princeton.edu/~otorres/Panel101.pdf



*accountability	
xtpoisson n_domtarg_events lag1vdem_partip  lag1logGDPexp_capita lag1logpop lag1any_conflict lag1durable i.year , fe nolog	
tpoisson n_domtarg_events lag1vdem_partip  lag1logGDPexp_capita lag1logpop lag1any_conflict lag1durable i.year i.consolidated_country if n_domtarg_events>0, ll(0) vce(robust) 
tpoisson n_domtarg_events lag1vdem_partip  lag1logGDPexp_capita lag1logpop lag1any_conflict lag1durable i.year if n_domtarg_events>0, ll(0) cluster(consolidated_country) 

tpoisson n_domtarg_events lag1vdem_egal  lag1logGDPexp_capita lag1logpop lag1any_conflict lag1durable i.year if n_domtarg_events>0, ll(0) cluster(consolidated_country) 
	
xtdhpoisson had_events lag1vdem_partip  lag1logGDPexp_capita lag1logpop lag1any_conflict lag1durable i.year , fe nolog	
	
	
xi: tpoisson n_domtarg_events lag1vdem_partip  lag1logGDPexp_capita lag1logpop lag1any_conflict lag1durable i.consolidated_country i.year if n_domtarg_events>0
	
	
	
	
	
	
	






