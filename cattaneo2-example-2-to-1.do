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


* CREATE RESTRICTED CUBIC SPLINES OF CONTINUOUS COVARIATES
mkspline rcs_mage_ = mage, cubic nknots(5)           // Mother's age (5 knots)
mkspline rcs_fage_ = fage, cubic nknots(5)           // Father's age
mkspline rcs_nprenatal_ = nprenatal, cubic nknots(5) // Number of prenatal visits
mkspline rcs_order_ = order, cubic nknots(3)         // birth number

* BUILT IN FUNCTIONS
teffects psmatch (bweight) (mbsmoke alcohol deadkids foreign rcs_* mhisp i.medu2 mmarried mrace i.prenatal), atet caliper(.25)

* BALANCE
tebalance box mage
tebalance density mage
tebalance box nprenatal
tebalance box order
tebalance summarize alcohol deadkids foreign mage nprenatal order mhisp i.medu2 mmarried mrace prenatal




