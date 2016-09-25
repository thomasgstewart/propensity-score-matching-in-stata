# An introduction to propensity score matching in STATA

Thomas G. Stewart

This lecture is part 9 of the *propensity scores and related methods series* presented and organized by Robert Greevy within Vanderbilt University's Center for Health Services Research.

## NOTE 1

I reserve the right for these notes to be wrong, mistaken, or incomplete.

## NOTE 2

These notes will continue to be updated as I
* expand the content
* generate more examples
* respond to helpful feedback regarding items in NOTE 1.

Please feel free to provide content and comments.

## ACKNOWLEDGEMENTS & REFERENCES

* StataCorp. 2015. *Stata Statistical Software: Release 14.* College Station, TX: StataCorp LP.

* E. Leuven and B. Sianesi. 2003. *PSMATCH2: Stata module to perform full Mahalanobis and propensity score matching, common support graphing, and covariate imbalance testing*.   [(link)](http://ideas.repec.org/c/boc/bocode/s432001.html) This version 4.0.11.

* Elizabeth A. Stuart. 2010. *Matching Methods for Causal Inference:
A Review and a Look Forward,* Statistical Science, Vol. 25, No. 1, 1–21.

## BACKGROUND

 | Randomized Clinical Trial | Observational Study
--- | --- | ---
**Treatment Assignment:** | Investigators generate a treatment schedule prior to patient enrollment.  The schedule is constructed based on the design of the study, which includes randomization in some fashion.  Physicians (who may be blind to treatment as well) assign treatments/exposures to study participants following the sequence in the schedule. | Phyicians assign treatment/exposure based on
* characteristics of the patient
* personal preference
* regional preference
* insurance restrictions
Study participants choose for themselves treatments or behaviors
Exposures are based on geographic location or cultural identity.

<img src="unexposed-exposed-population.svg" style="width:80vw;"></img>
