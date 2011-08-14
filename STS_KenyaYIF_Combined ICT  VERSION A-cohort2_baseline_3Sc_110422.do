version 11
clear all
macro drop _all
set linesize 80

capture log close
global rawname STS_KenyaYIF_Combined ICT  VERSION A-cohort2_baseline
log using "${rawname}_3Sc", replace text

//	Project:	STS_YIF_Kenya
//	Author:		Thomaz Alvares
// 		Date:	08-03-2011

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

quietly summarize q_s_no
display r(N) " in combined Version A and Versio B"

*local i1 = 0
foreach var of varlist q1_start-q45_outlookdraft {
	clonevar C_`var' = `var'
*	local ++i1
}

*local i2 = 0
foreach var of varlist C_q1_start-C_q45_outlookdraft {
	replace `var' = "" if `var' == "99"
	replace `var' = "1" if `var' == "A"
	replace `var' = "2" if `var' == "B"
	replace `var' = "3" if `var' == "C"
	replace `var' = "4" if `var' == "D"
*	local ++i2
}

destring C_q1_start-C_q45_outlookdraft, replace

recode C_q1_start (2 = 1) (nonmissing = 0) (missing = 0), prefix(S_)
recode C_q2_folder (3 = 1) (nonmissing = 0) (missing = 0), prefix(S_)
recode C_q3_paste (4 = 1) (nonmissing = 0) (missing = 0), prefix(S_)
recode C_q4_write (4 = 1) (nonmissing = 0) (missing = 0), prefix(S_)
recode C_q5_time (2 = 1) (nonmissing = 0) (missing = 0), prefix(S_)
recode C_q6_highlight (1 = 1) (nonmissing = 0) (missing = 0), prefix(S_)
recode C_q7_docnew (2 = 1) (nonmissing = 0) (missing = 0), prefix(S_)
recode C_q8_docdel (4 = 1) (nonmissing = 0) (missing = 0), prefix(S_)
recode C_q9_keyboard (4 = 1) (nonmissing = 0) (missing = 0), prefix(S_)
recode C_q10_mem (1 = 1) (nonmissing = 0) (missing = 0), prefix(S_)
recode C_q11_hd (3 = 1) (nonmissing = 0) (missing = 0), prefix(S_)
recode C_q12_wireless (4 = 1) (nonmissing = 0) (missing = 0), prefix(S_)
recode C_q13_speaker (2 = 1) (nonmissing = 0) (missing = 0), prefix(S_)
recode C_q14_sata (3 = 1) (nonmissing = 0) (missing = 0), prefix(S_)
recode C_q15_scanner (1 = 1) (nonmissing = 0) (missing = 0), prefix(S_)
recode C_q16_laptop (2 = 1) (nonmissing = 0) (missing = 0), prefix(S_)
recode C_q17_monitor (1 = 1) (nonmissing = 0) (missing = 0), prefix(S_)
recode C_q18_flashdrive (3 = 1) (nonmissing = 0) (missing = 0), prefix(S_)
recode C_q19_printer (2 = 1) (nonmissing = 0) (missing = 0), prefix(S_)
recode C_q20_system (4 = 1) (nonmissing = 0) (missing = 0), prefix(S_)
recode C_q21_notinterchange (3 = 1) (nonmissing = 0) (missing = 0), prefix(S_)
recode C_q22_email (2 = 1) (nonmissing = 0) (missing = 0), prefix(S_)
recode C_q23_cdclean (1 = 1) (nonmissing = 0) (missing = 0), prefix(S_)
recode C_q24_ladder (2 = 1) (nonmissing = 0) (missing = 0), prefix(S_)
recode C_q25_compdust (2 = 1) (nonmissing = 0) (missing = 0), prefix(S_)
recode C_q26_compclean (1 = 1) (nonmissing = 0) (missing = 0), prefix(S_)
recode C_q27_compscrew (4 = 1) (nonmissing = 0) (missing = 0), prefix(S_)
recode C_q28_multiplication (2 = 1) (nonmissing = 0) (missing = 0), prefix(S_)
recode C_q29_percentage (1 = 1) (nonmissing = 0) (missing = 0), prefix(S_)
recode C_q30_division (1 = 1) (nonmissing = 0) (missing = 0), prefix(S_)
recode C_q31_multiplicationadv (4 = 1) (nonmissing = 0) (missing = 0), prefix(S_)
recode C_q32_antivirus (3 = 1) (nonmissing = 0) (missing = 0), prefix(S_)
recode C_q33_dialogbox (2 = 1) (nonmissing = 0) (missing = 0), prefix(S_)
recode C_q34_rename (4 = 1) (nonmissing = 0) (missing = 0), prefix(S_)
recode C_q35_wordclose (3 = 1) (nonmissing = 0) (missing = 0), prefix(S_)
recode C_q36_wordrecent (4 = 1) (nonmissing = 0) (missing = 0), prefix(S_)
recode C_q37_wordcopy (1 = 1) (nonmissing = 0) (missing = 0), prefix(S_)
recode C_q38_excelcell (3 = 1) (nonmissing = 0) (missing = 0), prefix(S_)
recode C_q39_excelrow (1 = 1) (nonmissing = 0) (missing = 0), prefix(S_)
recode C_q40_excelformula (3 = 1) (nonmissing = 0) (missing = 0), prefix(S_)
recode C_q41_weburl (1 = 1) (nonmissing = 0) (missing = 0), prefix(S_)
recode C_q42_webnavigator (2 = 1) (nonmissing = 0) (missing = 0), prefix(S_)
recode C_q43_websecurity (3 = 1) (nonmissing = 0) (missing = 0), prefix(S_)
recode C_q44_outlookbanner (4 = 1) (nonmissing = 0) (missing = 0), prefix(S_)
recode C_q45_outlookdraft (3 = 1) (nonmissing = 0) (missing = 0), prefix(S_)

renpfix S_C_ S_

egen S_q_resp_total = rowtotal( S_q1_start-S_q45_outlookdraft), missing
egen S_q_resp_mean = rowmean( S_q1_start-S_q45_outlookdraft)
egen S_q_resp_missing = rowmiss( S_q1_start-S_q45_outlookdraft)
zscore S_q_resp_total
label var S_q_resp_total "Number of Correct Answers"
label var S_q_resp_mean "Respondent's mean (correct/total)"
label var S_q_resp_missing "Number of Answers Left Blank (or DE missing)"
label var z_S_q_resp_total "ICT test score (in units of sd)"
rename z_S_q_resp_total S_q_resp_zscore

gen q_dataset = 2
label var q_dataset "Data Source"
label def dset 1 "Demographics" 2 "ICT" 3 "Life Skills" 4 "Treat Group"
label val q_dataset dset

* Comparing Test Scores and the Scores in Units of SD
checkvar S_q_resp_total S_q_resp_zscore

* Checking that Raw, Recoded and Scored Data are consistent
list 	q1_start 		C_q1_start 		S_q1_start		in 1/15
list	q10_mem 		C_q10_mem 		S_q10_mem 		in 31/45
list 	q25_compdust	C_q25_compdust 	S_q25_compdust	in 91/105

drop C_q1_start-C_q45_outlookdraft
gen q_s_no_V2 = _n
label var q_s_no_V2 "Serial Number in Combined ICT Dataset"
save "${rawname}_3Sc.dta", replace

log close
exit
