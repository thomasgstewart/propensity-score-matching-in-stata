* READ DATA INTO MEMORY
webuse cattaneo2, clear
drop if prenatal == 0 | mage == 0 | medu == 0 | order == 0
order *, sequential // put variables in alphabetical order (personal preference)
egen float medu2 = cut(medu), at(0 9 12 13 17 18) // create coarse education groups


* TABLE 1, UNADJUSTED
table1, by(mbsmoke)      ///
  vars(  alcohol cat     /// 
       \ deadkids cat    /// 
       \ foreign cat     ///
       \ mage conts      ///
       \ medu cat        ///
       \ mhisp cat       ///
       \ mmarried cat    ///
       \ mrace cat       ///
       \ nprenatal conts ///
       \ order cat       ///
       \ prenatal cat    ///
       )

* TABLE 1, BIAS
pstest alcohol deadkids foreign mage i.medu2 mhisp ///
 mmarried mrace nprenatal order i.prenatal ///
 , raw treated(mbsmoke)

* TABLE 1, BIAS PLOT
pstest alcohol deadkids foreign mage medu2 mhisp ///
 mmarried mrace nprenatal order prenatal ///
 , raw treated(mbsmoke) graph
 

* INDIVIDUAL CONTINUOUS COVARIATES
pstest mage, density raw treated(mbsmoke)


* CREATE RESTRICTED CUBIC SPLINES OF CONTINUOUS COVARIATES
mkspline rcs_mage_ = mage, cubic nknots(5)           // Mother's age (5 knots)
mkspline rcs_fage_ = fage, cubic nknots(5)           // Father's age
mkspline rcs_nprenatal_ = nprenatal, cubic nknots(5) // Number of prenatal visits
mkspline rcs_order_ = order, cubic nknots(3)         // birth number

* MODEL ALCOHOL CONSUMPTION
logistic mbsmoke alcohol deadkids foreign rcs_* mhisp i.medu2 mmarried mrace i.prenatal

* LOG ODDS OF SMOKING
predict logodds, xb

* GET A SENSE OF .25 SD OF LINEAR PROPENSITY SCORE
summarize logodds

* CONSTRUCT MATCHES
* Note that this will also estimate ATT (without covariate adjustment). Disregard
* that information at the moment.
psmatch2 mbsmoke, outcome(bweight) pscore(logodds) neighbor(1) noreplace caliper(.25)

* MATCHES variable _weight indicates which observations were selected
list _* // show constructed variables

* ASSESS MATCHES

* PLOT PROPENSITY SCORE BEFORE
twoway ///
 (kdensity logodds if mbsmoke == 1, lcolor(navy) lwidth(thick)) ///
 (kdensity logodds if mbsmoke == 0, lcolor(red) lwidth(thick))  ///
 , legend(order(1 "SMOKER" 2 "NON-SMOKER"))
 
* PLOT PROPENSITY SCORE AFTER
twoway ///
 (kdensity logodds if mbsmoke == 1, lcolor(navy) lwidth(thick)) ///
 (kdensity logodds if mbsmoke == 0, lcolor(red) lwidth(thick))  ///
 if _weight == 1 ///
 , legend(order(1 "SMOKER" 2 "NON-SMOKER")) 
 
 * COVARIATE BALANCE
 pstest alcohol deadkids foreign mage i.medu2 mhisp ///
 mmarried mrace nprenatal order i.prenatal ///
 , both treated(mbsmoke) graph
 
* COVARIATE BALANCE, CONTINUOUS VARIABLES
cumul mage if _weight == 1 & mbsmoke == 1, generate(ecdf_mage_1)
cumul mage if _weight == 1 & mbsmoke == 0, generate(ecdf_mage_0)
generate secdf = ecdf_mage_1
replace secdf = ecdf_mage_0 if secdf == .
sort secdf
twoway (line ecdf_mage_1 mage if ecdf_mage_1 ~= ., sort) ///
  (line ecdf_mage_0 mage if ecdf_mage_0 ~= ., sort) ///
  , legend(order(1 "SMOKER" 2 "NON-SMOKER"))

cumul nprenatal if _weight == 1 & mbsmoke == 1, generate(ecdf_nprenatal_1)
cumul nprenatal if _weight == 1 & mbsmoke == 0, generate(ecdf_nprenatal_0)
generate secdf_nprenatal = ecdf_nprenatal_1
replace secdf_nprenatal = ecdf_nprenatal_0 if secdf_nprenatal == .
sort secdf_nprenatal
twoway (line ecdf_nprenatal_1 nprenatal if ecdf_nprenatal_1 ~= ., sort) ///
  (line ecdf_nprenatal_0 nprenatal if ecdf_nprenatal_0 ~= ., sort) ///
  , legend(order(1 "SMOKER" 2 "NON-SMOKER"))

 
* TABLE 1, ONE-TO-ONE SAMPLE, CATEGORICAL VARIABLES 
table1 if _weight == 1   ///
      , by(mbsmoke)      ///
  vars(  alcohol cat     /// 
       \ deadkids cat    /// 
       \ foreign cat     ///
       \ medu2 cat       ///
       \ mhisp cat       ///
       \ mmarried cat    ///
       \ mrace cat       ///
       \ order cat       ///
       \ prenatal cat    ///
       )

* WHERE IS THE LACK OF OVERLAP?
generate smoke_group = 1*(mbsmoke == 1 & _weight == 1) + ///
                       2*(mbsmoke == 1 & _weight == .) + ///
		       3*(mbsmoke == 0 & _weight == 1) + ///
		       4*(mbsmoke == 0 & _weight == .)

label define smoke_group 1 "Smoker IN" 2 "Smoker OUT" 3 "Non-smoker IN" 4 "Non-smoker OUT" 
label values smoke_group smoke_group

table1 ///
      , by(smoke_group)      ///
  vars(  alcohol cat     /// 
       \ deadkids cat    /// 
       \ foreign cat     ///
       \ mage conts      ///
       \ medu2 cat       ///
       \ mhisp cat       ///
       \ mmarried cat    ///
       \ mrace cat       ///
       \ nprenatal conts ///
       \ order cat       ///
       \ prenatal cat    ///
       ) onecol


twoway (scatter smoke_group logodds, sort jitter(15) jitterseed(1))

* ESTIMATE OF SMOKING EFFECT ON BIRTHWEIGHT

regress bweight mbsmoke alcohol deadkids foreign rcs_* mhisp i.medu2 mmarried mrace i.prenatal if _weight == 1




