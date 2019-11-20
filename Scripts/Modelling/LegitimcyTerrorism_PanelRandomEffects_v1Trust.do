
*** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***
* STATE LEGITIMACY AND TERRORISM
*** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***
sysdir set PERSONAL "/Users/schwarze/Documents/DISS/DISSanly/ados"


*TO DO
*include trust in government
*change GDP to GINI
*remove variables?


*sysdir set PERSONAL "/Users/schwarze/Documents/DISS/DISSanly/ados"

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

*-------------- summary statistics
generate y = uniform()
eststo: quietly regress y n_events accountability corruption effectiveness quality rule_of_law polity2 GDPexp_capita pop any_conflict durable mean_trust_others, noconstant

estadd summ : *	
esttab using "/Users/schwarze/Documents/GitHub/LegitimacyTerrorism/Scripts/Modelling/SummaryStataWVS.rtf", ///
	cells("mean(fmt(a2) label(Mean)) sd(fmt(a2)label(SD)) min(fmt(a2)label(Min)) max(fmt(a2)label(Max))") nodepvar nostar nonote ///
	replace compress rtf label
	eststo clear

*-------------- Negative Binomial Fixed Effects Model with Panel Data, output as IRR
*Before using xtreg you need to set Stata to handle panel data by using the command xtset. 
xtset consolidated_country year 
// �country� represents the entities or panels (i) and �year� represents the time variable (t)
// strongly balanced)� refers to the fact that all countries have data for all years.



*EFFECTIVENESS 

xtnbreg n_events lag1effectiveness lag1logGDPexp_capita lag1logpop lag1any_conflict lag1durable mean_trust_others, re irr

xtnbreg n_events lag1effectiveness lag1logGDPexp_capita lag1logpop lag1any_conflict lag1durable mean_importance_politics, re irr

xtnbreg n_events lag1effectiveness lag1logGDPexp_capita lag1logpop lag1any_conflict lag1durable mean_interest_politics, re irr





xtnbreg n_events lag1effectiveness lag1logGDPexp_capita lag1logpop lag1any_conflict, fe irr
est store model

coefplot model, ///
xline(1, lcolor(black) lwidth(thin) lpattern(dash)) /// 
drop(_cons) eform






*ACCOUNTABILITY 
xtnbreg n_events lag1accountability lag1logGDPexp_capita lag1logpop lag1any_conflict lag1durable lagmean_trust_others, re irr
est store model1

*CORRUPTION 
xtnbreg n_events lag1corruption lag1logGDPexp_capita lag1logpop lag1any_conflict lag1durable mean_trust_others, fe irr
est store model2

*EFFECTIVENESS 
xtnbreg n_events lag1effectiveness lag1logGDPexp_capita lag1logpop lag1any_conflict lag1durable mean_trust_others, fe irr
est store model3

*QUALITY 
xtnbreg n_events lag1quality lag1logGDPexp_capita lag1logpop lag1any_conflict lag1durable mean_trust_others, fe irr
est store model4

*RULE OF LAW
xtnbreg n_events lag1rule_of_law lag1logGDPexp_capita lag1logpop lag1any_conflict lag1durable mean_trust_others, fe irr
est store model5
		   
*POLITY IV: polity2
xtnbreg n_events lag1polity2 lag1logGDPexp_capita lag1logpop lag1any_conflict lag1durable mean_trust_others, fe irr
est store model6


*-------------- write output

esttab model1 model2 model3 model4 model5 model6 using "/Users/schwarze/Documents/GitHub/LegitimacyTerrorism/Scripts/Modelling/NegbinFixStata.rtf",  ///
	wide eqlabels(none) eform z constant ///
	mtitles ("Model 1" "Model 2" "Model 3" "Model 4" "Model 5" "Model 6" "Model 7" "Model 8") ///
	star(* 0.05 ** 0.01 *** 0.001) ///		
	b(%9.2f) z(%9.1f) scalars("rank Rank" "ll Log lik." "chi2 Chi-squared" "bic BIC " "aic AIC") sfmt(%9.0f %9.0f %9.2f %9.0f %9.0f) obslast   ///
	compress rtf replace label 	
	
	
esttab model1dom model2dom model3dom model4dom model5dom model6dom using "/Users/schwarze/Documents/GitHub/LegitimacyTerrorism/Scripts/Modelling/NegbinFixStataDom.rtf",  ///
	wide eqlabels(none) eform z constant ///
	mtitles ("Model 1" "Model 2" "Model 3" "Model 4" "Model 5" "Model 6" "Model 7" "Model 8") ///
	star(* 0.05 ** 0.01 *** 0.001) ///		
	b(%9.2f) z(%9.1f) scalars("rank Rank" "ll Log lik." "chi2 Chi-squared" "bic BIC " "aic AIC") sfmt(%9.0f %9.0f %9.2f %9.0f %9.0f) obslast   ///
	compress rtf replace label 		
	
	
	
	

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

LINKS

*https://www.princeton.edu/~otorres/Panel101.pdf
*https://www.stata.com/statalist/archive/2012-02/msg00398.html
*https://www.stata.com/manuals14/xt.pdf

Panel dummies for fixed effects
https://www.stata.com/statalist/archive/2012-02/msg00398.html

Typically for a fixed effects negative binomial model, you would want to use
the -xtnbreg, fe- command.   -xtnbreg, fe- is fitting a conditional fixed
effects model.  When you include panel dummies in -nbreg- command, you are
fitting an unconditional fixed effects model.  For nonlinear models such as
the negative binomial model, the unconditional fixed effects estimator
produces inconsistent estimates. 

https://www.statalist.org/forums/forum/general-stata-discussion/general/1431557-negative-binomial-fixed-effects-model-with-panel-data-several-options
https://www.statalist.org/forums/forum/general-stata-discussion/general/1430344-panel-negative-binomial-model
https://www.stata.com/statalist/archive/2012-02/msg00398.html
https://statisticalhorizons.com/fe-nbreg



*https://www.ls3.soziologie.uni-muenchen.de/studium-lehre/archiv/teaching-marterials/panel-analysis_april-2019.pdf
*https://www.stata.com/meeting/germany17/slides/Germany17_Kripfganz.pdf
*https://blog.stata.com/2015/10/29/fixed-effects-or-random-effects-the-mundlak-approach/

Chamblain and Mundlak

hybrid model





