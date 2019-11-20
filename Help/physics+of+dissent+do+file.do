***Replication File Accompanying "The Physics of Dissent and the Effects of Movement Momentum"
***Erica Chenoweth & Margherita Belgioioso
***Nature: Human Behaviour
***Last updated 17 June 2019

tsset ccode date, daily

**Table2)

*Model 1) rare events logit for all types of dissent and control variables 
relogit Strict_exit Dvelocity MDPC Dmomentum changeNNVL lagrep log_POPWB log_GDPWB  nochange _spline1 _spline2 _spline3, cluster (ccode)
outreg2 using Table1.doc,drop(nochange _spline1 _spline2 _spline3*) sideway stats (coef se pval ci_low ci_high) noaster noparen dec(3) replace excel
*WALD TEST
test (Dmomentum)
*Model 2) rare events logit for nonviolent dissent and control variables 
relogit Strict_exit velocity MNNP newMmomentum changeNNVL lagrep  log_POPWB log_GDPWB  nochange _spline1 _spline2 _spline3, cluster (ccode)
outreg2 using Table1a.doc,drop(nochange _spline1 _spline2 _spline3*) sideway stats (coef se pval ci_low ci_high) noaster noparen dec(3) replace excel
*WALD TEST
test (newMmomentum)
*Model 3) rare events logit for all types of dissent and control variables (incl violent events) 
relogit Strict_exit CWvelocity Dvelocity MDPC Dmomentum changeNNVL lagrep  log_POPWB log_GDPWB  nochange _spline1 _spline2 _spline3, cluster (ccode)
outreg2 using Table1b.doc,drop(nochange _spline1 _spline2 _spline3*) sideway stats (coef se pval ci_low ci_high) noaster noparen dec(3) replace excel
*WALD TEST
test (Dmomentum)
*Model 4) conditional rare events logit for all types of dissent and control variables 
relogit Strict_exit Dmomentum Dvelocity MDPC changeNNVL lagrep log_POPWB log_GDPWB  nochange _spline1 _spline2 _spline3, cluster (ccode), if event==1
outreg2 using Table1c.doc,drop(nochange _spline1 _spline2 _spline3*) sideway stats (coef se pval ci_low ci_high) noaster noparen dec(3) replace excel
*WALD TEST
test (Dmomentum)
*Model 5) conditional rare events logit for strict NV dissent and control variables
relogit Strict_exit newMmomentum velocity MNNP changeNNVL lagrep log_POPWB log_GDPWB  nochange _spline1 _spline2 _spline3, cluster (ccode), if event==1
outreg2 using Table1d.doc,drop(nochange _spline1 _spline2 _spline3*) sideway stats (coef se pval ci_low ci_high) noaster noparen dec(3) replace excel
test (newMmomentum)
*Model 6) conditional rare events logit with logged mass and momentum for all types of dissent and control variables 
relogit Strict_exit logDmomentum Dvelocity newlogmdpc changeNNVL lagrep log_POPWB log_GDPWB  nochange _spline1 _spline2 _spline3, cluster (ccode)
outreg2 using Table1e.doc,drop(nochange _spline1 _spline2 _spline3*) sideway stats (coef se pval ci_low ci_high) noaster noparen dec(3) append excel
*WALD TEST
test (logDmomentum)
*Model 7) conditional rare events logit with logged mass and momentum for strict NV dissent and control variables
relogit Strict_exit lognewMmomentum velocity newlogmnnp changeNNVL lagrep log_POPWB log_GDPWB  nochange _spline1 _spline2 _spline3, cluster (ccode)
outreg2 using Table1f.doc,drop(nochange _spline1 _spline2 _spline3*) sideway stats (coef se pval ci_low ci_high) noaster noparen dec(3) replace excel
*WALD TEST
test (lognewMmomentum)
*Model 8) rare events logit for number of violent events 
relogit Strict_exit CWvelocity nochange _spline1 _spline2 _spline3, cluster (ccode)
outreg2 using Table1g.doc,drop(nochange _spline1 _spline2 _spline3*) sideway stats (coef se pval ci_low ci_high) noaster noparen dec(3) replace excel

**likelihood ratio tests (not reported in text)

