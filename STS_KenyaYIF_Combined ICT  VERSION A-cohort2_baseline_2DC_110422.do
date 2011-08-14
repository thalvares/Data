version 11
clear all
macro drop _all
set linesize 80

capture log close
global rawname STS_KenyaYIF_Combined ICT  VERSION A-cohort2_baseline
log using "${rawname}_2dc", replace text

//	Project:	STS_YIF_Kenya
//	Author:		Thomaz Alvares
// 		Date:	08-03-2011

/*	
	This do-file replaces typos in the answers for the
	multiple choice questions
*/

// Edit 01: 
//	Date:

display "rawname is $rawname"
use "${rawname}_1prep.dta", clear

quietly summarize q_s_no
display r(N) " in combined Version A and Versio B"

foreach var of varlist q1_start-q45_outlookdraft {
	replace `var' = "" if `var' == "99 "
	replace `var' = "A" if `var' == "A "
	replace `var' = "B" if `var' == "B "
	replace `var' = "C" if `var' == "C "
	replace `var' = "D" if `var' == "D "
}

foreach var of varlist q1_start-q45_outlookdraft {
	replace `var' = "" if `var' == " 99"
	replace `var' = "A" if `var' == " A"
	replace `var' = "B" if `var' == " B"
	replace `var' = "C" if `var' == " C"
	replace `var' = "D" if `var' == " D"
}

foreach var of varlist q1_start-q45_outlookdraft {
	replace `var' = "" if `var' == " 99 "
	replace `var' = "A" if `var' == " A "
	replace `var' = "B" if `var' == " B "
	replace `var' = "C" if `var' == " C "
	replace `var' = "D" if `var' == " D "
}

// DC
* being string instead of numeric
tab q5_time, miss
replace q5_time = "B" if q5_time == "b"
replace q5_time = "" if q5_time == "9"
tab q5_time, miss

tab q12_wireless, miss
replace q12_wireless = "D" if q12_wireless == "0D"
tab q12_wireless, miss

* being float instead of byte
tab q32_antivirus, miss
replace q32_antivirus = "" if q32_antivirus == "9999"
tab q32_antivirus, miss

* mismatched id
replace resp_id = "1-2-001" if resp_id == "1-2-002"
replace resp_id = "6-2-020" if resp_id == "6/2/020"
replace resp_id = "5-2-051" if resp_id == "5-1-051"


save "${rawname}_2DC.dta", replace

log close
exit

