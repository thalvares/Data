version 11
clear all
macro drop _all
set linesize 80

capture log close
global rawname STS_KenyaYIF_Combined Life Skills  VERSION  A-cohort2_baseline
log using "${rawname}_3Sc", replace text

//	Project:	STS_YIF_Kenya
//	Author:		Thomaz Alvares
// 		Date:	05-11-2011

/*	
	This do-file dostring the raw data from string
	and generates a the scored value for each item
	as S_varname. It calculates total number of correct
	answers, mean (corrected answers/total qs), and
	total number of questions left blank
*/

// Edit 01:
//	Date:

/*
*/

display "rawname is $rawname"
use "${rawname}_2DC.dta", clear

quietly summarize l_s_no
display r(N) " in combined Version A and Versio B"

*local i1 = 0
foreach var of varlist l1_emoint-l41_sex_harass {
	clonevar C_`var' = `var'
*	local ++i1
}

*local i2 = 0
foreach var of varlist C_l1_emoint-C_l41_sex_harass {
	replace `var' = "" if `var' == "99"
	replace `var' = "1" if `var' == "A"
	replace `var' = "2" if `var' == "B"
	replace `var' = "3" if `var' == "C"
	replace `var' = "4" if `var' == "D"
*	local ++i2
}

destring C_l1_emoint-C_l41_sex_harass, replace

recode C_l1_emoint (2 = 1 ) (nonmissing = 0) (missing = 0), prefix(S_)
recode C_l2_lifeskillmary (4 = 1 ) (nonmissing = 0) (missing = 0), prefix(S_)
recode C_l3_criticthink (1 = 1 ) (nonmissing = 0) (missing = 0), prefix(S_)
recode C_l4_humanemo (2 = 1 ) (nonmissing = 0) (missing = 0), prefix(S_)
recode C_l5_emoeliz (1 = 1 ) (nonmissing = 0) (missing = 0), prefix(S_)
recode C_l6_lifeskilleliz (2 = 1 ) (nonmissing = 0) (missing = 0), prefix(S_)
recode C_l7_sad (2 = 1 ) (nonmissing = 0) (missing = 0), prefix(S_)
recode C_l8_anger (3 = 1 ) (nonmissing = 0) (missing = 0), prefix(S_)
recode C_l9_listen (1 = 1 ) (nonmissing = 0) (missing = 0), prefix(S_)
recode C_l10_motivekaren (2 = 1 ) (nonmissing = 0) (missing = 0), prefix(S_)
recode C_l11_motivebio (1 = 1 ) (nonmissing = 0) (missing = 0), prefix(S_)
recode C_l12_selfaware (3 = 1 ) (nonmissing = 0) (missing = 0), prefix(S_)
recode C_l13_feedback (1 = 1 ) (nonmissing = 0) (missing = 0), prefix(S_)
recode C_l14_emobehavior (3 = 1 ) (nonmissing = 0) (missing = 0), prefix(S_)
recode C_l15_educgoal (2 = 1 ) (nonmissing = 0) (missing = 0), prefix(S_)
recode C_l16_marriagegoal (3 = 1 ) (nonmissing = 0) (missing = 0), prefix(S_)
recode C_l17_workworld_forcenot (2 = 1 ) (nonmissing = 0) (missing = 0), prefix(S_)
recode C_l18_workworld_force (4 = 1 ) (nonmissing = 0) (missing = 0), prefix(S_)
recode C_l19_workplace_deviance (1 = 1 ) (nonmissing = 0) (missing = 0), prefix(S_)
recode C_l20_hhchorus (4 = 1 ) (nonmissing = 0) (missing = 0), prefix(S_)
recode C_l21_probsolving (2 = 1 ) (nonmissing = 0) (missing = 0), prefix(S_)
recode C_l22_personalatt (1 = 1 ) (nonmissing = 0) (missing = 0), prefix(S_)
recode C_l23_job_ideal (3 = 1 ) (nonmissing = 0) (missing = 0), prefix(S_)
recode C_l24_job_searchgood (4 = 1 ) (nonmissing = 0) (missing = 0), prefix(S_)
recode C_l25_job_searchbest (3 = 1 ) (nonmissing = 0) (missing = 0), prefix(S_)
recode C_l26_job_searchinfo (1 = 1 ) (nonmissing = 0) (missing = 0), prefix(S_)
recode C_l27_job_searchintv (4 = 1 ) (nonmissing = 0) (missing = 0), prefix(S_)
recode C_l28_job_searchresume (3 = 1 ) (nonmissing = 0) (missing = 0), prefix(S_)
recode C_l29_personalvalues (2 = 1 ) (nonmissing = 0) (missing = 0), prefix(S_)
recode C_l30_emocontrol (3 = 1 ) (nonmissing = 0) (missing = 0), prefix(S_)
recode C_l31_pregnancy_system (1 = 1 ) (nonmissing = 0) (missing = 0), prefix(S_)
recode C_l32_infections_genital (4 = 1 ) (nonmissing = 0) (missing = 0), prefix(S_)
recode C_l33_pregnancy_unwanted (2 = 1 ) (nonmissing = 0) (missing = 0), prefix(S_)
recode C_l34_pregnancy_contraceptive (2 = 1 ) (nonmissing = 0) (missing = 0), prefix(S_)
recode C_l35_infections_HIVprotec (1 = 1 ) (nonmissing = 0) (missing = 0), prefix(S_)
recode C_l36_infections_HIVtrans (4 = 1 ) (nonmissing = 0) (missing = 0), prefix(S_)
recode C_l37_infections_HIVnAIDS (2 = 1 ) (nonmissing = 0) (missing = 0), prefix(S_)
recode C_l38_smoking (1 = 1 ) (nonmissing = 0) (missing = 0), prefix(S_)
recode C_l39_sex_gnd (3 = 1 ) (nonmissing = 0) (missing = 0), prefix(S_)
recode C_l40_sex_harassprotec (4 = 1 ) (nonmissing = 0) (missing = 0), prefix(S_)
recode C_l41_sex_harass (2 = 1 ) (nonmissing = 0) (missing = 0), prefix(S_)


