version 11
clear all
macro drop _all
label drop _all
set linesize 80

//	Project:	STS_YIF_Kenya
//	Author:		Thomaz Alvares
// 		Date:		07-25-2011

/*	
*	(i)	 	This do-file runs the analysis included in the mid-line
				report with exception of pbis correlations, alpha and KR20
	(ii) 	Scores build the tables used in the report
	(iii)	Scores comparison compare T vs C for all sub-categories
	(iv)	Correlation are included in the report. Regression tables
				are not
	(v)		ANOVA are run on aggregated (T + C) and disagregated (T vs C)

*/

// Edit 01: 	
//		Date:		08-01-2011
/*	
	Note:	Several of the commands were repeated for T and C instead of looped
				through treatment (0=control; 1=treatmet). This was done to
				facilitate plugging number on the report template
*/

capture log close
global rawname STS_KenyaYIF_Analysis Report
log using "${rawname}", replace text

// ANALYSIS-cohort2_baseline
global tabs 	STS_KenyaYIF_Analysis Datasets_tabs
global regtabs	STS_KenyaYIF_Analysis Datasets_regtabs
global source 	STS_KenyaYIF_Combined Datasets-cohort2_baseline
use "${source}_long.dta", clear

//=============================================================
// SCORES
* Sc.: Tables
*	Sc1. ICT
table treatment if datasource == 2, contents(count S_resp_total mean S_resp_total semean S_resp_total )
tabstat S_resp_total if datasource == 2, statistics(n mean semean) col(statistics)

*	Sc2. Life Skills
table treatment if datasource == 3, contents(count S_resp_total mean S_resp_total semean S_resp_total )
tabstat S_resp_total if datasource == 3, statistics(n mean semean) col(statistics)

*	Scores per Age-Group
*		ICT
table age_cat if datasource == 2, contents(count S_resp_total mean S_resp_total semean S_resp_total )
*		Life Skills
table age_cat if datasource == 3, contents(count S_resp_total mean S_resp_total semean S_resp_total )

*	Scores per Location
*		ICT
table d6_location if datasource == 2, contents(count S_resp_total mean S_resp_total semean S_resp_total )
*		Life Skills
table d6_location if datasource == 3, contents(count S_resp_total mean S_resp_total semean S_resp_total )

*	Scores per Marital
*		ICT
table d4_marital if datasource == 2, contents(count S_resp_total mean S_resp_total semean S_resp_total )
*		Life Skills
table d4_marital if datasource == 3, contents(count S_resp_total mean S_resp_total semean S_resp_total )

*	Scores per Educ
*		ICT
table d8_educ if datasource == 2, contents(count S_resp_total mean S_resp_total semean S_resp_total )
*		Life Skills
table d8_educ if datasource == 3, contents(count S_resp_total mean S_resp_total semean S_resp_total )

*	Scores per Yrs Employed
*		ICT
table d15_employ_duration if datasource == 2, contents(count S_resp_total mean S_resp_total semean S_resp_total )
*		Life Skills
table d15_employ_duration if datasource == 3, contents(count S_resp_total mean S_resp_total semean S_resp_total )

*	Scores per Exposure to Previous Training Program
*		ICT
table d10_train_previous if datasource == 2, contents(count S_resp_total mean S_resp_total semean S_resp_total )
*		Life Skills
table d10_train_previous if datasource == 3, contents(count S_resp_total mean S_resp_total semean S_resp_total )

//=============================================================
// TABLES FOR SCORES COMPARISON (T vs C)
* AGE
* F2. Tables
* 	F2.1. ICT
table treatment if datasource == 2, contents(count S_resp_total mean S_resp_total semean S_resp_total ) by(age_cat)
*	F2.2. Life Skills
table treatment if datasource == 3, contents(count S_resp_total mean S_resp_total semean S_resp_total ) by(age_cat)

* LOCATION
* A2. Tables
* 	A2.1. ICT
table treatment if datasource == 2, contents(count S_resp_total mean S_resp_total semean S_resp_total ) by(d6_location)
*	A2.2. Life Skills
table treatment if datasource == 3, contents(count S_resp_total mean S_resp_total semean S_resp_total ) by(d6_location)