*Model 1a velocity mass momentum for all types of dissent 
logit Strict_exit Dvelocity MDPC  nochange _spline1 _spline2 _spline3
estimates store m1
logit Strict_exit Dvelocity MDPC Dmomentum  nochange _spline1 _spline2 _spline3
estimates store m2
lrtest m1 m2
*Model 1b velocity mass momentum for all types of dissent and control variables
logit Strict_exit Dvelocity MDPC changeNNVL lagrep log_POPWB log_GDPWB  nochange _spline1 _spline2 _spline3
estimates store m5
logit Strict_exit Dvelocity MDPC Dmomentum changeNNVL lagrep log_POPWB log_GDPWB  nochange _spline1 _spline2 _spline3
estimates store m6
lrtest m5 m6
*Model 2a velocity mass momentum for only for nonviolent events
logit Strict_exit velocity MNNP   nochange _spline1 _spline2 _spline3
estimates store m3
logit Strict_exit velocity MNNP newMmomentum  nochange _spline1 _spline2 _spline3
estimates store m4
lrtest m3 m4
*Model 2b velocity mass momentum for nonviolent events only and control variables 
logit Strict_exit velocity MNNP  changeNNVL lagrep  log_POPWB log_GDPWB  nochange _spline1 _spline2 _spline3
estimates store m7
logit Strict_exit velocity MNNP newMmomentum changeNNVL lagrep  log_POPWB log_GDPWB  nochange _spline1 _spline2 _spline3
estimates store m8
lrtest m7 m8
*Model 4 conditional logit using velocity, mass, and new momentum measure for all types of dissent 
logit Strict_exit Dvelocity MDPC  nochange _spline1 _spline2 _spline3 if event==1
estimates store m1
logit Strict_exit Dmomentum Dvelocity MDPC  nochange _spline1 _spline2 _spline3 if event==1
estimates store m2
lrtest m1 m2
*Model 5 conditional logit using velocity, mass, and new momentum measure for only nonviolent dissent 
logit Strict_exit velocity MNNP nochange _spline1 _spline2 _spline3 if event==1
estimates store m1
logit Strict_exit newMmomentum velocity MNNP nochange _spline1 _spline2 _spline3 if event==1
estimates store m2
lrtest m1 m2
*Model 6 conditional logit using velocity, logged mass, and new momentum measure for all types of dissent 
logit Strict_exit Dvelocity newlogmdpc  nochange _spline1 _spline2 _spline3
estimates store m1
logit Strict_exit logDmomentum Dvelocity newlogmdpc  nochange _spline1 _spline2 _spline3
estimates store m2
lrtest m1 m2
*Model 7 conditional logit using velocity, logged mass, and new momentum measure for only nonviolent dissent 
logit Strict_exit velocity newlogmnnp nochange _spline1 _spline2 _spline3
estimates store m1
logit Strict_exit lognewMmomentum velocity newlogmnnp nochange _spline1 _spline2 _spline3
estimates store m2
lrtest m1 m2

*Figures 

**Figure 1 
logit Strict_exit c.Dvelocity##c.MDPC changeNNVL lagrep log_POPWB log_GDPWB  nochange _spline1 _spline2 _spline3, cluster (ccode), if event==1
margins, at(Dvelocity=(0(20)189) MDPC=(0 15 35 50))
marginsplot, noci

***Figure 2
logit Strict_exit c.Dvelocity##c.newlogmdpc changeNNVL lagrep log_POPWB log_GDPWB  nochange _spline1 _spline2 _spline3, cluster (ccode)
margins, at(Dvelocity=(0(20)189) newlogmdpc=(.51 6.19 8.48 10.32 14.89))
marginsplot, noci

**Supplementary Information

***Summary Statistics of Main Variables with Quantiles
univar Strict_exit MDPC Dvelocity Dmomentum changeNNVL lagrep log_POPWB log_GDPWB velocity MNNP newMmomentum CWvelocity newlogmdpc newlogmnnp logDmomentum lognewMmomentum, boxplot

