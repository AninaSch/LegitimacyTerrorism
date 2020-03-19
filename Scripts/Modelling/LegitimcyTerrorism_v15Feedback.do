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
foreach v of var wvs_trust wvs_polint wvs_imppol wvs_confpol wvs_confcs {
	gen lag1`v'= `v'[_n-1]
}
* generate squared variables

gen lag1vdem_partip2 = lag1vdem_partip^2

gen lag1vdem_corr2 = lag1vdem_corr^2

gen lag1vdem_liberal2 = lag1vdem_liberal^2

gen lag1vdem_egal2 = lag1vdem_egal^2


*generate dummy n_domtarg_events

generate had_domtarg_events = 0
replace had_domtarg_events = 1 if n_domtarg_events>0

*generate dummies for years

*tab year, gen(yr)
*tab consolidated_country, gen(ctry)

*save  "../../Data/Data for Modelling/LEGTER_ts_recode.dta", replace

*-------------- correlation matrix

corr fh_pr fh_ipolity2 fh_ep fh_ppp fh_fog fh_cl 

corr vdem_edcomp_thick vdem_liberal vdem_partip vdem_dl_delib vdem_egal vdem_corr  
corr n_domtarg_events vdem_partip vdem_corr vdem_liberal  vdem_egal   

corr wbgi_cce wbgi_gee wbgi_pve wbgi_rle wbgi_vae 

*-------------- summary statistics
generate y = uniform()
eststo: quietly regress y n_domtarg_events vdem_partip vdem_corr vdem_liberal vdem_egal logGDPexp_capita logpop any_conflict durable , noconstant

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
xtnbreg n_domtarg_events lag1vdem_partip  lag1logGDPexp_capita lag1logpop lag1any_conflict lag1durable i.year , fe irr 
est store A
xtnbreg n_domtarg_events lag1vdem_partip  lag1logGDPexp_capita lag1logpop i.year , fe irr 

xtnbreg n_domtarg_events lag1vdem_partip lag1vdem_partip2  lag1logGDPexp_capita lag1logpop lag1any_conflict lag1durable i.year , fe irr 
est store AA


*MARGINAL EFFECTS
*https://www.stata.com/support/faqs/statistics/predict-and-adjust/
*marginsplot https://www.stata.com/features/overview/margins-plots/
*https://www3.nd.edu/~rwilliam/stats/Margins01.pdf
*https://www.stata.com/manuals13/xtxtnbregpostestimation.pdf
*https://www.stata.com/manuals13/rmargins.pdf#rmargins
*https://www.stata.com/statalist/archive/2012-12/msg00889.html
*https://www.statalist.org/forums/forum/general-stata-discussion/general/1367333-stata-question-how-to-use-margins-with-xtnbreg

xtnbreg n_domtarg_events c.lag1vdem_partip c.lag1vdem_partip#c.lag1vdem_partip  lag1logGDPexp_capita lag1logpop lag1any_conflict lag1durable i.year , fe irr 
quietly margins, at(lag1vdem_partip=(0.2(0.2)1)) atmeans predict(nu0)

*marginsplot, noci
*margins, dydx(lag1vdem_partip) at(lag1vdem_partip=(0.1(0.1)1)) atmeans
*marginsplot, xlabel(10(10)60) recast(line) recastci(rarea)

xtnbreg n_domtarg_events vdem_edcomp_thick  lag1logGDPexp_capita lag1logpop lag1any_conflict lag1durable i.year , fe  irr 
xtnbreg n_domtarg_events vdem_dl_delib  lag1logGDPexp_capita lag1logpop lag1any_conflict lag1durable i.year , fe irr 

*** EFFICIENCY
xtnbreg n_domtarg_events lag1vdem_corr lag1logGDPexp_capita lag1logpop lag1any_conflict lag1durable i.year , fe irr 
est store B
xtnbreg n_domtarg_events lag1vdem_corr lag1logGDPexp_capita  i.year , fe irr 

xtnbreg n_domtarg_events lag1vdem_corr lag1vdem_corr2 lag1logGDPexp_capita lag1logpop lag1any_conflict lag1durable i.year , fe irr 
est store BB