* MARITAL STATUS
* B2. Tables
* 	B2.1. ICT
table treatment if datasource == 2, contents(count S_resp_total mean S_resp_total semean S_resp_total ) by(d4_marital)
*	B2.2. Life Skills
table treatment if datasource == 3, contents(count S_resp_total mean S_resp_total semean S_resp_total ) by(d4_marital)

* EDUCATION
* C2. Tables
* 	C2.1. ICT
table treatment if datasource == 2, contents(count S_resp_total mean S_resp_total semean S_resp_total ) by(d8_educ)
*	C2.2. Life Skills
table treatment if datasource == 3, contents(count S_resp_total mean S_resp_total semean S_resp_total ) by(d8_educ)

* YEARS EMPLOYED
* D2. Tables
* 	D2.1. ICT
table treatment if datasource == 2, contents(count S_resp_total mean S_resp_total semean S_resp_total ) by(d15_employ_duration)
*	D2.2. Life Skills
table treatment if datasource == 3, contents(count S_resp_total mean S_resp_total semean S_resp_total ) by(d15_employ_duration)

* EXPOSURE TO PREVIOUS TRAINING PROGRAMS
* E2. Tables
* 	E2.1. ICT
table treatment if datasource == 2, contents(count S_resp_total mean S_resp_total semean S_resp_total ) by(d10_train_previous)
*	E2.2. Life Skills
table treatment if datasource == 3, contents(count S_resp_total mean S_resp_total semean S_resp_total ) by(d10_train_previous)

//=============================================================
// SCORES COMPARISON (T vs C)
*	Total
*		ICT
ttest S_resp_total if datasource == 2, by(treatment)
*		Life Skills
ttest S_resp_total if datasource == 3, by(treatment)

//=============================================================
// F: AGE
tabout	age_cat d6_location d4_marital d8_educ d15_employ_duration d10_train_previous	///
			treatment if datasource == 1 using "${tabs}.txt",	///
			c(freq col) f(0) clab(No. Col_%)								///
			append
* Age
tabstat age if datasource == 1, statistics( count mean semean ) columns(statistics)			
* Age per Study group
table treatment if datasource == 1, contents(count age mean age semean age)
* T-Test Age per Study group
ttest age if datasource == 1 , by(treatment)
* Age as in Age groups for T and C 
tab age_cat treatment if datasource == 1, col miss

/* 
	Note: 	
*/

* F1. T-Tests
* 	F1.1. ICT
bysort age_cat: ttest S_resp_total if datasource == 2 , by(treatment)
* 	F1.2. Life Skills
bysort age_cat: ttest S_resp_total if datasource == 3 , by(treatment)

//=============================================================
// A: LOCATION
tab 	d6_location treatment if datasource == 1, col miss
tabout	d6_location treatment if datasource == 1 using "${tabs}.txt",	///
			c(freq col) f(0 1) clab(No. Col_%) 		///
			replace
/* 
	Note: Location 7 ("Other") NOT present in Treatment and CONTROL group 
*/

* A1. T-Tests
* 	A1.1. ICT
bysort d6_location: ttest S_resp_total if datasource == 2, by(treatment)
* 	A1.2. Life Skills
bysort d6_location: ttest S_resp_total if datasource == 3, by(treatment)

//=============================================================
// B: MARITAL STATUS
tab 	d4_marital treatment if datasource == 1, miss col
tabout 	d4_marital treatment if datasource == 1 using "${tabs}.txt",	///
			c(freq col) f(0 1) clab(No. Col_%) 	///
			append
/* 
	Note: 		1 case of missing value
*/

* B1. T-Tests
* 	B1.1. ICT
bysort d4_marital: ttest S_resp_total if datasource == 2 & d4_marital != . , by(treatment)
* 	B1.2. Life Skills
bysort d4_marital: ttest S_resp_total if datasource == 3 & d4_marital != . , by(treatment)