*Figure S1. Histograms of Mass, Velocity, and Momentum
histogram MDPC, saving(mass)
histogram Dvelocity, saving(velocity)
histogram Dmomentum, saving(momentum)
histogram changeNNVL, saving(changeinlocations)
histogram lagrep, saving(repression)
histogram log_POPWB, saving(logpopulation) 
histogram log_GDPWB, saving(loggdp) 
histogram velocity, saving(velocitystrict) 
histogram MNNP, saving(massstrict) 
histogram newMmomentum, saving(momentumstrict) 
histogram CWvelocity, saving(violentevents)
histogram newlogmdpc, saving(loggedmass) 
histogram logDmomentum, saving(momentumloggedmass)
histogram newlogmnnp, saving(loggedmassstrict)
histogram lognewMmomentum, saving(momentumloggedmassstrict)
histogram MDPC if event==1, saving(masscl)
histogram MNNP if event==1, saving(massstrictcl)
gr combine mass.gph velocity.gph momentum.gph massstrict.gph velocitystrict.gph momentumstrict.gph massstrictcl.gph masscl.gph loggedmass.gph momentumloggedmass.gph loggedmassstrict.gph momentumloggedmassstrict.gph changeinlocations.gph repression.gph logpopulation.gph loggdp.gph violentevents.gph 

**Table S1. Summary Stats
sum Strict_exit MDPC Dvelocity Dmomentum changeNNVL lagrep log_POPWB log_GDPWB velocity MNNP newMmomentum CWvelocity newlogmdpc newlogmnnp logDmomentum lognewMmomentum

*Table S2. Collinearity diagnostic Model 1
collin Dvelocity MDPC Dmomentum changeNNVL lagrep log_POPWB log_GDPWB 
 
*Table S3. Correlation diagnostic Model 1
corr Dvelocity MDPC Dmomentum changeNNVL lagrep log_POPWB log_GDPWB  

*Table S4. Collinearity diagnostic Model 2
collin velocity MNNP newMmomentum changeNNVL lagrep  log_POPWB log_GDPWB

*Table S5. Correlation diagnostic Model 2
corr velocity MNNP newMmomentum changeNNVL lagrep  log_POPWB log_GDPWB

*Table S6. Collinearity diagnostic velocity and mass
collin Dvelocity MDPC

*Table S7. Correlation diagnostic velocity and mass
corr Dvelocity MDPC

*Table S8. Collinearity diagnostic velocity and mass for nonviolent events only
collin velocity MNNP

*Table S9. Correlation diagnostic velocity and mass for nonviolent events only
corr velocity MNNP

*Table S10. Crosstab of major civil war occurence and strict measure of irregular leader exit
tab Strict_exit majorW, col

*Model 1) velocity mass momentum for all types of dissent 
relogit Strict_exit majorW Dvelocity MDPC Dmomentum  nochange _spline1 _spline2 _spline3, cluster (ccode)
*Model 2) velocity mass momentum for only for nonviolence 
relogit Strict_exit majorW velocity MNNP newMmomentum  nochange _spline1 _spline2 _spline3, cluster (ccode)
*Model 3) velocity mass momentum for all types of dissent and control variables 
relogit Strict_exit majorW Dvelocity MDPC Dmomentum changeNNVL lagrep log_POPWB log_GDPWB  nochange _spline1 _spline2 _spline3, cluster (ccode)
*Model 4) velocity mass momentum for nonviolence and control variables 
relogit Strict_exit majorW velocity MNNP newMmomentum changeNNVL lagrep  log_POPWB log_GDPWB  nochange _spline1 _spline2 _spline3, cluster (ccode)

*Table S11. Determinants of irregular leader exit using alt mass measure (logged mass)
*Model 1) velocity mass momentum for all types of dissent 
relogit Strict_exit Dvelocity MDPClog1 mom  nochange _spline1 _spline2 _spline3, cluster (ccode)
outreg2 using Table11.doc,drop(nochange _spline1 _spline2 _spline3*) sideway stats (coef se pval ci_low ci_high) noaster noparen dec(3) replace excel
*Model 2) velocity mass momentum for only for nonviolence 
relogit Strict_exit velocity  MNNPlog1 mom1  nochange _spline1 _spline2 _spline3, cluster (ccode)
outreg2 using Table11a.doc,drop(nochange _spline1 _spline2 _spline3*) sideway stats (coef se pval ci_low ci_high) noaster noparen dec(3) replace excel
*Model 3) velocity mass momentum for all types of dissent and control variables 
relogit Strict_exit Dvelocity MDPClog1 mom changeNNVL lagrep log_POPWB log_GDPWB  nochange _spline1 _spline2 _spline3, cluster (ccode)
outreg2 using Table11b.doc,drop(nochange _spline1 _spline2 _spline3*) sideway stats (coef se pval ci_low ci_high) noaster noparen dec(3) replace excel
*Model 4) velocity mass momentum for nonviolence and control variables 
relogit Strict_exit velocity  MNNPlog1 mom1 changeNNVL lagrep  log_POPWB log_GDPWB  nochange _spline1 _spline2 _spline3, cluster (ccode)
outreg2 using Table11c.doc,drop(nochange _spline1 _spline2 _spline3*) sideway stats (coef se pval ci_low ci_high) noaster noparen dec(3) replace excel