xtnbreg n_domtarg_events c.lag1vdem_corr c.lag1vdem_corr#c.lag1vdem_corr lag1logGDPexp_capita lag1logpop lag1any_conflict lag1durable i.year , fe irr 
quietly margins, at(lag1vdem_corr=(0.2(0.2)1)) atmeans predict(nu0)


*** FAIRNESS (PROCEDURAL)
xtnbreg n_domtarg_events lag1vdem_liberal lag1logGDPexp_capita lag1logpop lag1any_conflict lag1durable i.year , fe irr 
est store C
xtnbreg n_domtarg_events lag1vdem_liberal lag1logGDPexp_capita i.year , fe irr 

xtnbreg n_domtarg_events lag1vdem_liberal lag1vdem_liberal2 lag1logGDPexp_capita lag1logpop lag1any_conflict lag1durable i.year , fe irr 
est store CC

xtnbreg n_domtarg_events c.lag1vdem_liberal c.lag1vdem_liberal#c.lag1vdem_liberal lag1logGDPexp_capita lag1logpop lag1any_conflict lag1durable i.year , fe irr 
quietly margins, at(lag1vdem_liberal=(0.2(0.2)1)) atmeans predict(nu0)

*** FAIRNESS (DISTRIBUTIVE)
xtnbreg n_domtarg_events lag1vdem_egal lag1logGDPexp_capita lag1logpop lag1any_conflict lag1durable i.year , fe irr 
est store D
xtnbreg n_domtarg_events lag1vdem_egal lag1logGDPexp_capita i.year , fe irr 


xtnbreg n_domtarg_events lag1vdem_egal lag1vdem_egal2 lag1logGDPexp_capita lag1logpop lag1any_conflict lag1durable i.year , fe irr 
est store DD

xtnbreg n_domtarg_events c.lag1vdem_egal c.lag1vdem_egal#c.lag1vdem_egal lag1logGDPexp_capita lag1logpop lag1any_conflict lag1durable i.year , fe irr 
quietly margins, at(lag1vdem_egal=(0.2(0.2)1)) atmeans predict(nu0)

*** COMBINED ANALYSIS
xtnbreg n_domtarg_events lag1vdem_partip lag1vdem_corr lag1vdem_liberal lag1vdem_egal lag1logGDPexp_capita lag1logpop lag1any_conflict lag1durable i.year , fe irr 

*** POLITY 2
xtnbreg n_domtarg_events lag1polity2 lag1logGDPexp_capita lag1logpop lag1any_conflict lag1durable i.year , fe irr 
est store E

*** WVS trust
xtnbreg n_domtarg_events lag1wvs_trust lag1logGDPexp_capita lag1logpop lag1any_conflict lag1durable i.year , fe irr 


*** WGI

xtset consolidated_country year
* voice and accountability
xtnbreg n_domtarg_events wbgi_vae lag1logGDPexp_capita lag1logpop lag1any_conflict lag1durable i.year , fe irr 
*control of corruption / government effectiveness
xtnbreg n_domtarg_events wbgi_cce lag1logGDPexp_capita lag1logpop lag1any_conflict lag1durable i.year , fe irr 
xtnbreg n_domtarg_events wbgi_gee lag1logGDPexp_capita lag1logpop lag1any_conflict lag1durable i.year , fe irr 
* rule of law
xtnbreg n_domtarg_events wbgi_rle lag1logGDPexp_capita lag1logpop lag1any_conflict lag1durable i.year , fe irr 
* regulatory quality
xtnbreg n_domtarg_events quality lag1logGDPexp_capita lag1logpop lag1any_conflict lag1durable i.year , fe irr 


*--------------  COEFPLOTS