//=============================================================
// C: EDUCATION
tab 	d8_educ treatment if datasource == 1, miss col
tabout 	d8_educ treatment if datasource == 1 using "${tabs}.txt",	///
			c(freq col) f(0 1) clab(No. Col_%) 	///
			append
/* 
	Note: 	1 case of university in T2, 0 on Control
			1 case of other in Control, 0 on T2
			1 case of missing value
*/

* C1. T-Tests
* 	C1.1. ICT
bysort d8_educ: ttest S_resp_total if datasource == 2 & d8_educ <= 3 , by(treatment)
* 	C1.2. Life Skills
bysort d8_educ: ttest S_resp_total if datasource == 3 & d8_educ <= 3 , by(treatment)

//=============================================================
// D: YEARS EMPLOYED
tab 	d15_employ_duration treatment if datasource == 1, miss
tabout 	d15_employ_duration treatment if datasource == 1 using "${tabs}.txt",	///
			c(freq col) f(0 1) clab(No. Col_%) 				///
			append
/* 
	Note:	1 over 5 yr in C, 0 in T2
			10 missing values
*/
tab d15_employ_duration treatment if datasource == 1, col miss

* D1. T-Tests
* 	D1.1. ICT
bysort d15_employ_duration: ttest S_resp_total if datasource == 2 ///
	& d15_employ_duration <= 3 , by(treatment)
* 	D1.2. Life Skills
bysort d15_employ_duration: ttest S_resp_total if datasource == 3 ///
	& d15_employ_duration <= 3 , by(treatment)

//=============================================================
// E: EXPOSURE TO PREVIOUS TRAINING PROGRAMS
tab 	d10_train_previous treatment if datasource == 1, miss
tabout 	d10_train_previous treatment if datasource == 1 using "${tabs}.txt",	///
			c(freq col) f(0 1) clab(No. Col_%) 			///
			append
tab d10_train_previous treatment if datasource == 1, col miss

/* 
	Note: 	
*/

* E1. T-Tests
* 	E1.1. ICT
bysort d10_train_previous: ttest S_resp_total if datasource == 2 , by(treatment)
* 	E1.2. Life Skills
bysort d10_train_previous: ttest S_resp_total if datasource == 3 , by(treatment)

//=============================================================
// G: CORRELATIONS AND REGRESSIONS
/*
	Assessing whether score in the two tests are correlated and;
	Regressing one on the other (converted them to z-scores before)
*/

// Correlation
* 	Overall
pwcorr  S_q_resp_t_V2 S_l_resp_t_V2 if datasource == 1, sig star(.05)
* 	Control
pwcorr  S_q_resp_t_V2 S_l_resp_t_V2 if datasource == 1 & treatment == 0, sig star(.05)
* 	Treatment
pwcorr  S_q_resp_t_V2 S_l_resp_t_V2 if datasource == 1 & treatment == 1, sig star(.05)

// Regression
regress	S_q_resp_z_V2 S_l_resp_z_V2 treatment if datasource == 1
eststo	clear
esttab	using "${regtabs}.rtf",																	///
			label nonumbers varwidth(33) se ar2 obslast replace									///
			title("Table X: Effects of Life Skills and Participant Group on ICT test scores")	///
			mtitles("ICT")																

regress  S_l_resp_z_V2 S_q_resp_z_V2 treatment if datasource == 1
eststo	clear
esttab	using "${regtabs}.rtf",																	///
			label nonumbers varwidth(33) se ar2 obslast append									///
			title("Table X: Effects of ICT and Participant Group on Life Skills test scores")	///
			mtitles("Life Skills")


//=============================================================
// H: ANOVAS