*Table S12. Determinants of irregular leader exit using alt mass measure (dissidents per capita)
*Model 1) velocity mass momentum for all types of dissent 
relogit Strict_exit Dvelocity DPC Dmomentum1  nochange _spline1 _spline2 _spline3, cluster (ccode)
outreg2 using Table12.doc,drop(nochange _spline1 _spline2 _spline3*) sideway stats (coef se pval ci_low ci_high) noaster noparen dec(3) replace excel
*WALD TEST
test (Dmomentum1) 
*Model 2) velocity mass momentum for only for nonviolence 
relogit Strict_exit velocity PCNNP newMmomentum1  nochange _spline1 _spline2 _spline3, cluster (ccode)
outreg2 using Table12a.doc,drop(nochange _spline1 _spline2 _spline3*) sideway stats (coef se pval ci_low ci_high) noaster noparen dec(3) replace excel
*WALD TEST
test (newMmomentum1) 
*Model 3) velocity mass momentum for all types of dissent and control variables 
relogit Strict_exit Dvelocity DPC Dmomentum1 changeNNVL lagrep log_POPWB log_GDPWB  nochange _spline1 _spline2 _spline3, cluster (ccode)
outreg2 using Table12b.doc,drop(nochange _spline1 _spline2 _spline3*) sideway stats (coef se pval ci_low ci_high) noaster noparen dec(3) replace excel
*WALD TEST
test (Dmomentum1) 
*Model 4) velocity mass momentum for nonviolence and control variables 
relogit Strict_exit velocity PCNNP newMmomentum1 changeNNVL lagrep log_POPWB log_GDPWB  nochange _spline1 _spline2 _spline3, cluster (ccode)
outreg2 using Table12c.doc,drop(nochange _spline1 _spline2 _spline3*) sideway stats (coef se pval ci_low ci_high) noaster noparen dec(3) replace excel
*WALD TEST
test (newMmomentum1) 
*likelihood ratio tests
*Model 1
logit Strict_exit Dvelocity DPC  nochange _spline1 _spline2 _spline3
estimates store m9
logit Strict_exit Dvelocity DPC Dmomentum1  nochange _spline1 _spline2 _spline3
estimates store m10
lrtest m9 m10
*Model 2
logit Strict_exit velocity PCNNP  nochange _spline1 _spline2 _spline3
estimates store m11
logit Strict_exit velocity PCNNP newMmomentum1  nochange _spline1 _spline2 _spline3
estimates store m12
lrtest m11 m12
*Model 3
logit Strict_exit Dvelocity DPC changeNNVL lagrep log_POPWB log_GDPWB  nochange _spline1 _spline2 _spline3
estimates store m13
logit Strict_exit Dvelocity DPC Dmomentum1 changeNNVL lagrep log_POPWB log_GDPWB  nochange _spline1 _spline2 _spline3
estimates store m14
lrtest m13 m14
*Model 4
logit Strict_exit velocity PCNNP changeNNVL   lagrep log_POPWB log_GDPWB  nochange _spline1 _spline2 _spline3
estimates store m17
logit Strict_exit velocity PCNNP newMmomentum1 changeNNVL  lagrep log_POPWB log_GDPWB  nochange _spline1 _spline2 _spline3
estimates store m18
lrtest m17 m18

