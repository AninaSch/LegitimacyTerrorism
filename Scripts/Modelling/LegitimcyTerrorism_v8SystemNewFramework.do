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


*** SYSTEM LEVEL LEGITIMACY
* accountability
* fairness
* efficiency
* --> check definitions from paper

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
foreach v of var wbgi_vae fh_pr fh_ipolity2 fh_ep fh_ppp fh_fog vdem_dl_delib  vdem_edcomp_thick vdem_partip cpds_vt ideavt_legvt ideavt_presvt {
	gen lag1`v'= `v'[_n-1]
}

* efficiency
foreach v of var wbgi_gee wbgi_cce bci_bci vdem_corr tax_revenue {
	gen lag1`v'= `v'[_n-1]
}

*fairness (procedural)
foreach v of var wbgi_rle fh_cl  fh_feb fh_aor fh_rol fh_pair  {
	gen lag1`v'= `v'[_n-1]
}

*fairness (distributive)
foreach v of var vdem_egal nonviolent_protests violent_protests politcal_relaxations {
	gen lag1`v'= `v'[_n-1]
}


foreach v of var wvs_trust wvs_polint wvs_imppol wvs_confpol wvs_confcs {
	gen lag1`v'= `v'[_n-1]
}

*-------------- correlation matrix
corr n_events legitimacy logGDPexp_capita logpop any_conflict durable mean_trust_others mean_importance_politics accountability corruption effectiveness quality rule_of_law
corr n_events legitimacy logGDPexp_capita logpop lag1any_conflict durable mean_trust_others mean_importance_politics
corr  wbgi_cce wbgi_gee  wbgi_pve  wbgi_rle  wbgi_vae 
corr fh_pr fh_ipolity2 fh_ep fh_ppp fh_fog fh_cl 
corr vdem_dl_delib  vdem_edcomp_thick vdem_partip vdem_corr vdem_egal

*-------------- summary statistics
generate y = uniform()
eststo: quietly regress y n_events legitimacy logGDPexp_capita logpop any_conflict durable mean_trust_others, noconstant

estadd summ : *	
esttab using "../../Findings/SummaryStataWVS.rtf", ///
	cells("mean(fmt(a2) label(Mean)) sd(fmt(a2)label(SD)) min(fmt(a2)label(Min)) max(fmt(a2)label(Max))") nodepvar nostar nonote ///
	replace compress rtf label
	eststo clear

*--------------  FIXED EFFECTS MODEL WITH DV N_EVENTS
xtset consolidated_country year // Before using xtreg you need to set Stata to handle panel data by using the command xtset. 
// “country” represents the entities or panels (i) and “year” represents the time variable (t)
// strongly balanced)” refers to the fact that all countries have data for all years.

*** ACCOUNTABILITY
xtnbreg n_events lag1wbgi_vae lag1logGDPexp_capita lag1logpop lag1any_conflict lag1durable i.year , fe irr 

xtnbreg n_events lag1fh_pr lag1logGDPexp_capita lag1logpop lag1any_conflict lag1durable i.year , fe irr 

xtnbreg n_events lag1fh_ipolity2 lag1logGDPexp_capita lag1logpop lag1any_conflict lag1durable i.year , fe irr 

xtnbreg n_events lag1vdem_edcomp_thick lag1logGDPexp_capita lag1logpop lag1any_conflict lag1durable i.year , fe irr 
xtnbreg n_events lag1vdem_partip lag1logGDPexp_capita lag1logpop lag1any_conflict lag1durable i.year , fe irr 
xtnbreg n_events lag1vdem_dl_delib   lag1logGDPexp_capita lag1logpop lag1any_conflict lag1durable i.year , fe irr 

xtnbreg n_events lag1ideavt_presvt lag1logGDPexp_capita lag1logpop lag1any_conflict lag1durable i.year , fe irr 
xtnbreg n_events lag1ideavt_legvt lag1logGDPexp_capita lag1logpop lag1any_conflict lag1durable i.year , fe irr 

*** EFFICIENCY
xtnbreg n_events lag1wbgi_gee lag1logGDPexp_capita lag1logpop lag1any_conflict lag1durable i.year , fe irr 
xtnbreg n_events lag1wbgi_cce lag1logGDPexp_capita lag1logpop lag1any_conflict lag1durable i.year , fe irr 

xtnbreg n_events lag1vdem_corr lag1logGDPexp_capita lag1logpop lag1any_conflict lag1durable i.year , fe irr 

xtnbreg n_events lag1tax_revenue lag1logGDPexp_capita lag1logpop lag1any_conflict lag1durable i.year , fe irr 