renpfix S_C_ S_

egen S_l_resp_total = rowtotal( S_l1_emoint-S_l41_sex_harass), missing
egen S_l_resp_mean = rowmean( S_l1_emoint-S_l41_sex_harass)
egen S_l_resp_missing = rowmiss( S_l1_emoint-S_l41_sex_harass)
zscore S_l_resp_total
label var S_l_resp_total "Number of Correct Answers"
label var S_l_resp_mean "Respondent's mean (correct/total)"
label var S_l_resp_missing "Number of Answers Left Blank (or DE missing)"
label var z_S_l_resp_total "Life Skills test score (in units of sd)"
rename z_S_l_resp_total S_l_resp_zscore

gen l_dataset = 3
label var l_dataset "Data Source"
label def dset 1 "Demographics" 2 "ICT" 3 "Life Skills" 4 "Treat Group"
label val l_dataset dset

* Comparing Test Scores and the Scores in Units of SD
checkvar S_l_resp_total S_l_resp_zscore

* Checking that Raw, Recoded and Scored Data are consistent
list 	l1_emoint 			C_l1_emoint 			S_l1_emoint				in 1/15
list	l10_motivekaren 	C_l10_motivekaren 		S_l10_motivekaren 		in 31/45
list 	l25_job_searchbest	C_l25_job_searchbest 	S_l25_job_searchbest	in 91/105

drop C_l1_emoint-C_l41_sex_harass
gen l_s_no_V2 = _n
label var l_s_no_V2 "Serial Number in Combined Life Skills Dataset"
save "${rawname}_3Sc.dta", replace

log close
exit