*Table 13) Determinants of irregular leader exit using standard errors clustered per year
*Model 1) velocity mass momentum for all types of dissent 
relogit Strict_exit Dvelocity MDPC Dmomentum  nochange _spline1 _spline2 _spline3, cluster (year)
outreg2 using Table13.doc,drop(nochange _spline1 _spline2 _spline3*) sideway stats (coef se pval ci_low ci_high) noaster noparen dec(3) replace excel
*WALD TEST
test (Dmomentum)
*Model 2) velocity mass momentum for only for nonviolence 
relogit Strict_exit velocity MNNP newMmomentum  nochange _spline1 _spline2 _spline3, cluster (year)
outreg2 using Table13a.doc,drop(nochange _spline1 _spline2 _spline3*) sideway stats (coef se pval ci_low ci_high) noaster noparen dec(3) replace excel
*WALD TEST
test (newMmomentum)
*Model 3) velocity mass momentum for all types of dissent and control variables 
relogit Strict_exit Dvelocity MDPC Dmomentum changeNNVL lagrep log_POPWB log_GDPWB  nochange _spline1 _spline2 _spline3, cluster (year)
outreg2 using Table13b.doc,drop(nochange _spline1 _spline2 _spline3*) sideway stats (coef se pval ci_low ci_high) noaster noparen dec(3) replace excel
test (Dmomentum)
*Model 4) velocity mass momentum for nonviolence and control variables 
relogit Strict_exit velocity MNNP newMmomentum changeNNVL lagrep  log_POPWB log_GDPWB  nochange _spline1 _spline2 _spline3, cluster (year)
outreg2 using Table13c.doc,drop(nochange _spline1 _spline2 _spline3*) sideway stats (coef se pval ci_low ci_high) noaster noparen dec(3) replace excel
*WALD TEST
test (newMmomentum)

*Table 14) Determinants of irregular leader exit using standard errors not clustered 
*Model 1) velocity mass momentum for all types of dissent 
relogit Strict_exit Dvelocity MDPC Dmomentum  nochange _spline1 _spline2 _spline3
outreg2 using Table14.doc,drop(nochange _spline1 _spline2 _spline3*) sideway stats (coef se pval ci_low ci_high) noaster noparen dec(3) replace excel
*WALD TEST
test (Dmomentum)
*Model 2) velocity mass momentum for only for nonviolence 
relogit Strict_exit velocity MNNP newMmomentum  nochange _spline1 _spline2 _spline3
outreg2 using Table14a.doc,drop(nochange _spline1 _spline2 _spline3*) sideway stats (coef se pval ci_low ci_high) noaster noparen dec(3) replace excel
*WALD TEST
test (newMmomentum)
*Model 3) velocity mass momentum for all types of dissent and control variables 
relogit Strict_exit Dvelocity MDPC Dmomentum changeNNVL lagrep log_POPWB log_GDPWB  nochange _spline1 _spline2 _spline3
outreg2 using Table14b.doc,drop(nochange _spline1 _spline2 _spline3*) sideway stats (coef se pval ci_low ci_high) noaster noparen dec(3) replace excel
test (Dmomentum)
*Model 4) velocity mass momentum for nonviolence and control variables 
relogit Strict_exit velocity MNNP newMmomentum changeNNVL lagrep  log_POPWB log_GDPWB  nochange _spline1 _spline2 _spline3
outreg2 using Table14c.doc,drop(nochange _spline1 _spline2 _spline3*) sideway stats (coef se pval ci_low ci_high) noaster noparen dec(3) replace excel
*WALD TEST
test (newMmomentum)

*Table 15) Determinants of irregular leader exit using alt mass measure (dissidents per capita) and standard errors clustered by year
*Model 1) velocity mass momentum for all types of dissent 
relogit Strict_exit Dvelocity DPC Dmomentum1  nochange _spline1 _spline2 _spline3, cluster (year)
outreg2 using Table15.doc,drop(nochange _spline1 _spline2 _spline3*) sideway stats (coef se pval ci_low ci_high) noaster noparen dec(3) replace excel
*WALD TEST
test (Dmomentum1) 
*Model 2) velocity mass momentum for only for nonviolence 
relogit Strict_exit velocity PCNNP newMmomentum1  nochange _spline1 _spline2 _spline3, cluster (year)
outreg2 using Table15a.doc,drop(nochange _spline1 _spline2 _spline3*) sideway stats (coef se pval ci_low ci_high) noaster noparen dec(3) replace excel
*WALD TEST
test (newMmomentum1) 
*Model 3) velocity mass momentum for all types of dissent and control variables 
relogit Strict_exit Dvelocity DPC Dmomentum1 changeNNVL lagrep log_POPWB log_GDPWB  nochange _spline1 _spline2 _spline3, cluster (year)
outreg2 using Table15b.doc,drop(nochange _spline1 _spline2 _spline3*) sideway stats (coef se pval ci_low ci_high) noaster noparen dec(3) replace excel
*WALD TEST
test (Dmomentum1) 
*Model 4) velocity mass momentum for nonviolence and control variables 
relogit Strict_exit velocity PCNNP newMmomentum1 changeNNVL lagrep log_POPWB log_GDPWB  nochange _spline1 _spline2 _spline3, cluster (year)
outreg2 using Table15c.doc,drop(nochange _spline1 _spline2 _spline3*) sideway stats (coef se pval ci_low ci_high) noaster noparen dec(3) replace excel
*WALD TEST
test (newMmomentum1) 