*** FAIRNESS (PROCEDURAL)
xtnbreg n_events lag1wbgi_rle lag1logGDPexp_capita lag1logpop lag1any_conflict lag1durable i.year , fe irr 

xtnbreg n_events lag1fh_cl lag1logGDPexp_capita lag1logpop lag1any_conflict lag1durable i.year , fe irr 


*** FAIRNESS (DISTRIBUTIVE)
xtnbreg n_events lag1vdem_egal lag1logGDPexp_capita lag1logpop lag1any_conflict lag1durable i.year , fe irr 

xtnbreg n_events lag1violent_protests lag1logGDPexp_capita lag1logpop lag1any_conflict lag1durable i.year , fe irr 


*--------------  FIXED EFFECTS MODEL WITH DV TERRORISM INDEX
*** accountability
xtreg voh_gti lag1fh_pr lag1logGDPexp_capita lag1logpop lag1any_conflict lag1durable i.year, fe

*** efficiency
xtreg voh_gti lag1vdem_corr lag1logGDPexp_capita lag1logpop lag1any_conflict lag1durable i.year, fe 

*** fairness (procedural)
xtreg voh_gti lag1fh_cl lag1logGDPexp_capita lag1logpop lag1any_conflict lag1durable i.year, fe  

*** fairness (distributive)
xtreg voh_gti lag1vdem_egal lag1logGDPexp_capita lag1logpop lag1any_conflict lag1durable i.year, fe 


*--------------  ADDITIONAL CONTROLS
*** accountability
xtnbreg n_events lag1fh_pr lag1logGDPexp_capita lag1logpop lag1any_conflict lag1durable i.year polleg, fe irr 
xtnbreg n_events lag1fh_pr lag1logGDPexp_capita lag1logpop lag1any_conflict lag1durable i.year ecoleg, fe irr 
xtnbreg n_events lag1fh_pr lag1logGDPexp_capita lag1logpop lag1any_conflict lag1durable i.year socleg, fe irr 

*** efficiency
xtnbreg n_events lag1vdem_corr lag1logGDPexp_capita lag1logpop lag1any_conflict lag1durable i.year , fe irr 

*** fairness (procedural)
xtnbreg n_events lag1fh_cl lag1logGDPexp_capita lag1logpop lag1any_conflict lag1durable i.year , fe irr 

*** fairness (distributive)
xtnbreg n_events lag1vdem_egal lag1logGDPexp_capita lag1logpop lag1any_conflict lag1durable i.year , fe irr 


* check with polleg variable from systemic peace database
xtnbreg n_events lag1polleg lag1logGDPexp_capita lag1logpop lag1any_conflict lag1durable  i.year, fe irr 
xtnbreg n_events lag1poleff lag1logGDPexp_capita lag1logpop lag1any_conflict lag1durable  i.year, fe irr 

xtnbreg n_events lag1socleg lag1logGDPexp_capita lag1logpop lag1any_conflict lag1durable  i.year, fe irr 
xtnbreg n_events lag1soceff lag1logGDPexp_capita lag1logpop lag1any_conflict lag1durable  i.year, fe irr 

xtnbreg n_events lag1secleg lag1logGDPexp_capita lag1logpop lag1any_conflict lag1durable  i.year, fe irr 
xtnbreg n_events lag1seceff lag1logGDPexp_capita lag1logpop lag1any_conflict lag1durable  i.year, fe irr 

xtnbreg n_events lag1ecoleg lag1logGDPexp_capita lag1logpop lag1any_conflict lag1durable  i.year, fe irr 
xtnbreg n_events lag1ecoeff lag1logGDPexp_capita lag1logpop lag1any_conflict lag1durable  i.year, fe irr 


*--------------  WORLD VALUE SURVEY
xtnbreg n_events lag1wvs_trust lag1logGDPexp_capita lag1logpop lag1any_conflict lag1durable i.year   , fe irr 
xtnbreg n_events lag1wvs_polint lag1logGDPexp_capita lag1logpop lag1any_conflict lag1durable i.year   , fe irr 
xtnbreg n_events lag1wvs_confpol lag1logGDPexp_capita lag1logpop lag1any_conflict lag1durable i.year   , fe irr 





coefplot (model), ///
xline(0, lcolor(black) lwidth(thin) lpattern(dash)) /// 
keep(lag1legitimacy lag1logGDPexp_capita lag1logpop lag1any_conflict lag1durable) ///
coeflabels(lag1legitimacy = "political legitimacy" lag1logGDPexp_capita = "GDP per capita" lag1logpop = "population" lag1any_conflict = "involvement in conflict" lag1durable = "regime stability")