coefplot (A, label(Accountability)) (B, label(Efficiency)), ///
xline(1, lcolor(black) lwidth(thin) lpattern(dash)) eform /// 
keep(lag1vdem_partip lag1vdem_corr lag1legitimacy lag1vdem_liberal lag1vdem_egal lag1logGDPexp_capita lag1logpop lag1any_conflict lag1durable) ///
coeflabels(lag1vdem_partip = "accountability" lag1vdem_corr = "efficiency"  lag1vdem_liberal= "liberal" lag1vdem_egal = "egalitarian" ///
lag1polity2 = "democracy" ///
lag1logpop = "log population" lag1any_conflict = "involvement in conflict" lag1durable = "regime stability" lag1logGDPexp_capita = "log GDP per capita") 

graph save "/Users/schwarze/Documents/PUBLICATIONS/2020Article_TerrorismStateLegitimacy_ETH/coefplot_AB", replace
graph export "/Users/schwarze/Documents/PUBLICATIONS/2020Article_TerrorismStateLegitimacy_ETH/coefplot_AB", replace	

coefplot (C, label(Procedural Fairness)) (D, label(Distributive Fairness)), ///
xline(1, lcolor(black) lwidth(thin) lpattern(dash)) eform /// 
keep(lag1vdem_partip lag1vdem_corr lag1legitimacy lag1vdem_liberal lag1vdem_egal lag1logGDPexp_capita lag1logpop lag1any_conflict lag1durable lag1polity2) ///
coeflabels(lag1vdem_partip = "partecipation" lag1vdem_corr = "corruption"  lag1vdem_liberal= "proc. fairness" lag1vdem_egal = "dist.fairness" ///
lag1polity2 = "democracy" ///
lag1logpop = "log population" lag1any_conflict = "involvement in conflict" lag1durable = "regime stability" lag1logGDPexp_capita = "log GDP per capita")

graph save "/Users/schwarze/Documents/PUBLICATIONS/2020Article_TerrorismStateLegitimacy_ETH/coefplot_CD", replace
graph export "/Users/schwarze/Documents/PUBLICATIONS/2020Article_TerrorismStateLegitimacy_ETH/coefplot_CD", replace	
 
*--------------  SAVE

global varlabels ///		
	varlabels(`e(labels)') ///
	coeflabel(lag1vdem_partip "participation" lag1vdem_corr "corruption"  lag1vdem_liberal "liberal" lag1vdem_egal "egalitarian" ///
	lag1polity2  "democracy" ///
	lag1logpop "population" lag1logGDPexp_capita "log GDP per capita" lag1any_conflict "involvement in conflict" lag1durable "regime stability" ///
	lag1vdem_partip2 "participation sqr"  lag1vdem_corr2 "corruption sqr"  lag1vdem_liberal2 "liberal sqr" lag1vdem_egal2 "egalitarian sqr")

* SAVE MODELS 
esttab A B C D E using "/Users/schwarze/Documents/PUB/2020Article_TerrorismStateLegitimacy_ETH/NegativeBinPanel.rtf", $varlabels ///
	wide eqlabels(none) eform z constant ///
	mtitles ("Accountability" "Efficiency" "Procedural Fairness" "Distributive Fairness" "Democracy" ) ///
	star(* 0.05 ** 0.01 *** 0.001) 	///
	b(%9.2f) z(%9.1f) scalars("rank Rank" "ll Log lik." "chi2 Chi-squared" "bic BIC " "aic AIC") sfmt(%9.0f %9.0f %9.2f %9.0f %9.0f) obslast   ///
	compress rtf replace label 	
	
	* b(%9.2f) r2 obslast compress rtf replace label ///

esttab AA BB CC DD using "/Users/schwarze/Documents/PUB/2020Article_TerrorismStateLegitimacy_ETH/NegativeBinPanel_sqr.rtf", $varlabels ///
	wide eqlabels(none) eform z constant ///
	mtitles ("Accountability" "Efficiency" "Procedural Fairness" "Distributive Fairness" "Democracy" ) ///
	star(* 0.05 ** 0.01 *** 0.001) 	///
	b(%9.2f) z(%9.1f) scalars("rank Rank" "ll Log lik." "chi2 Chi-squared" "bic BIC " "aic AIC") sfmt(%9.0f %9.0f %9.2f %9.0f %9.0f) obslast   ///
	compress rtf replace label 		