*Table 16) Determinants of irregular leader exit using alt mass measure (dissidents per capita) and standard errors not clustered 
*Model 1) velocity mass momentum for all types of dissent 
relogit Strict_exit Dvelocity DPC Dmomentum1  nochange _spline1 _spline2 _spline3
outreg2 using Table16.doc,drop(nochange _spline1 _spline2 _spline3*) sideway stats (coef se pval ci_low ci_high) noaster noparen dec(3) replace excel
*WALD TEST
test (Dmomentum1) 
*Model 2) velocity mass momentum for only for nonviolence 
relogit Strict_exit velocity PCNNP newMmomentum1  nochange _spline1 _spline2 _spline3
outreg2 using Table16a.doc,drop(nochange _spline1 _spline2 _spline3*) sideway stats (coef se pval ci_low ci_high) noaster noparen dec(3) replace excel
*WALD TEST
test (newMmomentum1) 
*Model 3) velocity mass momentum for all types of dissent and control variables 
relogit Strict_exit Dvelocity DPC Dmomentum1 changeNNVL lagrep log_POPWB log_GDPWB  nochange _spline1 _spline2 _spline3
outreg2 using Table16b.doc,drop(nochange _spline1 _spline2 _spline3*) sideway stats (coef se pval ci_low ci_high) noaster noparen dec(3) replace excel
*WALD TEST
test (Dmomentum1) 
*Model 4) velocity mass momentum for nonviolence and control variables 
relogit Strict_exit velocity PCNNP newMmomentum1 changeNNVL lagrep log_POPWB log_GDPWB  nochange _spline1 _spline2 _spline3
outreg2 using Table16c.doc,drop(nochange _spline1 _spline2 _spline3*) sideway stats (coef se pval ci_low ci_high) noaster noparen dec(3) replace excel
*WALD TEST
test (newMmomentum1) 

*Table 17 Determinants of irregular leader exit using loose measure of irregular leader exit
*Model 1) velocity mass momentum for all types of dissent 
relogit Loose_exit Dvelocity MDPC Dmomentum  nochange _spline1 _spline2 _spline3, cluster (ccode)
outreg2 using Table17.doc,drop(nochange _spline1 _spline2 _spline3*) sideway stats (coef se pval ci_low ci_high) noaster noparen dec(3) replace excel
*Model 2) velocity mass momentum for only for nonviolence 
relogit Loose_exit velocity MNNP newMmomentum  nochange _spline1 _spline2 _spline3, cluster (ccode)
outreg2 using Table17a.doc,drop(nochange _spline1 _spline2 _spline3*) sideway stats (coef se pval ci_low ci_high) noaster noparen dec(3) replace excel
*Model 3) velocity mass momentum for all types of dissent and control variables 
relogit Loose_exit Dvelocity MDPC Dmomentum changeNNVL lagrep log_POPWB log_GDPWB  nochange _spline1 _spline2 _spline3, cluster (ccode)
outreg2 using Table17b.doc,drop(nochange _spline1 _spline2 _spline3*) sideway stats (coef se pval ci_low ci_high) noaster noparen dec(3) replace excel
*Model 4) velocity mass momentum for nonviolence and control variables 
relogit Loose_exit velocity MNNP newMmomentum changeNNVL lagrep  log_POPWB log_GDPWB  nochange _spline1 _spline2 _spline3, cluster (ccode)
outreg2 using Table17c.doc,drop(nochange _spline1 _spline2 _spline3*) sideway stats (coef se pval ci_low ci_high) noaster noparen dec(3) replace excel
