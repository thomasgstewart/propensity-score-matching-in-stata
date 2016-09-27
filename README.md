# An introduction to propensity score matching in STATA

Thomas G. Stewart
Assistant Professor

This lecture is part 9 of the *Propensity Scores and Related Methods Series* presented and organized by Robert Greevy within Vanderbilt University's Center for Health Services Research.

## NOTE 1

I reserve the right for these notes to be wrong, mistaken, or incomplete.

## NOTE 2

These notes will continue to be updated as I
* expand the content
* generate more examples
* respond to helpful feedback regarding items in NOTE 1.

Please feel free to provide content and comments.

## SOFTWARE

* StataCorp. 2015. *Stata Statistical Software: Release 14.* College Station, TX: StataCorp LP.

* E. Leuven and B. Sianesi. 2003. *PSMATCH2: Stata module to perform full Mahalanobis and propensity score matching, common support graphing, and covariate imbalance testing*.    [(link)](http://ideas.repec.org/c/boc/bocode/s432001.html). Version 4.0.11. To install in STATA, use command:
```
ssc install psmatch2
```

* Phil Clayton. 2013. *TABLE1: module to create "table 1" of baseline characteristics for a manuscript*. Version 1.1.  To install in STATA, use command:
```
ssc install table1
```

## REFERENCES

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


## BIG PICTURE: BACKGROUND

<table style = "table-layout: fixed;width: 100%;">
<thead>
<tr>
<th align="left" style="width:25%;"></th>
<th align="left">Randomized Clinical Trial</th>
<th align="left">Observational Study</th>
</tr>
</thead>
<tbody>
<tr>
<td align="left">
<strong>Treatment Assignment:</strong>
</td>
<td align="left">Investigators generate a treatment schedule prior to patient enrollment. The schedule is constructed based on the design of the study, which includes randomization in some fashion. Physicians (who may be blind to treatment as well) assign treatments/exposures to study participants following the sequence in the schedule.</td>
<td align="left">
<ul>
<li>
Phyicians assign treatment/exposure based on
<ul>
<li> characteristics of the patient</li>
<li> personal preference</li>
<li> regional preference</li>
<li> insurance restrictions</li>
</ul>
</li>
<li>Study participants choose for themselves treatments or behaviors</li>
<li>Exposures are based on geographic location or cultural identity</li>
</ul>
</td>
</tr>
<tr>
<td colspan="3">
<strong>CONSEQUENTLY</strong>
</td>
</tr>
<tr>
<td align="left">
<strong>Probability of Treatment:</strong>
</td>
<td align="left">Known</td>
<td align="left">Unknown, may be 0 or 1</td>
</tr>
<tr>
<td align="left">
<strong>Covariate Balance:</strong>
</td>
<td align="left">Relationship between covariates and treatment assignment are known from study design. Usually the study is designed so that there is no relationship between treatment assignment and covariates.</td>
<td align="left">Relationship between covariates and treatment assignment is unknown. There may be covariate imbalance.</td>
</tr>
</tbody>
</table>

## BIG PICTURE: CHALLENGES

Differences in outcomes between the treated and untreated (or exposed and unexposed) may be the consequence of confounding variables and not the treatment (or exposure).

Dataset may include sub-groups for which a treatment effect should not be calculated because
* the sub-group may not be eligible for one treatment (a treatment effect should only be calculated in populations eligible for both treatments)
* though a sub-group may be eligible for both treatments, there may not be enough data for a comparison without extrapolation.

## BIG PICTURE: SOLUTIONS

There are several methods for estimating a treatment effect with observational data.  In this lecture series, you have been exposed (not randomly) to a family of methods which use the propensity score.  The primary focus has been on propensity score matching.

### STEPS (A SUMMARY OF STUART 2010)
1. Defining “closeness”: the distance measure used to determine whether an individual is a good match for another.
   1. Variables to include
      * Researchers should thus be liberal in terms of including variables that may be associated with treatment assignment and/or the outcomes.
      * One type of variable that should not be included in the  matching  process  is  any  variable  that  may  have been affected by the treatment of interest (Rosenbaum, 1984; Frangakis and Rubin, 2002; Greenland, 2003).
   2. Distance Measures
      * Exact
      * Mahalanobis
      * Propensity score / linear propensity score
         * With propensity score estimation, concern is not with the parameter estimates of the model, but rather with the resulting balance of the covariates (Augurzky and Schmidt, 2001).
2.  Implementing a matching method, given that measure of closeness.
   * Methods:
      1. k:1 Nearest Neighbor
         * Estimates Average Treatment Effect in the Treated (ATT or ATET)
         * May need a caliper
      2. Subclassification
      3. Full matching
      4. Weighting (IPTW)
   * Assess Common Support
      *  Examining the common support may indicate that it is not possible to reliably estimate the ATE.
3. Assessing the quality of the resulting matched samples, and perhaps iterating with steps 1 and 2 until well-matched samples result.
   * Perhaps  the  most  important  step  in  using  matching methods is to diagnose the quality of the resulting matched samples
   * Tools:
      1. Histograms / Density Plots / ECDF
      2. Standardized Bias / Standardized difference in means
4. Analysis of the outcome and estimation of the treatment effect, given the matching done in step 3.
   1. After k:1 mathcing
      * May not need to account for matched pair
      * Must use weights if matching was *with replacement*
      * Use regression adjustment
   2. After subclassification
      * Aggregation weights determine estimation of ATT or ATE
      * Use regression adjustment

### DEMONSTRATION
