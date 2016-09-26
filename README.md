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

* E. Leuven and B. Sianesi. 2003. *PSMATCH2: Stata module to perform full Mahalanobis and propensity score matching, common support graphing, and covariate imbalance testing*.    [(link)](http://ideas.repec.org/c/boc/bocode/s432001.html). Version 4.0.11. To install in STATA, use command:
```ssc install psmatch2````

* Elizabeth A. Stuart. 2010. *Matching Methods for Causal Inference:
A Review and a Look Forward,* Statistical Science, Vol. 25, No. 1, 1–21.

## DATA FOR EXAMPLES AND DISCUSSION

To motivate the propensity score matching, I'll use the `cattaneo2` dataset, a STATA example dataset.  It can be loaded with the following command:
```stata
webuse cattaneo2
```
The data in `cattaneo2` is a subset of data that was analysed in the following journal articles:

* Almond, D., Chay, K.Y., Lee, D.S., 2005. *The costs of low birth weight,* Quarterly Journal of Economics 120, 1031-1083.

* Cattaneo, M.D. 2010. *Efficient semiparametric estimation of multi-valued treatment effects under ignorability,* Journal of Econometrics, 155(2), 138-154.

The dataset included information about infant/mother/father characteristics from singleton births in Pennsylvania between 1989 and 1991.  The original dataset included nearly 500,000 births.  The STATA example dataset includes 4642 births.

>**RESEARCH QUESTION**: What is the effect of maternal smoking during pregnancy on the infant's birthweight?

The dataset includes the following set of variables:

Infant | Mother | Father
:--- | :--- | :---
birth weight (grams) | married/not married |
birth month | hispanic (yes/no) | hispanic (yes/no)
 | race (white/not white) | race (white/not white)
 | age | age
 | education | education
 | foreign born (yes/no) |
 | birth number |
 | months since last birth |
 | infant of previous births died (yes/no) |
 | number of prenatal care visits |
 | trimester of first prenatal care visit |
 | alcohol during pregnancy (yes/no) |
 | smoking during pregnancy (0, 1-5, 6-10, 11+ daily) |
 | smoking during pregnancy (yes/no) |


You can access the complete codebook with the command `codebook` after loading the data.


## BIG PICTURE BACKGROUND

 | Randomized Clinical Trial | Observational Study
:--- | :--- | :---
**Treatment Assignment:** | Investigators generate a treatment schedule prior to patient enrollment.  The schedule is constructed based on the design of the study, which includes randomization in some fashion.  Physicians (who may be blind to treatment as well) assign treatments/exposures to study participants following the sequence in the schedule. |<ul> <li>Phyicians assign treatment/exposure based on <ul><li> characteristics of the patient</li><li> personal preference</li><li> regional preference</li><li> insurance restrictions</li></ul></li><li>Study participants choose for themselves treatments or behaviors</li><li>Exposures are based on geographic location or cultural identity</li></ul>

<img src="unexposed-exposed-populations.svg" style="width:80vw;"></img>

 | Randomized Clinical Trial | Observational Study
:--- | :--- | :---
**Probability of Treatment:**| Known | Unknown, may be 0 or 1
**Covariate Balance:** | Relationship between covariates and treatment assignment are known from study design. Usually the study is designed so that there is no relationship between treatment assignment and covariates. | Relationship between covariates and treatment assignment is unknown.  There may be covariate imbalance.

## STATISTICAL ANALYSIS OF TREATMENT EFFECTS WITH OBSERVATIONAL DATA

There are several methods for estimating a treatment effect with observational data.  In this lecture series, you have been exposed (not randomly) to a family of methods which use the propensity score.  The primary focus has been on propensity score matching.

### PROPENSITY SCORE MATCHING

<img src="unexposed-exposed-populations-paired.svg" style="width:80vw;"></img>
<img src="unexposed-exposed-one-to-one-paired.svg" style="width:80vw;"></img>
<img src="unexposed-exposed-two-to-one-paired.svg" style="width:80vw;"></img>
<img src="unexposed-exposed-three-to-one-paired.svg" style="width:80vw;"></img>


### GOAL

Estimate the effect of maternal smoking on infant birthweight.

### IN STATA: ONE-TO-ONE MATCHING WITH COVARIATE ADJUSTMENT

### IN STATA: ONE-TO-ONE MATCHING, NO COVARIATE ADJUSTMENT

### IN STATA: BOOM