*-------------------
* AGGREGATED (T + C)
*-------------------
foreach var of varlist	age_cat 				d6_location 				///
						d4_marital 				d8_educ 					///
						d15_employ_duration 	d10_train_previous	 		{
	display "ICT"
	tabstat S_resp_total if datasource == 2, by(`var') stat(n mean semean) 	
	oneway  S_resp_total `var' if datasource == 2, bonferroni				
	display "Life Skills"
	tabstat S_resp_total if datasource == 3, by(`var') stat(n mean semean) 	
	oneway  S_resp_total `var' if datasource == 3, bonferroni				
}

* Follow-up
* Marital has only two sub-categories
* ICT
ttest S_resp_total if ///
			d4_marital == 1 & datasource == 2 | d4_marital == 2 & datasource == 2, by(d4_marital)
* Life Skills
ttest S_resp_total if ///
			d4_marital == 1 & datasource == 3 | d4_marital == 2 & datasource == 3, by(d4_marital)

* Educ has only two sub-categories			
* ICT
ttest S_resp_total if ///
			d8_educ == 2 & datasource == 2 | d8_educ == 3 & datasource == 2, by(d8_educ)
* Life Skills
ttest S_resp_total if ///
			d8_educ == 2 & datasource == 3 | d8_educ == 3 & datasource == 3, by(d8_educ)

*----------
* TREATMENT
*----------
foreach var of varlist	age_cat 				d6_location 				///
						d4_marital 				d8_educ 					///
						d15_employ_duration 	d10_train_previous	 		{
	display "ICT"
	tabstat S_resp_total if datasource == 2 & treatment == 1, by(`var') stat(n mean semean) 	
	oneway  S_resp_total `var' if datasource == 2 & treatment == 1, bonferroni				
	display "Life Skills"
	tabstat S_resp_total if datasource == 3 & treatment == 1, by(`var') stat(n mean semean) 	
	oneway  S_resp_total `var' if datasource == 3 & treatment == 1, bonferroni				
}

* Follow-up
* Marital has only two sub-categories
* ICT
ttest S_resp_total if ///
			d4_marital == 1 & datasource == 2 & treatment == 1 | d4_marital == 2 & datasource == 2 & treatment == 1, by(d4_marital)
* Life Skills
ttest S_resp_total if ///
			d4_marital == 1 & datasource == 3 & treatment == 1 | d4_marital == 2 & datasource == 3 & treatment == 1, by(d4_marital)

* Educ has only two sub-categories			
* ICT
ttest S_resp_total if ///
			d8_educ == 2 & datasource == 2 & treatment == 1 | d8_educ == 3 & datasource == 2 & treatment == 1, by(d8_educ)
* Life Skills
ttest S_resp_total if ///
			d8_educ == 2 & datasource == 3 & treatment == 1 | d8_educ == 3 & datasource == 3 & treatment == 1, by(d8_educ)

*--------
* CONTROL
*--------
foreach var of varlist	age_cat 				d6_location 				///
						d4_marital 				d8_educ 					///
						d15_employ_duration 	d10_train_previous	 		{
	display "ICT"
	tabstat S_resp_total if datasource == 2 & treatment == 0, by(`var') stat(n mean semean) 	
	oneway  S_resp_total `var' if datasource == 2 & treatment == 0, bonferroni				
	display "Life Skills"
	tabstat S_resp_total if datasource == 3 & treatment == 0, by(`var') stat(n mean semean) 	
	oneway  S_resp_total `var' if datasource == 3 & treatment == 0, bonferroni				
}

* Follow-up
* Marital has only two sub-categories
* ICT
ttest S_resp_total if ///
			d4_marital == 1 & datasource == 2 & treatment == 0 | d4_marital == 2 & datasource == 2 & treatment == 0, by(d4_marital)
* Life Skills
ttest S_resp_total if ///
			d4_marital == 1 & datasource == 3 & treatment == 0 | d4_marital == 2 & datasource == 3 & treatment == 0, by(d4_marital)

* Educ has only two sub-categories			
* ICT
ttest S_resp_total if ///
			d8_educ == 2 & datasource == 2 & treatment == 0 | d8_educ == 3 & datasource == 2 & treatment == 0, by(d8_educ)
* Life Skills
ttest S_resp_total if ///
			d8_educ == 2 & datasource == 3 & treatment == 0 | d8_educ == 3 & datasource == 3 & treatment == 0, by(d8_educ)

		
log close
exit
